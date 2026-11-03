# Lit une clé dans langues/<langue>.json, repli sur le français.
# Usage : tr_cle "b6.un.titre_t" t=3
tr_cle() {
  local cle="$1"; shift
  local L="${DMP_LANG:-fr}"
  [ -f "$(dirname "${BASH_SOURCE[0]}")/langues/$L.json" ] || L=fr
  local txt
  txt=$(python3 -c "import json,sys; d=json.load(open(sys.argv[1],encoding='utf-8')); f=json.load(open(sys.argv[2],encoding='utf-8')); print(d.get(sys.argv[3]) or f.get(sys.argv[3]) or sys.argv[3])" "$(dirname "${BASH_SOURCE[0]}")/langues/$L.json" "$(dirname "${BASH_SOURCE[0]}")/langues/fr.json" "$cle")
  for kv in "$@"; do txt="${txt//\{${kv%%=*}\}/${kv#*=}}"; done
  printf '%s' "$txt"
}
