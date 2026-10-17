#!/bin/bash

# ==================================================
# DMP - Installateur
# Debian Maintenance Professional
# Version 1.7.0
# ==================================================

set -e

DMP_VERSION=$(cat VERSION)

echo "=============================================="
echo " Installation Debian Maintenance Professional"
echo " Version : $DMP_VERSION"
echo "=============================================="
echo

INSTALL_DIR="/opt/dmp"

echo "Installation dans : $INSTALL_DIR"
echo

if [ "$EUID" -ne 0 ]
then
    echo "Veuillez lancer l'installation avec sudo."
    exit 1
fi


echo "Création du dossier d'installation..."

mkdir -p "$INSTALL_DIR"


echo "Copie des fichiers DMP..."

cp -a \
bin \
config \
lib \
languages \
plugins \
desktop \
icons \
VERSION \
README.md \
CHANGELOG.md \
AUTHORS \
LICENSE \
dmp-check.sh \
"$INSTALL_DIR/"


echo "Création du lanceur système..."

cat > /usr/local/bin/dmp <<EOF
#!/bin/bash
exec "$INSTALL_DIR/bin/dmp" "\$@"
EOF

chmod 755 /usr/local/bin/dmp


echo "Installation de l'icône..."

mkdir -p /usr/share/icons/hicolor/128x128/apps

cp "$INSTALL_DIR/icons/hicolor/128x128/apps/dmp.png" \
/usr/share/icons/hicolor/128x128/apps/


gtk-update-icon-cache \
-f \
/usr/share/icons/hicolor \
2>/dev/null || true


echo "Installation du lanceur graphique..."

cp "$INSTALL_DIR/desktop/dmp.desktop" \
/usr/share/applications/dmp.desktop

chmod 644 /usr/share/applications/dmp.desktop


update-desktop-database \
/usr/share/applications \
2>/dev/null || true


echo
echo "=============================================="
echo " Installation terminée ✅"
echo "=============================================="
echo

echo "Lancement possible avec :"
echo

echo "dmp"

echo
