#!/bin/bash

# ==================================================
# DMP - Module système
# Version 0.2.0
# ==================================================

system_info()
{
    echo
    echo "=============================================="
    echo " DIAGNOSTIC SYSTÈME"
    echo "=============================================="
    echo

    echo "Machine : $(hostname)"

    echo "OS : $(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')"

    echo "Noyau : $(uname -r)"

    echo "Architecture : $(uname -m)"

    echo

    echo "----------------------------------------------"
    echo " CPU"
    echo "----------------------------------------------"

    lscpu | grep "Model name" | sed 's/Model name *: //'

    echo "Cœurs : $(nproc)"

    echo

    echo "----------------------------------------------"
    echo " MÉMOIRE"
    echo "----------------------------------------------"

    free -h

    echo

    echo "----------------------------------------------"
    echo " STOCKAGE"
    echo "----------------------------------------------"

    lsblk -o NAME,MODEL,SIZE,TYPE,FSTYPE,MOUNTPOINTS

    echo

    echo "----------------------------------------------"
    echo " ENVIRONNEMENT GRAPHIQUE"
    echo "----------------------------------------------"

    echo "Bureau : ${XDG_CURRENT_DESKTOP:-inconnu}"

    echo "Session : ${XDG_SESSION_TYPE:-inconnue}"

    echo

    echo "Diagnostic terminé."

}
