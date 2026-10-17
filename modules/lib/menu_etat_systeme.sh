#!/bin/bash

# ==================================================
# DMP - Comprendre l'état actuel du système Debian
# Navigation DMP v1 + intégration mémoire DMP V2
# ==================================================

DMP_MEMORY_MODULE="${DMP_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}/memory_module.sh"

menu_etat_systeme()
{

while true
do

clear

dmp_ui_print_title "$MENU_SYSTEM_STATE_TITLE — Menu 2"
echo
echo "1 - $MENU_SYSTEM_STATE_DISKS"
echo "2 - $MENU_SYSTEM_STATE_PERFORMANCE"
echo "3 - État détaillé de la mémoire"
echo
echo "0 - $MENU_BACK_MAIN"
echo

read -p "$PROMPT_CHOICE " CHOICE


case "$CHOICE" in

1)
ssd_check
read -p "Entrée pour revenir..."
;;

2)
performance_check
read -p "Entrée pour revenir..."
;;

3)
if [[ -x "$DMP_MEMORY_MODULE" ]]; then
    "$DMP_MEMORY_MODULE"
else
    echo
    echo "Le module mémoire DMP V2 est indisponible."
    echo
fi
read -p "Entrée pour revenir..."
;;

0)
return
;;

*)
echo "$MSG_INVALID_CHOICE"
sleep 2
;;

esac

done

}
