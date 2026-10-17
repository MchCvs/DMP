#!/bin/bash

# ==================================================
# DMP — Collecteur D1.4
# Informations techniques de l'historique
#
# Sources utilisées :
#   d1_data.sh
#   d1_2_data.sh
#   d1_3_data.sh
#
# Règle :
#   Ne jamais fabriquer une information absente.
# ==================================================

DMP_DIR="${DMP_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"

D1_DATA="$DMP_DIR/d1_data.sh"
D1_2_DATA="$DMP_DIR/d1_2_data.sh"
D1_3_DATA="$DMP_DIR/d1_3_data.sh"

escape_json()
{
    printf '%s' "$1" |
    sed 's/\\/\\\\/g; s/"/\\"/g'
}

if [ ! -x "$D1_DATA" ] || \
   [ ! -x "$D1_2_DATA" ] || \
   [ ! -x "$D1_3_DATA" ]; then
    cat <<JSON
{
  "collected": false,
  "technical_available": false,
  "explanation": "Les informations techniques nécessaires à l'historique D1 ne sont pas toutes disponibles.",
  "technical_result": "Informations techniques historiques indisponibles."
}
JSON
    exit 0
fi

OBSERVATIONS=$("$D1_DATA" 2>/dev/null)
ACTIONS=$("$D1_2_DATA" 2>/dev/null)
RESULTS=$("$D1_3_DATA" 2>/dev/null)

if ! printf '%s\n' "$OBSERVATIONS" | python3 -m json.tool >/dev/null 2>&1; then
    OBSERVATIONS='{"collected":false}'
fi

if ! printf '%s\n' "$ACTIONS" | python3 -m json.tool >/dev/null 2>&1; then
    ACTIONS='{"collected":false}'
fi

if ! printf '%s\n' "$RESULTS" | python3 -m json.tool >/dev/null 2>&1; then
    RESULTS='{"collected":false}'
fi

history_count=$(printf '%s\n' "$OBSERVATIONS" |
    python3 -c 'import json,sys; d=json.load(sys.stdin); print(d.get("history_count","Information indisponible"))')

last_observation=$(printf '%s\n' "$OBSERVATIONS" |
    python3 -c 'import json,sys; d=json.load(sys.stdin); print(d.get("last_date","Information indisponible"))')

last_action=$(printf '%s\n' "$ACTIONS" |
    python3 -c 'import json,sys; d=json.load(sys.stdin); print(d.get("last_action","Information indisponible"))')

action_date=$(printf '%s\n' "$ACTIONS" |
    python3 -c 'import json,sys; d=json.load(sys.stdin); print(d.get("last_date","Information indisponible"))')

report_count=$(printf '%s\n' "$RESULTS" |
    python3 -c 'import json,sys; d=json.load(sys.stdin); print(d.get("report_count","Information indisponible"))')

last_result=$(printf '%s\n' "$RESULTS" |
    python3 -c 'import json,sys; d=json.load(sys.stdin); print(d.get("last_result","Information indisponible"))')

result_date=$(printf '%s\n' "$RESULTS" |
    python3 -c 'import json,sys; d=json.load(sys.stdin); print(d.get("last_date","Information indisponible"))')

cat <<JSON
{
  "collected": true,
  "technical_available": true,
  "observation_history_count": "$(escape_json "$history_count")",
  "last_observation": "$(escape_json "$last_observation")",
  "action_history_available": "$(printf '%s\n' "$ACTIONS" | python3 -c 'import json,sys; print(str(json.load(sys.stdin).get("action_available",False)).lower())')",
  "last_action": "$(escape_json "$last_action")",
  "last_action_date": "$(escape_json "$action_date")",
  "result_history_count": "$(escape_json "$report_count")",
  "last_result": "$(escape_json "$last_result")",
  "last_result_date": "$(escape_json "$result_date")",
  "conclusion": "Information indisponible",
  "technical_result": "Observations historiques : $history_count\nDernière observation : $(escape_json "$last_observation")\nActions historiques générales : $(escape_json "$last_action")\nDate de la dernière action : $(escape_json "$action_date")\nRapports historiques : $report_count\nDernier résultat : $(escape_json "$last_result")\nDate du dernier résultat : $(escape_json "$result_date")\nConclusion DMP enregistrée : Information indisponible\nSources : d1_data.sh, d1_2_data.sh, d1_3_data.sh"
}
JSON
