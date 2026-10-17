#!/usr/bin/env bash
set -u

top_data="$(top -bn1 2>/dev/null || true)"
process_data="$(ps -eo comm=,%cpu= --sort=-%cpu 2>/dev/null || true)"
temperature_data="$(sensors 2>/dev/null || true)"
cpu_cores="$(nproc 2>/dev/null || true)"

[ -n "$top_data" ] || top_data="Information non disponible"
[ -n "$process_data" ] || process_data="Information non disponible"
[ -n "$temperature_data" ] || temperature_data="Information non disponible"
[ -n "$cpu_cores" ] || cpu_cores="Information non disponible"

python3 - "$top_data" "$process_data" "$temperature_data" "$cpu_cores" <<'PY'
import json
import re
import sys

top_data = sys.argv[1]
process_data = sys.argv[2]
temperature_data = sys.argv[3]
cpu_cores = sys.argv[4]

cpu_user = None
cpu_system = None
cpu_idle = None

for line in top_data.splitlines():
    if "%Cpu" in line:
        match = re.search(
            r'(\d+(?:[.,]\d+)?)\s+ut.*?'
            r'(\d+(?:[.,]\d+)?)\s+sy.*?'
            r'(\d+(?:[.,]\d+)?)\s+id',
            line
        )

        if match:
            cpu_user = float(match.group(1).replace(",", "."))
            cpu_system = float(match.group(2).replace(",", "."))
            cpu_idle = float(match.group(3).replace(",", "."))
        break

cpu_used = None

if cpu_user is not None and cpu_system is not None:
    cpu_used = cpu_user + cpu_system

top_process_name = None
top_process_cpu = None

for line in process_data.splitlines():
    fields = line.split(None, 1)

    if len(fields) != 2:
        continue

    name = fields[0]

    if name in {"ps", "top"}:
        continue

    try:
        value = float(fields[1].replace(",", "."))
    except ValueError:
        continue

    top_process_name = name
    top_process_cpu = value
    break

package_temperature_c = None

for line in temperature_data.splitlines():
    if "Package id 0:" in line:
        match = re.search(r'\+?(\d+(?:[.,]\d+)?)°C', line)

        if match:
            package_temperature_c = float(
                match.group(1).replace(",", ".")
            )

        break

print(json.dumps({
    "module": "B2",
    "element": "activite_processeur",
    "collected": True,
    "cpu_used_percent": round(cpu_used, 1) if cpu_used is not None else None,
    "cpu_user_percent": cpu_user,
    "cpu_system_percent": cpu_system,
    "cpu_idle_percent": cpu_idle,
    "top_process_name": top_process_name,
    "top_process_cpu_percent": top_process_cpu,
    "package_temperature_c": package_temperature_c,
    "cpu_cores": cpu_cores
}, ensure_ascii=False, indent=2))
PY
