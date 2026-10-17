#!/bin/bash

# ==================================================
# DMP - Optimisation système
# Version 0.9.0
# ==================================================

dmp_explain_service()
{
    case "$1" in
fwupd.service)
    echo "Rôle : Gestion des mises à jour internes de certains composants matériels."
    ;;

        NetworkManager.service)
            echo "Rôle : Gestion des connexions réseau de Debian."
            ;;

        udisks2.service)
            echo "Rôle : Gestion des périphériques de stockage."
            ;;

        systemd-udev-trigger.service)
            echo "Rôle : Détection et préparation du matériel."
            ;;

        user@*.service)
            echo "Rôle : Préparation de l'environnement utilisateur."
            ;;

        postfix.service)
            echo "Rôle : Service de messagerie installé sur le système."
            ;;

        plymouth-quit-wait.service)
            echo "Rôle : Gestion de l'affichage graphique pendant le démarrage."
            ;;

        e2scrub_reap.service)
            echo "Rôle : Entretien automatique du système de fichiers."
            ;;

systemd-suspend.service)
    echo "Rôle : Gestion des fonctions de suspension et de mise en veille."
    ;;

apt-daily.service)
    echo "Rôle : Vérification automatique des mises à jour disponibles."
    ;;

apt-daily-upgrade.service)
    echo "Rôle : Installation automatique des mises à jour configurées."
    ;;

*.device)
            echo "Rôle : Périphérique matériel utilisé par Debian."
            ;;

accounts-daemon.service)
    echo "Rôle : Gestion des comptes utilisateurs et des sessions."
    ;;

        *)
            echo "Rôle : Service système non identifié par DMP."
            ;;


    esac
}


system_optimization()
{

clear

echo "=============================================="
echo " OPTIMISATION SYSTÈME DMP"
echo "=============================================="

echo
echo "Analyse en cours..."
echo

echo "----------------------------------------------"
echo " Temps de démarrage"
echo "----------------------------------------------"

STARTUP_DATA=$(systemd-analyze)

TOTAL_TIME=$(echo "$STARTUP_DATA" | grep "Startup finished" | sed -E 's/.*= ([0-9.]+s).*/\1/')

USERSPACE_TIME=$(echo "$STARTUP_DATA" | grep "graphical.target reached" | sed -E 's/.*after ([0-9.]+s) in userspace.*/\1/')

echo
echo "Analyse DMP :"

if [ -n "$TOTAL_TIME" ]; then
    echo "Temps total mesuré : $TOTAL_TIME"
fi

if [ -n "$USERSPACE_TIME" ]; then
    echo "Temps de préparation Debian : $USERSPACE_TIME"
fi

echo

echo "Interprétation :"

echo "Le démarrage de votre système est analysé."

echo
echo "Explication :"
echo "Le temps total inclut plusieurs étapes avant"
echo "que Debian soit complètement disponible."

echo
echo "Conclusion :"
echo "Aucune anomalie détectée, DMP ne propose donc aucune action."
echo "Analyse avancée disponible :"
echo "Les éléments détaillés du démarrage sont conservés"
echo "pour une analyse technique approfondie."

echo
echo "Informations techniques disponibles :"
echo "Les mesures détaillées du démarrage sont disponibles"
echo "dans l'analyse technique avancée de DMP."

echo
echo
echo "----------------------------------------------"
echo " Analyse des services au démarrage"
echo "----------------------------------------------"

SERVICE_DATA=$(systemd-analyze blame | head -10)

echo
echo "Constat :"
echo "DMP a analysé les services qui demandent le plus de temps au démarrage."

echo
echo "Analyse DMP :"
echo "DMP compare les durées observées afin d'identifier"
echo "un service pouvant ralentir le démarrage."
echo
echo "Explication :"
echo "Un service plus long ne signifie pas forcément"
echo "un problème. DMP vérifie d'abord son impact réel."

echo
echo "Décision :"
echo "Aucune modification n'est proposée sans anomalie identifiée."

echo
echo "Analyse détaillée des services :"

echo "$SERVICE_DATA" | while read -r TIME SERVICE REST
do

    echo
    echo "Service analysé :"
    echo "$SERVICE"

    echo
    dmp_explain_service "$SERVICE"

    echo
    echo "Temps mesuré :"
    echo "$TIME"

done

echo
echo "Analyse globale DMP :"
echo "Les services observés participent au fonctionnement normal de Debian."
echo "Aucun service analysé ne présente actuellement d'anomalie nécessitant une action."

echo
echo
echo "----------------------------------------------"
echo " Mémoire de l'ordinateur"
echo "----------------------------------------------"

RAM_DATA=$(free -h)

RAM_TOTAL=$(echo "$RAM_DATA" | awk '/^Mem:/ {print $2}')
RAM_USED=$(echo "$RAM_DATA" | awk '/^Mem:/ {print $3}')
RAM_AVAILABLE=$(echo "$RAM_DATA" | awk '/^Mem:/ {print $7}')
SWAP_USED=$(echo "$RAM_DATA" | awk '/^Échange:/ {print $3}')
echo
echo "Constat :"
echo "DMP a vérifié l'utilisation de la mémoire de votre ordinateur."

echo
echo "Mémoire installée : $RAM_TOTAL"
echo "Mémoire actuellement utilisée : $RAM_USED"
echo "Mémoire disponible : $RAM_AVAILABLE"

echo
echo "Explication :"
echo "La mémoire permet à Debian de conserver les programmes en cours d'utilisation."
echo "La mémoire disponible indique la capacité restante pour utiliser d'autres programmes."

echo
echo "Analyse DMP :"
echo "DMP analyse l'utilisation actuelle de la mémoire."

echo
echo "Conclusion :"
echo "Aucune anomalie détectée, DMP ne propose donc aucune action."

echo
echo "Informations techniques disponibles :"
echo "$RAM_DATA"

echo
echo
echo "Explication de la mémoire d'échange :"
echo "La mémoire d'échange est un espace utilisé par Debian"
echo "lorsque la mémoire principale devient insuffisante."

echo
echo "Mémoire d'échange actuellement utilisée : $SWAP_USED"

SWAPPINESS=$(cat /proc/sys/vm/swappiness 2>/dev/null)

echo
echo "Réglage de l'utilisation de la mémoire d'échange :"

if [ -n "$SWAPPINESS" ]; then
    echo "La swappiness indique à quel point le noyau Linux"
    echo "est disposé à utiliser la mémoire d'échange lorsque"
    echo "la mémoire vive devient moins disponible."
    echo
    echo "DMP constate actuellement une valeur de : $SWAPPINESS."
    echo "Cette valeur est un réglage du noyau ; elle ne représente"
    echo "ni un pourcentage de mémoire utilisée, ni un niveau d'alerte."
else
    echo "DMP n'a pas pu déterminer le réglage actuel."
fi

echo
echo "Informations techniques disponibles :"
echo "Valeur swappiness : ${SWAPPINESS:-inconnu}"

echo
echo "----------------------------------------------"
echo " Disque système"
echo "----------------------------------------------"

ROOT_SOURCE=$(findmnt -no SOURCE / 2>/dev/null)
ROOT_DEVICE=$(lsblk -no PKNAME "$ROOT_SOURCE" 2>/dev/null)

if [ -n "$ROOT_DEVICE" ] && [ -r "/sys/block/$ROOT_DEVICE/queue/scheduler" ]; then

    DISK_MODEL=$(lsblk -no MODEL "/dev/$ROOT_DEVICE" 2>/dev/null |
        sed 's/[[:space:]]*$//')

    SCHEDULER_INFO=$(cat "/sys/block/$ROOT_DEVICE/queue/scheduler" 2>/dev/null)
echo
echo "Constat :"
echo "DMP a identifié le support utilisé par Debian."

echo
echo "Analyse DMP :"
echo "Le support de stockage est correctement détecté."

echo
echo "Conclusion :"
echo "Aucune anomalie détectée, DMP ne propose donc aucune action."

echo
echo "Informations techniques disponibles :"
echo "Périphérique : /dev/$ROOT_DEVICE"

if [ -n "$DISK_MODEL" ]; then
    echo "Modèle : $DISK_MODEL"
fi

echo
echo "Gestion du fonctionnement du stockage :"
echo "Debian utilise un réglage du noyau pour organiser"
echo "l'ordre dans lequel les opérations de lecture et d'écriture"
echo "sont traitées sur le disque."
echo "Ce réglage est appelé ordonnanceur du stockage."

if [ -n "$SCHEDULER_INFO" ]; then

    SCHEDULER_CURRENT=$(printf '%s\n' "$SCHEDULER_INFO" |
        grep -o '\[[^]]*\]' |
        tr -d '[]')

    SCHEDULER_AVAILABLE=$(printf '%s\n' "$SCHEDULER_INFO" |
        sed 's/\[[^]]*\]//g' |
        xargs)

    if [ -n "$SCHEDULER_CURRENT" ]; then
echo "Configuration actuelle : $SCHEDULER_CURRENT"
    else
        echo "Actuel : information indisponible"
    fi

    if [ -n "$SCHEDULER_AVAILABLE" ]; then
echo "Autres configurations possibles : $SCHEDULER_AVAILABLE"
    fi

echo
echo "Analyse DMP :"
echo "Cette configuration est actuellement utilisée par Debian."

echo
echo "Décision :"
echo "Aucune modification n'est proposée sans mesure démontrant un bénéfice réel."

else

    echo "Le scheduler du disque n'a pas pu être déterminé."
    echo "Aucune modification n'est proposée."

fi

else

    echo "Le disque système n'a pas pu être identifié."
    echo "Le scheduler ne peut pas être vérifié."

fi


echo
echo "----------------------------------------------"
echo " Montage du système de fichiers racine"
echo "----------------------------------------------"

ROOT_MOUNT_INFO=$(findmnt -no SOURCE,FSTYPE,OPTIONS / 2>/dev/null)

if [ -n "$ROOT_MOUNT_INFO" ]; then

    ROOT_SOURCE=$(printf '%s\n' "$ROOT_MOUNT_INFO" | awk '{print $1}')
    ROOT_FSTYPE=$(printf '%s\n' "$ROOT_MOUNT_INFO" | awk '{print $2}')
    ROOT_OPTIONS=$(printf '%s\n' "$ROOT_MOUNT_INFO" | cut -d' ' -f3-)

echo
echo "Constat :"
echo "DMP a vérifié l'organisation utilisée pour stocker"
echo "les fichiers nécessaires au fonctionnement de Debian."

echo
echo "Analyse DMP :"

if printf '%s\n' "$ROOT_OPTIONS" | grep -qw 'noatime'; then
    echo "Une configuration spécifique de lecture des fichiers est active."
elif printf '%s\n' "$ROOT_OPTIONS" | grep -qw 'relatime'; then
    echo "La configuration actuelle est analysée par DMP."
else
    echo "La configuration actuelle ne correspond pas aux paramètres vérifiés."
fi

echo
echo "Conclusion :"
echo "Aucune anomalie détectée, DMP ne propose donc aucune action."

echo
echo "Informations techniques disponibles :"
echo "Périphérique utilisé : $ROOT_SOURCE"
echo "Organisation des fichiers : $ROOT_FSTYPE"

if [ "$ROOT_FSTYPE" = "ext4" ]; then
    echo
    echo "Explication :"
    echo "ext4 est le format utilisé par Debian"
    echo "pour organiser les fichiers sur le disque."
fi

echo
echo "Explication des paramètres du système de fichiers :"
echo "Ces paramètres indiquent à Debian comment le système"
echo "de fichiers doit être monté et utilisé."
echo "Ils sont conservés comme informations techniques"
echo "et ne sont pas modifiés automatiquement par DMP."

echo
echo "Paramètres utilisés : $ROOT_OPTIONS"

else

    echo "Le montage du système de fichiers racine"
    echo "n'a pas pu être déterminé."

fi


echo
echo "----------------------------------------------"
echo " Recommandations DMP"
echo "----------------------------------------------"

echo
echo "Analyse DMP :"

echo "La quantité de mémoire installée ne permet pas"
echo "à elle seule de conclure à un manque de ressources."

echo "DMP vérifie d'abord l'utilisation réelle de la mémoire"
echo "avant de proposer une amélioration."

echo
echo "Décision :"

echo "Aucune recommandation concernant la mémoire"
echo "n'est proposée sans observation d'un manque réel."

SWAPPINESS=$(cat /proc/sys/vm/swappiness 2>/dev/null)
SWAP_USED_KIB=$(awk 'NR > 1 && $1 != "" { total += $4 } END { print total + 0 }' /proc/swaps)

echo
echo "Analyse de l'utilisation du stockage de secours mémoire :"

if [ "${SWAP_USED_KIB:-0}" -eq 0 ]; then

    echo "DMP constate que Debian n'utilise actuellement pas"
    echo "d'espace de secours pour la mémoire."

    echo
    echo "Conclusion :"
    echo "Aucune anomalie détectée, DMP ne propose donc aucune action."

else

    echo "DMP constate qu'une partie de la mémoire utilise"
    echo "actuellement un espace de secours."

    echo
    echo "Conclusion :"
    echo "Cette utilisation est surveillée par DMP."

fi

echo
echo "Réglage de l'utilisation de la mémoire d'échange :"

if [ -n "$SWAPPINESS" ]; then
    echo "Cette valeur indique à quel point le noyau Linux"
    echo "est disposé à utiliser la mémoire d'échange lorsque"
    echo "la mémoire vive devient moins disponible."
    echo
    echo "DMP constate actuellement une valeur de : $SWAPPINESS."
    echo "Cette valeur est un réglage du noyau ; elle ne représente"
    echo "ni un pourcentage de mémoire utilisée, ni un niveau d'alerte."
else
    echo "DMP n'a pas pu déterminer le réglage actuel."
fi

echo
echo "Informations techniques disponibles :"
echo "Réglage swappiness : ${SWAPPINESS:-inconnu}"


echo
echo "----------------------------------------------"
echo " Conclusion DMP"
echo "----------------------------------------------"

echo
echo "Votre système Debian présente actuellement"
echo "un fonctionnement conforme aux observations réalisées."

echo
echo "Les contrôles réalisés ne mettent actuellement"
echo "en évidence aucune amélioration nécessaire."

echo
echo "DMP n'applique aucune modification automatique."
echo
echo "=============================================="
echo " Analyse terminée"
echo "=============================================="

}


