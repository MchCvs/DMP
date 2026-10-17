#!/usr/bin/env bash
set -u

updates="Information non disponible"
update_count=0
updates_available=false

if command -v apt >/dev/null 2>&1; then
    raw_updates="$(LC_ALL=C apt list --upgradable 2>/dev/null | tail -n +2 || true)"

    if [ -n "$raw_updates" ]; then
        update_count="$(printf '%s\n' "$raw_updates" | grep -c . || true)"
        updates_available=true
        updates="$raw_updates"
    else
        update_count=0
        updates_available=false
        updates="Aucune mise à jour disponible"
    fi
fi

python3 - "$updates_available" "$update_count" "$updates" <<'PY'
import json
import sys

updates_available = sys.argv[1].lower() == "true"
update_count = int(sys.argv[2])
updates = sys.argv[3]

print(json.dumps({
    "module": "C1",
    "element": "mises_a_jour",
    "collected": True,
    "updates_available": updates_available,
    "update_count": update_count,
    "updates": updates
}, ensure_ascii=False, indent=2))
PY
