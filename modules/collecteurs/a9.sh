#!/bin/bash
source "$(dirname "$0")/lib.sh"
I18="$(dirname "$0")/../i18n"; LG=${DMP_LANG:-fr}; [ -f "$I18/$LG/a9.sh" ] || LG=fr
. "$I18/$LG/a9.sh"
b=$(ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -1)
if [ -z "$b" ]; then j "$T_COMP_NO" "$T_NO_O" "$T_NO_R" "$T_CMD"; exit; fi
P=$(cat $b/capacity); S=$(cat $b/status)
full=$(cat $b/energy_full 2>/dev/null || cat $b/charge_full 2>/dev/null); des=$(cat $b/energy_full_design 2>/dev/null || cat $b/charge_full_design 2>/dev/null)
WL=none; W=""
if [ -n "$full" ] && [ -n "$des" ] && [ "$des" -gt 0 ]; then W=$((full*100/des)); if [ $W -ge 80 ]; then WL=good; elif [ $W -ge 60 ]; then WL=mid; else WL=bad; fi; fi
T_O
export X
export NV=$LV
j "$T_COMP" "$O" "$R" "$T_CMD"
