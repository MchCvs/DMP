#!/bin/bash

# ==================================================
# DMP Language Checker
# Version 1.5.1
# ==================================================

LANG_DIR="languages"

REFERENCE="$LANG_DIR/template.lang"

echo
echo "=============================================="
echo " DMP Language Checker"
echo "=============================================="
echo


if [ ! -f "$REFERENCE" ]
then
    echo "Template language file missing."
    exit 1
fi


for FILE in "$LANG_DIR"/*.lang
do

    NAME=$(basename "$FILE")

    echo -n "$NAME : "

    MISSING=0

    while read LINE
    do

        KEY=$(echo "$LINE" | grep -o '^[A-Z_]*=')

        if [ -n "$KEY" ]
        then

            if ! grep -q "^$KEY" "$FILE"
            then
                echo
                echo " Missing $KEY"
                MISSING=1
            fi

        fi

    done < "$REFERENCE"


    if [ "$MISSING" -eq 0 ]
    then
        echo "OK"
    fi

done

echo
