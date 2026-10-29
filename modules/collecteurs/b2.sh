#!/bin/bash
source "$(dirname "$0")/lib.sh"; NL=$'\n'
I18="$(dirname "$0")/../i18n"; LG=${DMP_LANG:-fr}; [ -f "$I18/$LG/b2.sh" ] || LG=fr
. "$I18/$LG/b2.sh"
read -r _ a b c d e f g _ < /proc/stat; t1=$((a+b+c+d+e+f+g)); i1=$((d+e)); sleep 1
read -r _ a b c d e f g _ < /proc/stat; t2=$((a+b+c+d+e+f+g)); i2=$((d+e))
dt=$((t2-t1)); [ $dt -le 0 ] && dt=1; P=$(( (dt-(i2-i1))*100/dt ))
RAW=$(ps -eo pcpu,comm --sort=-pcpu --no-headers | grep -v '^ *[0-9.]* *ps$' | head -3)
if [ $P -ge 85 ]; then PL=2; elif [ $P -ge 50 ]; then PL=1; else PL=0; fi
T_O
export NV=$LV
export X; j "$T_COMP" "$O" "$R" "$T_CMD"
