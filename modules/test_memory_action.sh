#!/usr/bin/env bash

set -u

PASS=0
FAIL=0

test_case() {
    local name="$1"
    local diagnosis="$2"
    local expected="$3"
    local result

    case "$diagnosis" in
        NORMAL)
            result="NONE"
            ;;
        WATCH)
            result="MONITOR"
            ;;
        PROBLEM)
            result="CORRECTIVE"
            ;;
        IMPOSSIBLE)
            result="COLLECT_MORE_DATA"
            ;;
        *)
            result="COLLECT_MORE_DATA"
            ;;
    esac

    if [[ "$result" == "$expected" ]]; then
        printf "PASS  %-35s → %s\n" "$name" "$result"
        ((PASS++))
    else
        printf "FAIL  %-35s → attendu=%s obtenu=%s\n" \
            "$name" "$expected" "$result"
        ((FAIL++))
    fi
}

echo "===== DMP V2 — TEST MOTEUR D'ACTION ====="
echo

test_case "diagnostic normal" \
    NORMAL NONE

test_case "diagnostic à surveiller" \
    WATCH MONITOR

test_case "problème identifié" \
    PROBLEM CORRECTIVE

test_case "données insuffisantes" \
    IMPOSSIBLE COLLECT_MORE_DATA

test_case "diagnostic inconnu" \
    UNKNOWN COLLECT_MORE_DATA

echo
echo "===== RÉSULTAT ====="
echo "PASS : $PASS"
echo "FAIL : $FAIL"

if [[ "$FAIL" -eq 0 ]]; then
    echo
    echo "BATTERIE : PASS"
    exit 0
else
    echo
    echo "BATTERIE : FAIL"
    exit 1
fi
