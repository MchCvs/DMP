#!/bin/bash
source "$(dirname "$0")/lib.sh"; NL=$'\n'; export LC_ALL=C; S=0
I18="$(dirname "$0")/../i18n"; LG=${DMP_LANG:-fr}; [ -f "$I18/$LG/d3.sh" ] || LG=fr
. "$I18/$LG/d3.sh"
read DF DP <<< $(df -h --output=avail,pcent / | tail -1); [ ${DP%\%} -lt 75 ] && { E1="✅"; S=$((S+1)); } || E1="🟡"
MA=$(awk '/MemAvailable/{a=$2}/MemTotal/{t=$2}END{printf "%d %.1f",a*100/t,a/1048576}' /proc/meminfo); MP=${MA% *}; MG=${MA#* }; [ $MP -ge 30 ] && { E2="✅"; S=$((S+1)); } || E2="🟡"
UP=$(apt list --upgradable 2>/dev/null | tail -n +2 | wc -l); [ $UP -eq 0 ] && { E3="✅"; S=$((S+1)); } || E3="🟡"
[ $UP -eq 0 ] && UPT="$T_ALL" || UPT="$UP $T_PEND"
{ systemctl is-active --quiet ufw || grep -qi "^ENABLED=yes" /etc/ufw/ufw.conf; } && { FW="$T_ON"; E4="✅"; S=$((S+1)); } || { FW="$T_OFF"; E4="🟡"; }
T_O
export X="$T_X"
export NV=$LV
j "$T_COMP" "$O" "$R" "$T_CMD"
