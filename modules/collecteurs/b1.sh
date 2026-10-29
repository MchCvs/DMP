#!/bin/bash
source "$(dirname "$0")/lib.sh"; NL=$'\n'
I18="$(dirname "$0")/../i18n"; LG=${DMP_LANG:-fr}; [ -f "$I18/$LG/b1.sh" ] || LG=fr
. "$I18/$LG/b1.sh"
S=$(cut -d. -f1 /proc/uptime); J=$((S/86400)); H=$((S%86400/3600)); M=$((S%3600/60))
L=$(cut -d' ' -f1 /proc/loadavg); C=$(nproc); DEP=$(uptime -s)
if [ $J -ge 30 ]; then UL=long; elif [ $J -ge 7 ]; then UL=mid; else UL=new; fi
RB=""; [ -f /var/run/reboot-required ] && RB=1
T_O
export NV=$LV
export X; j "$T_COMP" "$O" "$R" "$T_CMD"
