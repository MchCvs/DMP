#!/bin/bash

# ==================================================
# DMP - Menu principal
# Version 1.8.4
# Navigation DMP v1
# ==================================================

MENU_WIDTH=2


show_header()
{
    clear
    dmp_ui_print_title "$DMP_NAME — Version $DMP_VERSION"
    echo
}


main_menu()
{

while true
do

show_header

printf "%${MENU_WIDTH}s - %s\n" "1" "$MENU_MAIN_MACHINE"
printf "%${MENU_WIDTH}s - %s\n" "2" "$MENU_MAIN_SYSTEM_STATE"
printf "%${MENU_WIDTH}s - %s\n" "3" "$MENU_MAIN_MAINTENANCE"
printf "%${MENU_WIDTH}s - %s\n" "4" "$MENU_MAIN_EVOLUTION"
printf "%${MENU_WIDTH}s - %s\n" "5" "$MENU_MAIN_RESULTS"
printf "%${MENU_WIDTH}s - %s\n" "6" "$MENU_MAIN_ADVANCED"
printf "%${MENU_WIDTH}s - %s\n" "0" "$MENU_EXIT"

echo

read -p "$PROMPT_CHOICE " CHOICE


case "$CHOICE" in

1)
menu_comprendre_machine
;;

2)
menu_etat_systeme
;;

3)
menu_maintenance
;;

4)
menu_evolution
;;

5)
menu_resultats
;;

6)
menu_avance
;;

0)
echo "$MSG_EXIT"
exit 0
;;

*)
echo "$MSG_INVALID_CHOICE"
sleep 2
;;

esac

done

}
