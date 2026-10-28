#!/bin/bash
source "$(dirname "$0")/lib.sh"; NL=$'\n'; export LC_ALL=C
I18="$(dirname "$0")/../i18n"; LG=${DMP_LANG:-fr}; [ -f "$I18/$LG/f3.sh" ] || LG=fr
. "$I18/$LG/f3.sh"
mbs(){ awk '/copied/{v=$(NF-1);u=$NF;if(u=="GB/s")v*=1000;if(u=="kB/s")v/=1000;printf "%d",v}'; }
S=$(date +%s.%N); python3 -c 'x=0
for i in range(5000000): x+=i*i'; E=$(date +%s.%N); CT=$(awk -v a=$S -v b=$E 'BEGIN{printf "%.2f",b-a}'); CI=$(awk -v t=$CT 'BEGIN{printf "%d",t*100}')
MM=$(dd if=/dev/zero of=/dev/null bs=1M count=3000 2>&1 | mbs); MM=${MM:-0}
F=$HOME/.dmp-bench; DW=$(dd if=/dev/zero of=$F bs=1M count=64 conv=fdatasync 2>&1 | mbs); rm -f $F; DW=${DW:-0}
dev=$(lsblk -no PKNAME "$(findmnt -no SOURCE /)" 2>/dev/null | head -1); DK="$T_DKU"; [ -r /sys/block/$dev/queue/rotational ] && { [ "$(cat /sys/block/$dev/queue/rotational)" = 0 ] && DK="$T_SSD" || DK="$T_HDD"; }
lv(){ [ $1 -lt $2 ] && echo 0 || { [ $1 -lt $3 ] && echo 1 || echo 2; }; }
LC=$(lv $CI 80 160); LM=$([ $MM -ge 4000 ] && echo 0 || { [ $MM -ge 1500 ] && echo 1 || echo 2; }); LD=$([ $DW -ge 300 ] && echo 0 || { [ $DW -ge 100 ] && echo 1 || echo 2; })
W=$LC; [ $LM -gt $W ] && W=$LM; [ $LD -gt $W ] && W=$LD
vd(){ case $1 in 0) echo "$T_V0";; 1) echo "$T_V1";; *) echo "$T_V2";; esac; }
T_O
T_RX
export X; j "$T_COMP" "$O" "$R" "$T_CMD"
