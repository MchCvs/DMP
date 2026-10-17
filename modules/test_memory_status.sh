#!/usr/bin/env bash

set -u

BASE="${DMP_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
STATUS="$BASE/memory_status.sh"

PASS=0
FAIL=0

check_field() {
    local field="$1"
    local pattern="$2"

    if grep -qE "^${field}=${pattern}$" <<< "$OUTPUT"; then
        printf "PASS  %-25s → PRESENT\n" "$field"
        ((PASS++))
    else
        printf "FAIL  %-25s → ABSENT OU INVALIDE\n" "$field"
        ((FAIL++))
    fi
}

echo "===== DMP V2 — CONTRAT DMP_MEMORY_STATUS ====="
echo

OUTPUT=$("$STATUS" 2>&1)
STATUS_CODE=$?

if [[ "$STATUS_CODE" -eq 0 ]]; then
    echo "PASS  exécution moteur        → OK"
    ((PASS++))
else
    echo "FAIL  exécution moteur        → ERREUR"
    ((FAIL++))
fi

echo
echo "===== IDENTITÉ ====="

if grep -q '^DMP_MEMORY_STATUS$' <<< "$OUTPUT"; then
    echo "PASS  en-tête                 → DMP_MEMORY_STATUS"
    ((PASS++))
else
    echo "FAIL  en-tête                 → ABSENT"
    ((FAIL++))
fi

echo
echo "===== MESURES SYSTÈME ====="

check_field "timestamp" '.+'
check_field "mem_total_kb" '[0-9]+'
check_field "mem_available_kb" '[0-9]+'
check_field "swap_total_kb" '[0-9]+'
check_field "swap_used_kb" '[0-9]+'

echo
echo "===== FIREFOX ====="

check_field "firefox_present" '[01]'
check_field "firefox_pid" '[0-9]+'
check_field "firefox_total_kb" '[0-9]+'

echo
echo "===== CONTRIBUTEUR ====="

check_field "contributor_pid" '[0-9]+'
check_field "contributor_name" '.+'
check_field "contributor_rss_kb" '[0-9]+'

echo
echo "===== DIAGNOSTIC ====="

check_field "trend" '(STABLE|INCREASING|DECREASING|INSUFFICIENT_DATA)'
check_field "recovery" '(RECOVERED|PARTIAL_RECOVERY|NO_RECOVERY|INSUFFICIENT_DATA)'
check_field "pressure" '(NORMAL|WATCH|INCREASING|INSUFFICIENT_DATA)'
check_field "diagnosis" '(NORMAL|WATCH|PROBLEM|IMPOSSIBLE)'
check_field "action" '(NONE|MONITOR|CORRECTIVE|COLLECT_MORE_DATA)'

echo
echo "===== RÉSULTAT ====="
echo "PASS : $PASS"
echo "FAIL : $FAIL"

if [[ "$FAIL" -eq 0 ]]; then
    echo
    echo "CONTRAT : PASS"
    exit 0
else
    echo
    echo "CONTRAT : FAIL"
    exit 1
fi
