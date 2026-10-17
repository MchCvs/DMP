#!/bin/bash

# ==================================================
# DMP - Interaction utilisateur
# Version 1.0.0
# ==================================================


dmp_start()
{
    dmp_first_start
}


dmp_first_start()
{
    clear

    welcome_line()
    {
        local TEXT="$1"
        local LEN=${#TEXT}
        local PAD=$((44 - LEN))

        printf "              ║  %s" "$TEXT"

        if [ "$PAD" -gt 0 ]; then
            printf "%${PAD}s" ""
        fi

        printf "║\\n"
    }

    echo
    echo "              ╔══════════════════════════════════════════════╗"

    welcome_line ""
    welcome_line "$MSG_WELCOME_TITLE1"
    welcome_line "$MSG_WELCOME_TITLE2"
    welcome_line ""

    echo "              ╠══════════════════════════════════════════════╣"

    welcome_line ""
    welcome_line "$MSG_WELCOME_TEXT1"
    welcome_line "$MSG_WELCOME_TEXT2"
    welcome_line ""

    welcome_line "$MSG_WELCOME_DISCOVERY1"
    welcome_line "$MSG_WELCOME_DISCOVERY2"
    welcome_line "$MSG_WELCOME_DISCOVERY3"
    welcome_line ""

    welcome_line "$MSG_WELCOME_SAFE1"
    welcome_line "$MSG_WELCOME_SAFE2"
    welcome_line ""

    echo "              ╚══════════════════════════════════════════════╝"
    echo

    read -r -p "              $PROMPT_START_DISCOVERY"

    discover_machine

    show_dmp_orientation
}

show_dmp_orientation()
{
echo
echo "              =============================================="
echo "              $MSG_ORIENTATION_TITLE"
echo "              =============================================="

echo
echo "              1 - $MENU_DISCOVER_AGAIN"
echo "              2 - $MENU_ACCESS_TOOLS"
echo "              3 - $MENU_CHANGE_LANGUAGE"
echo "              0 - $MENU_EXIT"
echo

read -p "              $PROMPT_CHOICE " CHOICE

    case $CHOICE in

        1)
        discover_machine
        show_dmp_orientation
        ;;

    2)
        main_menu
        ;;

    3)
        choose_language
        source "$BASE_DIR/lib/language.sh"
        show_dmp_orientation
        ;;

    0)
        exit 0
        ;;

    *)
        echo "$MSG_INVALID_CHOICE"
        ;;

    esac
}
