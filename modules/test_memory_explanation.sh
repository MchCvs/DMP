#!/usr/bin/env bash

set -u

PASS=0
FAIL=0

test_case() {
    local name="$1"
    local diagnosis="$2"
    local expected_state="$3"
    local expected_action="$4"

    local state
    local action

    case "$diagnosis" in
        NORMAL)
            state="OK"
            action="Aucune action nécessaire."
            ;;

        WATCH)
            state="SURVEILLER"
            action="Une surveillance de l'évolution est recommandée."
            ;;

        PROBLEM)
            state="PROBLÈME"
            action="Une action corrective est recommandée."
            ;;

        IMPOSSIBLE)
            state="INDETERMINE"
            action="De nouvelles mesures sont nécessaires."
            ;;

        *)
            state="INDETERMINE"
            action="De nouvelles mesures sont nécessaires."
            ;;
    esac

    if [[ "$state" == "$expected_state" &&
          "$action" == "$expected_action" ]]; then
        printf "PASS  %-38s → %s / %s\n" \
            "$name" "$state" "$action"
        ((PASS++))
    else
        printf "FAIL  %-38s → attendu=%s / %s obtenu=%s / %s\n" \
            "$name" "$expected_state" "$expected_action" \
            "$state" "$action"
        ((FAIL++))
    fi
}

echo "===== DMP V2 — NON-RÉGRESSION EXPLICATION MÉMOIRE ====="
echo

test_case "E01 diagnostic normal" \
    NORMAL \
    OK \
    "Aucune action nécessaire."

test_case "E02 diagnostic à surveiller" \
    WATCH \
    SURVEILLER \
    "Une surveillance de l'évolution est recommandée."

test_case "E03 problème identifié" \
    PROBLEM \
    PROBLÈME \
    "Une action corrective est recommandée."

test_case "E04 données insuffisantes" \
    IMPOSSIBLE \
    INDETERMINE \
    "De nouvelles mesures sont nécessaires."

test_case "E05 diagnostic inconnu" \
    UNKNOWN \
    INDETERMINE \
    "De nouvelles mesures sont nécessaires."

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
