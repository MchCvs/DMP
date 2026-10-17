#!/bin/bash

# ==================================================
# Gestion des plugins DMP
# Version 1.6.0
# ==================================================

PLUGIN_DIR="$BASE_DIR/plugins"


plugin_menu()
{

while true
do

clear

echo "=============================================="
echo " Gestion des plugins DMP"
echo "=============================================="
echo

PLUGINS=()
INDEX=1


if [ ! -d "$PLUGIN_DIR" ]
then
    echo "No plugins installed."
    read -p "Entrée pour revenir..."
    return
fi


for DIR in "$PLUGIN_DIR"/*
do

    if [ -d "$DIR/plugin.conf" ] || [ -f "$DIR/plugin.conf" ]
    then

        source "$DIR/plugin.conf"

        PLUGINS[$INDEX]="$DIR"

        echo "$INDEX - $PLUGIN_NAME"
        echo "     Version : $PLUGIN_VERSION"
        echo "     Auteur  : $PLUGIN_AUTHOR"
        echo

        INDEX=$((INDEX+1))

    fi

done


echo "0 - $MENU_BACK"
echo

read -p "Votre choix : " CHOICE


if [ "$CHOICE" = "0" ]
then
    return
fi


PLUGIN_PATH="${PLUGINS[$CHOICE]}"


if [ -n "$PLUGIN_PATH" ]
then

    source "$PLUGIN_PATH/plugin.conf"

    clear

    echo "=============================================="
    echo " $PLUGIN_NAME"
    echo "=============================================="
    echo

    SCRIPT="$PLUGIN_PATH/$PLUGIN_SCRIPT"


    if [ -f "$SCRIPT" ]
    then
        bash "$SCRIPT"
    else
        echo "Script plugin introuvable."
    fi

    echo
    read -p "Entrée pour revenir..."

fi


done

}


list_plugins()
{
plugin_menu
}
