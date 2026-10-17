#!/usr/bin/env bash

set -u

BASE_URL="http://127.0.0.1:8765"
SERVER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../web/server" && pwd)"
SERVER_SCRIPT="dmp_web_server.py"

FAIL=0
PASS=0
SERVER_PID=""
SERVER_WAS_RUNNING=0

pass() {
    printf 'PASS : %s\n' "$1"
    PASS=$((PASS + 1))
}

fail() {
    printf 'FAIL : %s\n' "$1"
    FAIL=$((FAIL + 1))
}

get_cpu_e1_2() {
    curl -fsS "$BASE_URL/api/e1_2" |
        jq -r '
            .elements as $elements
            | .results as $results
            | ($elements | to_entries[])
            | select(.value == "CPU")
            | $results[.key]
        ' |
        sed -n 's/.*utilisation actuelle : \([0-9]\+\)%.*/\1/p'
}

get_cpu_e1_3() {
    curl -fsS "$BASE_URL/api/e1_3" |
        jq -r '
            .explanations[]
            | select(.element == "Processeur")
            | .constat
        ' |
        sed -n 's/.*utilisation mesurée pendant la période d’observation est de \([0-9]\+\)%.*/\1/p'
}

wait_server() {
    local attempt

    for attempt in {1..20}; do
        if curl -fsS "$BASE_URL/api/e1_2" >/dev/null 2>&1; then
            return 0
        fi
        sleep 1
    done

    return 1
}

stop_server() {
    local pid

    pid=$(pgrep -f "python3 ${SERVER_SCRIPT}" | head -n 1 || true)

    if [[ -n "$pid" ]]; then
        SERVER_PID="$pid"
        SERVER_WAS_RUNNING=1

        kill "$pid" 2>/dev/null || true

        for _ in {1..10}; do
            if ! kill -0 "$pid" 2>/dev/null; then
                return 0
            fi
            sleep 1
        done

        kill -9 "$pid" 2>/dev/null || true
    fi

    return 0
}

start_server() {
    cd "$SERVER_DIR" || return 1

    nohup python3 "$SERVER_SCRIPT" \
        > /tmp/dmp_web_server_test.log 2>&1 &

    SERVER_PID=$!

    if wait_server; then
        return 0
    fi

    return 1
}

cleanup() {
    if ! pgrep -f "python3 ${SERVER_SCRIPT}" >/dev/null 2>&1; then
        printf 'RESTAURATION : serveur DMP absent, tentative de relance...\\n'
        start_server >/dev/null 2>&1 || true
    fi
}

test_snapshot_valid() {
    local cpu_2 cpu_3

    cpu_2=$(get_cpu_e1_2) || {
        fail "E1.2 inaccessible"
        return
    }

    if [[ -z "$cpu_2" || "$cpu_2" == "null" ]]; then
        fail "E1.2 : observation CPU indisponible"
        return
    fi

    cpu_3=$(get_cpu_e1_3) || {
        fail "E1.3 inaccessible"
        return
    }

    if [[ -z "$cpu_3" || "$cpu_3" == "null" ]]; then
        fail "E1.3 : explication CPU indisponible"
        return
    fi

    if [[ "$cpu_2" == "$cpu_3" ]]; then
        pass "Snapshot valide : E1.2 = E1.3 ($cpu_2)"
    else
        fail "Snapshot valide incohérent : E1.2='$cpu_2' E1.3='$cpu_3'"
    fi
}

test_snapshot_expiration() {
    local cpu_3

    printf 'ATTENTE : expiration du snapshot (31 secondes)...\n'
    sleep 31

    cpu_3=$(get_cpu_e1_3) || {
        fail "E1.3 inaccessible après expiration"
        return
    }

    if [[ -n "$cpu_3" && "$cpu_3" != "null" ]]; then
        pass "Expiration : E1.3 reconstruit une observation CPU ($cpu_3)"
    else
        fail "Expiration : observation CPU E1.3 indisponible"
    fi
}

test_restart() {
    local cpu_3

    printf 'ARRÊT : serveur DMP actuel...\n'

    stop_server

    if pgrep -f "python3 ${SERVER_SCRIPT}" >/dev/null 2>&1; then
        fail "Le serveur DMP n'a pas pu être arrêté"
        return
    fi

    printf 'RELANCE : serveur DMP...\n'

    if ! start_server; then
        fail "Le serveur DMP n'a pas pu être relancé"
        return
    fi

    cpu_3=$(get_cpu_e1_3) || {
        fail "E1.3 inaccessible après redémarrage"
        return
    }

    if [[ -n "$cpu_3" && "$cpu_3" != "null" ]]; then
        pass "Redémarrage : E1.3 produit une nouvelle observation CPU ($cpu_3)"
    else
        fail "Redémarrage : observation CPU E1.3 indisponible"
    fi
}

trap cleanup EXIT

printf '%s\n' "=============================================="
printf '%s\n' "DMP — Test de cohérence E1.2 → E1.3"
printf '%s\n' "=============================================="

printf '%s\n' ""
printf '%s\n' "[1/3] Snapshot valide"
test_snapshot_valid

printf '%s\n' ""
printf '%s\n' "[2/3] Expiration du snapshot"
test_snapshot_expiration

printf '%s\n' ""
printf '%s\n' "[3/3] Redémarrage du serveur"
test_restart

printf '%s\n' ""
printf '%s\n' "=============================================="
printf 'PASS : %d\n' "$PASS"
printf 'FAIL : %d\n' "$FAIL"
printf '%s\n' "=============================================="

if (( FAIL == 0 )); then
    exit 0
else
    exit 1
fi
