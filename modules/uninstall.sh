#!/bin/bash

# ==================================================
# DMP - Désinstallateur
# Debian Maintenance Professional
# Version 1.7.0
# ==================================================

set -e

INSTALL_DIR="/opt/dmp"
LINK="/usr/local/bin/dmp"

echo "Suppression du lanceur graphique..."

rm -f /usr/share/applications/dmp.desktop


echo "=============================================="
echo " Désinstallation Debian Maintenance Professional"
echo "=============================================="
echo

if [ "$EUID" -ne 0 ]
then
    echo "Veuillez lancer la désinstallation avec sudo."
    exit 1
fi

echo "Suppression de l'installation DMP..."

if [ -d "$INSTALL_DIR" ]
then
    rm -rf "$INSTALL_DIR"
    echo "✅ Dossier supprimé : $INSTALL_DIR"
else
    echo "ℹ️ Dossier DMP absent."
fi

echo

if [ -f "$LINK" ]
then
    rm -f "$LINK"
    echo "✅ Commande supprimée : dmp"
else
    echo "ℹ️ Lanceur système absent."
fi

echo
echo "=============================================="
echo " Désinstallation terminée ✅"
echo "=============================================="
