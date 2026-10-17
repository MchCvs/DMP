#!/bin/bash

# ==================================================
# DMP - Diagnostic SSD SMART
# Version 0.7.1
# ==================================================


bold()
{
    printf '\033[1m%s\033[0m' "$1"
}

bold_underline()
{
    printf '\033[1;4m%s\033[0m' "$1"
}

ssd_check()
{

clear

echo "=============================================="
echo " ÉTAT DE VOS DISQUES"
echo "=============================================="
echo

SMARTCTL_CMD=$(command -v smartctl 2>/dev/null)

if [ -z "$SMARTCTL_CMD" ] && [ -x /usr/sbin/smartctl ]; then
    SMARTCTL_CMD="/usr/sbin/smartctl"
fi

if [ -z "$SMARTCTL_CMD" ]; then
    echo "Vérification de l’état des disques impossible."
    echo
    echo "DMP ne dispose pas de l’outil nécessaire pour vérifier"
    echo "l’état matériel des disques."
    echo
    echo "Aucune conclusion fiable ne peut être établie."
    echo
    return 0
fi

echo "Les informations disponibles dépendent du disque et de la manière"
echo "dont il est connecté."
echo
echo "Certains disques fournissent les informations nécessaires aux"
echo "contrôles DMP. D’autres ne les fournissent pas ou ne permettent"
echo "pas de les interpréter de façon fiable."
echo
echo "DMP indique donc clairement lorsqu’une information ne peut pas"
echo "être vérifiée de manière fiable."
echo
echo
echo "Pour vérifier l’état matériel de vos disques,"
echo "DMP doit accéder à certaines informations"
echo "protégées de votre ordinateur."
echo
echo "Debian demande donc votre mot de passe"
echo "pour autoriser cette vérification."
echo
echo "Votre mot de passe n’est pas enregistré"
echo "par DMP."
echo

sudo -v || {
    echo
    echo "La vérification des disques ne peut pas continuer"
    echo "sans cette autorisation."
    echo
    return 0
}

echo
echo "Disques détectés :"
echo

ROOT_SOURCE=$(findmnt -no SOURCE / 2>/dev/null)
ROOT_DEVICE=$(lsblk -no PKNAME "$ROOT_SOURCE" 2>/dev/null)

if [ -n "$ROOT_DEVICE" ]; then
    echo "Le disque utilisé par Debian a été identifié."
else
    echo "Le disque utilisé par Debian n’a pas pu être identifié."
fi

echo

for disk in /dev/sd? /dev/nvme*n1
do

    if [ ! -b "$disk" ]; then
        continue
    fi

    MODEL=$(sudo "$SMARTCTL_CMD" -i "$disk" 2>/dev/null |
        grep -E "Device Model|Model Number")

    if [ -z "$MODEL" ]; then
        DISK_MODEL=$(lsblk -dn -o MODEL "$disk" 2>/dev/null)
    else
        DISK_MODEL=$(printf "%s\n" "$MODEL" |
            sed -E 's/^[^:]+:[[:space:]]*//')
    fi

    DISK_SIZE=$(lsblk -dnbo SIZE "$disk" 2>/dev/null)

    if [ -z "$DISK_MODEL" ]; then
        DISK_MODEL="Disque non identifié"
    fi

    case "$DISK_SIZE" in
        0|"")
            HUMAN_SIZE="Capacité non déterminée"
            ;;
        *)
            HUMAN_SIZE=$(numfmt --to=si --format="%.0f" "$DISK_SIZE" 2>/dev/null |
                sed 's/GB/Go/; s/TB/To/; s/MB/Mo/')

            if [ -z "$HUMAN_SIZE" ]; then
                HUMAN_SIZE="Capacité non déterminée"
            fi
            ;;
    esac

    echo "----------------------------------------------"
    echo
    printf "\033[1m%s\033[0m\n" "${DISK_MODEL} — ${HUMAN_SIZE}"
    echo

    HEALTH=$(sudo "$SMARTCTL_CMD" -H "$disk" 2>/dev/null |
        grep "overall-health")

    echo "État général du disque :"
    echo

    if printf '%s\n' "$HEALTH" | grep -qi "PASSED"; then
        dmp_status_good \
            "État général du disque" \
            "Les contrôles disponibles ne signalent aucune anomalie matérielle."

    elif printf '%s\n' "$HEALTH" | grep -qi "FAILED"; then
        dmp_status_problem \
            "État général du disque" \
            "Les contrôles disponibles signalent une anomalie matérielle."

    else
        dmp_status_unknown \
            "État général du disque" \
            "DMP ne peut pas vérifier l’état matériel de ce disque avec les informations actuellement disponibles."
    fi

    echo
    echo "Température du disque :"
    echo

    TEMP=$(sudo "$SMARTCTL_CMD" -A "$disk" 2>/dev/null |
        grep -E "Temperature_Celsius|Airflow_Temperature_Cel")

    TEMP_VALUE=$(printf "%s\n" "$TEMP" |
        awk '$1 ~ /^[0-9]+$/ && $NF ~ /^[0-9]+$/ {print $NF; exit}')

    if [ -n "$TEMP_VALUE" ]; then
        echo "Valeur : ${TEMP_VALUE} °C"
        echo

        if [ "$TEMP_VALUE" -lt 30 ]; then
            dmp_status_good \
                "Température — BASSE" \
                "La température mesurée est basse et ne signale pas de problème."

        elif [ "$TEMP_VALUE" -le 60 ]; then
            dmp_status_good \
                "Température — NORMALE" \
                "La température mesurée se situe dans la plage normale."

        elif [ "$TEMP_VALUE" -le 70 ]; then
            dmp_status_watch \
                "Température — ÉLEVÉE" \
                "La température mesurée est élevée et mérite une surveillance."

        else
            dmp_status_problem \
                "Température — CRITIQUE" \
                "La température mesurée est critique et nécessite une analyse."
        fi
    else
        dmp_status_unknown \
            "Température" \
            "La température ne peut pas être déterminée de manière fiable avec les informations fournies par ce disque."
    fi

    echo
    echo "Durée de vie du disque :"
    echo

    LIFE=$(sudo "$SMARTCTL_CMD" -A "$disk" 2>/dev/null |
        grep -E "SSD_Life_Left|Percentage Used")

    LIFE_VALUE=$(printf "%s\n" "$LIFE" |
        awk '$1 ~ /^[0-9]+$/ && $NF ~ /^[0-9]+$/ {print $NF; exit}')

    if printf "%s\n" "$LIFE" | grep -q "SSD_Life_Left" &&
       [ -n "$LIFE_VALUE" ]; then

        echo "Durée de vie restante : ${LIFE_VALUE} %"
        echo

        if [ "$LIFE_VALUE" -ge 90 ]; then
            dmp_status_good \
                "Durée de vie — EXCELLENTE" \
                "La durée de vie restante estimée est excellente."

        elif [ "$LIFE_VALUE" -ge 70 ]; then
            dmp_status_good \
                "Durée de vie — BONNE" \
                "La durée de vie restante estimée est bonne."

        elif [ "$LIFE_VALUE" -ge 40 ]; then
            dmp_status_watch \
                "Durée de vie — MOYENNE" \
                "La durée de vie restante estimée mérite une surveillance."

        elif [ "$LIFE_VALUE" -ge 20 ]; then
            dmp_status_watch \
                "Durée de vie — FAIBLE" \
                "La durée de vie restante estimée est faible et mérite une surveillance."

        else
            dmp_status_problem \
                "Durée de vie — CRITIQUE" \
                "La durée de vie restante estimée est critique et nécessite une analyse."
        fi

    else
        dmp_status_unknown \
            "Durée de vie" \
            "La durée de vie restante ne peut pas être déterminée de manière fiable avec les informations fournies par ce disque."
    fi

    echo
    echo "État des erreurs détectées :"
    echo

    ERRORS=$(sudo "$SMARTCTL_CMD" -a "$disk" 2>/dev/null |
        grep -E "No Errors Logged|Errors Logged")

    if printf "%s\n" "$ERRORS" | grep -q "No Errors Logged"; then
        dmp_status_good \
            "Erreurs matérielles" \
            "Aucune erreur matérielle enregistrée n’a été détectée."

    elif printf "%s\n" "$ERRORS" | grep -q "Errors Logged"; then
        dmp_status_problem \
            "Erreurs matérielles" \
            "Des erreurs matérielles enregistrées ont été détectées."

    else
        dmp_status_unknown \
            "Erreurs matérielles" \
            "DMP ne peut pas déterminer si des erreurs matérielles sont enregistrées avec les informations actuellement disponibles."
    fi

    echo
    echo

done

echo
printf "\033[1m%s\033[0m\n" "Gestion automatique des espaces inutilisés du SSD"
echo

if systemctl is-enabled fstrim.timer >/dev/null 2>&1; then
    dmp_status_good \
        "Gestion automatique des espaces inutilisés du SSD" \
        "Debian dispose d’une gestion automatique qui libère régulièrement les espaces inutilisés des SSD afin de maintenir leur bon fonctionnement."
else
    dmp_status_watch \
        "Gestion automatique des espaces inutilisés du SSD" \
        "Debian ne dispose pas actuellement de cette gestion automatique. Les espaces inutilisés du SSD ne sont donc pas traités automatiquement."
fi

echo
echo "Vérification des disques terminée."

}
