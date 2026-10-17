#!/usr/bin/env bash
set -u

uptime_data="$(uptime 2>/dev/null || true)"
load_data="$(cat /proc/loadavg 2>/dev/null || true)"
kernel="$(uname -r 2>/dev/null || true)"
systemd="$(systemctl is-system-running 2>/dev/null || true)"
cpu_cores="$(nproc 2>/dev/null || true)"

memory_data="$(free -k 2>/dev/null || true)"
disk_data="$(df -k / 2>/dev/null || true)"

[ -n "$uptime_data" ] || uptime_data="Information non disponible"
[ -n "$load_data" ] || load_data="Information non disponible"
[ -n "$kernel" ] || kernel="Information non disponible"
[ -n "$systemd" ] || systemd="Information non disponible"
[ -n "$cpu_cores" ] || cpu_cores="Information non disponible"

python3 - "$uptime_data" "$load_data" "$kernel" "$systemd" "$cpu_cores" "$memory_data" "$disk_data" <<'PY'
import json
import sys

uptime_data = sys.argv[1]
load_data = sys.argv[2]
kernel = sys.argv[3]
systemd = sys.argv[4]
cpu_cores = sys.argv[5]
memory_data = sys.argv[6]
disk_data = sys.argv[7]

memory_total_kb = None
memory_available_kb = None
swap_total_kb = None
swap_used_kb = None

for line in memory_data.splitlines():
    fields = line.split()
    if not fields:
        continue

    if fields[0] == "Mem:" and len(fields) >= 7:
        memory_total_kb = int(fields[1])
        memory_available_kb = int(fields[6])

    elif fields[0] in ("Swap:", "Échange:") and len(fields) >= 4:
        swap_total_kb = int(fields[1])
        swap_used_kb = int(fields[2])

    elif fields[0] == "Swap:" and len(fields) >= 4:
        swap_total_kb = int(fields[1])
        swap_used_kb = int(fields[2])

disk_total_kb = None
disk_used_kb = None
disk_available_kb = None
disk_use_percent = None

for line in disk_data.splitlines()[1:]:
    fields = line.split()
    if len(fields) >= 6:
        disk_total_kb = int(fields[1])
        disk_used_kb = int(fields[2])
        disk_available_kb = int(fields[3])
        disk_use_percent = fields[4]
        break

print(json.dumps({
    "module": "B1",
    "element": "etat_general",
    "collected": True,
    "uptime": uptime_data.strip(),
    "load": load_data.strip(),
    "kernel": kernel.strip(),
    "systemd": systemd.strip(),
    "cpu_cores": cpu_cores.strip(),
    "memory_total_kb": memory_total_kb,
    "memory_available_kb": memory_available_kb,
    "swap_total_kb": swap_total_kb,
    "swap_used_kb": swap_used_kb,
    "disk_total_kb": disk_total_kb,
    "disk_used_kb": disk_used_kb,
    "disk_available_kb": disk_available_kb,
    "disk_use_percent": disk_use_percent
}, ensure_ascii=False, indent=2))
PY
