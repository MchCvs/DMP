#!/bin/bash
source "$(dirname "$0")/lib.sh"; NL=$'\n'; export LC_ALL=C
I18="$(dirname "$0")/../i18n"; LG=${DMP_LANG:-fr}; [ -f "$I18/$LG/c1.sh" ] || LG=fr
. "$I18/$LG/c1.sh"
L=$(apt list --upgradable 2>/dev/null | tail -n +2); UP=$(echo "$L" | grep -c .); SU=$(echo "$L" | grep -ci security)
ST=/var/lib/apt/periodic/update-success-stamp; [ -f $ST ] && AG=$(( ($(date +%s)-$(stat -c %Y $ST))/86400 )) || AG=-1
LST=$( (echo "$L" | grep -i security; echo "$L" | grep -vi security) | grep . | head -15 | awk -v sec="$T_SECL" -v ord="$T_ORDL" -v f="$T_LFMT" '{split($1,a,"/");o=$NF;sub(/\]/,"",o);s=($0~/[Ss]ecurity/)?sec:ord;printf f,a[1],o,$2,s}')
T_O
if [ "$SU" -gt 0 ]; then NV=2; elif [ "$UP" -gt 0 ]; then NV=1; else NV=0; fi
export NV
export X; j "$T_COMP" "$O" "$R" "$T_CMD"
