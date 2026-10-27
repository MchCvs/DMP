#!/bin/bash
source "$(dirname "$0")/lib.sh"; NL=$'\n'; export LC_ALL=C
I18="$(dirname "$0")/../i18n"; LG=${DMP_LANG:-fr}; [ -f "$I18/$LG/d2.sh" ] || LG=fr
. "$I18/$LG/d2.sh"
TOP=""; i=0
while IFS=$'\t' read -r sz p sec pri; do [ -z "$p" ] && continue; i=$((i+1)); sec=${sec##*/}
 R=$(T_PKG "$p"); [ -z "$R" ] && R=$(T_SEC "$sec")
 SU=$(T_SU "$p" "$pri")
 TOP="$TOP${NL}$i) $p : $((sz/1024)) $T_MO${NL}   • $T_ROLE $R${NL}   • $T_CAN $SU${NL}"
done < <(dpkg-query -Wf '${Installed-Size}\t${Package}\t${Section}\t${Priority}\n' $(apt-mark showmanual) 2>/dev/null | sort -nr | head -12)
T_O
export X="$T_X"
j "$T_COMP" "$O" "$T_R" "$T_CMD"
