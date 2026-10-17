#!/bin/bash

# ==================================================
# DMP - Découverte utilisateur
# Version 1.0.0
# ==================================================

# Pagination adaptative selon la taille du terminal
dmp_get_terminal_lines()
{
    if [ -n "${LINES:-}" ] && [ "$LINES" -gt 0 ] 2>/dev/null; then
        printf '%s\n' "$LINES"
    elif command -v tput >/dev/null 2>&1; then
        tput lines 2>/dev/null || printf '24\n'
    else
        printf '24\n'
    fi
}

dmp_get_terminal_cols()
{
    if [ -n "${COLUMNS:-}" ] && [ "$COLUMNS" -gt 0 ] 2>/dev/null; then
        printf '%s\n' "$COLUMNS"
    elif command -v tput >/dev/null 2>&1; then
        tput cols 2>/dev/null || printf '80\n'
    else
        printf '80\n'
    fi
}

dmp_pagination_pause()
{
    printf '\n'
    printf '              %s' "$MSG_CONTINUE"
    read -r
}


# ==================================================

discover_machine()
{
    clear

    show_discovery_intro
    discover_system
    discover_hardware

    dmp_pagination_pause

    clear
    show_discovery_intro

    echo
    echo "              $MSG_MEMORY_TITLE"
    echo "              ============="
    echo

    MEM=$(free -h | awk '/^Mem:/ {print $2}' |
        sed -E 's/Gi$/ Go/; s/G$/ Go/; s/[[:space:]]+/ /')

    echo "              $MSG_RAM_TITLE"
    echo "              ------------"
    echo
    echo "              $MEM"
    echo
    explain_memory

    discover_storage

    dmp_pagination_pause

    clear
    show_discovery_intro
    explain_discovery_end
}


show_discovery_intro()
{
    echo
    echo "              =============================================="
    echo "              $MSG_DISCOVERY_TITLE"
    echo "              =============================================="
    echo
}

discover_system()
{
    DEBIAN_NAME=$(grep '^PRETTY_NAME=' /etc/os-release | cut -d= -f2 | tr -d '"')

    # Le nom de code Debian reste une information technique.
    DEBIAN_NAME=$(printf '%s\n' "$DEBIAN_NAME" | sed -E 's/ \([^)]*\)$//')

    echo
    echo "              $MSG_SYSTEM_DETECTED : $DEBIAN_NAME"
    echo

    explain_debian
}

discover_hardware()
{
    echo
    echo "              =============================================="
    echo "              $MSG_HARDWARE_TITLE"
    echo "              =============================================="
    echo

    echo "              $MSG_HARDWARE_INTRO1"
    echo
    echo "              $MSG_HARDWARE_INTRO2"
    echo

    CPU=$(LC_ALL=C lscpu | awk -F: '/^Model name:/ { gsub(/^[[:space:]]+/, "", $2); print $2; exit }')

    echo "              $MSG_PROCESSOR"
    echo "              ----------"
    echo
    echo "              $CPU"
    echo

    explain_processor

    echo
    echo

    echo "              $MSG_CORES"
    echo "              ----------------"
    echo
    echo "              $(nproc)"
    echo

    explain_cores


}

explain_disk_role()
{
    local DISK="$1"

    if lsblk -n -o MOUNTPOINTS "/dev/$DISK" | grep -qx '/'; then
        printf '%s' "Disque principal Debian"

    elif lsblk -n -o MOUNTPOINTS "/dev/$DISK" | grep -qE '^/media/|^/mnt/'; then
        printf '%s' "Disque de données"

    else
        printf '%s' "Disque supplémentaire"
    fi
}

dmp_get_commercial_capacity()
{
    local BYTES="$1"

    awk -v bytes="$BYTES" '
    BEGIN {
        if (bytes >= 900000000000 && bytes < 1100000000000)
            print "1 To"
        else if (bytes >= 225000000000 && bytes < 255000000000)
            print "240 Go"
        else if (bytes >= 112000000000 && bytes < 125000000000)
            print "120 Go"
        else
            print ""
    }'
}

discover_storage()
{
    echo
    echo "              =============================================="
    echo "              $MSG_DISKS_TITLE"
    echo "              =============================================="
    echo

    explain_storage

    MAIN_SIZE=""
    MAIN_BYTES=""
    MAIN_COMMERCIAL=""

    DATA_SIZE=""
    DATA_BYTES=""
    DATA_COMMERCIAL=""

    EXTRA_SIZE=""
    EXTRA_BYTES=""
    EXTRA_COMMERCIAL=""

    while IFS= read -r LINE
    do
        eval "$LINE"

        if [ "$TYPE" = "disk" ]; then

            SECTORS=$(cat "/sys/block/$NAME/size" 2>/dev/null)
            BLOCK_SIZE=$(cat "/sys/block/$NAME/queue/logical_block_size" 2>/dev/null)

            if [ -n "$SECTORS" ] && [ -n "$BLOCK_SIZE" ]; then
                BYTES=$((SECTORS * BLOCK_SIZE))
            else
                BYTES=0
            fi

            ROLE=$(explain_disk_role "$NAME")

            case "$ROLE" in

                "Disque principal Debian")
                    MAIN_SIZE="$SIZE"
                    MAIN_BYTES="$BYTES"
                    MAIN_COMMERCIAL=$(dmp_get_commercial_capacity "$BYTES")
                    ;;

                "Disque de données")
                    DATA_SIZE="$SIZE"
                    DATA_BYTES="$BYTES"
                    DATA_COMMERCIAL=$(dmp_get_commercial_capacity "$BYTES")
                    ;;

                "Disque supplémentaire")
                    EXTRA_SIZE="$SIZE"
                    EXTRA_BYTES="$BYTES"
                    EXTRA_COMMERCIAL=$(dmp_get_commercial_capacity "$BYTES")
                    ;;

            esac
        fi

    done < <(lsblk -P -n -o NAME,SIZE,TYPE,FSTYPE,PARTTYPENAME,MOUNTPOINTS)

    if [ -n "$MAIN_SIZE" ]; then
        echo
        echo "              $MSG_MAIN_DISK"
        echo "              ------------------------"
        echo
        echo "              $MSG_ADVERTISED_CAPACITY : $MAIN_COMMERCIAL"
        echo "              $MSG_VISIBLE_CAPACITY : ${MAIN_SIZE%G} Gio"
        echo
    fi

    if [ -n "$DATA_SIZE" ]; then
        echo
        echo "              $MSG_DATA_DISK"
        echo "              -----------------"
        echo
        echo "              $MSG_ADVERTISED_CAPACITY : $DATA_COMMERCIAL"
        echo "              $MSG_VISIBLE_CAPACITY : ${DATA_SIZE%G} Gio"
        echo
    fi

    if [ -n "$EXTRA_SIZE" ]; then
        echo
        echo "              $MSG_EXTRA_DISK"
        echo "              --------------------"
        echo
        echo "              $MSG_ADVERTISED_CAPACITY : $EXTRA_COMMERCIAL"
        echo "              $MSG_VISIBLE_CAPACITY : ${EXTRA_SIZE%G} Gio"
        echo
    fi

    echo
    echo "              $MSG_WHY_CAPACITY_TITLE"
    echo
    echo "              $MSG_MANUFACTURER_UNIT"
    echo
    echo "              $MSG_SYSTEM_UNIT"
    echo
    echo "              $MSG_GO_VALUE"
    echo "              $MSG_GIO_VALUE"
    echo
    echo "              $MSG_GIO_EXPLANATION"
    echo
    echo "              $MSG_DISK_EXAMPLE1"
    echo
    echo "              $MSG_DISK_EXAMPLE2"
}



