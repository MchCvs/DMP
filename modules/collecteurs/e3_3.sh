#!/bin/bash
I18="$(dirname "$0")/../i18n"; LG=${DMP_LANG:-fr}; [ -f "$I18/$LG/e3_3.sh" ] || LG=fr
. "$I18/$LG/e3_3.sh"
T_O
echo "{\"comprendre\":\"$T_COMP\",\"observations\":\"$O\",\"resultat\":\"$T_R\",\"informations_techniques\":{\"cmd\":\"$T_CMD\",\"records\":10,\"status\":\"available\"}}"
