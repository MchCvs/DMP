#!/bin/bash

# ==================================================
# DMP — Collecteur D2.3
# Identifier les tendances
#
# Source :
#   $REPORT_DIR/history.csv
#
# Règle :
#   Une tendance n'est établie que si une même
#   direction est confirmée sur au moins trois
#   observations successives comparables.
#
# Ne jamais transformer une simple variation
# en tendance.
# ==================================================

CONFIG="${DMP_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}/config/dmp.conf"

if [ -f "$CONFIG" ]; then
    . "$CONFIG"
fi

REPORT_DIR="${REPORT_DIR:-${DMP_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}/reports}"
HISTORY_FILE="$REPORT_DIR/history.csv"

escape_json()
{
    printf '%s' "$1" |
    sed 's/\\/\\\\/g; s/"/\\"/g'
}

if [ ! -f "$HISTORY_FILE" ]; then
    cat <<JSON
{
  "collected": false,
  "trend_available": false,
  "trend": "Information indisponible",
  "element": "Information indisponible",
  "evolution": "Information indisponible",
  "explanation": "Aucun historique de mesures n'est actuellement disponible.",
  "technical_result": "Aucune tendance historique actuellement disponible."
}
JSON
    exit 0
fi

mapfile -t OBSERVATIONS < <(
    awk 'NR > 1 && NF {print}' "$HISTORY_FILE"
)

COUNT="${#OBSERVATIONS[@]}"

if [ "$COUNT" -lt 3 ]; then
    cat <<JSON
{
  "collected": false,
  "trend_available": false,
  "trend": "Aucune tendance établie",
  "element": "Information indisponible",
  "evolution": "Au moins trois observations comparables sont nécessaires.",
  "explanation": "DMP ne dispose pas d'un nombre suffisant d'observations pour établir une tendance.",
  "technical_result": "Tendance impossible à établir : moins de trois observations disponibles."
}
JSON
    exit 0
fi

PREV_TEMP=""
PREV_RAM=""
PREV_DISK=""
PREV_BOOT=""

TEMP_UP=0
TEMP_DOWN=0
RAM_UP=0
RAM_DOWN=0
DISK_UP=0
DISK_DOWN=0
BOOT_UP=0
BOOT_DOWN=0

for OBS in "${OBSERVATIONS[@]}"; do

    IFS=';' read -r DATE SCORE TEMP RAM DISK BOOT <<< "$OBS"

    if [ -n "$PREV_TEMP" ] && [ "$TEMP" != "N/A" ] && [ "$PREV_TEMP" != "N/A" ]; then
        if LC_ALL=C awk -v a="$PREV_TEMP" -v b="$TEMP" 'BEGIN {exit !(b > a)}'; then
            TEMP_UP=$((TEMP_UP + 1))
        elif LC_ALL=C awk -v a="$PREV_TEMP" -v b="$TEMP" 'BEGIN {exit !(b < a)}'; then
            TEMP_DOWN=$((TEMP_DOWN + 1))
        fi
    fi

    if [ -n "$PREV_RAM" ] && [ "$RAM" != "N/A" ] && [ "$PREV_RAM" != "N/A" ]; then
        PREV_RAM_NUM="${PREV_RAM//,/\.}"
        RAM_NUM="${RAM//,/\.}"

        if LC_ALL=C awk -v a="$PREV_RAM_NUM" -v b="$RAM_NUM" 'BEGIN {exit !(b > a)}'; then
            RAM_UP=$((RAM_UP + 1))
        elif LC_ALL=C awk -v a="$PREV_RAM_NUM" -v b="$RAM_NUM" 'BEGIN {exit !(b < a)}'; then
            RAM_DOWN=$((RAM_DOWN + 1))
        fi
    fi

    if [ -n "$PREV_DISK" ] && [ "$DISK" != "N/A" ] && [ "$PREV_DISK" != "N/A" ]; then
        PREV_DISK_NUM="${PREV_DISK%\%}"
        DISK_NUM="${DISK%\%}"

        if LC_ALL=C awk -v a="$PREV_DISK_NUM" -v b="$DISK_NUM" 'BEGIN {exit !(b > a)}'; then
            DISK_UP=$((DISK_UP + 1))
        elif LC_ALL=C awk -v a="$PREV_DISK_NUM" -v b="$DISK_NUM" 'BEGIN {exit !(b < a)}'; then
            DISK_DOWN=$((DISK_DOWN + 1))
        fi
    fi

    if [ -n "$PREV_BOOT" ] && [ "$BOOT" != "N/A" ] && [ "$PREV_BOOT" != "N/A" ]; then
        PREV_BOOT_NUM="${PREV_BOOT%s}"
        BOOT_NUM="${BOOT%s}"

        if LC_ALL=C awk -v a="$PREV_BOOT_NUM" -v b="$BOOT_NUM" 'BEGIN {exit !(b > a)}'; then
            BOOT_UP=$((BOOT_UP + 1))
        elif LC_ALL=C awk -v a="$PREV_BOOT_NUM" -v b="$BOOT_NUM" 'BEGIN {exit !(b < a)}'; then
            BOOT_DOWN=$((BOOT_DOWN + 1))
        fi
    fi

    PREV_TEMP="$TEMP"
    PREV_RAM="$RAM"
    PREV_DISK="$DISK"
    PREV_BOOT="$BOOT"

done

# ==================================================
# Détection de la tendance actuelle
#
# Une tendance doit être confirmée sur les
# trois dernières observations comparables :
# deux transitions successives dans la même direction.
# ==================================================

RECENT="${OBSERVATIONS[@]: -3}"

mapfile -t RECENT_OBS < <(
    printf '%s\n' "${OBSERVATIONS[@]}" | tail -3
)

TREND="Aucune tendance établie"
ELEMENT="Aucun élément ne présente actuellement une tendance établie"
EVOLUTION="Les trois dernières observations ne confirment pas une direction suffisamment répétée."

if [ "${#RECENT_OBS[@]}" -eq 3 ]; then

    IFS=';' read -r D1 S1 T1 R1 K1 B1 <<< "${RECENT_OBS[0]}"
    IFS=';' read -r D2 S2 T2 R2 K2 B2 <<< "${RECENT_OBS[1]}"
    IFS=';' read -r D3 S3 T3 R3 K3 B3 <<< "${RECENT_OBS[2]}"

    # ---------- Température CPU ----------

    if [ "$T1" != "N/A" ] && [ "$T2" != "N/A" ] && [ "$T3" != "N/A" ]; then
        TEMP_1=$(LC_ALL=C awk -v a="$T1" -v b="$T2" 'BEGIN {if (b>a) print "UP"; else if (b<a) print "DOWN"; else print "STABLE"}')
        TEMP_2=$(LC_ALL=C awk -v a="$T2" -v b="$T3" 'BEGIN {if (b>a) print "UP"; else if (b<a) print "DOWN"; else print "STABLE"}')

        if [ "$TEMP_1" = "UP" ] && [ "$TEMP_2" = "UP" ]; then
            TREND="Hausse répétée de la température CPU"
            ELEMENT="Température CPU"
            EVOLUTION="La température CPU augmente sur les deux dernières transitions observées."
        elif [ "$TEMP_1" = "DOWN" ] && [ "$TEMP_2" = "DOWN" ]; then
            TREND="Baisse répétée de la température CPU"
            ELEMENT="Température CPU"
            EVOLUTION="La température CPU diminue sur les deux dernières transitions observées."
        fi
    fi

    # ---------- RAM disponible ----------

    if [ "$TREND" = "Aucune tendance établie" ] && \
       [ "$R1" != "N/A" ] && [ "$R2" != "N/A" ] && [ "$R3" != "N/A" ]; then

        R1_NUM="${R1//,/\.}"
        R2_NUM="${R2//,/\.}"
        R3_NUM="${R3//,/\.}"

        RAM_1=$(LC_ALL=C awk -v a="$R1_NUM" -v b="$R2_NUM" 'BEGIN {if (b>a) print "UP"; else if (b<a) print "DOWN"; else print "STABLE"}')
        RAM_2=$(LC_ALL=C awk -v a="$R2_NUM" -v b="$R3_NUM" 'BEGIN {if (b>a) print "UP"; else if (b<a) print "DOWN"; else print "STABLE"}')

        if [ "$RAM_1" = "UP" ] && [ "$RAM_2" = "UP" ]; then
            TREND="Hausse répétée de la RAM disponible"
            ELEMENT="RAM disponible"
            EVOLUTION="La RAM disponible augmente sur les deux dernières transitions observées."
        elif [ "$RAM_1" = "DOWN" ] && [ "$RAM_2" = "DOWN" ]; then
            TREND="Baisse répétée de la RAM disponible"
            ELEMENT="RAM disponible"
            EVOLUTION="La RAM disponible diminue sur les deux dernières transitions observées."
        fi
    fi

    # ---------- Disque utilisé ----------

    if [ "$TREND" = "Aucune tendance établie" ] && \
       [ "$K1" != "N/A" ] && [ "$K2" != "N/A" ] && [ "$K3" != "N/A" ]; then

        K1_NUM="${K1%\%}"
        K2_NUM="${K2%\%}"
        K3_NUM="${K3%\%}"

        DISK_1=$(LC_ALL=C awk -v a="$K1_NUM" -v b="$K2_NUM" 'BEGIN {if (b>a) print "UP"; else if (b<a) print "DOWN"; else print "STABLE"}')
        DISK_2=$(LC_ALL=C awk -v a="$K2_NUM" -v b="$K3_NUM" 'BEGIN {if (b>a) print "UP"; else if (b<a) print "DOWN"; else print "STABLE"}')

        if [ "$DISK_1" = "UP" ] && [ "$DISK_2" = "UP" ]; then
            TREND="Hausse répétée de l'utilisation du disque"
            ELEMENT="Disque utilisé"
            EVOLUTION="L'utilisation du disque augmente sur les deux dernières transitions observées."
        elif [ "$DISK_1" = "DOWN" ] && [ "$DISK_2" = "DOWN" ]; then
            TREND="Baisse répétée de l'utilisation du disque"
            ELEMENT="Disque utilisé"
            EVOLUTION="L'utilisation du disque diminue sur les deux dernières transitions observées."
        fi
    fi

    # ---------- Temps de démarrage ----------

    if [ "$TREND" = "Aucune tendance établie" ] && \
       [ "$B1" != "N/A" ] && [ "$B2" != "N/A" ] && [ "$B3" != "N/A" ]; then

        B1_NUM="${B1%s}"
        B2_NUM="${B2%s}"
        B3_NUM="${B3%s}"

        BOOT_1=$(LC_ALL=C awk -v a="$B1_NUM" -v b="$B2_NUM" 'BEGIN {if (b>a) print "UP"; else if (b<a) print "DOWN"; else print "STABLE"}')
        BOOT_2=$(LC_ALL=C awk -v a="$B2_NUM" -v b="$B3_NUM" 'BEGIN {if (b>a) print "UP"; else if (b<a) print "DOWN"; else print "STABLE"}')

        if [ "$BOOT_1" = "UP" ] && [ "$BOOT_2" = "UP" ]; then
            TREND="Augmentation répétée du temps de démarrage"
            ELEMENT="Temps de démarrage"
            EVOLUTION="Le temps de démarrage augmente sur les deux dernières transitions observées."
        elif [ "$BOOT_1" = "DOWN" ] && [ "$BOOT_2" = "DOWN" ]; then
            TREND="Diminution répétée du temps de démarrage"
            ELEMENT="Temps de démarrage"
            EVOLUTION="Le temps de démarrage diminue sur les deux dernières transitions observées."
        fi
    fi
fi

if [ "$TREND" = "Aucune tendance établie" ]; then
    TREND_AVAILABLE="false"
else
    TREND_AVAILABLE="true"
fi

cat <<JSON
{
  "collected": true,
  "trend_available": $TREND_AVAILABLE,
  "trend": "$(escape_json "$TREND")",
  "element": "$(escape_json "$ELEMENT")",
  "evolution": "$(escape_json "$EVOLUTION")",
  "explanation": "DMP compare les observations successives et ne présente une tendance que lorsqu'une même direction est confirmée.",
  "technical_result": "Nombre d'observations disponibles : $COUNT\nObservations examinées pour la tendance actuelle : 3\nTransitions récentes comparées : 2\nObservation 1 : $(escape_json "$D1")\nObservation 2 : $(escape_json "$D2")\nObservation 3 : $(escape_json "$D3")\nTendance établie : $(escape_json "$TREND")\nÉlément : $(escape_json "$ELEMENT")\nSource : $(escape_json "$HISTORY_FILE")"
}
JSON
