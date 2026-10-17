#!/usr/bin/env bash

set -u

DMP_ROOT="${DMP_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
MODULE="$DMP_ROOT/memory_module.sh"

PASS=0
FAIL=0

check() {
    local name="$1"
    local condition="$2"

    if [[ "$condition" == "1" ]]; then
        printf "PASS  %-40s → OK\n" "$name"
        ((PASS++))
    else
        printf "FAIL  %-40s → KO\n" "$name"
        ((FAIL++))
    fi
}

echo "===== DMP V2 — TEST INTÉGRATION MODULE MÉMOIRE ====="
echo

check "module présent" "$([[ -f "$MODULE" ]] && echo 1 || echo 0)"
check "module exécutable" "$([[ -x "$MODULE" ]] && echo 1 || echo 0)"
check "syntaxe" "$(bash -n "$MODULE" >/dev/null 2>&1; echo $((!$?)))"

OUTPUT="$("$MODULE" 2>/dev/null)"
EXIT_CODE=$?

check "exécution" "$([[ $EXIT_CODE -eq 0 ]] && echo 1 || echo 0)"
check "présentation française" \
    "$([[ "$OUTPUT" == *"ÉTAT DÉTAILLÉ DE LA MÉMOIRE"* ]] && echo 1 || echo 0)"
check "diagnostic utilisateur présent" \
    "$([[ "$OUTPUT" == *"La mémoire fonctionne normalement."* || "$OUTPUT" == *"situation mémoire"* ]] && echo 1 || echo 0)"
check "action utilisateur présente" \
    "$([[ "$OUTPUT" == *"Action :"* ]] && echo 1 || echo 0)"

echo
echo "===== RÉSULTAT ====="
echo "PASS : $PASS"
echo "FAIL : $FAIL"

if [[ $FAIL -eq 0 ]]; then
    echo
    echo "INTÉGRATION MODULE : PASS"
    exit 0
else
    echo
    echo "INTÉGRATION MODULE : FAIL"
    exit 1
fi
