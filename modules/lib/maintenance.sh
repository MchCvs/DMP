#!/bin/bash

# ==================================================
# DMP - Maintenance Debian
# Version 1.0.0
# ==================================================

maintenance_debian()
{
    clear

    echo "=============================================="
    echo " $MSG_MAINTENANCE_TITLE"
    echo "=============================================="
    echo

    echo "----------------------------------------------"
    echo " $MSG_PACKAGE_CHECK"
    echo "----------------------------------------------"

    AUDIT=$(dpkg --audit)

    if [ -z "$AUDIT" ]; then
        dmp_status_good \
            "État des paquets — CONFORME" \
            "Aucun paquet présentant un problème de configuration n’a été détecté."

    else
        dmp_status_problem \
            "État des paquets — PROBLÈME" \
            "DMP a détecté des paquets nécessitant une intervention."

        echo
        echo "$AUDIT"
    fi

    echo
    echo "----------------------------------------------"
    echo " $MSG_DEPENDENCY_CHECK"
    echo "----------------------------------------------"

    read -r -p "Réparer les paquets interrompus avec sudo ? (o/N) : " REP
if [[ "$REP" =~ ^[oOyY]$ ]] && sudo dpkg --configure -a; then
        dmp_status_good \
            "Configuration des paquets — CONFORME" \
            "La configuration des paquets s’est terminée correctement."

    elif [[ ! "$REP" =~ ^[oOyY]$ ]]; then
        echo "Ignoré à votre demande."
    else
        dmp_status_problem \
            "Configuration des paquets — PROBLÈME" \
            "La configuration des paquets a rencontré une erreur."
    fi

    echo
echo
echo "----------------------------------------------"
echo " $MSG_REPOSITORY_UPDATE"
echo "----------------------------------------------"

read -r -p "Rafraîchir la liste des paquets avec sudo ? (o/N) : " REP
if [[ "$REP" =~ ^[oOyY]$ ]] && sudo apt update >/tmp/dmp_apt_update.log 2>&1; then
    dmp_status_good \
        "Dépôts Debian — ACCESSIBLES" \
        "Les dépôts configurés ont été contactés correctement."

elif [[ ! "$REP" =~ ^[oOyY]$ ]]; then
    echo "Ignoré à votre demande."
else
    dmp_status_problem \
        "Dépôts Debian — PROBLÈME" \
        "DMP n’a pas pu mettre à jour correctement les informations des dépôts."

    echo
    cat /tmp/dmp_apt_update.log
fi

echo
echo
echo "----------------------------------------------"
echo " $MSG_AVAILABLE_UPDATES"
echo "----------------------------------------------"

UPDATES=$(LC_ALL=C apt list --upgradable 2>/dev/null | tail -n +2)

if [ -z "$UPDATES" ]; then

    dmp_status_good \
        "Mises à jour — SYSTÈME À JOUR" \
        "Aucune mise à jour logicielle n’est actuellement disponible."

else

    dmp_status_watch \
        "Mises à jour — DISPONIBLES" \
        "Des mises à jour logicielles sont disponibles. Leur installation reste une décision de l’utilisateur."

    echo
    echo "$UPDATES"

    echo
    read -r -p \
        "$MSG_INSTALL_UPDATES " REPONSE

    if [[ "$REPONSE" =~ ^[Oo]$ ]]; then

        echo
        echo "$MSG_INSTALLING_UPDATES"

        if sudo env \
            DEBIAN_FRONTEND=noninteractive \
            NEEDRESTART_MODE=l \
            apt upgrade; then

            dmp_status_good \
                "Installation des mises à jour — TERMINÉE" \
                "Les mises à jour sélectionnées ont été installées correctement."

            echo
            echo "$MSG_VERIFY_AFTER_INSTALL"

            dmp_verify_command \
                "État des paquets après mise à jour" \
                bash -c '! dpkg --audit | grep -q .'

        else

            dmp_status_problem \
                "Installation des mises à jour — ÉCHEC" \
                "L’installation des mises à jour a rencontré une erreur."

        fi

    else

        echo
        echo "$MSG_INSTALL_CANCELLED"
    fi
fi
echo
echo
echo "----------------------------------------------"
echo " $MSG_LIGHT_CLEANUP"
echo "----------------------------------------------"

AUTOREMOVE=$(apt-get --dry-run autoremove 2>/dev/null)

REMOVED_COUNT=$(echo "$AUTOREMOVE" |
    sed -n 's/^\([0-9][0-9]*\) à enlever.*/\1/p')

if [ -n "$REMOVED_COUNT" ] && [ "$REMOVED_COUNT" -gt 0 ]; then

    dmp_status_watch \
        "Paquets supprimables — DISPONIBLES" \
        "DMP a identifié des paquets qui peuvent être supprimés. Leur suppression reste une décision de l’utilisateur."

    echo
    printf "$MSG_REMOVABLE_PACKAGES
" "$REMOVED_COUNT"
    echo
    echo "$MSG_CLEANUP_PROPOSAL"

    read -r -p \
        "$MSG_REMOVE_PACKAGES " NETTOYAGE

    if [[ "$NETTOYAGE" =~ ^[Oo]$ ]]; then

        echo
        echo "$MSG_REMOVING_PACKAGES"

        if sudo apt autoremove; then

            dmp_status_good \
                "Suppression des paquets — TERMINÉE" \
                "La suppression des paquets sélectionnés s’est terminée correctement."

            dmp_verify_packages "État des paquets après suppression"

        else

            dmp_status_problem \
                "Suppression des paquets — ÉCHEC" \
                "La suppression des paquets a rencontré une erreur."
        fi

    else

        echo
        echo "$MSG_REMOVAL_CANCELLED"
    fi

else

    dmp_status_good \
        "Paquets supprimables — AUCUN" \
        "Aucun paquet inutilisé n’a été identifié pour une suppression automatique."
fi

CACHE_BEFORE=$(du -sb /var/cache/apt/archives 2>/dev/null | awk '{print $1}')
CACHE_BEFORE_HUMAN=$(du -sh /var/cache/apt/archives 2>/dev/null | awk '{print $1}')

if [ -n "$CACHE_BEFORE" ] && [ "$CACHE_BEFORE" -gt 0 ]; then

    AUTOCLEAN_SIMULATION=$(sudo apt-get -s autoclean 2>/dev/null)

    AUTOCLEAN_COUNT=$(echo "$AUTOCLEAN_SIMULATION" |
        sed -n 's/.* \\([0-9][0-9]*\\) à enlever.*/\\1/p' |
        tail -1)

    if [ -z "$AUTOCLEAN_COUNT" ]; then
        AUTOCLEAN_COUNT=0
    fi

    echo
    echo "$MSG_CACHE_TITLE"
    echo "occupe actuellement $CACHE_BEFORE_HUMAN."

    if [ "$AUTOCLEAN_COUNT" -gt 0 ]; then

        dmp_status_watch \
            "Cache APT — NETTOYAGE POSSIBLE" \
            "DMP a identifié des fichiers du cache APT pouvant être supprimés."

        echo
        printf "$MSG_FILES_CAN_REMOVE
" "$AUTOCLEAN_COUNT"

        echo
        echo "$MSG_CACHE_RECOMMEND"

        echo
        read -r -p \
            "$MSG_CLEAN_CACHE " NETTOYAGE_CACHE

        if [[ "$NETTOYAGE_CACHE" =~ ^[Oo]$ ]]; then

            echo
            echo "$MSG_CLEANING_CACHE"

            if sudo apt autoclean; then

                CACHE_AFTER=$(du -sb /var/cache/apt/archives 2>/dev/null | awk '{print $1}')
                CACHE_AFTER_HUMAN=$(du -sh /var/cache/apt/archives 2>/dev/null | awk '{print $1}')

                if [ -n "$CACHE_AFTER" ] && [ "$CACHE_AFTER" -lt "$CACHE_BEFORE" ]; then

                    GAIN=$((CACHE_BEFORE - CACHE_AFTER))

                    dmp_status_good \
                        "Cache APT — NETTOYAGE TERMINÉ" \
                        "Le nettoyage du cache APT a permis de libérer de l’espace."

                    echo
                    echo "$MSG_SPACE_RELEASED"
                    numfmt --to=iec "$GAIN" 2>/dev/null || echo "$GAIN octets"

                    dmp_verify_apt_cache \
                        "État du cache APT après nettoyage"

                else

                    dmp_status_watch \
                        "Cache APT — AUCUN GAIN" \
                        "Le nettoyage s’est terminé mais aucune réduction mesurable du cache n’a été constatée."

                    echo
                    echo "$MSG_NO_SPACE_RELEASED"
                fi

            else

                dmp_status_problem \
                    "Cache APT — ÉCHEC" \
                    "Le nettoyage du cache APT a rencontré une erreur."

                echo
                echo "$MSG_CACHE_ERROR"
            fi

        else

            dmp_status_watch \
                "Cache APT — NON MODIFIÉ" \
                "Le nettoyage du cache APT était possible mais aucune modification n’a été effectuée."

            echo
            echo "$MSG_CACHE_CANCELLED"
            echo
            echo "$MSG_NO_CHANGE"
        fi

    else

        dmp_status_good \
            "Cache APT — AUCUN NETTOYAGE NÉCESSAIRE" \
            "Aucun fichier du cache APT ne peut actuellement être supprimé automatiquement."

        echo
        echo "$MSG_CACHE_CHECKED"
        echo "$MSG_CACHE_REMOVED_AUTOMATICALLY"
        echo
        echo "$MSG_NO_CACHE_CLEANUP"
    fi

else

    dmp_status_good \
        "Cache APT — VIDE" \
        "Le cache APT ne contient actuellement aucun élément nécessitant un nettoyage."

    echo
    echo "$MSG_CACHE_NO_CLEAN_REQUIRED"
fi

    echo
    echo "=============================================="
    echo " $MSG_MAINTENANCE_DONE"
    echo "=============================================="
    echo
}
