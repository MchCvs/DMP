#!/bin/bash
# Copyright (C) 2026 Thierry CHEVASSUS — GPL-3.0-or-later — voir LICENSE
# Désinstalle DMP : arrête le service, retire l'icône et le lanceur.
DMP_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
bash "$DMP_ROOT/install.sh" --desinstaller
echo "Pour supprimer aussi les fichiers de DMP : rm -rf $DMP_ROOT"
