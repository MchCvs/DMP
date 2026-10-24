#!/bin/bash

# ==================================================
# DMP - Nettoyage système
# Version 0.6.0
# ==================================================


# ==================================================
# Mesure cache APT
# ==================================================

dmp_measure_apt_cache()
{
    du -sb /var/cache/apt/archives 2>/dev/null | awk '{print $1}'
}


# ==================================================
# Mesure paquets inutiles
# ==================================================

dmp_measure_unused_packages()
{
    apt-get --dry-run autoremove 2>/dev/null |     grep -c "^Remv"
}


# ==================================================
# Mesure journaux système
# ==================================================

dmp_measure_journal_size()
{
    journalctl --disk-usage 2>/dev/null | awk '{print $7}'
}


# ==================================================
# Mesure miniatures utilisateur
# ==================================================

dmp_measure_thumbnails()
{
    du -sb ~/.cache/thumbnails 2>/dev/null | awk '{print $1}'
}


# ==================================================
# Analyse possibilité nettoyage cache APT
# ==================================================

dmp_can_clean_apt_cache()
{
    apt-get --dry-run autoclean 2>/dev/null |
    grep -q "^Del "
}


# ==================================================
# Analyse utilité réduction journaux
# ==================================================

dmp_can_reduce_journal()
{
    JOURNAL_BYTES=$(journalctl --disk-usage 2>/dev/null |
        awk '{print $7}' |
        numfmt --from=iec 2>/dev/null)

    if [ -z "$JOURNAL_BYTES" ]; then
        return 1
    fi

    # En dessous de 100 Mo, le gain attendu est considéré comme négligeable
    if [ "$JOURNAL_BYTES" -lt 104857600 ]; then
        return 1
    fi

    return 0
}


cleanup_system()
{

clear

echo "=============================================="
echo " NETTOYAGE SYSTÈME"
echo "=============================================="
echo


echo "Espace disque avant :"
df -h /


echo
echo "----------------------------------------------"
echo " Cache APT"
echo "----------------------------------------------"

CACHE_BEFORE=$(dmp_measure_apt_cache)

CACHE_BEFORE_HUMAN=$(numfmt --to=iec --suffix=B "$CACHE_BEFORE" 2>/dev/null || echo "${CACHE_BEFORE} octets")

echo "Cache APT avant : $CACHE_BEFORE_HUMAN"


if dmp_can_clean_apt_cache; then

    echo
    read -r -p "Nettoyer le cache APT ? (o/N) : " REP

    if [[ "$REP" =~ ^[Oo]$ ]]; then

        if sudo apt autoclean; then

            CACHE_AFTER=$(dmp_measure_apt_cache)

            CACHE_AFTER_HUMAN=$(numfmt --to=iec --suffix=B "$CACHE_AFTER" 2>/dev/null || echo "${CACHE_AFTER} octets")

            if [ "$CACHE_BEFORE" -ge "$CACHE_AFTER" ]; then
                CACHE_GAIN=$((CACHE_BEFORE-CACHE_AFTER))
            else
                CACHE_GAIN=0
            fi

            CACHE_GAIN_HUMAN=$(numfmt --to=iec --suffix=B "$CACHE_GAIN" 2>/dev/null || echo "${CACHE_GAIN} octets")

            echo "Cache APT après : $CACHE_AFTER_HUMAN"
            echo "Espace réellement libéré : $CACHE_GAIN_HUMAN"

            if [ "$CACHE_GAIN" -eq 0 ]; then
                echo "Aucun espace disque récupéré."
            fi

        else
            echo "Nettoyage du cache APT : PROBLÈME"
        fi

    else

        echo "Cache APT conservé"

    fi

else

    echo "Aucun nettoyage du cache APT n'est nécessaire."

fi


echo "----------------------------------------------"
echo " Paquets inutiles"
echo "----------------------------------------------"

UNUSED_PACKAGES=$(dmp_measure_unused_packages)

echo "Paquets inutiles détectés : $UNUSED_PACKAGES"

if [ "$UNUSED_PACKAGES" -gt 0 ]; then

    read -r -p "Supprimer les paquets inutiles ? (o/N) : " REP

    if [[ "$REP" =~ ^[Oo]$ ]]; then

        if sudo apt autoremove; then
            dmp_verify_packages "État des paquets après suppression"
        else
            echo "Suppression des paquets inutiles : PROBLÈME"
        fi

    else

        echo "Suppression annulée"

    fi

else

    echo "Aucun paquet inutile détecté."
    echo "Aucune action nécessaire."

fi


echo
echo "----------------------------------------------"
echo " Journaux système"
echo "----------------------------------------------"

JOURNAL_SIZE=$(dmp_measure_journal_size)

echo "Taille actuelle des journaux : $JOURNAL_SIZE"

if dmp_can_reduce_journal; then

    read -r -p "Réduire les journaux à 30 jours ? (o/N) : " REP

    if [[ "$REP" =~ ^[Oo]$ ]]; then

    if sudo journalctl --vacuum-time=30d; then

        JOURNAL_AFTER=$(dmp_measure_journal_size)

        echo "Taille des journaux après nettoyage : $JOURNAL_AFTER"

        echo "Vérification : Journaux système après nettoyage : OK"

    else
        echo "Nettoyage des journaux : PROBLÈME"
    fi

else

    echo "Journaux conservés"

fi

fi


echo
echo "----------------------------------------------"
echo " Miniatures utilisateur"
echo "----------------------------------------------"

THUMB_BEFORE=$(dmp_measure_thumbnails)

echo "Taille des miniatures avant nettoyage : ${THUMB_BEFORE} octets"

if [ "$THUMB_BEFORE" -gt 0 ]; then

    read -r -p "Supprimer les miniatures ? (o/N) : " REP

    if [[ "$REP" =~ ^[Oo]$ ]]; then

        if find "$HOME/.cache/thumbnails" -mindepth 1 -maxdepth 1 -exec rm -rf -- {} + 2>/dev/null; then

            THUMB_AFTER=$(dmp_measure_thumbnails)

            echo "Taille des miniatures après nettoyage : ${THUMB_AFTER} octets"

            echo "Vérification : Miniatures après nettoyage : OK"

        else
            echo "Suppression des miniatures : PROBLÈME"
        fi

    else

        echo "Miniatures conservées"

    fi

else

    echo "Aucune miniature à nettoyer."
    echo "Aucune action nécessaire."

fi


echo
echo "=============================================="
echo " Espace disque après nettoyage"
echo "=============================================="

df -h /


echo
echo "Nettoyage terminé."

}

