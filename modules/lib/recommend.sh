#!/bin/bash

# ==================================================
# DMP - Recommandations
# Version 2.0.0
# ==================================================

recommended_optimizations()
{
    clear

    echo
    echo "              =============================================="
    echo "              Recommandations DMP"
    echo "              =============================================="
    echo

    echo "              DMP analyse votre système afin de déterminer"
    echo "              si une intervention est réellement nécessaire."
    echo

    echo "              Cette consultation ne modifie aucun élément"
    echo "              de votre ordinateur."
    echo

    SWAP=$(cat /proc/sys/vm/swappiness 2>/dev/null || echo "INCONNU")

    NETWORK_WAIT_STATUS=$(
        systemctl is-enabled NetworkManager-wait-online.service 2>/dev/null
    )

    RECOMMENDATION_FOUND=0

    echo
    echo "              Analyse de la configuration"
    echo "              ---------------------------"
    echo

    # --------------------------------------------------
    # Swappiness
    # --------------------------------------------------

    if [ "$SWAP" != "INCONNU" ] && [ "$SWAP" -gt 30 ] 2>/dev/null
    then
        RECOMMENDATION_FOUND=1

        echo
        echo "              Recommandation DMP"
        echo
        echo "              Élément concerné : mémoire virtuelle"
        echo
        echo "              La valeur actuelle de la gestion"
        echo "              de la mémoire virtuelle est de $SWAP."
        echo
        echo "              DMP considère qu'une valeur plus basse"
        echo "              peut être mieux adaptée à cette machine."
        echo
        echo "              DMP recommande d'étudier une valeur"
        echo "              de 20 avant toute modification."
        echo
        echo "              Aucune modification n'a été effectuée."
        echo
    fi

    # --------------------------------------------------
    # NetworkManager wait-online
    # --------------------------------------------------

    if [ "$NETWORK_WAIT_STATUS" = "enabled" ]
    then
        RECOMMENDATION_FOUND=1

        echo
        echo "              Recommandation DMP"
        echo
        echo "              Élément concerné : démarrage du réseau"
        echo
        echo "              Debian attend actuellement que le réseau"
        echo "              soit disponible avant de considérer"
        echo "              le démarrage du réseau comme terminé."
        echo
        echo "              Selon l'utilisation de votre machine,"
        echo "              cette attente peut être inutile."
        echo
        echo "              DMP recommande de vérifier si ce service"
        echo "              est réellement nécessaire avant"
        echo "              toute désactivation."
        echo
        echo "              Aucune modification n'a été effectuée."
        echo
    fi

    # --------------------------------------------------
    # Résultat global
    # --------------------------------------------------

    echo
    echo "              =============================================="
    echo "              Résultat de l'analyse"
    echo "              =============================================="
    echo

    if [ "$RECOMMENDATION_FOUND" -eq 0 ]
    then
        echo "              Votre système ne nécessite actuellement"
        echo "              aucune optimisation parmi les éléments"
        echo "              analysés par DMP."
        echo
        echo "              Aucune intervention n'est recommandée."
    else
        echo "              DMP a identifié une ou plusieurs"
        echo "              possibilités d'amélioration."
        echo
        echo "              Aucune modification n'a été effectuée."
        echo
        echo "              Vous pourrez décider ultérieurement"
        echo "              si vous souhaitez appliquer"
        echo "              une optimisation."
    fi

    echo
    echo "              DMP n'effectue aucune modification"
    echo "              lorsque vous consultez simplement"
    echo "              ses recommandations."
    echo

    echo "              $PROMPT_RETURN"
    read -r
}
