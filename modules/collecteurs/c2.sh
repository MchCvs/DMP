#!/bin/bash
source "$(dirname "$0")/lib.sh"; NL=$'\n'; export LC_ALL=C
I18="$(dirname "$0")/../i18n"; LG=${DMP_LANG:-fr}; [ -f "$I18/$LG/c2.sh" ] || LG=fr
. "$I18/$LG/c2.sh"
TBL=$(dpkg-query -Wf '${db:Status-Abbrev}\t${Installed-Size}\t${Package}\t${binary:Summary}\n' 2>/dev/null | awk -F'\t' '$1~/^ii/')
NI=$(echo "$TBL" | grep -c .); TOT=$(echo "$TBL" | awk -F'\t' '{s+=$2}END{printf "%.1f",s/1048576}')
MAN=$(apt-mark showmanual | wc -l); HOLD=$(apt-mark showhold | wc -l); BRK=$(dpkg --audit 2>/dev/null | grep -c .); RC=$(dpkg -l | grep -c '^rc')
BIG=$(echo "$TBL" | sort -t$'\t' -k2 -nr | head -10 | awk -F'\t' -v f="$T_BIGFMT" '{printf f,NR,$3,$2/1024,$4}')
if [ $BRK -gt 0 ]; then HL=brk; elif [ $HOLD -gt 0 ]; then HL=hold; else HL=ok; fi
T_O
export X; j "$T_COMP" "$O" "$R" "$T_CMD"
