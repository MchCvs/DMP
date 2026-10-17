#!/bin/bash
DMP_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "🚀 Démarrage DMP..."
cd $DMP_ROOT/web/server
python3 dmp_simple.py &
sleep 2
echo "✅ Serveur lancé sur http://127.0.0.1:8765/"
echo "📖 Ouvre le navigateur pour commencer!"
