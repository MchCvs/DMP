#!/bin/bash
source "$(dirname "$0")/lib.sh"; NL=$'\n'; export LC_ALL=C
I18="$(dirname "$0")/../i18n"; LG=${DMP_LANG:-fr}; [ -f "$I18/$LG/c3.sh" ] || LG=fr
. "$I18/$LG/c3.sh"
mb(){ [ -d "$1" ] && du -sm "$1" 2>/dev/null | cut -f1 || echo 0; }
AR=$(apt-get -s autoremove 2>/dev/null | grep -c '^Remv'); CA=$(mb /var/cache/apt/archives); UC=$(mb ~/.cache); TR=$(mb ~/.local/share/Trash)
KE=$(dpkg -l 'linux-image-[0-9]*' 2>/dev/null | grep -c '^ii'); RC=$(dpkg -l | grep -c '^rc'); JD=$(journalctl --disk-usage 2>/dev/null | sed -n 's/.*take up \([0-9.]*[KMGB]*\).*/\1/p')
REC=$((CA+TR))
if [ $REC -ge 2000 ] || [ $AR -gt 5 ] || [ $KE -gt 3 ]; then CL=big; elif [ $REC -ge 500 ] || [ $AR -gt 0 ]; then CL=some; else CL=ok; fi
T_O
case "$LG" in en) NOP="Nothing to do.";; de) NOP="Nichts zu tun.";; *) NOP="Rien à faire.";; esac
O=$(printf '%s\n' "$O" | awk -v msg="$NOP" '
/^[0-9]+\) /{n=$0;sub(/\).*/,"",n);n+=0;z=($0 ~ /: 0( [A-Za-z]+)?$/);said=0}
$0==""{z=0}
z && /^   • / && (n==4 || /sudo/){if(!said){print "   • " msg;said=1};next}
{print}')
UP=$(apt-get -s upgrade 2>/dev/null | grep -c '^Inst'); case "$LG" in fr) MU=Mo;; *) MU=MB;; esac
POSS=$(python3 -c 'import json,sys
ar,up,ca,mu=int(sys.argv[1] or 0),int(sys.argv[2] or 0),int(sys.argv[3] or 0),sys.argv[4]
print(json.dumps({"updates":{"detected":up>0,"count":up},"autoremove":{"detected":ar>0,"count":ar},"cleanup":{"detected":ca>0,"apt_cache_mb":ca,"apt_cache_human":"%d %s"%(ca,mu)}}))' "$AR" "$UP" "$CA" "$MU"); export POSS
export X; j "$T_COMP" "$O" "$R" "$T_CMD"
