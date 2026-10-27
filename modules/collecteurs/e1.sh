#!/bin/bash
I18="$(dirname "$0")/../i18n"; LG=${DMP_LANG:-fr}; [ -f "$I18/$LG/e1.sh" ] || LG=fr
. "$I18/$LG/e1.sh"
CORES=$(nproc)
RAM=$(free -h | grep "^Mem:" | awk '{print $2}')
DISK=$(df -h / | tail -1 | awk '{print $2}')
DISK=${DISK:-"non lisible"}
HOSTNAME=$(hostname)
T_O
echo "{\"comprendre\":\"$T_COMP\",\"observations\":\"$O\",\"resultat\":\"$T_R\",\"informations_techniques\":{\"cmd\":\"nproc + free -h + df -h + hostname\",\"cores\":$CORES,\"ram\":\"$RAM\",\"disk\":\"$DISK\",\"hostname\":\"$HOSTNAME\"}}"
