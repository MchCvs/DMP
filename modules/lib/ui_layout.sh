#!/bin/bash

# ==================================================
# DMP - Grille UI centralisée
# Version 1.0.0
# ==================================================

dmp_ui_init()
{
    DMP_TERM_COLS=$(tput cols 2>/dev/null || printf '80')
    DMP_TERM_LINES=$(tput lines 2>/dev/null || printf '24')

    if [ "$DMP_TERM_COLS" -lt 60 ]; then
        DMP_UI_MODE="COMPACT"
        DMP_CONTENT_WIDTH=$((DMP_TERM_COLS - 4))

    elif [ "$DMP_TERM_COLS" -lt 90 ]; then
        DMP_UI_MODE="NARROW"
        DMP_CONTENT_WIDTH=$((DMP_TERM_COLS - 8))

    elif [ "$DMP_TERM_COLS" -lt 120 ]; then
        DMP_UI_MODE="STANDARD"
        DMP_CONTENT_WIDTH=72

    else
        DMP_UI_MODE="LARGE"
        DMP_CONTENT_WIDTH=80
    fi

    if [ "$DMP_CONTENT_WIDTH" -lt 40 ]; then
        DMP_CONTENT_WIDTH=40
    fi

    DMP_UI_PADDING=2
    DMP_TEXT_WIDTH=$((DMP_CONTENT_WIDTH - (DMP_UI_PADDING * 2)))

    DMP_LEFT_MARGIN=$(( (DMP_TERM_COLS - DMP_CONTENT_WIDTH) / 2 ))

    if [ "$DMP_LEFT_MARGIN" -lt 0 ]; then
        DMP_LEFT_MARGIN=0
    fi
}

dmp_ui_indent()
{
    printf '%*s' "$DMP_LEFT_MARGIN" ''
}

dmp_ui_print()
{
    dmp_ui_indent
    printf '%s\n' "$1"
}

dmp_ui_print_title()
{
    dmp_ui_indent
    printf '%s\n' "$1"
}

dmp_ui_print_title_underlined()
{
    dmp_ui_indent
    printf '\033[4m%s\033[0m\n' "$1"
}

dmp_ui_print_section()
{
    dmp_ui_indent
    printf '%*s%s\n' "$DMP_UI_PADDING" '' "$1"
}

dmp_ui_wrap()
{
    local TEXT="$1"

    printf '%s\n' "$TEXT" |
        fold -s -w "$DMP_TEXT_WIDTH" |
        while IFS= read -r LINE; do
            LINE="${LINE%"${LINE##*[![:space:]]}"}"
            dmp_ui_indent
            printf '%*s%s\n' "$DMP_UI_PADDING" '' "$LINE"
        done
}

dmp_ui_print_message()
{
    dmp_ui_wrap "$1"
}

dmp_ui_print_list_item()
{
    local TEXT="$1"

    printf '%s\n' "$TEXT" |
        fold -s -w "$DMP_TEXT_WIDTH" |
        while IFS= read -r LINE; do
            LINE="${LINE%"${LINE##*[![:space:]]}"}"
            dmp_ui_indent
            printf '%*s- %s\n' "$DMP_UI_PADDING" '' "$LINE"
        done
}

dmp_ui_debug()
{
    echo
    echo "DMP_UI_MODE       = $DMP_UI_MODE"
    echo "DMP_TERM_COLS     = $DMP_TERM_COLS"
    echo "DMP_TERM_LINES    = $DMP_TERM_LINES"
    echo "DMP_CONTENT_WIDTH = $DMP_CONTENT_WIDTH"
    echo "DMP_TEXT_WIDTH    = $DMP_TEXT_WIDTH"
    echo "DMP_UI_PADDING    = $DMP_UI_PADDING"
    echo "DMP_LEFT_MARGIN   = $DMP_LEFT_MARGIN"
}
