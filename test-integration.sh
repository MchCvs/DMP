#!/bin/bash
echo "🧪 Tests"
for api in a1 b2 b3 b4; do
  JSON=$(/home/thierry/DMP-FINAL/modules/collecteurs/${api}.sh 2>/dev/null)
  if echo "$JSON" | python3 -m json.tool > /dev/null 2>&1; then
    echo "✅ $api"
  else
    echo "❌ $api"
  fi
done
