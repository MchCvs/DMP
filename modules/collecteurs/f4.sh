#!/bin/bash
I18="$(dirname "$0")/../i18n"; LG=${DMP_LANG:-fr}; [ -f "$I18/$LG/f4.sh" ] || LG=fr
. "$I18/$LG/f4.sh"
LAST_BOOT=$(stat /var/log/apt/history.log 2>/dev/null | grep Modify | cut -d' ' -f2-3 || echo "Inconnu")
CHANGES=$(grep "apt-get install\|apt-get remove" /var/log/apt/history.log 2>/dev/null | wc -l)
T_O
echo "{\"comprendre\":\"$T_COMP\",\"observations\":\"$O\",\"resultat\":\"$T_R\",\"informations_techniques\":{\"cmd\":\"$T_CMD\",\"last_change\":\"$LAST_BOOT\",\"total_changes\":$CHANGES,\"note\":\"$T_NOTE\"}}"
