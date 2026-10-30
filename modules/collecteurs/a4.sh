#!/bin/bash
source "$(dirname "$0")/lib.sh"
ID="$(dirname "$0")/../i18n"; LG=${DMP_LANG:-fr}; [ -f "$ID/$LG/a4.sh" ] || LG=fr
. "$ID/$LG/a4.sh"
F=$(ip route | awk '/default/{print $5;exit}')
if [ -z "$F" ]; then export NV=2; j "$T_COMP" "$T_NO_O" "$T_NO_R" "$T_NO_CMD"; exit; fi
A=$(ip -4 -o addr show "$F" | awk '{print $4}' | head -1)
WL=""; [ -d /sys/class/net/$F/wireless ] && WL=1
T_O
if [ -z "$F" ]; then NV=2; else
pg(){ o=$(ping -c3 -i0.2 -W1 "$1" 2>/dev/null); L=$(echo "$o" | sed -n 's/.* \([0-9]*\)% packet loss.*/\1/p'); }
pg 1.1.1.1; NI=${L:-100}
if [ "$NI" -ge 100 ]; then NV=2; elif [ "$NI" -gt 0 ]; then NV=1; else NV=0; fi
fi
export NV
export X
j "$T_COMP" "$O" "$R" "$T_CMD"
