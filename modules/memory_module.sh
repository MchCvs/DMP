#!/usr/bin/env bash

set -u

DMP_ROOT="${DMP_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
MEMORY_STATUS="$DMP_ROOT/memory_status.sh"

echo "===== DMP V2 — ÉTAT DÉTAILLÉ DE LA MÉMOIRE ====="
echo

if [[ ! -x "$MEMORY_STATUS" ]]; then
    echo "La vérification détaillée de la mémoire est actuellement indisponible."
    exit 1
fi

STATUS_OUTPUT="$("$MEMORY_STATUS")"
STATUS_EXIT=$?

if [[ $STATUS_EXIT -ne 0 ]]; then
    echo "DMP ne peut pas actuellement établir l'état détaillé de la mémoire."
    exit "$STATUS_EXIT"
fi

get_value()
{
    local key="$1"
    printf '%s\n' "$STATUS_OUTPUT" |
        awk -F= -v key="$key" '$1 == key {print substr($0, index($0,$2)); exit}'
}

MEM_TOTAL_KB=$(get_value "mem_total_kb")
MEM_AVAILABLE_KB=$(get_value "mem_available_kb")
SWAP_TOTAL_KB=$(get_value "swap_total_kb")
SWAP_USED_KB=$(get_value "swap_used_kb")

FIREFOX_PRESENT=$(get_value "firefox_present")
FIREFOX_TOTAL_KB=$(get_value "firefox_total_kb")

CONTRIBUTOR_NAME=$(get_value "contributor_name")
CONTRIBUTOR_RSS_KB=$(get_value "contributor_rss_kb")

TREND=$(get_value "trend")
RECOVERY=$(get_value "recovery")
PRESSURE=$(get_value "pressure")
DIAGNOSIS=$(get_value "diagnosis")
ACTION=$(get_value "action")

kb_to_gib()
{
    awk -v kb="${1:-0}" 'BEGIN {printf "%.1f GiB", kb / 1048576}'
}

kb_to_mib()
{
    awk -v kb="${1:-0}" 'BEGIN {printf "%.1f MiB", kb / 1024}'
}

case "$TREND" in
    STABLE)     TREND_FR="STABLE" ;;
    INCREASING) TREND_FR="EN AUGMENTATION" ;;
    DECREASING) TREND_FR="EN DIMINUTION" ;;
    *)          TREND_FR="INDÉTERMINÉE" ;;
esac

case "$RECOVERY" in
    RECOVERED) RECOVERY_FR="RÉCUPÉRÉE" ;;
    PARTIAL)   RECOVERY_FR="PARTIELLE" ;;
    FAILED)    RECOVERY_FR="NON RÉCUPÉRÉE" ;;
    *)         RECOVERY_FR="INDÉTERMINÉE" ;;
esac

case "$PRESSURE" in
    NORMAL)     PRESSURE_FR="NORMALE" ;;
    WATCH)      PRESSURE_FR="À SURVEILLER" ;;
    INCREASING) PRESSURE_FR="EN AUGMENTATION" ;;
    *)          PRESSURE_FR="INDÉTERMINÉE" ;;
esac

case "$DIAGNOSIS" in
    NORMAL)
        DIAGNOSIS_TITLE="NORMALE"
        DIAGNOSIS_TEXT="La mémoire fonctionne normalement."
        ;;
    WATCH)
        DIAGNOSIS_TITLE="À SURVEILLER"
        DIAGNOSIS_TEXT="La situation mémoire mérite une observation complémentaire."
        ;;
    PROBLEM)
        DIAGNOSIS_TITLE="PROBLÈME"
        DIAGNOSIS_TEXT="DMP a identifié une situation mémoire nécessitant une analyse complémentaire."
        ;;
    *)
        DIAGNOSIS_TITLE="INDÉTERMINÉE"
        DIAGNOSIS_TEXT="DMP ne dispose pas actuellement de suffisamment d'informations pour conclure."
        ;;
esac

case "$ACTION" in
    NONE)
        ACTION_FR="Aucune action n'est nécessaire actuellement."
        ;;
    MONITOR)
        ACTION_FR="Une surveillance de l'évolution est recommandée."
        ;;
    CORRECTIVE)
        ACTION_FR="Une action corrective est recommandée."
        ;;
    COLLECT_MORE_DATA)
        ACTION_FR="De nouvelles mesures sont nécessaires avant de décider d'une action."
        ;;
    *)
        ACTION_FR="Aucune action ne peut être déterminée actuellement."
        ;;
esac

echo "Mémoire disponible : $(kb_to_gib "$MEM_AVAILABLE_KB")"
echo

echo "■ Mémoire — $DIAGNOSIS_TITLE"
echo "  $DIAGNOSIS_TEXT"
echo
echo "Tendance mémoire : $TREND_FR"
echo "Récupération : $RECOVERY_FR"
echo "Pression mémoire : $PRESSURE_FR"
echo
echo "Action : $ACTION_FR"

if [[ "${FIREFOX_PRESENT:-0}" == "1" ]]; then
    echo
    echo "Programme Firefox observé"
    echo "Mémoire utilisée par Firefox : $(kb_to_mib "$FIREFOX_TOTAL_KB")"
fi

if [[ -n "${CONTRIBUTOR_NAME:-}" && -n "${CONTRIBUTOR_RSS_KB:-}" ]]; then
    echo
    echo "Principal contributeur mémoire observé : $CONTRIBUTOR_NAME"
    echo "Mémoire utilisée : $(kb_to_mib "$CONTRIBUTOR_RSS_KB")"
fi

echo
echo "Mémoire virtuelle totale : $(kb_to_gib "$SWAP_TOTAL_KB")"
echo "Mémoire virtuelle utilisée : $(kb_to_mib "$SWAP_USED_KB")"
echo
echo "Cette présentation est destinée à l'utilisateur."
echo "Les mesures techniques détaillées restent disponibles dans le moteur DMP V2."
