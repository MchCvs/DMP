#!/bin/bash
# Copyright Thierry CHEVASSUS — PolyForm Noncommercial 1.0.0 — voir LICENSE
# Désinstalle DMP : arrête le service, retire l'icône et le lanceur.
DMP_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
bash "$DMP_ROOT/install.sh" --desinstaller
echo "Pour supprimer aussi les fichiers de DMP : rm -rf $DMP_ROOT"
