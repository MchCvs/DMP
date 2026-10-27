#!/bin/bash
I18="$(dirname "$0")/../i18n"; LG=${DMP_LANG:-fr}; [ -f "$I18/$LG/e5.sh" ] || LG=fr
. "$I18/$LG/e5.sh"
UPTIME=$(uptime -p 2>/dev/null | sed 's/up //')
LOAD=$(cat /proc/loadavg | awk '{print $1}')
T_O
echo "{\"comprendre\":\"$T_COMP\",\"observations\":\"$O\",\"resultat\":\"$T_R\",\"informations_techniques\":{\"cmd\":\"$T_CMD\",\"uptime\":\"$UPTIME\",\"load_avg\":$LOAD,\"note\":\"$T_NOTE\"}}"
