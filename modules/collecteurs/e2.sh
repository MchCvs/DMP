#!/bin/bash
I18="$(dirname "$0")/../i18n"; LG=${DMP_LANG:-fr}; [ -f "$I18/$LG/e2.sh" ] || LG=fr
. "$I18/$LG/e2.sh"
CPU_USAGE=$(ps aux | awk '{sum+=$3} END {print int(sum)}')
MEM_USAGE=$(free | grep "^Mem:" | awk '{print int(($3/$2)*100)}')
DISK_USAGE=$(df / | tail -1 | awk '{print int(($3/$2)*100)}')
SCORE=$((100 - (CPU_USAGE + MEM_USAGE + DISK_USAGE) / 3))
SCORE=$([[ $SCORE -lt 0 ]] && echo 0 || echo $SCORE)
if [[ $SCORE -gt 80 ]]; then RES="$T_EXC"; elif [[ $SCORE -gt 60 ]]; then RES="$T_GOOD"; else RES="$T_IMP"; fi
T_O
echo "{\"comprendre\":\"$T_COMP\",\"observations\":\"$O\",\"resultat\":\"$RES\",\"informations_techniques\":{\"cmd\":\"$T_CMD\",\"cpu\":$CPU_USAGE,\"mem\":$MEM_USAGE,\"disk\":$DISK_USAGE,\"score\":$SCORE,\"note\":\"$T_NOTE\"}}"
