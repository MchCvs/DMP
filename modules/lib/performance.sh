#!/bin/bash

# ==================================================
# DMP - Analyse performances
# Version 1.3.0
# ==================================================

# Grille UI centralisée
if [ -f "$(dirname "${BASH_SOURCE[0]}")/ui_layout.sh" ]; then
    source "$(dirname "${BASH_SOURCE[0]}")/ui_layout.sh"
fi

if [ -z "${DMP_CONTENT_WIDTH:-}" ]; then
    dmp_ui_init
fi

# États visuels DMP
if [ -f "$(dirname "${BASH_SOURCE[0]}")/ui_status.sh" ]; then
    source "$(dirname "${BASH_SOURCE[0]}")/ui_status.sh"
fi

# Couche d'explication DMP
if [ -f "$(dirname "${BASH_SOURCE[0]}")/explanation.sh" ]; then
    source "$(dirname "${BASH_SOURCE[0]}")/explanation.sh"
fi

performance_check()
{
    clear

    echo
    dmp_ui_print_title_underlined "$MSG_PERFORMANCE_TITLE"
    echo

    explain_performance

    # --------------------------------------------------
    # CPU
    # --------------------------------------------------

    CPU_MODEL=$(LC_ALL=C lscpu | awk -F: '/^Model name:/ {
        gsub(/^[[:space:]]+/, "", $2)
        print $2
        exit
    }')

    CPU_MODEL=$(printf '%s' "$CPU_MODEL" |
        sed -E 's/Intel\(R\)/Intel/g; s/Core\(TM\)/Core/g; s/ CPU @.*$//')

    dmp_ui_print_title_underlined "$MSG_PROCESSOR_TITLE"
    echo
    dmp_ui_print_message "$CPU_MODEL"
    echo

    explain_processor
    explain_cores

    # Calcul de l'utilisation actuelle du processeur.
    CPU_USAGE=$(LC_ALL=C top -bn1 | awk -F'[, ]+' '/^%Cpu/ {
        for (i=1; i<=NF; i++)
        if ($i == "id") {
            printf "%.0f", 100 - $(i-1)
            exit
        }
    }')
    dmp_ui_print_section "$MSG_CPU_USAGE : ${CPU_USAGE}%"
    echo
    dmp_ui_print_message "$MSG_CPU_USAGE_EXPLAIN"
    echo
    echo

    # --------------------------------------------------
    # MÉMOIRE — MOTEUR DMP V2
    # --------------------------------------------------

    DMP_MEMORY_MODULE="${DMP_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}/memory_module.sh"

    dmp_ui_print_title_underlined "Votre mémoire"
    echo

    if [ -x "$DMP_MEMORY_MODULE" ]; then

        MEMORY_STATUS=$("$DMP_MEMORY_MODULE" 2>/dev/null)

        MEM_AVAILABLE_KB=$(printf '%s\n' "$MEMORY_STATUS" |
            awk -F= '$1=="mem_available_kb" {print $2; exit}')

        MEM_TOTAL_KB=$(printf '%s\n' "$MEMORY_STATUS" |
            awk -F= '$1=="mem_total_kb" {print $2; exit}')

        MEMORY_DIAGNOSIS=$(printf '%s\n' "$MEMORY_STATUS" |
            awk -F= '$1=="diagnosis" {print $2; exit}')

        MEMORY_ACTION=$(printf '%s\n' "$MEMORY_STATUS" |
            awk -F= '$1=="action" {print $2; exit}')

        MEMORY_TREND=$(printf '%s\n' "$MEMORY_STATUS" |
            awk -F= '$1=="trend" {print $2; exit}')

        MEMORY_RECOVERY=$(printf '%s\n' "$MEMORY_STATUS" |
            awk -F= '$1=="recovery" {print $2; exit}')

        MEMORY_PRESSURE=$(printf '%s\n' "$MEMORY_STATUS" |
            awk -F= '$1=="pressure" {print $2; exit}')

        if [ -n "$MEM_AVAILABLE_KB" ] && [ -n "$MEM_TOTAL_KB" ]; then
            MEM_AVAILABLE=$(awk -v kb="$MEM_AVAILABLE_KB" 'BEGIN {
                if (kb >= 1024*1024)
                    printf "%.1f GiB", kb/1024/1024
                else
                    printf "%.0f MiB", kb/1024
            }')

            dmp_ui_print_message "Mémoire disponible : $MEM_AVAILABLE"
        fi

        echo

        case "$MEMORY_DIAGNOSIS" in

            NORMAL)
                dmp_status_good \
                    "Mémoire — NORMALE" \
                    "La mémoire fonctionne normalement. Aucune action n'est nécessaire."
                ;;

            WATCH)
                dmp_status_watch \
                    "Mémoire — À SURVEILLER" \
                    "La mémoire présente un signal à surveiller. DMP recommande d'observer son évolution."
                ;;

            PROBLEM)
                dmp_status_problem \
                    "Mémoire — PROBLÈME" \
                    "Les mesures indiquent une situation mémoire nécessitant une action corrective."
                ;;

            *)
                dmp_status_unknown \
                    "Mémoire — ÉTAT INDÉTERMINÉ" \
                    "Les données disponibles ne permettent pas d'établir un diagnostic fiable."
                ;;
        esac

        echo
        case "$MEMORY_TREND" in
            STABLE)      MEMORY_TREND_FR="STABLE" ;;
            INCREASING)  MEMORY_TREND_FR="EN AUGMENTATION" ;;
            DECREASING)  MEMORY_TREND_FR="EN DIMINUTION" ;;
            *)           MEMORY_TREND_FR="INDÉTERMINÉE" ;;
        esac

        case "$MEMORY_RECOVERY" in
            RECOVERED)   MEMORY_RECOVERY_FR="RÉCUPÉRÉE" ;;
            PARTIAL)     MEMORY_RECOVERY_FR="PARTIELLE" ;;
            FAILED)      MEMORY_RECOVERY_FR="NON RÉCUPÉRÉE" ;;
            *)           MEMORY_RECOVERY_FR="INDÉTERMINÉE" ;;
        esac

        case "$MEMORY_PRESSURE" in
            NORMAL)      MEMORY_PRESSURE_FR="NORMALE" ;;
            WATCH)       MEMORY_PRESSURE_FR="À SURVEILLER" ;;
            INCREASING)  MEMORY_PRESSURE_FR="EN AUGMENTATION" ;;
            *)           MEMORY_PRESSURE_FR="INDÉTERMINÉE" ;;
        esac

        dmp_ui_print_message "Tendance mémoire : $MEMORY_TREND_FR"
        dmp_ui_print_message "Récupération : $MEMORY_RECOVERY_FR"
        dmp_ui_print_message "Pression mémoire : $MEMORY_PRESSURE_FR"

    else

        dmp_status_unknown \
            "Mémoire — MODULE INDISPONIBLE" \
            "Le moteur mémoire DMP V2 ne peut pas être exécuté actuellement."

    fi

    echo

    # --------------------------------------------------
    # PROGRAMME LE PLUS ACTIF
    # --------------------------------------------------

    TOP_CPU=$(ps -eo comm=,%cpu= --sort=-%cpu |
        awk '$1 != "ps" && $1 != "awk" && $2 ~ /^[0-9.]+$/ && $2 > 0 {
            printf "%s|%s", $1, $2
            exit
        }')

    if [ -n "$TOP_CPU" ]; then
        TOP_CPU_NAME=${TOP_CPU%%|*}
        TOP_CPU_PERCENT=${TOP_CPU#*|}
        dmp_ui_print_message "$MSG_TOP_CPU : $TOP_CPU_NAME"
        dmp_ui_print_message "$MSG_TOP_CPU_USAGE : ${TOP_CPU_PERCENT}%"
        echo
        echo
        dmp_ui_print_message "Cette valeur correspond au programme utilisant actuellement le plus le processeur parmi les programmes observés."
        dmp_ui_print_message "Cela ne signifie pas qu'une action est nécessaire."
        echo
    fi

    TOP_MEM=$(ps -eo comm=,%mem= --sort=-%mem |
        awk '$1 != "ps" && $1 != "awk" && $2 ~ /^[0-9.]+$/ && $2 > 0 {
            printf "%s|%s", $1, $2
            exit
        }')

    if [ -n "$TOP_MEM" ]; then
        TOP_MEM_NAME=${TOP_MEM%%|*}
        TOP_MEM_PERCENT=${TOP_MEM#*|}
        dmp_ui_print_message "$MSG_TOP_MEMORY : $TOP_MEM_NAME"
        dmp_ui_print_message "$MSG_TOP_MEMORY_USAGE : ${TOP_MEM_PERCENT}%"
        echo
        echo
        dmp_ui_print_message "Cette valeur correspond au programme utilisant actuellement le plus de mémoire parmi les programmes observés."
        dmp_ui_print_message "Cela ne signifie pas qu'une action est nécessaire."
        echo
    fi

    # --------------------------------------------------
    # TEMPÉRATURE
    # --------------------------------------------------

    dmp_ui_print_title_underlined "Température du processeur"
    echo

    if command -v sensors >/dev/null 2>&1
    then
        TEMP=$(sensors 2>/dev/null |
            awk '/Package id 0:/ {
                gsub(/[+°C]/, "", $4)
                print $4
                exit
            }')

        if [ -n "$TEMP" ]; then
            dmp_ui_print_message "Température actuelle : ${TEMP} °C"
            echo

            explain_temperature

            TEMP_INT=${TEMP%.*}

            if [ "$TEMP_INT" -lt 70 ]; then
                dmp_status_good \
                    "Température — NORMALE" \
                    "La température du processeur se situe dans une plage normale."

                echo
                echo

            elif [ "$TEMP_INT" -lt 85 ]; then
                dmp_status_watch \
                    "Température — ÉLEVÉE" \
                    "La température du processeur est élevée et mérite une surveillance."

            else
                dmp_status_problem \
                    "Température — TRÈS ÉLEVÉE" \
                    "La température du processeur est très élevée et nécessite une analyse."
            fi
        else
            dmp_ui_print_message "Température du processeur non disponible."
        fi
    else
        dmp_ui_print_message "La température du processeur ne peut pas être vérifiée actuellement."
    fi

    echo

    # --------------------------------------------------
    # SWAP
    # --------------------------------------------------

    dmp_ui_print_title_underlined "Mémoire virtuelle"
    echo

    SWAP_INFO=$(awk 'NR > 1 && $1 != "" {
        total += $3
        used += $4
    }
    END {
        printf "%d|%d", total, used
    }' /proc/swaps)

    SWAP_TOTAL_KIB=${SWAP_INFO%%|*}
    SWAP_USED_KIB=${SWAP_INFO#*|}

    if [ "${SWAP_TOTAL_KIB:-0}" -gt 0 ]; then

        SWAP_TOTAL=$(awk -v kb="$SWAP_TOTAL_KIB" 'BEGIN {
            printf "%.1f GiB", kb / 1024 / 1024
        }')

        SWAP_USED=$(awk -v kb="$SWAP_USED_KIB" 'BEGIN {
            if (kb < 1024)
                printf "%d KiB", kb
            else
                printf "%.1f MiB", kb / 1024
        }')

        SWAP_PERCENT=$(awk -v used="$SWAP_USED_KIB" -v total="$SWAP_TOTAL_KIB" 'BEGIN {
            if (total > 0)
                printf "%.0f", (used / total) * 100
            else
                print "0"
        }')

        dmp_ui_print_message "Mémoire virtuelle totale : $SWAP_TOTAL"
        dmp_ui_print_message "Mémoire virtuelle utilisée : $SWAP_USED"
        echo
        dmp_ui_print_message "Utilisation actuelle : ${SWAP_PERCENT}%"
        echo

        explain_swap

        if [ "$SWAP_USED_KIB" -eq 0 ]; then
            dmp_status_good \
                "Mémoire virtuelle — NON UTILISÉE" \
                "Aucune mémoire virtuelle n’est actuellement utilisée."

        else
            dmp_status_watch \
                "Mémoire virtuelle — UTILISÉE" \
                "La mémoire virtuelle est actuellement utilisée."
        fi

    else
        dmp_ui_print_message "Mémoire virtuelle : aucune"
        echo

        dmp_status_unknown \
            "Mémoire virtuelle — NON CONFIGURÉE" \
            "Debian ne dispose actuellement d'aucune mémoire virtuelle configurée."
    fi

    echo

    echo
    dmp_ui_print_title_underlined "Résultat de l'analyse"
    echo

    MEMORY_OK=0

    if [ "${MEMORY_DIAGNOSIS:-UNKNOWN}" = "NORMAL" ]; then
        MEMORY_OK=1
    fi

    echo
    echo

    if [ "${CPU_USAGE:-0}" -lt 80 ] &&
       [ "${TEMP_INT:-0}" -lt 85 ] &&
       [ "$MEMORY_OK" -eq 1 ]; then

        dmp_status_good \
            "Résultat global des performances" \
            "Les mesures observées par DMP ne montrent actuellement aucune sollicitation inhabituelle des ressources analysées."

        echo



    echo
    dmp_ui_print_message "Analyse des performances terminée."
    echo

    echo

else
    dmp_status_watch \
        "Résultat global des performances" \
        "DMP a identifié une ou plusieurs mesures nécessitant une observation complémentaire."

    echo
    dmp_ui_print_section "Éléments concernés"

    if [ "${CPU_USAGE:-0}" -ge 80 ]; then
        dmp_ui_print_list_item "Utilisation processeur élevée : ${CPU_USAGE}%"
    fi

    if [ "${TEMP_INT:-0}" -ge 85 ]; then
        dmp_ui_print_list_item "Température processeur élevée : ${TEMP_INT}°C"
    fi

    echo
    dmp_ui_print_message "Cette observation ne signifie pas forcément qu'un problème est présent."
    dmp_ui_print_message "DMP doit déterminer la cause avant de proposer une action."
fi

    echo
    echo
}
