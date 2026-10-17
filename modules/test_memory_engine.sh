#!/usr/bin/env bash

set -u

BASE="${DMP_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"

ENGINE="$BASE/memory_engine.sh"

PASS=0
FAIL=0

echo "===== DMP V2 — NON-RÉGRESSION MOTEUR MÉMOIRE ====="
echo

# Vérification des composants
COMPONENTS=(
    "memory_collect.sh"
    "memory_trend.sh"
    "memory_recovery.sh"
    "memory_pressure.sh"
    "memory_diagnosis.sh"
    "memory_action.sh"
    "memory_explanation.sh"
)

for component in "${COMPONENTS[@]}"; do
    if [[ -x "$BASE/$component" ]]; then
        printf "PASS  composant %-28s → PRESENT\n" "$component"
        ((PASS++))
    else
        printf "FAIL  composant %-28s → ABSENT\n" "$component"
        ((FAIL++))
    fi
done

echo
echo "===== TEST DE SYNTAXE ====="

for component in "${COMPONENTS[@]}" "memory_engine.sh"; do
    if bash -n "$BASE/$component" 2>/dev/null; then
        printf "PASS  syntaxe %-29s → OK\n" "$component"
        ((PASS++))
    else
        printf "FAIL  syntaxe %-29s → ERREUR\n" "$component"
        ((FAIL++))
    fi
done

echo
echo "===== TEST D'EXÉCUTION ====="

OUTPUT=$("$ENGINE" 2>&1)
STATUS=$?

if [[ "$STATUS" -eq 0 ]]; then
    echo "PASS  exécution moteur                  → OK"
    ((PASS++))
else
    echo "FAIL  exécution moteur                  → ERREUR"
    ((FAIL++))
fi

echo
echo "===== VÉRIFICATION DE LA CHAÎNE ====="

if grep -q "===== 1. COLLECTE =====" <<< "$OUTPUT"; then
    echo "PASS  collecte                           → PRESENT"
    ((PASS++))
else
    echo "FAIL  collecte                           → ABSENTE"
    ((FAIL++))
fi

if grep -q "===== 2. DIAGNOSTIC =====" <<< "$OUTPUT"; then
    echo "PASS  diagnostic                         → PRESENT"
    ((PASS++))
else
    echo "FAIL  diagnostic                         → ABSENT"
    ((FAIL++))
fi

if grep -q "===== 3. ACTION =====" <<< "$OUTPUT"; then
    echo "PASS  action                             → PRESENT"
    ((PASS++))
else
    echo "FAIL  action                             → ABSENTE"
    ((FAIL++))
fi

if grep -q "===== 4. EXPLICATION =====" <<< "$OUTPUT"; then
    echo "PASS  explication                        → PRESENT"
    ((PASS++))
else
    echo "FAIL  explication                        → ABSENTE"
    ((FAIL++))
fi

echo
echo "===== VÉRIFICATION DU DIAGNOSTIC ====="

if grep -qE '^diagnosis=(NORMAL|WATCH|PROBLEM|IMPOSSIBLE)$' <<< "$OUTPUT"; then
    echo "PASS  diagnostic valide                  → OUI"
    ((PASS++))
else
    echo "FAIL  diagnostic valide                  → NON"
    ((FAIL++))
fi

echo
echo "===== VÉRIFICATION DE L'ACTION ====="

if grep -qE '^action=(NONE|MONITOR|CORRECTIVE|COLLECT_MORE_DATA)$' <<< "$OUTPUT"; then
    echo "PASS  action valide                      → OUI"
    ((PASS++))
else
    echo "FAIL  action valide                      → NON"
    ((FAIL++))
fi

echo
echo "===== RÉSULTAT ====="
echo "PASS : $PASS"
echo "FAIL : $FAIL"

if [[ "$FAIL" -eq 0 ]]; then
    echo
    echo "NON-RÉGRESSION : PASS"
    exit 0
else
    echo
    echo "NON-RÉGRESSION : FAIL"
    exit 1
fi
