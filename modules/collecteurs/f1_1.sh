#!/bin/bash
I18="$(dirname "$0")/../i18n"; LG=${DMP_LANG:-fr}; [ -f "$I18/$LG/f1_1.sh" ] || LG=fr
. "$I18/$LG/f1_1.sh"
ERRORS=$(dmesg 2>/dev/null | grep -i error | wc -l)
[[ $ERRORS -eq 0 ]] && RES="$T_OK" || RES="$T_ERR"
T_O
echo "{\"comprendre\":\"$T_COMP\",\"observations\":\"$O\",\"resultat\":\"$RES\",\"informations_techniques\":{\"cmd\":\"$T_CMD\",\"errors\":$ERRORS}}"
