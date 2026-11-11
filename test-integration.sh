#!/bin/bash
# Contrôle de non-régression DMP : collecteurs, niveaux, pages, syntaxe
DMP_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PORT="${DMP_PORT:-8765}"
ERR=0
echo "🧪 Syntaxe des scripts"
for f in "$DMP_ROOT"/modules/collecteurs/*.sh "$DMP_ROOT"/modules/i18n/*.sh "$DMP_ROOT"/modules/i18n/*/*.sh; do
  bash -n "$f" 2>/dev/null || { echo "❌ syntaxe : $f"; ERR=1; }
done
echo "🧪 Pages"
for p in menu tableau-bord verification-sante aide a1 a2 a3 a4 a5 a6 a7 a8 a9 b1 b2 b3 b4 b5 b6 b7 b8 b9 c1 c2 c3 c4 d1 d2 d3 e1-analyse e2-resume e3-score e4-rapport e5-graphiques f1-1 f1-2 f1-3 f2-extensions f3-f4; do
  code=$(curl -s -o /dev/null -w "%{http_code}" "http://localhost:$PORT/$p.html")
  [ "$code" = 200 ] || { echo "❌ page $p : $code"; ERR=1; }
done
echo "🧪 Niveaux des collecteurs"
for k in a1 a2 a3 a4 a5 a6 a7 a8 a9 b1 b2 b3 b4 b5 b6 b7 b8 b9 c1 c2 c3 c4 d1 d2 d3 f2_1 f3; do
  n=$(curl -s "http://localhost:$PORT/api/$k" | jq -r '.niveau' 2>/dev/null)
  case "$n" in 0|1|2|3) ;; *) echo "❌ niveau $k : '$n'"; ERR=1;; esac
done
echo "🧪 Cohérence de la version"
V=$(cat "$DMP_ROOT/modules/VERSION" 2>/dev/null)
R=$(grep -o 'dmp_[0-9][0-9.]*-[0-9]*_all\.deb' "$DMP_ROOT/README.md" | head -1 | sed 's/dmp_\(.*\)-[0-9]*_all\.deb/\1/')
[ -n "$R" ] && [ "$V" = "$R" ] || { echo "❌ README ($R) et VERSION ($V) diffèrent"; ERR=1; }
[ "$ERR" = 0 ] && echo "✅ Tous les contrôles sont passés" || echo "⚠️ Des contrôles ont échoué"
exit $ERR
