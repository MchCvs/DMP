#!/bin/bash
source "$(dirname "$0")/lib.sh"; NL=$'\n'; export LC_ALL=C
I18="$(dirname "$0")/../i18n"; LG=${DMP_LANG:-fr}; [ -f "$I18/$LG/f2_1.sh" ] || LG=fr
. "$I18/$LG/f2_1.sh"
T=""; for t in timeshift borg restic rsnapshot rsync deja-dup pika-backup; do command -v $t >/dev/null && T="$T $t"; done; command -v flatpak >/dev/null && flatpak list --app 2>/dev/null | grep -qi pika && T="$T pika-backup(flatpak)"
SN=$(ls -d /timeshift/snapshots/*/* 2>/dev/null | tail -1)
BK=$(ls -t /var/backups/*.gz 2>/dev/null | head -1); [ -n "$BK" ] && BKD=$(date -r "$BK" +%d/%m/%Y) || BKD="$T_NOBK"
EXT=$(lsblk -dno RM,TYPE 2>/dev/null | awk '$1==1&&$2=="disk"' | wc -l)
T_O1
BR=$(find /media /run/media -maxdepth 5 -name "hints.*" 2>/dev/null | head -1); [ -n "$BR" ] && { BRD=$(date -r "$BR" +%d/%m/%Y); BAGE=$(( ($(date +%s)-$(stat -c %Y "$BR"))/86400 )); }
T_O2
if [ -n "$BR" ]; then if [ $BAGE -gt 7 ]; then ST=old; else ST=recent; fi
elif [ -z "$T" ] && [ -z "$SN" ]; then ST=none
elif [ -z "$SN" ]; then ST=tool
else ST=ok; fi
T_RX
export X; j "$T_COMP" "$O" "$R" "$T_CMD"
