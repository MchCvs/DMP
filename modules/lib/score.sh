dmp_calculate_score()
{
    DMP_SCORE=100

    DMP_PAQUETS="OK"
    DMP_DISQUE="OK"
    DMP_TRIM="OK"
    DMP_RAM="OK"
    DMP_SMART="INCONNU"

    # Données techniques conservées pour la traçabilité E2.4
    DMP_TECH_PAQUETS_RAW=""
    DMP_TECH_PAQUETS_EXIT_CODE=""

    DMP_TECH_DISQUE_RAW=""
    DMP_TECH_DISQUE_EXIT_CODE=""
    DMP_TECH_DISQUE_FILESYSTEM=""
    DMP_TECH_DISQUE_SIZE=""
    DMP_TECH_DISQUE_USED=""
    DMP_TECH_DISQUE_AVAILABLE=""
    DMP_TECH_DISQUE_USAGE=""

    DMP_TECH_TRIM_RAW=""
    DMP_TECH_TRIM_EXIT_CODE=""

    DMP_TECH_MEMOIRE_RAW=""
    DMP_TECH_MEMOIRE_EXIT_CODE=""
    DMP_TECH_MEM_TOTAL=""
    DMP_TECH_MEM_USED=""
    DMP_TECH_MEM_FREE=""
    DMP_TECH_MEM_SHARED=""
    DMP_TECH_MEM_BUFF_CACHE=""
    DMP_TECH_MEM_AVAILABLE=""
    DMP_TECH_SWAP_TOTAL=""
    DMP_TECH_SWAP_USED=""
    DMP_TECH_SWAP_FREE=""
    DMP_TECH_MEM_USAGE=""

    DMP_TECH_SMART_RAW=""
    DMP_TECH_SMART_DEVICE=""
    DMP_TECH_SMART_SOURCE_PARTITION=""
    DMP_TECH_SMART_EXIT_CODE=""

    # Trace complète du calcul
    DMP_TECH_STEPS=()

    # ==================================================
    # 1. Paquets Debian
    # ==================================================

    local SCORE_BEFORE
    local SCORE_AFTER

    SCORE_BEFORE="$DMP_SCORE"

    DMP_TECH_PAQUETS_RAW=$(dpkg --audit)
    DMP_TECH_PAQUETS_EXIT_CODE=$?

    if printf '%s\n' "$DMP_TECH_PAQUETS_RAW" | grep -q .; then
        DMP_SCORE=$((DMP_SCORE - 15))
        DMP_PAQUETS="PROBLEME"
        DMP_TECH_PAQUETS_EVALUATION="DECLENCHE"
        DMP_TECH_PAQUETS_CONTRIBUTION="-15"
    else
        DMP_TECH_PAQUETS_EVALUATION="NON_DECLENCHE"
        DMP_TECH_PAQUETS_CONTRIBUTION="0"
    fi

    SCORE_AFTER="$DMP_SCORE"

    DMP_TECH_STEPS+=(
        "Paquets Debian|dpkg --audit|paquets cassés détectés|${DMP_TECH_PAQUETS_EVALUATION}|-15|${DMP_TECH_PAQUETS_CONTRIBUTION}|${SCORE_BEFORE}|${SCORE_AFTER}"
    )

    # ==================================================
    # 2. Espace disque
    # ==================================================

    SCORE_BEFORE="$DMP_SCORE"

    DMP_TECH_DISQUE_RAW=$(df /)
    DMP_TECH_DISQUE_EXIT_CODE=$?

    DMP_TECH_DISQUE_FILESYSTEM=$(
        printf '%s\n' "$DMP_TECH_DISQUE_RAW" |
        awk 'NR==2 {print $1}'
    )

    DMP_TECH_DISQUE_SIZE=$(
        printf '%s\n' "$DMP_TECH_DISQUE_RAW" |
        awk 'NR==2 {print $2}'
    )

    DMP_TECH_DISQUE_USED=$(
        printf '%s\n' "$DMP_TECH_DISQUE_RAW" |
        awk 'NR==2 {print $3}'
    )

    DMP_TECH_DISQUE_AVAILABLE=$(
        printf '%s\n' "$DMP_TECH_DISQUE_RAW" |
        awk 'NR==2 {print $4}'
    )

    DMP_TECH_DISQUE_USAGE=$(
        printf '%s\n' "$DMP_TECH_DISQUE_RAW" |
        awk 'NR==2 {print $5}' |
        tr -d '%'
    )

    if [ -n "$DMP_TECH_DISQUE_USAGE" ] &&
       [ "$DMP_TECH_DISQUE_USAGE" -gt 85 ]; then

        DMP_SCORE=$((DMP_SCORE - 20))
        DMP_DISQUE="PROBLEME"
        DMP_TECH_DISQUE_EVALUATION="DECLENCHE"
        DMP_TECH_DISQUE_CONTRIBUTION="-20"
    else
        DMP_TECH_DISQUE_EVALUATION="NON_DECLENCHE"
        DMP_TECH_DISQUE_CONTRIBUTION="0"
    fi

    SCORE_AFTER="$DMP_SCORE"

    DMP_TECH_STEPS+=(
        "Espace disque|df /|utilisation supérieure à 85 %|${DMP_TECH_DISQUE_EVALUATION}|-20|${DMP_TECH_DISQUE_CONTRIBUTION}|${SCORE_BEFORE}|${SCORE_AFTER}"
    )

    # ==================================================
    # 3. TRIM
    # ==================================================

    SCORE_BEFORE="$DMP_SCORE"

    DMP_TECH_TRIM_RAW=$(systemctl is-enabled fstrim.timer 2>&1)
    DMP_TECH_TRIM_EXIT_CODE=$?

    if [ "$DMP_TECH_TRIM_EXIT_CODE" -eq 0 ]; then
        DMP_TRIM="OK"
        DMP_TECH_TRIM_EVALUATION="NON_DECLENCHE"
    else
        DMP_TRIM="INCONNU"
        DMP_TECH_TRIM_EVALUATION="INCONNU"
    fi

    DMP_TECH_TRIM_CONTRIBUTION="0"

    SCORE_AFTER="$DMP_SCORE"

    DMP_TECH_STEPS+=(
        "TRIM SSD|systemctl is-enabled fstrim.timer|TRIM non disponible ou non actif|${DMP_TECH_TRIM_EVALUATION}|0|0|${SCORE_BEFORE}|${SCORE_AFTER}"
    )

    # ==================================================
    # 4. Mémoire
    # ==================================================

    SCORE_BEFORE="$DMP_SCORE"

    DMP_TECH_MEMOIRE_RAW=$(free)
    DMP_TECH_MEMOIRE_EXIT_CODE=$?

    DMP_TECH_MEM_TOTAL=$(
        printf '%s\n' "$DMP_TECH_MEMOIRE_RAW" |
        awk '/^Mem:/ {print $2}'
    )

    DMP_TECH_MEM_USED=$(
        printf '%s\n' "$DMP_TECH_MEMOIRE_RAW" |
        awk '/^Mem:/ {print $3}'
    )

    DMP_TECH_MEM_FREE=$(
        printf '%s\n' "$DMP_TECH_MEMOIRE_RAW" |
        awk '/^Mem:/ {print $4}'
    )

    DMP_TECH_MEM_SHARED=$(
        printf '%s\n' "$DMP_TECH_MEMOIRE_RAW" |
        awk '/^Mem:/ {print $5}'
    )

    DMP_TECH_MEM_BUFF_CACHE=$(
        printf '%s\n' "$DMP_TECH_MEMOIRE_RAW" |
        awk '/^Mem:/ {print $6}'
    )

    DMP_TECH_MEM_AVAILABLE=$(
        printf '%s\n' "$DMP_TECH_MEMOIRE_RAW" |
        awk '/^Mem:/ {print $7}'
    )

    DMP_TECH_SWAP_TOTAL=$(
        printf '%s\n' "$DMP_TECH_MEMOIRE_RAW" |
        awk '/^(Échange:|Swap:) / {print $2}'
    )

    DMP_TECH_SWAP_USED=$(
        printf '%s\n' "$DMP_TECH_MEMOIRE_RAW" |
        awk '/^(Échange:|Swap:) / {print $3}'
    )

    DMP_TECH_SWAP_FREE=$(
        printf '%s\n' "$DMP_TECH_MEMOIRE_RAW" |
        awk '/^(Échange:|Swap:) / {print $4}'
    )

    if [ -n "$DMP_TECH_MEM_TOTAL" ] &&
       [ "$DMP_TECH_MEM_TOTAL" -gt 0 ]; then

        DMP_TECH_MEM_USAGE=$(
            awk -v used="$DMP_TECH_MEM_USED" \
                -v total="$DMP_TECH_MEM_TOTAL" \
                'BEGIN {printf "%.0f", used/total*100}'
        )
    else
        DMP_TECH_MEM_USAGE=""
    fi

    if [ -n "$DMP_TECH_MEM_USAGE" ] &&
       [ "$DMP_TECH_MEM_USAGE" -gt 90 ]; then

        DMP_SCORE=$((DMP_SCORE - 10))
        DMP_RAM="PROBLEME"
        DMP_TECH_MEM_EVALUATION="DECLENCHE"
        DMP_TECH_MEM_CONTRIBUTION="-10"
    elif [ -n "$DMP_TECH_MEM_USAGE" ]; then
        DMP_TECH_MEM_EVALUATION="NON_DECLENCHE"
        DMP_TECH_MEM_CONTRIBUTION="0"
    else
        DMP_TECH_MEM_EVALUATION="INCONNU"
        DMP_TECH_MEM_CONTRIBUTION="0"
    fi

    SCORE_AFTER="$DMP_SCORE"

    DMP_TECH_STEPS+=(
        "Mémoire|free|utilisation supérieure à 90 %|${DMP_TECH_MEM_EVALUATION}|-10|${DMP_TECH_MEM_CONTRIBUTION}|${SCORE_BEFORE}|${SCORE_AFTER}"
    )

    # ==================================================
    # 5. SMART
    # ==================================================

    SCORE_BEFORE="$DMP_SCORE"

    local SSD

    DMP_TECH_SMART_SOURCE_PARTITION=$(
        findmnt -no SOURCE / 2>/dev/null
    )

    SSD=$(
        printf '%s\n' "$DMP_TECH_SMART_SOURCE_PARTITION" |
        sed 's/[0-9]*$//'
    )

    if [ -n "$SSD" ]; then
        DMP_TECH_SMART_DEVICE="$SSD"

        DMP_TECH_SMART_RAW=$(
            sudo -n smartctl -H "$SSD" 2>&1
        )
        DMP_TECH_SMART_EXIT_CODE=$?

        if printf '%s\n' "$DMP_TECH_SMART_RAW" |
           grep -q "PASSED"; then

            DMP_SMART="OK"
            DMP_TECH_SMART_EVALUATION="NON_DECLENCHE"
            DMP_TECH_SMART_CONTRIBUTION="0"

        elif printf '%s\n' "$DMP_TECH_SMART_RAW" |
             grep -qE "overall-health self-assessment test result: FAILED"; then

            DMP_SMART="PROBLEME"
            DMP_SCORE=$((DMP_SCORE - 20))
            DMP_TECH_SMART_EVALUATION="DECLENCHE"
            DMP_TECH_SMART_CONTRIBUTION="-20"

        else
            DMP_SMART="INCONNU"
            DMP_TECH_SMART_EVALUATION="INCONNU"
            DMP_TECH_SMART_CONTRIBUTION="0"
        fi
    else
        DMP_TECH_SMART_EVALUATION="INCONNU"
        DMP_TECH_SMART_CONTRIBUTION="0"
    fi

    SCORE_AFTER="$DMP_SCORE"

    DMP_TECH_STEPS+=(
        "SSD SMART|sudo -n smartctl -H ${DMP_TECH_SMART_DEVICE}|échec SMART|${DMP_TECH_SMART_EVALUATION}|-20|${DMP_TECH_SMART_CONTRIBUTION}|${SCORE_BEFORE}|${SCORE_AFTER}"
    )

    # ==================================================
    # Etat global
    # ==================================================

    if [ "$DMP_SCORE" -ge 90 ]; then
        DMP_STATE="EXCELLENT"
    elif [ "$DMP_SCORE" -ge 75 ]; then
        DMP_STATE="BON"
    else
        DMP_STATE="A_SURVEILLER"
    fi

    # ==================================================
    # Conservation du dernier état de santé mesuré
    # ==================================================

    HEALTH_SCORE_FILE="${REPORT_DIR:-${DMP_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}/reports}/health_score.txt"

    mkdir -p "$(dirname "$HEALTH_SCORE_FILE")"

    printf '%s;%s\n' "$DMP_SCORE" "$DMP_STATE" > "$HEALTH_SCORE_FILE"
}
