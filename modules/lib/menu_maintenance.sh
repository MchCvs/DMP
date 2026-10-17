#!/bin/bash

# ==================================================
# DMP - Prendre soin de ma machine
# Navigation DMP v1
# ==================================================


menu_maintenance()
{

while true
do

clear

dmp_ui_print_title "$MENU_MAINTENANCE_TITLE — Menu 3"
echo
echo "1 - $MENU_MAINTENANCE_SYSTEM"
echo "2 - $MENU_MAINTENANCE_CLEANUP"
echo "3 - $MENU_MAINTENANCE_OPTIMIZE"
echo "4 - $MENU_MAINTENANCE_RECOMMEND"
echo
echo "0 - $MENU_BACK_MAIN"
echo

read -p "$PROMPT_CHOICE " CHOICE


case "$CHOICE" in

1)
maintenance_debian
read -p "Entrée pour revenir..."
;;

2)
cleanup_system
read -p "Entrée pour revenir..."
;;

3)
system_optimization
read -p "Entrée pour revenir..."
;;

4)
recommended_optimizations
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
