#!/bin/bash
DMP_DATA="${DMP_DATA:-${XDG_DATA_HOME:-$HOME/.local/share}/dmp}"

set -u
export LC_ALL=C

REPORT_DIR="${DMP_DATA}/reports"
HISTORY_FILE="$REPORT_DIR/history.csv"
HEALTH_SCORE_FILE="$REPORT_DIR/health_score.txt"

# Valeurs par défaut : information indisponible
SCORE="N/A"
HEALTH="Indisponible"

HISTORY_COUNT=0

BOOT_INITIAL="Indisponible"
BOOT_CURRENT="Indisponible"
BOOT_DELTA="Indisponible"
BOOT_STATUS="Indisponible"

TEMP_INITIAL="Indisponible"
TEMP_CURRENT="Indisponible"
TEMP_DELTA="Indisponible"
TEMP_STATUS="Indisponible"

RECOMMENDATION_LEVEL=0
RECOMMENDATION_TITLE="Information indisponible"
RECOMMENDATION_TEXT="Aucune recommandation ne peut actuellement être établie."

JUSTIFICATION_TITLE="Pourquoi ?"
JUSTIFICATION_TEXT="Les informations disponibles ne permettent pas actuellement d'établir une justification complète."

DECISION_TITLE="Décision DMP"
DECISION_TEXT="Information indisponible"

# -------------------------------------------------------------------
# SCORE SANTE
# -------------------------------------------------------------------

if [ -f "$HEALTH_SCORE_FILE" ]; then
    IFS=';' read -r SCORE HEALTH < "$HEALTH_SCORE_FILE"

    [ -z "$SCORE" ] && SCORE="N/A"
    [ -z "$HEALTH" ] && HEALTH="Indisponible"

    case "$SCORE" in
        90|9[0-9]|100)
            HEALTH="EXCELLENT"
            ;;
        75|7[5-9]|8[0-9])
            HEALTH="BON"
            ;;
        50|5[0-9]|6[0-9]|74)
            HEALTH="À SURVEILLER"
            ;;
        *)
            HEALTH="INDÉTERMINÉ"
            ;;
    esac
fi

# -------------------------------------------------------------------
# HISTORIQUE
# -------------------------------------------------------------------

if [ -f "$HISTORY_FILE" ]; then

    HISTORY_COUNT=$(awk 'NR > 1 && NF { count++ } END { print count+0 }' "$HISTORY_FILE")

    if [ "$HISTORY_COUNT" -ge 1 ]; then
        BOOT_INITIAL=$(awk -F';' 'NR==2 {gsub(/s/,"",$6); print $6}' "$HISTORY_FILE")
        BOOT_CURRENT=$(awk -F';' 'NF {gsub(/s/,"",$6); value=$6} END {print value}' "$HISTORY_FILE")

        TEMP_INITIAL=$(awk -F';' 'NR==2 {print $3}' "$HISTORY_FILE")
        TEMP_CURRENT=$(awk -F';' 'NF {value=$3} END {print value}' "$HISTORY_FILE")
    fi

    if [ "$HISTORY_COUNT" -ge 2 ]; then

        BOOT_DELTA=$(awk -v a="$BOOT_INITIAL" -v b="$BOOT_CURRENT" \
            'BEGIN {printf "%.3f", b-a}')

        if awk -v d="$BOOT_DELTA" 'BEGIN {exit !(d < 0)}'; then
            BOOT_STATUS="AMÉLIORATION"
        elif awk -v d="$BOOT_DELTA" 'BEGIN {exit !(d > 0)}'; then
            BOOT_STATUS="DEGRADATION"
        else
            BOOT_STATUS="STABLE"
        fi

        TEMP_DELTA=$(awk -v a="$TEMP_INITIAL" -v b="$TEMP_CURRENT" \
            'BEGIN {printf "%.1f", b-a}')

        if awk -v d="$TEMP_DELTA" 'BEGIN {exit !(d > 3)}'; then
            TEMP_STATUS="HAUSSE"
        elif awk -v d="$TEMP_DELTA" 'BEGIN {exit !(d < -3)}'; then
            TEMP_STATUS="BAISSE"
        else
            TEMP_STATUS="STABLE"
        fi
    fi
fi

# -------------------------------------------------------------------
# RECOMMANDATION E1
# -------------------------------------------------------------------

if [ "$HEALTH" = "EXCELLENT" ]; then

    if [ "$TEMP_STATUS" != "HAUSSE" ]; then

        if [ "$BOOT_STATUS" = "DEGRADATION" ]; then

            if awk -v d="$BOOT_DELTA" 'BEGIN {exit !(d < 10)}'; then
                RECOMMENDATION_LEVEL=1
                RECOMMENDATION_TITLE="Aucun changement nécessaire"
                RECOMMENDATION_TEXT="Aucune anomalie nécessitant une intervention n'est actuellement établie."
                JUSTIFICATION_TEXT="Le score santé est excellent et aucune évolution significative ne justifie actuellement une intervention."
                DECISION_TEXT="Aucune intervention recommandée actuellement"
            else
                RECOMMENDATION_LEVEL=2
                RECOMMENDATION_TITLE="Surveillance renforcée recommandée"
                RECOMMENDATION_TEXT="Une évolution du temps de démarrage mérite d'être suivie avant toute intervention."
                JUSTIFICATION_TEXT="Une dégradation du temps de démarrage est mesurée. Une surveillance complémentaire est préférable avant toute intervention."
                DECISION_TEXT="Surveillance renforcée recommandée"
            fi

        else
            RECOMMENDATION_LEVEL=1
            RECOMMENDATION_TITLE="Aucun changement nécessaire"
            RECOMMENDATION_TEXT="Aucune anomalie nécessitant une intervention n'est actuellement établie."
            JUSTIFICATION_TEXT="Le score santé est excellent et aucune évolution significative ne justifie actuellement une intervention."
            DECISION_TEXT="Aucune intervention recommandée actuellement"
        fi

    else
        RECOMMENDATION_LEVEL=2
        RECOMMENDATION_TITLE="Surveillance renforcée recommandée"
        RECOMMENDATION_TEXT="Une hausse de température est observée et mérite une surveillance."
        JUSTIFICATION_TEXT="Le score santé reste excellent, mais une hausse significative de température est mesurée."
        DECISION_TEXT="Surveillance renforcée recommandée"
    fi

elif [ "$HEALTH" = "BON" ]; then

    RECOMMENDATION_LEVEL=2
    RECOMMENDATION_TITLE="Surveillance recommandée"
    RECOMMENDATION_TEXT="Le système fonctionne correctement, mais une surveillance reste recommandée."
    JUSTIFICATION_TEXT="Le niveau de santé est bon. Une surveillance permet de vérifier son évolution."
    DECISION_TEXT="Surveillance recommandée"

elif [ "$HEALTH" = "À SURVEILLER" ]; then

    RECOMMENDATION_LEVEL=3
    RECOMMENDATION_TITLE="Analyse complémentaire recommandée"
    RECOMMENDATION_TEXT="Une analyse complémentaire est recommandée avant toute intervention."
    JUSTIFICATION_TEXT="L'état constaté justifie une analyse plus approfondie avant de décider d'une action."
    DECISION_TEXT="Analyse complémentaire recommandée"

else

    RECOMMENDATION_LEVEL=0
    RECOMMENDATION_TITLE="Information indisponible"
    RECOMMENDATION_TEXT="Aucune recommandation fiable ne peut actuellement être établie."
    JUSTIFICATION_TEXT="Les informations disponibles ne permettent pas d'établir une recommandation fiable."
    DECISION_TEXT="Information indisponible"

fi

# -------------------------------------------------------------------
# SORTIE JSON
# -------------------------------------------------------------------

python3 - "$SCORE" "$HEALTH" "$HISTORY_COUNT" \
    "$BOOT_INITIAL" "$BOOT_CURRENT" "$BOOT_DELTA" "$BOOT_STATUS" \
    "$TEMP_INITIAL" "$TEMP_CURRENT" "$TEMP_DELTA" "$TEMP_STATUS" \
    "$RECOMMENDATION_LEVEL" "$RECOMMENDATION_TITLE" "$RECOMMENDATION_TEXT" \
    "$JUSTIFICATION_TITLE" "$JUSTIFICATION_TEXT" \
    "$DECISION_TITLE" "$DECISION_TEXT" <<'PY'
import json
import sys

(
    score, health, history_count,
    boot_initial, boot_current, boot_delta, boot_status,
    temperature_initial, temperature_current, temperature_delta,
    temperature_status,
    recommendation_level, recommendation_title, recommendation_text,
    justification_title, justification_text,
    decision_title, decision_text
) = sys.argv[1:]

def number(value):
    try:
        return int(value)
    except ValueError:
        try:
            return float(value)
        except ValueError:
            return value

data = {
    "score": number(score),
    "health": health,
    "history_count": int(history_count),

    "boot_initial": number(boot_initial),
    "boot_current": number(boot_current),
    "boot_delta": number(boot_delta),
    "boot_status": boot_status,

    "temperature_initial": number(temperature_initial),
    "temperature_current": number(temperature_current),
    "temperature_delta": number(temperature_delta),
    "temperature_status": temperature_status,

    "recommendation_level": int(recommendation_level),
    "recommendation_title": recommendation_title,
    "recommendation_text": recommendation_text,

    "justification_title": justification_title,
    "justification_text": justification_text,

    "decision_title": decision_title,
    "decision_text": decision_text
}

print(json.dumps(data, ensure_ascii=False, indent=2))
PY
