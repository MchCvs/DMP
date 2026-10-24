#!/bin/bash
DMP_DATA="${DMP_DATA:-${XDG_DATA_HOME:-$HOME/.local/share}/dmp}"

# ==================================================
# DMP V2 — Collecteur C4
# Recommandations
# ==================================================

set -u

REPORT_DIR="${REPORT_DIR:-${DMP_DATA}/reports}"

HEALTH_SCORE_FILE="$REPORT_DIR/health_score.txt"
HISTORY_FILE="$REPORT_DIR/history.csv"

# --------------------------------------------------
# Valeurs par défaut : information indisponible
# --------------------------------------------------

SCORE=""
HEALTH=""
HISTORY_COUNT=0

BOOT_DELTA=""
BOOT_STATUS="INDETERMINE"
BOOT_INITIAL=""
BOOT_CURRENT=""

TEMP_STATUS="INDETERMINE"
TEMP_INITIAL=""
TEMP_CURRENT=""
TEMP_DELTA=""

RECOMMENDATION_LEVEL=""
RECOMMENDATION_TITLE=""
RECOMMENDATION_TEXT=""

JUSTIFICATION_TITLE=""
JUSTIFICATION_TEXT=""

DECISION_TITLE=""
DECISION_TEXT=""

# --------------------------------------------------
# Score santé réel
# --------------------------------------------------

if [ -f "$HEALTH_SCORE_FILE" ]; then
    IFS=';' read -r SCORE HEALTH < "$HEALTH_SCORE_FILE"
fi

# --------------------------------------------------
# Historique réel
# --------------------------------------------------

if [ -f "$HISTORY_FILE" ]; then

    HISTORY_COUNT=$(tail -n +2 "$HISTORY_FILE" | grep -cve '^[[:space:]]*$' || true)

    if [ "$HISTORY_COUNT" -gt 0 ]; then

        FIRST_LINE=$(tail -n +2 "$HISTORY_FILE" | head -n 1)
        LAST_LINE=$(tail -n +2 "$HISTORY_FILE" | tail -n 1)

        FIRST_BOOT=$(printf '%s\n' "$FIRST_LINE" | awk -F';' '{print $6}' | tr -d 's')
        LAST_BOOT=$(printf '%s\n' "$LAST_LINE" | awk -F';' '{print $6}' | tr -d 's')

        BOOT_INITIAL="$FIRST_BOOT"
        BOOT_CURRENT="$LAST_BOOT"

        if [[ "$FIRST_BOOT" =~ ^[0-9]+([.][0-9]+)?$ ]] &&
           [[ "$LAST_BOOT" =~ ^[0-9]+([.][0-9]+)?$ ]]; then

            BOOT_DELTA=$(LC_ALL=C awk -v first="$FIRST_BOOT" -v last="$LAST_BOOT" \
                'BEGIN { printf "%.3f", first-last }')

            if awk -v d="$BOOT_DELTA" 'BEGIN { exit !(d > 0.001) }'; then
                BOOT_STATUS="AMELIORATION"
            elif awk -v d="$BOOT_DELTA" 'BEGIN { exit !(d < -0.001) }'; then
                BOOT_STATUS="DEGRADATION"
            else
                BOOT_STATUS="STABLE"
            fi
        fi

        FIRST_TEMP=$(printf '%s\n' "$FIRST_LINE" | awk -F';' '{print $3}')
        LAST_TEMP=$(printf '%s\n' "$LAST_LINE" | awk -F';' '{print $3}')

        TEMP_INITIAL="$FIRST_TEMP"
        TEMP_CURRENT="$LAST_TEMP"

        if [[ "$FIRST_TEMP" =~ ^[0-9]+([.][0-9]+)?$ ]] &&
           [[ "$LAST_TEMP" =~ ^[0-9]+([.][0-9]+)?$ ]]; then

            TEMP_DELTA=$(LC_ALL=C awk -v first="$FIRST_TEMP" -v last="$LAST_TEMP" \
                'BEGIN { printf "%.3f", last-first }')

            if awk -v d="$TEMP_DELTA" 'BEGIN { exit !(d > 3) }'; then
                TEMP_STATUS="HAUSSE"
            elif awk -v d="$TEMP_DELTA" 'BEGIN { exit !(d < -3) }'; then
                TEMP_STATUS="BAISSE"
            else
                TEMP_STATUS="STABLE"
            fi
        fi
    fi
fi

# --------------------------------------------------
# Logique de recommandation DMP
#
# Reprise du moteur de décision existant.
# Aucune action automatique.
# --------------------------------------------------

if [ "$HEALTH" = "EXCELLENT" ] && [ "$TEMP_STATUS" != "HAUSSE" ]; then

    if [ "$BOOT_STATUS" = "DEGRADATION" ] &&
       [ -n "$BOOT_DELTA" ] &&
       awk -v d="$BOOT_DELTA" 'BEGIN { exit !(d < -10) }'; then

        RECOMMENDATION_LEVEL="2"
        RECOMMENDATION_TITLE="Surveillance renforcée recommandée"
        RECOMMENDATION_TEXT="Le fonctionnement général reste excellent, mais le temps de démarrage montre une dégradation notable."

        JUSTIFICATION_TITLE="Pourquoi cette recommandation ?"
        JUSTIFICATION_TEXT="L'état général reste excellent, mais l'historique montre une dégradation du démarrage supérieure au seuil de surveillance."

        DECISION_TITLE="Décision DMP"
        DECISION_TEXT="Surveillance renforcée recommandée"

    else

        RECOMMENDATION_LEVEL="1"
        RECOMMENDATION_TITLE="Aucun changement nécessaire"
        RECOMMENDATION_TEXT="Aucune anomalie nécessitant une intervention n'est actuellement établie."

        JUSTIFICATION_TITLE="Pourquoi ?"
        JUSTIFICATION_TEXT="Le score santé est excellent et aucune évolution significative ne justifie actuellement une intervention."

        DECISION_TITLE="Décision DMP"
        DECISION_TEXT="Aucune intervention recommandée actuellement"
    fi

elif [ "$HEALTH" = "BON" ]; then

    RECOMMENDATION_LEVEL="2"
    RECOMMENDATION_TITLE="Surveillance recommandée"
    RECOMMENDATION_TEXT="Le fonctionnement général est bon, mais certains éléments méritent une surveillance."

    JUSTIFICATION_TITLE="Pourquoi cette recommandation ?"
    JUSTIFICATION_TEXT="L'état général est bon, sans justification suffisante pour une intervention automatique."

    DECISION_TITLE="Décision DMP"
    DECISION_TEXT="Surveillance recommandée"

elif [ -n "$HEALTH" ]; then

    RECOMMENDATION_LEVEL="3"
    RECOMMENDATION_TITLE="Analyse complémentaire recommandée"
    RECOMMENDATION_TEXT="L'état actuel justifie une analyse complémentaire avant toute décision."

    JUSTIFICATION_TITLE="Pourquoi cette recommandation ?"
    JUSTIFICATION_TEXT="Le niveau de santé mesuré ne permet pas de conclure qu'aucune intervention n'est nécessaire."

    DECISION_TITLE="Décision DMP"
    DECISION_TEXT="Analyse complémentaire recommandée"
fi

# --------------------------------------------------
# Sortie JSON
# --------------------------------------------------

python3 - "$SCORE" "$HEALTH" "$HISTORY_COUNT" "$BOOT_DELTA" \
    "$BOOT_STATUS" "$BOOT_INITIAL" "$BOOT_CURRENT" \
    "$TEMP_STATUS" "$TEMP_INITIAL" "$TEMP_CURRENT" "$TEMP_DELTA" \
    "$RECOMMENDATION_LEVEL" \
    "$RECOMMENDATION_TITLE" "$RECOMMENDATION_TEXT" \
    "$JUSTIFICATION_TITLE" "$JUSTIFICATION_TEXT" \
    "$DECISION_TITLE" "$DECISION_TEXT" <<'PY'
import json
import sys

(
    score,
    health,
    history_count,
    boot_delta,
    boot_status,
    boot_initial,
    boot_current,
    temp_status,
    temp_initial,
    temp_current,
    temp_delta,
    recommendation_level,
    recommendation_title,
    recommendation_text,
    justification_title,
    justification_text,
    decision_title,
    decision_text,
) = sys.argv[1:]

def number_or_none(value):
    try:
        return float(value)
    except ValueError:
        return None

data = {
    "score": int(score) if score.isdigit() else None,
    "health": health or None,
    "history_count": int(history_count),
    "boot_delta": number_or_none(boot_delta),
    "boot_status": boot_status,
    "boot_initial": number_or_none(boot_initial),
    "boot_current": number_or_none(boot_current),
    "temperature_status": temp_status,
    "temperature_initial": number_or_none(temp_initial),
    "temperature_current": number_or_none(temp_current),
    "temperature_delta": number_or_none(temp_delta),
    "recommendation_level": int(recommendation_level) if recommendation_level.isdigit() else None,
    "recommendation_title": recommendation_title or None,
    "recommendation_text": recommendation_text or None,
    "justification_title": justification_title or None,
    "justification_text": justification_text or None,
    "decision_title": decision_title or None,
    "decision_text": decision_text or None,
}

print(json.dumps(data, ensure_ascii=False))
PY
