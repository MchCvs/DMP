#!/bin/bash

# ==================================================
# DMP - Analyse historique
# Version 1.4.0
# ==================================================


history_view()
{

clear

echo "=============================================="
echo " TABLEAU DE BORD HISTORIQUE DMP"
echo "=============================================="

HISTORY="$REPORT_DIR/history.csv"


if [ ! -f "$HISTORY" ]
then
    echo
    echo "Aucun historique disponible."
    return
fi


echo
echo "Nombre de mesures :"

tail -n +2 "$HISTORY" | wc -l


echo
echo "----------------------------------------------"
echo " Dernière mesure"
echo "----------------------------------------------"

tail -1 "$HISTORY"


echo
echo "----------------------------------------------"
echo " Température moyenne"
echo "----------------------------------------------"

awk -F";" '
NR>1 && $3!="N/A" {sum+=$3; count++}
END {
if(count>0)
printf "%.1f °C\n",sum/count
else
print "N/A"
}' "$HISTORY"


echo
echo "----------------------------------------------"
echo " RAM disponible moyenne"
echo "----------------------------------------------"

awk -F";" '
NR>1 {print $4}
' "$HISTORY"


echo
echo "----------------------------------------------"
echo " Evolution démarrage"
echo "----------------------------------------------"

awk -F";" '
NR>1 {print $1 " : " $6}
' "$HISTORY"


echo
echo "=============================================="
echo " Analyse terminée"
echo "=============================================="

}
