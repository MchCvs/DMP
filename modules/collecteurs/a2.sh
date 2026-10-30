#!/bin/bash
source "$(dirname "$0")/lib.sh"
ID="$(dirname "$0")/../i18n"; LG=${DMP_LANG:-fr}; [ -f "$ID/$LG/a2.sh" ] || LG=fr
. "$ID/$LG/a2.sh"
T=$(awk '/MemTotal/{printf "%.1f",$2/1048576}' /proc/meminfo)
D=$(awk '/MemAvailable/{printf "%.1f",$2/1048576}' /proc/meminfo)
P=$(awk '/MemTotal/{t=$2}/MemAvailable/{a=$2}END{printf "%d",(t-a)*100/t}' /proc/meminfo)
I=${T%.*}
if [ "$I" -ge 16 ]; then LV=3; elif [ "$I" -ge 8 ]; then LV=2; elif [ "$I" -ge 4 ]; then LV=1; else LV=0; fi
if [ "$P" -lt 50 ]; then PL=0; elif [ "$P" -lt 85 ]; then PL=1; else PL=2; fi
T_O
export X
export NV=$PL
j "$T_COMP" "$O" "$R" "$T_CMD"
