#!/bin/bash

# ==================================================
# DMP - Comprendre ma machine Debian
# Navigation DMP v1
# ==================================================


menu_comprendre_machine()
{

while true
do

clear

dmp_ui_print_title "$MENU_UNDERSTAND_TITLE — Menu 1"
echo

echo "1 - Découvrir à nouveau ma machine"
echo "2 - Accéder aux outils DMP"
echo "3 - Changer la langue"
echo
echo "0 - $MENU_BACK_MAIN"
echo

read -p "$PROMPT_CHOICE " CHOICE

case "$CHOICE" in

1)
discover_machine
read -p "Entrée pour revenir..."
;;


2)
main_menu
;;


3)
choose_language
source "$BASE_DIR/lib/language.sh"
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

