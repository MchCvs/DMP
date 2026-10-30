#!/bin/bash
source "$(dirname "$0")/lib.sh"; NL=$'\n'; export LC_ALL=C
ID="$(dirname "$0")/../i18n"; LG=${DMP_LANG:-fr}; [ -f "$ID/$LG/a3.sh" ] || LG=fr
. "$ID/$LG/a3.sh"
read S U A P <<< $(df -h --output=size,used,avail,pcent / | tail -1); NP=${P%\%}; SG=$(df -BG --output=size / | tail -1 | tr -dc 0-9)
D=""; N=0
while read -r n s r ty m; do [ "$ty" = disk ] || continue; [[ "$n" == zram* ]] && continue; N=$((N+1))
 G=$(awk -v b=$s 'BEGIN{printf "%.1f",b/1e9}'); RMV=$(cat /sys/block/$n/removable 2>/dev/null); TR=$(lsblk -dno TRAN /dev/$n 2>/dev/null)
 if [[ "$m" =~ SSD|ssd ]]; then KT=ssd; elif [ "$r" = 0 ]; then KT=ssd; elif [ "$RMV" = 1 ] || [ "$TR" = usb ]; then KT=usb; else KT=hdd; fi
 T_K
 # PT=""; while read -r pn ps pf pm; do [ -z "$pm" ] && continue; u=$(df -h --output=used,pcent "$pm" 2>/dev/null | tail -1 | awk '{print $1" ("$2")"}'); T_PART; done < <(lsblk -nrpo NAME,SIZE,FSTYPE,MOUNTPOINT /dev/$n | tail -n +2)
 T_DISK
done < <(lsblk -dnbo NAME,SIZE,ROTA,TYPE,MODEL)
if [ $SG -ge 500 ]; then SL=3; elif [ $SG -ge 200 ]; then SL=2; else SL=1; fi
T_O
if [ "$NP" -lt 50 ]; then DL=0; elif [ "$NP" -lt 85 ]; then DL=1; else DL=2; fi
export NV=$DL
export X="$SU"; j "$T_COMP" "$O" "$R" "$T_CMD"
