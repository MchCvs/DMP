#!/bin/bash
# Copyright Thierry CHEVASSUS — PolyForm Noncommercial 1.0.0 — voir LICENSE
DMP_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "🚀 DMP Setup"

echo "1. Vérifier Python"
python3 --version || { echo "❌ Erreur"; exit 1; }

echo "2. Vérifier collecteurs"
COUNT=$(ls $DMP_ROOT/modules/collecteurs/*.sh 2>/dev/null | wc -l)
echo "   $COUNT collecteurs trouvés"

echo "3. Démarrer serveur"
cd $DMP_ROOT/web/server
python3 dmp_simple.py > /tmp/dmp.log 2>&1 &
DMP_PID=$!
sleep 2

echo "4. Tester"
if curl -s http://127.0.0.1:8765/api/a1 > /dev/null 2>&1; then
  echo "✅ OK"
else
  echo "❌ Timeout"
  kill $DMP_PID
  exit 1
fi

echo ""
echo "✅ DMP OPÉRATIONNEL"
echo "📍 http://127.0.0.1:8765/"
echo "PID: $DMP_PID"
