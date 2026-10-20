#!/bin/bash
I18="$(dirname "$0")/../i18n"; LG=${DMP_LANG:-fr}; [ -f "$I18/$LG/e3_1.sh" ] || LG=fr
. "$I18/$LG/e3_1.sh"
DATE=$(date '+%Y-%m-%d %H:%M:%S')
T_O
echo "{\"comprendre\":\"$T_COMP\",\"observations\":\"$O\",\"resultat\":\"$T_R\",\"informations_techniques\":{\"cmd\":\"$T_CMD\",\"date\":\"$DATE\",\"status\":\"ready\"}}"
