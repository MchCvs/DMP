#!/usr/bin/env bash

set -u

BASE="${DMP_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"

COLLECT="$BASE/memory_collect.sh"
DIAGNOSIS="$BASE/memory_diagnosis.sh"
ACTION="$BASE/memory_action.sh"
EXPLANATION="$BASE/memory_explanation.sh"

echo "===== DMP V2 — MOTEUR MÉMOIRE ====="
date --iso-8601=seconds
echo

echo "===== 1. COLLECTE ====="
"$COLLECT"

echo
echo "===== 2. DIAGNOSTIC ====="
"$DIAGNOSIS"

echo
echo "===== 3. ACTION ====="
"$ACTION"

echo
echo "===== 4. EXPLICATION ====="
"$EXPLANATION"

echo
echo "===== FIN DU MOTEUR MÉMOIRE ====="
