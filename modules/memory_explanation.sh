#!/usr/bin/env bash

set -u

DIAGNOSIS_SCRIPT="${DMP_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}/memory_diagnosis.sh"
ACTION_SCRIPT="${DMP_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}/memory_action.sh"

DIAGNOSIS=$("$DIAGNOSIS_SCRIPT" | awk -F= '/^diagnosis=/{print $2}')
ACTION=$("$ACTION_SCRIPT" | awk -F= '/^action=/{print $2}')

echo "===== DMP V2 — EXPLICATION MÉMOIRE ====="
echo

case "$DIAGNOSIS" in

    NORMAL)
        echo "état=OK"
        echo "explication=La mémoire fonctionne normalement."
        echo "action=Aucune action nécessaire."
        ;;

    WATCH)
        echo "état=SURVEILLER"
        echo "explication=La mémoire présente un signal à surveiller, mais aucune situation critique n'est actuellement établie."
        echo "action=Une surveillance de l'évolution est recommandée."
        ;;

    PROBLEM)
        echo "état=PROBLÈME"
        echo "explication=Les mesures indiquent une situation mémoire nécessitant une action corrective."
        echo "action=Une action corrective est recommandée."
        ;;

    IMPOSSIBLE)
        echo "état=INDETERMINE"
        echo "explication=Les données disponibles ne permettent pas d'établir un diagnostic fiable."
        echo "action=De nouvelles mesures sont nécessaires."
        ;;

    *)
        echo "état=INDETERMINE"
        echo "explication=Le moteur ne dispose pas d'un diagnostic exploitable."
        echo "action=De nouvelles mesures sont nécessaires."
        ;;
esac

echo
echo "diagnosis=$DIAGNOSIS"
echo "action=$ACTION"
