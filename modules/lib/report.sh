#!/bin/bash

# ==================================================
# DMP - Rapport complet
# Version 0.7.0
# ==================================================


generate_report()
{

clear


mkdir -p "$REPORT_DIR"


DATE=$(date +"%Y-%m-%d_%H-%M-%S")

REPORT="$REPORT_DIR/rapport_DMP_$DATE.txt"


echo "==============================================" > "$REPORT"
echo " Debian Maintenance Professional" >> "$REPORT"
echo " Rapport complet système" >> "$REPORT"
echo " Date : $(date)" >> "$REPORT"
echo "==============================================" >> "$REPORT"


echo >> "$REPORT"
echo "SYSTEME" >> "$REPORT"
echo "----------------------------------------------" >> "$REPORT"

echo "Machine : $(hostname)" >> "$REPORT"

grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"' \
>> "$REPORT"

echo "Noyau : $(uname -r)" >> "$REPORT"

echo "Architecture : $(uname -m)" >> "$REPORT"



echo >> "$REPORT"
echo "CPU" >> "$REPORT"
echo "----------------------------------------------" >> "$REPORT"

lscpu | grep -i "Nom de modèle" >> "$REPORT"



echo >> "$REPORT"
echo "MEMOIRE" >> "$REPORT"
echo "----------------------------------------------" >> "$REPORT"

free -h >> "$REPORT"



echo >> "$REPORT"
echo "STOCKAGE" >> "$REPORT"
echo "----------------------------------------------" >> "$REPORT"

lsblk -o NAME,MODEL,SIZE,FSTYPE,MOUNTPOINTS \
>> "$REPORT"



echo >> "$REPORT"
echo "ESPACE DISQUE" >> "$REPORT"
echo "----------------------------------------------" >> "$REPORT"

df -h / >> "$REPORT"



echo >> "$REPORT"
echo "SSD / TRIM" >> "$REPORT"
echo "----------------------------------------------" >> "$REPORT"

systemctl status fstrim.timer --no-pager \
>> "$REPORT" 2>&1



echo >> "$REPORT"
echo "PAQUETS" >> "$REPORT"
echo "----------------------------------------------" >> "$REPORT"

AUDIT=$(dpkg --audit)

if [ -z "$AUDIT" ]; then
echo "Paquets cassés : aucun" >> "$REPORT"
else
echo "$AUDIT" >> "$REPORT"
fi



echo >> "$REPORT"
echo "MISES A JOUR" >> "$REPORT"
echo "----------------------------------------------" >> "$REPORT"

apt list --upgradable 2>/dev/null \
| grep -v "Listing" >> "$REPORT"



echo >> "$REPORT"
echo "FIN DU RAPPORT" >> "$REPORT"


echo
echo "=============================================="
echo " Rapport généré"
echo "=============================================="
echo
echo "$REPORT"

}
