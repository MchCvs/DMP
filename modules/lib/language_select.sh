#!/bin/bash

# ==================================================
# DMP - Sélecteur de langue
# Version 1.5.0
# ==================================================

DMP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

CONFIG_FILE="$DMP_DIR/config/dmp.conf"

# Chargement temporaire des messages de langue
if [ -f "$DMP_DIR/languages/fr.lang" ]; then
    source "$DMP_DIR/languages/fr.lang"
fi


choose_language()
{

clear

echo
echo "              =============================================="
echo "              Debian Maintenance Professional"
echo "              =============================================="
echo
echo "              $MSG_LANGUAGE_TITLE"
echo
echo "              🇫🇷  1 - Français"
echo "              🇬🇧  2 - English"
echo "              🇩🇪  3 - Deutsch"
echo
echo "              0 - $MENU_BACK"
echo
read -p "              Selection : " LANG_CHOICE

case $LANG_CHOICE in

0)
return
;;

1)
LANGUAGE="fr"
;;

2)
LANGUAGE="en"
;;

3)
LANGUAGE="de"
;;

*)
LANGUAGE="fr"
;;

esac
if grep -q "^LANGUAGE=" "$CONFIG_FILE"
then
    sed -i "s/^LANGUAGE=.*/LANGUAGE=\"$LANGUAGE\"/" "$CONFIG_FILE"
else
    sed -i "s/^#LANGUAGE=.*/LANGUAGE=\"$LANGUAGE\"/" "$CONFIG_FILE"
fi


echo
echo "              $MSG_LANGUAGE_SAVED $LANGUAGE"
sleep 2

}
