#!/bin/bash

# ==================================================
# DMP — Collecteur D1.3
# Consulter les résultats précédents
#
# Source :
#   $REPORT_DIR/rapport_DMP_*.txt
#
# Règle :
#   Ne jamais fabriquer une conclusion absente
#   du rapport historique.
# ==================================================

CONFIG="${DMP_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}/config/dmp.conf"

if [ -f "$CONFIG" ]; then
    . "$CONFIG"
fi

REPORT_DIR="${REPORT_DIR:-${DMP_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}/reports}"

escape_json()
{
    printf '%s' "$1" |
    sed 's/\\/\\\\/g; s/"/\\"/g'
}

latest_report=$(ls -1t "$REPORT_DIR"/rapport_DMP_*.txt 2>/dev/null | head -1)

if [ -z "$latest_report" ] || [ ! -f "$latest_report" ]; then
    cat <<JSON
{
  "collected": false,
  "result_available": false,
  "last_result": "Information indisponible",
  "last_date": "Information indisponible",
  "conclusion": "Information indisponible",
  "explanation": "Aucun résultat historique DMP n'est actuellement disponible.",
  "technical_result": "Aucun résultat historique actuellement disponible."
}
JSON
    exit 0
fi

report_count=$(find "$REPORT_DIR" -maxdepth 1 -type f -name 'rapport_DMP_*.txt' | wc -l)

report_date=$(grep -m1 '^ Date :' "$latest_report" | sed 's/^ Date : //')

report_name=$(basename "$latest_report")

cat <<JSON
{
  "collected": true,
  "result_available": true,
  "report_count": $report_count,
  "last_result": "Rapport complet système",
  "last_date": "$(escape_json "$report_date")",
  "conclusion": "Information indisponible",
  "explanation": "Le dernier rapport DMP est disponible. Il contient les observations et résultats de l'analyse, mais aucune conclusion DMP explicite n'y est enregistrée.",
  "technical_result": "Dernier rapport : $(escape_json "$report_name")\nDate : $(escape_json "$report_date")\nNombre de rapports disponibles : $report_count\nSource : $(escape_json "$latest_report")\nConclusion enregistrée : Information indisponible"
}
JSON
