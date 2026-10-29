#!/bin/bash
source "$(dirname "$0")/lib.sh"
I18="$(dirname "$0")/../i18n"; LG=${DMP_LANG:-fr}; [ -f "$I18/$LG/a7.sh" ] || LG=fr
. "$I18/$LG/a7.sh"
. /etc/os-release
case "$VERSION_ID" in 13) VC=13;; 12) VC=12;; "") VC=none;; *) VC=old;; esac
T_O
export X
export NV=$LV
j "$T_COMP" "$O" "$R" "$T_CMD"
