#!/bin/bash

# ==================================================
# DMP - Fonctions avancées
# Navigation DMP v1
# ==================================================


menu_avance()
{

while true
do

clear

dmp_ui_print_title "$MENU_ADVANCED_TITLE"
echo
echo "1 - $MENU_ADVANCED_CHECK"
echo "2 - $MENU_ADVANCED_PLUGINS"
echo
echo "0 - $MENU_BACK_MAIN"
echo

read -p "$PROMPT_CHOICE " CHOICE


case "$CHOICE" in

1)
"$BASE_DIR/dmp-check.sh"
read -p "Entrée pour revenir..."
;;

2)
list_plugins
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
