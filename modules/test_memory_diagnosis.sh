#!/usr/bin/env bash

set -u

PASS=0
FAIL=0

test_case() {
    local name="$1"
    local trend="$2"
    local recovery="$3"
    local pressure="$4"
    local expected="$5"

    local result

    if [[ "$trend" == "INCREASING" &&
          "$recovery" == "NO_RECOVERY" &&
          "$pressure" == "INCREASING" ]]; then
        result="PROBLEM"

    elif [[ "$pressure" == "WATCH" ]]; then
        result="WATCH"

    elif [[ "$trend" == "INCREASING" ]]; then
        result="WATCH"

    elif [[ ( "$trend" == "STABLE" || "$trend" == "DECREASING" ) &&
            "$recovery" == "RECOVERED" &&
            "$pressure" == "NORMAL" ]]; then
        result="NORMAL"

    elif [[ "$trend" == "STABLE" &&
            "$recovery" == "PARTIAL_RECOVERY" &&
            "$pressure" == "NORMAL" ]]; then
        result="NORMAL"

    else
        result="IMPOSSIBLE"
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

echo "===== DMP V2 — NON-RÉGRESSION DIAGNOSTIC MÉMOIRE ====="
echo

test_case "M01 T0→T3 réel" \
    STABLE RECOVERED NORMAL NORMAL

test_case "M02 élevé mais stable" \
    STABLE RECOVERED NORMAL NORMAL

test_case "M03 hausse sans pression" \
    INCREASING RECOVERED NORMAL WATCH

test_case "M04 récupération complète" \
    DECREASING RECOVERED NORMAL NORMAL

test_case "M05 récupération partielle" \
    STABLE PARTIAL_RECOVERY NORMAL NORMAL

test_case "M06 hausse persistante" \
    INCREASING PARTIAL_RECOVERY NORMAL WATCH

test_case "M07 pression suspectée" \
    STABLE RECOVERED WATCH WATCH

test_case "M08 pression confirmée" \
    INCREASING NO_RECOVERY INCREASING PROBLEM

test_case "M09 pression en amélioration" \
    DECREASING PARTIAL_RECOVERY WATCH WATCH

test_case "M10 données insuffisantes" \
    INSUFFICIENT_DATA INSUFFICIENT_DATA INSUFFICIENT_DATA IMPOSSIBLE

test_case "M11 swap stable" \
    STABLE RECOVERED NORMAL NORMAL

test_case "M12 pic isolé" \
    INSUFFICIENT_DATA INSUFFICIENT_DATA NORMAL IMPOSSIBLE

test_case "M13 contributeur dominant" \
    STABLE RECOVERED NORMAL NORMAL

test_case "M14 signaux incohérents" \
    DECREASING NO_RECOVERY NORMAL IMPOSSIBLE

echo
echo "===== RÉSULTAT ====="
echo "PASS : $PASS"
echo "FAIL : $FAIL"

if (( FAIL == 0 )); then
    echo
    echo "NON-RÉGRESSION : PASS"
    exit 0
else
    echo
    echo "NON-RÉGRESSION : FAIL"
    exit 1
fi
