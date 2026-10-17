#!/bin/bash

# ==================================================
# DMP - Contrôle qualité projet
# Version 1.0
# ==================================================

echo "=============================================="
echo " DMP - Contrôle qualité"
echo "=============================================="
echo

BASE_DIR="$(dirname "$(realpath "$0")")"

ERROR=0

echo "Vérification des fichiers principaux..."
echo

FILES="VERSION
bin/dmp
config/dmp.conf
lib/menu.sh
lib/html_report.sh
README.md
CHANGELOG.md
LICENSE
AUTHORS
"

for FILE in $FILES
do
    if [ -f "$BASE_DIR/$FILE" ]; then
        echo "✅ $FILE"
    else
        echo "❌ $FILE manquant"
        ERROR=1
    fi
done

echo
echo "Vérification syntaxe Bash..."
echo

for SCRIPT in "$BASE_DIR"/bin/*.sh "$BASE_DIR"/lib/*.sh
do
    if [ -f "$SCRIPT" ]; then
        if bash -n "$SCRIPT"; then
            echo "✅ $(basename "$SCRIPT")"
        else
            echo "❌ Erreur : $(basename "$SCRIPT")"
            ERROR=1
        fi
    fi
done

echo
echo "Vérification des langues..."
echo

LANG_DIR="$BASE_DIR/languages"
REFERENCE="$LANG_DIR/template.lang"

if [ -f "$REFERENCE" ]; then

    for LANG_FILE in "$LANG_DIR"/*.lang
    do

        NAME=$(basename "$LANG_FILE")

        if [ "$NAME" = "template.lang" ]; then
            continue
        fi

        MISSING=0

        while read LINE
        do
            KEY=$(echo "$LINE" | grep -o '^[A-Z_]*=')

            if [ -n "$KEY" ]; then
                if ! grep -q "^$KEY" "$LANG_FILE"; then
                    MISSING=1
                fi
            fi

        done < "$REFERENCE"

        if [ "$MISSING" -eq 0 ]; then
            echo "✅ Langue $NAME"
        else
            echo "❌ Langue $NAME incomplète"
            ERROR=1
        fi

    done

else

    echo "❌ template.lang manquant"
    ERROR=1

fi

echo
echo "Vérification des plugins..."
echo

if [ -d "$BASE_DIR/plugins" ]; then

    for PLUGIN in "$BASE_DIR"/plugins/*
    do

        if [ -d "$PLUGIN" ]; then

            NAME=$(basename "$PLUGIN")

            if [ -f "$PLUGIN/plugin.conf" ]; then

                echo "✅ Plugin $NAME : configuration OK"

                source "$PLUGIN/plugin.conf"

                if [ -f "$PLUGIN/$PLUGIN_SCRIPT" ]; then

                    echo "   ✅ Script $PLUGIN_SCRIPT présent"

                    if bash -n "$PLUGIN/$PLUGIN_SCRIPT"; then
                        echo "   ✅ Syntaxe Bash OK"
                    else
                        echo "   ❌ Erreur syntaxe Bash"
                        ERROR=1
                    fi

                else

                    echo "   ❌ Script manquant"
                    ERROR=1

                fi

            else

                echo "❌ Plugin $NAME : plugin.conf manquant"
                ERROR=1

            fi

        fi

    done

else

    echo "Aucun plugin installé."

fi

echo

echo
echo "Vérification du lanceur système..."

if [ -x /usr/local/bin/dmp ]; then
    echo "✅ Lanceur système DMP"
else
    echo "⚠️ Lanceur système absent ou non exécutable"
fi

echo
echo "Vérification terminée."
echo

if [ "$ERROR" -eq 0 ]; then
    echo "=============================================="
    echo " DMP EST PRÊT ✅"
    echo "=============================================="
else
    echo "=============================================="
    echo " Des corrections sont nécessaires ⚠️"
    echo "=============================================="
fi
