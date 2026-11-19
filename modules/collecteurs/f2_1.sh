#!/bin/bash
source "$(dirname "$0")/lib.sh"; NL=$'\n'; export LC_ALL=C
. "$(dirname "$0")/../i18n/langues.sh"
I18="$(dirname "$0")/../i18n"; LG=${DMP_LANG:-fr}; [ -f "$I18/$LG/f2_1.sh" ] || LG=fr
. "$I18/$LG/f2_1.sh"
T=""; for t in timeshift borg restic rsnapshot rsync deja-dup pika-backup; do command -v $t >/dev/null && T="$T $t"; done; command -v flatpak >/dev/null && flatpak list --app 2>/dev/null | grep -qi pika && T="$T pika-backup(flatpak)"
SNSYS=$(ls -d /timeshift/snapshots/*/ 2>/dev/null | sort | tail -1)
SNEXT=$(ls -d /media/*/*/timeshift/snapshots/*/ /mnt/*/timeshift/snapshots/*/ 2>/dev/null | sort | tail -1)
SN="${SNSYS:-$SNEXT}"
BK=$(ls -t /var/backups/*.gz 2>/dev/null | head -1); [ -n "$BK" ] && BKD=$(date -r "$BK" +%d/%m/%Y) || BKD="$T_NOBK"
EXT=$(lsblk -dno RM,TYPE 2>/dev/null | awk '$1==1&&$2=="disk"' | wc -l)
T_O1
BR=$(find /media /run/media -maxdepth 5 -name "hints.*" 2>/dev/null | head -1); [ -n "$BR" ] && { BRD=$(date -r "$BR" +%d/%m/%Y); BAGE=$(( ($(date +%s)-$(stat -c %Y "$BR"))/86400 )); }
T_O2
MEMOF="$HOME/.local/share/dmp/derniere-sauvegarde.txt"
MEMO=$(cat "$MEMOF" 2>/dev/null)
[[ "$MEMO" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] || MEMO=""
d_of(){ basename "${1%/}" | cut -c1-10; }
SDSYS=""; [ -n "$SNSYS" ] && SDSYS=$(d_of "$SNSYS")
SDEXT=""; [ -n "$SNEXT" ] && SDEXT=$(d_of "$SNEXT")
LAST="$MEMO"; LASTSRC=memo
for c in "$SDSYS:sys" "$SDEXT:ext"; do
  d=${c%%:*}; s=${c##*:}
  [[ "$d" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] || continue
  if [ -z "$LAST" ] || [[ "$d" > "$LAST" ]]; then LAST="$d"; LASTSRC=$s; fi
done
if [ -n "$LAST" ] && [ "$LASTSRC" != memo ]; then mkdir -p "$(dirname "$MEMOF")"; echo "$LAST" > "$MEMOF"; fi
if [ "$LASTSRC" = memo ] && [[ "$LAST" > "$SDSYS" ]] && [[ "$LAST" > "$SDEXT" ]]; then ST=memo
elif [ -n "$BR" ]; then if [ $BAGE -gt 7 ]; then ST=old; else ST=recent; fi
elif [ -z "$T" ] && [ -z "$LAST" ]; then ST=none
elif [ -z "$LAST" ]; then ST=tool
else ST=ok; fi
LAST_DISP="$LAST"
T_RX
case "$ST" in ok|recent) NV=0;; old|tool|memo) NV=1;; none) NV=2;; *) NV=3;; esac
export NV
export X; j "$T_COMP" "$O" "$R" "$T_CMD"
