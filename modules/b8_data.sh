#!/usr/bin/env bash
set -u

uptime_data="$(uptime -p 2>/dev/null || true)"
startup="$(systemd-analyze 2>/dev/null || true)"
blame="$(systemd-analyze blame 2>/dev/null | head -n 15 || true)"

[ -n "$uptime_data" ] || uptime_data="Information non disponible"
[ -n "$startup" ] || startup="Information non disponible"
[ -n "$blame" ] || blame="Information non disponible"

python3 - "$uptime_data" "$startup" "$blame" <<'PY'
import json, sys

print(json.dumps({
    "module": "B8",
    "element": "demarrage",
    "collected": True,
    "uptime": sys.argv[1],
    "startup": sys.argv[2],
    "blame": sys.argv[3]
}, ensure_ascii=False, indent=2))
PY
