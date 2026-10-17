#!/bin/bash

# ==================================================
# DMP — Système d'états visuels
# ==================================================

# Grille UI centralisée
if [ -f "$(dirname "${BASH_SOURCE[0]}")/ui_layout.sh" ]; then
    source "$(dirname "${BASH_SOURCE[0]}")/ui_layout.sh"
fi

if [ -z "${DMP_CONTENT_WIDTH:-}" ]; then
    dmp_ui_init
fi

DMP_COLOR_RESET='\033[0m'
DMP_COLOR_GREEN='\033[92m'
DMP_COLOR_YELLOW='\033[93m'
DMP_COLOR_RED='\033[91m'
DMP_COLOR_WHITE='\033[97m'

dmp_color_supported()
{
    case "${TERM:-}" in
        dumb|"")
            return 1
            ;;
    esac

    if [ "${NO_COLOR:-}" != "" ]; then
        return 1
    fi

    return 0
}

dmp_status()
{
    local STATUS="$1"
    local LABEL="$2"
    local MESSAGE="$3"

    local SQUARE="■"
    local COLOR="$DMP_COLOR_WHITE"

    case "$STATUS" in
        GOOD)
            LABEL="${LABEL:-BON}"
            COLOR="$DMP_COLOR_GREEN"
            ;;

        WATCH)
            LABEL="${LABEL:-À SURVEILLER}"
            COLOR="$DMP_COLOR_YELLOW"
            ;;

        PROBLEM)
            LABEL="${LABEL:-PROBLÈME}"
            COLOR="$DMP_COLOR_RED"
            ;;

        UNKNOWN)
            LABEL="${LABEL:-INDÉTERMINÉ}"
            COLOR="$DMP_COLOR_WHITE"
            ;;

        *)
            LABEL="${LABEL:-INDÉTERMINÉ}"
            COLOR="$DMP_COLOR_WHITE"
            ;;
    esac

    dmp_ui_indent

    if dmp_color_supported; then
        printf '%b%s%b %s\n' \
            "$COLOR" \
            "$SQUARE" \
            "$DMP_COLOR_RESET" \
            "$LABEL"
    else
        printf '%s %s\n' "$SQUARE" "$LABEL"
    fi

    if [ -n "$MESSAGE" ]; then
        dmp_ui_wrap "$MESSAGE"
    fi
}

dmp_status_good()
{
    dmp_status "GOOD" "$1" "$2"
}

dmp_status_watch()
{
    dmp_status "WATCH" "$1" "$2"
}

dmp_status_problem()
{
    dmp_status "PROBLEM" "$1" "$2"
}

dmp_status_unknown()
{
    dmp_status "UNKNOWN" "$1" "$2"
}
