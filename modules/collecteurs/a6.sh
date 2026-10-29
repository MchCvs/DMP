#!/bin/bash
source "$(dirname "$0")/lib.sh"
I18="$(dirname "$0")/../i18n"; LG=${DMP_LANG:-fr}; [ -f "$I18/$LG/a6.sh" ] || LG=fr
. "$I18/$LG/a6.sh"
d=/sys/class/dmi/id
V=$(cat $d/board_vendor 2>/dev/null); N=$(cat $d/board_name 2>/dev/null); B=$(cat $d/bios_version 2>/dev/null); Y=$(cat $d/bios_date 2>/dev/null)
if [ -z "$V$N" ]; then j "$T_COMP_NO" "$T_NO_O" "$T_NO_R" "$T_CMD"; exit; fi
yr=${Y##*/}; XA=""
if [[ "$yr" =~ ^[0-9]{4}$ ]]; then XA=$(( $(date +%Y) - yr )); fi
T_O
export X
export NV=$LV
j "$T_COMP" "$O" "$R" "$T_CMD"
