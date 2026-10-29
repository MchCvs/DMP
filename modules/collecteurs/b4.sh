#!/bin/bash
source "$(dirname "$0")/lib.sh"; NL=$'\n'
I18="$(dirname "$0")/../i18n"; LG=${DMP_LANG:-fr}; [ -f "$I18/$LG/b4.sh" ] || LG=fr
. "$I18/$LG/b4.sh"
D=""; ND=0
while read -r n s r ty m; do [ "$ty" = disk ] || continue; [[ "$n" == zram* ]] && continue
 RMV=$(cat /sys/block/$n/removable 2>/dev/null); TR=$(lsblk -dno TRAN /dev/$n 2>/dev/null)
 if [ "$RMV" = 1 ] || [ "$TR" = usb ]; then KT=usb; elif [ "$r" = 0 ]; then KT=ssd; else KT=hdd; fi
 T_K
 ND=$((ND+1)); T_DISK; done < <(LC_ALL=C lsblk -dno NAME,SIZE,ROTA,TYPE,MODEL)
SA=""; HN=0
for dk in $(LC_ALL=C lsblk -dno NAME,TYPE | awk '$2=="disk" && $1!~/^zram/{print $1}'); do
 T=$(python3 "$(dirname "$0")/sante.py" "$dk" "$LG"); c=$?
 if [ $c -eq 3 ]; then T_NOHEALTH; elif [ $c -gt $HN ]; then HN=$c; fi
 T_SAD
done
P=""; W=0
while read -r s f t u a p tg; do n=${p%\%}; [ "$n" -gt "$W" ] && W=$n
 T_FS; T_RO; T_PART
done < <(LC_ALL=C df -h --output=source,fstype,size,used,avail,pcent,target -x tmpfs -x devtmpfs -x squashfs -x efivarfs -x overlay | tail -n +2)
if [ $W -ge 90 ]; then WL=2; elif [ $W -ge 75 ]; then WL=1; else WL=0; fi
T_O
export NV=$LV
export X; j "$T_COMP" "$O" "$R" "$T_CMD"
