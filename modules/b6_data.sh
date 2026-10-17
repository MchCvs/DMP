#!/usr/bin/env bash
set -u

systemd="$(systemctl is-system-running 2>/dev/null || true)"
failed="$(systemctl --failed --no-legend 2>/dev/null || true)"
running="$(systemctl list-units --type=service --state=running --no-legend 2>/dev/null || true)"
enabled="$(systemctl list-unit-files --type=service --state=enabled --no-pager 2>/dev/null || true)"

[ -n "$systemd" ] || systemd="Information non disponible"
[ -n "$failed" ] || failed="Aucun service en échec détecté"
[ -n "$running" ] || running="Information non disponible"
[ -n "$enabled" ] || enabled="Information non disponible"

python3 - "$systemd" "$failed" "$running" "$enabled" <<'PY'
import json
import sys

print(json.dumps({
    "module": "B6",
    "element": "services",
    "collected": True,
    "systemd": sys.argv[1],
    "failed": sys.argv[2],
    "running": sys.argv[3],
    "enabled": sys.argv[4]
}, ensure_ascii=False, indent=2))
PY
