#!/bin/bash

# ==================================================
# DMP - Consulter mes résultats DMP
# Navigation DMP v1
# ==================================================


menu_resultats()
{

while true
do

clear

dmp_ui_print_title "$MENU_RESULTS_TITLE"
echo
echo "1 - $MENU_RESULTS_REPORT"
echo "2 - $MENU_RESULTS_SCORE"
echo "3 - $MENU_RESULTS_HTML"
echo "4 - $MENU_RESULTS_CHART"
echo
echo "0 - $MENU_BACK_MAIN"
echo

read -p "$PROMPT_CHOICE " CHOICE


case "$CHOICE" in

1)
generate_report
read -p "Entrée pour revenir..."
;;

2)
health_score
read -p "Entrée pour revenir..."
;;

3)
generate_html_report
read -p "Entrée pour revenir..."
;;

4)
generate_chart_data
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
