#!/bin/bash
source "$(dirname "$0")/lib.sh"
ID="$(dirname "$0")/../i18n"; LG=${DMP_LANG:-fr}; [ -f "$ID/$LG/a4.sh" ] || LG=fr
. "$ID/$LG/a4.sh"
F=$(ip route | awk '/default/{print $5;exit}')
if [ -z "$F" ]; then j "$T_COMP" "$T_NO_O" "$T_NO_R" "$T_NO_CMD"; exit; fi
A=$(ip -4 -o addr show "$F" | awk '{print $4}' | head -1)
WL=""; [ -d /sys/class/net/$F/wireless ] && WL=1
T_O
export X
export NV=$LV
j "$T_COMP" "$O" "$R" "$T_CMD"
