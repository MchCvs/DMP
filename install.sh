#!/bin/bash
# Copyright Thierry CHEVASSUS — PolyForm Noncommercial 1.0.0 — voir LICENSE
# Installation permanente de DMP : démarrage automatique à l'ouverture de session.
# Sans droits administrateur. Désinstaller : bash install.sh --desinstaller
set -e

DMP_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UNIT_DIR="$HOME/.config/systemd/user"
APP_DIR="$HOME/.local/share/applications"
ICON_DIR="$HOME/.local/share/icons/hicolor/512x512/apps"

if [ "$1" = "--desinstaller" ]; then
  systemctl --user disable --now dmp.service 2>/dev/null || true
  rm -f "$UNIT_DIR/dmp.service" "$APP_DIR/dmp.desktop" "$ICON_DIR/dmp.png"
  systemctl --user daemon-reload
  echo "✅ DMP désinstallé (le dossier $DMP_ROOT est conservé)"
  exit 0
fi

command -v python3 >/dev/null || { echo "❌ python3 est requis : sudo apt install python3"; exit 1; }

pkill -f "dmp_simple.py" 2>/dev/null || true
mkdir -p "$UNIT_DIR" "$APP_DIR" "$ICON_DIR"
cp "$DMP_ROOT/web/assets/dmp.png" "$ICON_DIR/dmp.png"

cat > "$UNIT_DIR/dmp.service" <<EOF
[Unit]
Description=DMP - Debian Maintenance Professionnel

[Service]
ExecStart=/usr/bin/python3 $DMP_ROOT/web/server/dmp_simple.py
Restart=on-failure

[Install]
WantedBy=default.target
EOF

cat > "$APP_DIR/dmp.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=DMP
Comment=Maintenance Debian expliquée simplement
Exec=xdg-open http://127.0.0.1:8765/
Icon=dmp
Categories=System;
EOF

systemctl --user daemon-reload
systemctl --user enable --now dmp.service
sleep 2

if curl -s -o /dev/null http://127.0.0.1:8765/; then
  echo "✅ DMP est installé et démarre automatiquement à chaque session."
  echo "📍 http://127.0.0.1:8765/  (ou menu des applications → DMP)"
else
  echo "❌ Le service ne répond pas : systemctl --user status dmp.service"
  exit 1
fi
