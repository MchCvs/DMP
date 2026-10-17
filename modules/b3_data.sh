#!/usr/bin/env bash

set -u

STATUS_SCRIPT="${DMP_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}/memory_status.sh"

status_output="$("$STATUS_SCRIPT" 2>/dev/null || true)"

python3 - "$status_output" <<'PY'
import json
import sys

raw = sys.argv[1]

data = {}

for line in raw.splitlines():
    if "=" not in line:
        continue

    key, value = line.split("=", 1)
    data[key] = value

def integer(key):
    try:
        return int(data[key])
    except (KeyError, ValueError):
        return None

result = {
    "module": "B3",
    "element": "memoire",
    "collected": bool(data),
    "mem_total_kb": integer("mem_total_kb"),
    "mem_available_kb": integer("mem_available_kb"),
    "swap_total_kb": integer("swap_total_kb"),
    "swap_used_kb": integer("swap_used_kb"),
    "firefox_present": integer("firefox_present"),
    "firefox_pid": integer("firefox_pid"),
    "firefox_total_kb": integer("firefox_total_kb"),
    "contributor_pid": integer("contributor_pid"),
    "contributor_name": data.get("contributor_name"),
    "contributor_rss_kb": integer("contributor_rss_kb"),
    "trend": data.get("trend"),
    "recovery": data.get("recovery"),
    "pressure": data.get("pressure"),
    "diagnosis": data.get("diagnosis"),
    "action": data.get("action"),
}

if not data:
    result["collected"] = False
    result["error"] = "Collecte mémoire indisponible"

print(json.dumps(result, ensure_ascii=False, indent=2))
PY
