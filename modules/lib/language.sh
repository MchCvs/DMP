#!/bin/bash

# DMP Language Loader

DMP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

CONFIG_FILE="$DMP_DIR/config/dmp.conf"

if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    LANGUAGE="fr"
    DEFAULT_LANGUAGE="en"
fi


LANG_FILE="$DMP_DIR/languages/${LANGUAGE}.lang"


if [ -f "$LANG_FILE" ]; then
    source "$LANG_FILE"
else
    source "$DMP_DIR/languages/${DEFAULT_LANGUAGE}.lang"
fi
