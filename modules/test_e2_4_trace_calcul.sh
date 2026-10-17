#!/bin/bash

set -u

DMP_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$DMP_ROOT/lib/score.sh"

dmp_calculate_score

PASS=0
FAIL=0

check()
{
    if "$@"; then
        printf 'PASS : %s\n' "$2"
        PASS=$((PASS + 1))
    else
        printf 'FAIL : %s\n' "$2"
        FAIL=$((FAIL + 1))
    fi
}

check_value()
{
    local name="$1"
    local actual="$2"
    local expected="$3"

    if [ "$actual" = "$expected" ]; then
        printf 'PASS : %s\n' "$name"
        PASS=$((PASS + 1))
    else
        printf 'FAIL : %s — attendu [%s], obtenu [%s]\n' \
            "$name" "$expected" "$actual"
        FAIL=$((FAIL + 1))
    fi
}

printf '\n===== E2.4 — TEST DE TRACE DU CALCUL =====\n\n'

check_value "Nombre d'étapes" "${#DMP_TECH_STEPS[@]}" "5"

check_value "Score final" "$DMP_SCORE" "100"
check_value "État final" "$DMP_STATE" "EXCELLENT"

check_value "Paquets" "$DMP_PAQUETS" "OK"
check_value "Disque" "$DMP_DISQUE" "OK"
check_value "TRIM" "$DMP_TRIM" "OK"
check_value "Mémoire" "$DMP_RAM" "OK"
check_value "SMART" "$DMP_SMART" "INCONNU"

check_value "Évaluation paquets" \
    "$DMP_TECH_PAQUETS_EVALUATION" "NON_DECLENCHE"

check_value "Contribution paquets" \
    "$DMP_TECH_PAQUETS_CONTRIBUTION" "0"

check_value "Évaluation disque" \
    "$DMP_TECH_DISQUE_EVALUATION" "NON_DECLENCHE"

check_value "Contribution disque" \
    "$DMP_TECH_DISQUE_CONTRIBUTION" "0"

check_value "Évaluation TRIM" \
    "$DMP_TECH_TRIM_EVALUATION" "NON_DECLENCHE"

check_value "Contribution TRIM" \
    "$DMP_TECH_TRIM_CONTRIBUTION" "0"

check_value "Évaluation mémoire" \
    "$DMP_TECH_MEM_EVALUATION" "NON_DECLENCHE"

check_value "Contribution mémoire" \
    "$DMP_TECH_MEM_CONTRIBUTION" "0"

check_value "Évaluation SMART" \
    "$DMP_TECH_SMART_EVALUATION" "INCONNU"

check_value "Contribution SMART" \
    "$DMP_TECH_SMART_CONTRIBUTION" "0"

check_value "Score après paquets" \
    "$(echo "${DMP_TECH_STEPS[0]}" | awk -F'|' '{print $8}')" "100"

check_value "Score après disque" \
    "$(echo "${DMP_TECH_STEPS[1]}" | awk -F'|' '{print $8}')" "100"

check_value "Score après TRIM" \
    "$(echo "${DMP_TECH_STEPS[2]}" | awk -F'|' '{print $8}')" "100"

check_value "Score après mémoire" \
    "$(echo "${DMP_TECH_STEPS[3]}" | awk -F'|' '{print $8}')" "100"

check_value "Score après SMART" \
    "$(echo "${DMP_TECH_STEPS[4]}" | awk -F'|' '{print $8}')" "100"

printf '\n===== TRACE =====\n'
printf '%s\n' "${DMP_TECH_STEPS[@]}"

printf '\n===== RÉSULTAT =====\n'
printf 'PASS : %s\n' "$PASS"
printf 'FAIL : %s\n' "$FAIL"

if [ "$FAIL" -eq 0 ]; then
    printf 'E2.4 TRACE : PASS\n'
    exit 0
else
    printf 'E2.4 TRACE : FAIL\n'
    exit 1
fi
