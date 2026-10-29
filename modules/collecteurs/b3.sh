#!/bin/bash
source "$(dirname "$0")/lib.sh"; NL=$'\n'
I18="$(dirname "$0")/../i18n"; LG=${DMP_LANG:-fr}; [ -f "$I18/$LG/b3.sh" ] || LG=fr
. "$I18/$LG/b3.sh"
read T A ST SF <<< $(awk '/MemTotal/{t=$2}/MemAvailable/{a=$2}/SwapTotal/{st=$2}/SwapFree/{sf=$2}END{printf "%.1f %.1f %.1f %.1f",t/1048576,a/1048576,st/1048576,(st-sf)/1048576}' /proc/meminfo)
P=$(awk '/MemTotal/{t=$2}/MemAvailable/{a=$2}END{printf "%d",(t-a)*100/t}' /proc/meminfo)
RAW=$(ps -eo pmem,comm --sort=-pmem --no-headers | head -3)
if [ $P -ge 85 ]; then PL=2; elif [ $P -ge 60 ]; then PL=1; else PL=0; fi
T_O
export NV=$LV
export X; j "$T_COMP" "$O" "$R" "$T_CMD"
