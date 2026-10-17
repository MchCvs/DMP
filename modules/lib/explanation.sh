#!/bin/bash

# ==================================================
# DMP - Moteur d'explication utilisateur
# Version 1.0.0
# ==================================================

explain_debian()
{
    echo

    dmp_ui_print_message "DMP a identifié le système Debian utilisé par votre ordinateur."
    echo

    dmp_ui_print_message "Cette information permet à DMP d'adapter ses explications à votre environnement."
    echo
}

explain_hardware()
{
    dmp_ui_print_message "DMP a identifié les caractéristiques principales de votre ordinateur."
    echo

    dmp_ui_print_message "Ces informations permettent de mieux comprendre les capacités de votre machine."
    echo
}

explain_processor()
{
    dmp_ui_print_message "Le processeur est l'élément de l'ordinateur qui exécute les instructions des programmes."
    echo

    dmp_ui_print_message "DMP présente ici le modèle détecté afin de vous permettre de mieux comprendre les capacités de votre ordinateur."
    echo
}

explain_cores()
{
    dmp_ui_print_message "Les cœurs sont les unités de travail du processeur."
    echo

    dmp_ui_print_message "Plusieurs cœurs permettent au processeur de travailler sur plusieurs tâches en même temps."
    echo
}

explain_memory()
{
    dmp_ui_print_message "La mémoire vive permet à Debian d'utiliser les programmes actuellement ouverts."
    echo
}

explain_storage()
{
    dmp_ui_print_message "Les disques conservent Debian, vos fichiers et les données enregistrées sur votre ordinateur."
    echo

    dmp_ui_print_message "DMP présente chaque disque selon son rôle dans votre système."
    echo
}

explain_storage_role()
{
    local TYPE="$1"
    local FSTYPE="$2"
    local MOUNT="$3"

    if [ "$TYPE" = "disk" ]; then

        dmp_ui_print_message "Rôle : disque de stockage"

    elif [ "$FSTYPE" = "vfat" ]; then

        dmp_ui_print_message "Usage : démarrage de l'ordinateur"

    elif [ "$FSTYPE" = "ext4" ] && [ "$MOUNT" = "/" ]; then

        dmp_ui_print_message "Usage : système Debian principal"

    elif [ "$FSTYPE" = "ext4" ]; then

        dmp_ui_print_message "Usage : données Linux"

    elif [ "$FSTYPE" = "swap" ]; then

        dmp_ui_print_message "Usage : mémoire virtuelle"

    elif [ "$FSTYPE" = "ntfs" ]; then

        dmp_ui_print_message "Usage : espace de fichiers partagé"

    fi

    echo
}

explain_discovery_end()
{
    dmp_ui_print_message "La découverte de votre machine Debian est terminée."
    echo

    dmp_ui_print_message "DMP a maintenant identifié les éléments principaux de votre système."
    echo

    dmp_ui_print_message "Vous pouvez choisir la suite de votre accompagnement."
    echo
}

explain_performance()
{
    echo

    dmp_ui_print_message "DMP observe actuellement plusieurs éléments de fonctionnement de votre ordinateur."
    echo

    dmp_ui_print_message "Cette vérification analyse :"
    dmp_ui_print_list_item "l'utilisation du processeur"
    dmp_ui_print_list_item "l'utilisation de la mémoire"
    dmp_ui_print_list_item "les programmes actifs"
    dmp_ui_print_list_item "la température du processeur"
    dmp_ui_print_list_item "la mémoire virtuelle"
    echo
}

explain_memory_usage()
{
    dmp_ui_print_message "La mémoire vive est utilisée par Debian et les programmes actuellement ouverts."
    echo
}

explain_temperature()
{
    dmp_ui_print_message "La température permet de vérifier que le processeur fonctionne dans une plage thermique adaptée."
    echo
}

explain_swap()
{
    dmp_ui_print_message "La mémoire virtuelle permet à Debian de compléter temporairement la mémoire vive lorsque cela devient nécessaire."
    echo
}
