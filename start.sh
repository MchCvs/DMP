#!/bin/bash
echo "🚀 Démarrage DMP..."
cd /home/thierry/DMP-FINAL/web/server
python3 dmp_web_server.py &
sleep 2
echo "✅ Serveur lancé sur http://127.0.0.1:8765/"
echo "📖 Ouvre le navigateur pour commencer!"
