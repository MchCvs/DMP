#!/bin/bash
source "$(dirname "$0")/lib.sh"; NL=$'\n'; export LC_ALL=C
I18="$(dirname "$0")/../i18n"; LG=${DMP_LANG:-fr}; [ -f "$I18/$LG/b6.sh" ] || LG=fr
. "$I18/$LG/b6.sh"
RUN=$(systemctl list-units --type=service --state=running --no-legend --plain 2>/dev/null | wc -l)
ENA=$(systemctl list-unit-files --type=service --state=enabled --no-legend 2>/dev/null | wc -l)
FL=$(systemctl --failed --type=service --no-legend --plain 2>/dev/null | awk '{print $1}')
UFL=$(systemctl --user --failed --type=service --no-legend --plain 2>/dev/null | awk '{print $1}')
fiche(){ local u=$1 sc=$2 D RS EX SI CA RO LOG
 D=$(systemctl $sc show -p Description --value "$u" 2>/dev/null); RS=$(systemctl $sc show -p Result --value "$u" 2>/dev/null)
 EX=$(systemctl $sc show -p ExecMainStatus --value "$u" 2>/dev/null); SI=$(systemctl $sc show -p StateChangeTimestamp --value "$u" 2>/dev/null)
 LOG=$(journalctl $sc -u "$u" -n 3 --no-pager -o cat 2>/dev/null | cut -c1-150 | sed 's/^/         /')
 T_FICHE
}
NF=$(echo "$FL" | grep -c .); NUF=$(echo "$UFL" | grep -c .); FI=""
for u in $FL; do FI="$FI$(fiche $u)${NL}"; done
for u in $UFL; do FI="$FI$(fiche $u --user)${NL}"; done
IM=""
svc(){ systemctl cat "$1" >/dev/null 2>&1 || return; a=$(systemctl is-active "$1"); case $a in active) SK=active;; failed) SK=failed;; *) SK=other;; esac; T_SVC "$1" "$2" "$3"; }
ls /sys/class/bluetooth/* >/dev/null 2>&1 && BT=1 || BT=0
ls -d /sys/class/net/*/wireless >/dev/null 2>&1 && WF=1 || WF=0
T_SVCS
T=$((NF+NUF))
if [ $T -eq 0 ]; then TL=0; elif [ $T -le 2 ]; then TL=1; else TL=2; fi
T_O
export NV=$TL
export X; j "$T_COMP" "$O" "$R" "$T_CMD"
