#!/bin/bash
DMP_DATA="${DMP_DATA:-${XDG_DATA_HOME:-$HOME/.local/share}/dmp}"

# ==================================================
# DMP — Collecteur D2.1
# Voir les évolutions
#
# Source :
#   $REPORT_DIR/history.csv
#
# Règle :
#   Comparer uniquement les deux dernières
#   observations réellement disponibles.
#   Ne jamais fabriquer une évolution.
# ==================================================

CONFIG="${DMP_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}/config/dmp.conf"

if [ -f "$CONFIG" ]; then
    . "$CONFIG"
fi

REPORT_DIR="${REPORT_DIR:-${DMP_DATA}/reports}"
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
  "evolution_available": false,
  "explanation": "Aucun historique de mesures n'est actuellement disponible.",
  "technical_result": "Aucune évolution historique actuellement disponible."
}
JSON
    exit 0
fi

mapfile -t OBSERVATIONS < <(
    awk 'NR > 1 && NF {print}' "$HISTORY_FILE" | tail -2
)

if [ "${#OBSERVATIONS[@]}" -lt 2 ]; then
    cat <<JSON
{
  "collected": false,
  "evolution_available": false,
  "explanation": "Deux observations historiques sont nécessaires pour établir une comparaison.",
  "technical_result": "Comparaison historique impossible : moins de deux observations disponibles."
}
JSON
    exit 0
fi

PREVIOUS="${OBSERVATIONS[0]}"
CURRENT="${OBSERVATIONS[1]}"

IFS=';' read -r PREV_DATE PREV_SCORE PREV_TEMP PREV_RAM PREV_DISK PREV_BOOT <<< "$PREVIOUS"
IFS=';' read -r CUR_DATE CUR_SCORE CUR_TEMP CUR_RAM CUR_DISK CUR_BOOT <<< "$CURRENT"

TEMP_DELTA=$(LC_ALL=C awk -v a="$PREV_TEMP" -v b="$CUR_TEMP" 'BEGIN {printf "%.1f", b-a}')
BOOT_DELTA=$(LC_ALL=C awk -v a="${PREV_BOOT%s}" -v b="${CUR_BOOT%s}" 'BEGIN {printf "%.3f", b-a}')

TEMP_DIRECTION="stable"
if LC_ALL=C awk -v d="$TEMP_DELTA" 'BEGIN {exit !(d > 0)}'; then
    TEMP_DIRECTION="hausse"
elif LC_ALL=C awk -v d="$TEMP_DELTA" 'BEGIN {exit !(d < 0)}'; then
    TEMP_DIRECTION="baisse"
fi

BOOT_DIRECTION="stable"
if LC_ALL=C awk -v d="$BOOT_DELTA" 'BEGIN {exit !(d > 0)}'; then
    BOOT_DIRECTION="augmentation"
elif LC_ALL=C awk -v d="$BOOT_DELTA" 'BEGIN {exit !(d < 0)}'; then
    BOOT_DIRECTION="diminution"
fi

cat <<JSON
{
  "collected": true,
  "evolution_available": true,
  "observation_previous": "$(escape_json "$PREV_DATE")",
  "observation_current": "$(escape_json "$CUR_DATE")",
  "temperature_previous": "$(escape_json "$PREV_TEMP")",
  "temperature_current": "$(escape_json "$CUR_TEMP")",
  "temperature_delta": "$TEMP_DELTA",
  "temperature_direction": "$(escape_json "$TEMP_DIRECTION")",
  "ram_previous": "$(escape_json "$PREV_RAM")",
  "ram_current": "$(escape_json "$CUR_RAM")",
  "disk_previous": "$(escape_json "$PREV_DISK")",
  "disk_current": "$(escape_json "$CUR_DISK")",
  "boot_previous": "$(escape_json "$PREV_BOOT")",
  "boot_current": "$(escape_json "$CUR_BOOT")",
  "boot_delta": "$BOOT_DELTA",
  "boot_direction": "$(escape_json "$BOOT_DIRECTION")",
  "element": "Température CPU, RAM disponible, disque utilisé et temps de démarrage",
  "evolution": "Évolution mesurée entre les deux dernières observations",
  "explanation": "DMP compare les deux dernières observations réellement enregistrées afin de présenter les changements mesurés.",
  "technical_result": "Observation précédente : $(escape_json "$PREV_DATE")\nObservation actuelle : $(escape_json "$CUR_DATE")\nTempérature CPU : $(escape_json "$PREV_TEMP") → $(escape_json "$CUR_TEMP") °C\nRAM disponible : $(escape_json "$PREV_RAM") → $(escape_json "$CUR_RAM")\nDisque utilisé : $(escape_json "$PREV_DISK") → $(escape_json "$CUR_DISK")\nDémarrage : $(escape_json "$PREV_BOOT") → $(escape_json "$CUR_BOOT")\nÉcart température : $TEMP_DELTA °C\nÉcart démarrage : $BOOT_DELTA s\nSource : $(escape_json "$HISTORY_FILE")"
}
JSON
