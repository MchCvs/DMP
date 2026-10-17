#!/bin/bash

# ==================================================
# DMP - Suivre les évolutions de mon système
# Navigation DMP v1
# ==================================================


menu_evolution()
{

while true
do

clear

dmp_ui_print_title "$MENU_EVOLUTION_TITLE — Menu 4"
echo
echo "1 - $MENU_EVOLUTION_HISTORY"
echo "2 - $MENU_EVOLUTION_ANALYSIS"
echo
echo "0 - $MENU_BACK_MAIN"
echo

read -p "$PROMPT_CHOICE " CHOICE


case "$CHOICE" in

1)
history_check
read -p "Entrée pour revenir..."
;;

2)
history_view
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
