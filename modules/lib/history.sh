#!/bin/bash
DMP_DATA="${DMP_DATA:-${XDG_DATA_HOME:-$HOME/.local/share}/dmp}"

# ==================================================
# DMP - Historique machine
# Version 1.3.0
# ==================================================


history_check()
{

clear

echo "=============================================="
echo " HISTORIQUE MACHINE DMP"
echo "=============================================="

REPORT_DIR="${REPORT_DIR:-${DMP_DATA}/reports}"
HISTORY="$REPORT_DIR/history.csv"

mkdir -p "$REPORT_DIR"


if [ ! -f "$HISTORY" ]
then

echo "Date;Score;Temperature_CPU;RAM_disponible;Disque_utilise;Boot" > "$HISTORY"

fi


DATE=$(date "+%Y-%m-%d %H:%M")


TEMP=$(sensors 2>/dev/null | grep "Package id 0" | awk '{print $4}' | tr -d '+°C')

if [ -z "$TEMP" ]
then
TEMP="N/A"
fi


RAM=$(free -h | awk '/Mem:/ {print $7}')


DISK=$(df -h / | awk 'NR==2 {print $5}')


BOOT=$(systemd-analyze | awk -F= '{print $2}' | awk '{print $1}')


echo "$DATE;N/A;$TEMP;$RAM;$DISK;$BOOT" >> "$HISTORY"


echo
echo "Nouvelle mesure enregistrée :"
echo
tail -1 "$HISTORY"

echo
echo "Fichier :"
echo "$HISTORY"

}
