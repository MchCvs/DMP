#!/bin/bash
I18="$(dirname "$0")/../i18n"; LG=${DMP_LANG:-fr}; [ -f "$I18/$LG/f2_2.sh" ] || LG=fr
. "$(dirname "$0")/../i18n/langues.sh"
. "$I18/$LG/f2_2.sh"
T_O
echo "{\"comprendre\":\"$T_COMP\",\"observations\":\"$O\",\"resultat\":\"$T_R\",\"informations_techniques\":{\"cmd\":\"$T_CMD\",\"status\":\"success\"}}"
