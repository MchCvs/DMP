#!/usr/bin/env bash

set -u

PASS=0
FAIL=0

test_case() {
    local name="$1"
    local diagnosis="$2"
    local trend="$3"
    local recovery="$4"
    local pressure="$5"
    local expected="$6"

    local result

    if [[ "$diagnosis" == "IMPOSSIBLE" ]]; then
        result="COLLECT_MORE_DATA"

    elif [[ "$diagnosis" == "PROBLEM" ]]; then
        result="CORRECTIVE"

    elif [[ "$diagnosis" == "NORMAL" ]]; then
        result="NONE"

    elif [[ "$diagnosis" == "WATCH" &&
            "$pressure" == "WATCH" ]]; then
        result="MONITOR"

    elif [[ "$diagnosis" == "WATCH" &&
            "$trend" == "DECREASING" ]]; then
        result="NONE"

    elif [[ "$diagnosis" == "WATCH" &&
            "$trend" == "STABLE" ]]; then
        result="MONITOR"

    elif [[ "$diagnosis" == "WATCH" &&
            "$trend" == "INCREASING" ]]; then
        result="MONITOR"

    else
        result="COLLECT_MORE_DATA"
    fi

    if [[ "$result" == "$expected" ]]; then
        printf "PASS  %-38s → %s\n" "$name" "$result"
        ((PASS++))
    else
        printf "FAIL  %-38s → attendu=%s obtenu=%s\n" \
            "$name" "$expected" "$result"
        ((FAIL++))
    fi
}

echo "===== DMP V2 — MATRICE D'ACTION CONTEXTUALISÉE ====="
echo

test_case "A01 normal" \
    NORMAL STABLE RECOVERED NORMAL NONE

test_case "A02 watch stable" \
    WATCH STABLE RECOVERED NORMAL MONITOR

test_case "A03 watch en amélioration" \
    WATCH DECREASING RECOVERED NORMAL NONE

test_case "A04 watch récupération partielle" \
    WATCH DECREASING PARTIAL_RECOVERY NORMAL NONE

test_case "A05 hausse sans pression" \
    WATCH INCREASING RECOVERED NORMAL MONITOR

test_case "A06 hausse persistante" \
    WATCH INCREASING PARTIAL_RECOVERY NORMAL MONITOR

test_case "A07 pression suspectée" \
    WATCH STABLE RECOVERED WATCH MONITOR

test_case "A08 problème confirmé" \
    PROBLEM INCREASING NO_RECOVERY INCREASING CORRECTIVE

test_case "A09 données insuffisantes" \
    IMPOSSIBLE INSUFFICIENT_DATA INSUFFICIENT_DATA INSUFFICIENT_DATA COLLECT_MORE_DATA

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
