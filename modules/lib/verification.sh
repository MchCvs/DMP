#!/bin/bash

# ==================================================
# DMP - Vérification après action
# Version 1.2.0
# ==================================================

dmp_verify_command()
{
    local LABEL="$1"
    shift

    if "$@"; then
        dmp_status_good "$LABEL" "La vérification est conforme."
        return 0
    else
        dmp_status_problem "$LABEL" "La vérification a détecté un problème."
        return 1
    fi
}


dmp_verify_packages()
{
    local LABEL="${1:-État des paquets}"

    if dpkg --audit | grep -q .; then
        dmp_status_problem "$LABEL" "Des paquets présentent actuellement un problème."
        return 1
    else
        dmp_status_good "$LABEL" "Aucun problème de paquets n'a été détecté."
        return 0
    fi
}


dmp_verify_apt_cache()
{
    local LABEL="${1:-Cache APT}"

    local CACHE_SIZE
    local CACHE_COUNT

    CACHE_SIZE=$(du -sh /var/cache/apt/archives 2>/dev/null | awk '{print $1}')
    CACHE_COUNT=$(find /var/cache/apt/archives \
        -maxdepth 1 \
        -type f \
        -name '*.deb' \
        2>/dev/null | wc -l)

    if [ -z "$CACHE_SIZE" ]; then
        dmp_status_unknown "$LABEL" \
            "DMP ne dispose pas des informations nécessaires."
        return 1
    fi

    dmp_status_good "$LABEL" "Le cache APT est accessible et a été vérifié."
    echo "  Taille actuelle : $CACHE_SIZE"
    echo "  Paquets présents : $CACHE_COUNT"

    return 0
}


dmp_verify_journal_usage()
{
    local LABEL="${1:-Journaux système}"

    local USAGE
    USAGE=$(journalctl --disk-usage 2>/dev/null)

    if [ -n "$USAGE" ]; then
        dmp_status_good "$LABEL" "L'utilisation des journaux a été vérifiée."
        echo "  $USAGE"
        return 0
    else
        dmp_status_unknown "$LABEL" \
            "DMP ne dispose pas des informations nécessaires."
        return 1
    fi
}


dmp_verify_thumbnails()
{
    local LABEL="${1:-Miniatures utilisateur}"

    local COUNT

    COUNT=$(find "$HOME/.cache/thumbnails" \
        -type f \
        2>/dev/null | wc -l)

    if [ "$COUNT" -eq 0 ]; then
        dmp_status_good "$LABEL" "Aucune miniature restante."
        echo "  Miniatures restantes : 0"
        return 0
    else
        dmp_status_watch "$LABEL" \
            "$COUNT élément(s) restent présents."
        return 1
    fi
}


dmp_verify_swappiness()
{
    local LABEL="${1:-Swappiness}"
    local EXPECTED="${2:-20}"
    local CURRENT

    CURRENT=$(cat /proc/sys/vm/swappiness 2>/dev/null)

    if [ -z "$CURRENT" ]; then
        dmp_status_unknown "$LABEL" \
            "DMP ne dispose pas de la valeur actuelle."
        return 1
    fi

    if [ "$CURRENT" -eq "$EXPECTED" ]; then
        dmp_status_good "$LABEL" \
            "La valeur actuelle correspond à la valeur attendue."
        echo "  Valeur actuelle : $CURRENT"
        return 0
    fi

    dmp_status_problem "$LABEL" \
        "La valeur actuelle ne correspond pas à la valeur attendue."
    echo "  Valeur actuelle : $CURRENT"
    echo "  Valeur attendue : $EXPECTED"
    return 1
}


dmp_verify_network_wait_online()
{
    local LABEL="${1:-NetworkManager wait-online}"

    if systemctl is-enabled NetworkManager-wait-online.service \
        >/dev/null 2>&1
    then
        dmp_status_watch "$LABEL" \
            "Le service est actuellement activé."
        return 1
    fi

    dmp_status_good "$LABEL" \
        "Le service est actuellement désactivé."
    return 0
}
