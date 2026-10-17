#!/bin/bash

set -u
export LC_ALL=C

REPORT_DIR="${DMP_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}/reports"
HISTORY_FILE="$REPORT_DIR/history.csv"

latest_report=""

if [ -d "$REPORT_DIR" ]; then
    latest_report=$(find "$REPORT_DIR" -maxdepth 1 -type f \
        -name 'rapport_DMP_*.txt' \
        -printf '%T@ %p\n' 2>/dev/null |
        sort -n |
        tail -1 |
        cut -d' ' -f2-)
fi

history_count=0

if [ -f "$HISTORY_FILE" ]; then
    history_count=$(awk 'NR > 1 && NF { count++ } END { print count+0 }' "$HISTORY_FILE")
fi

python3 - "$latest_report" "$history_count" <<'PY'
import json
import os
import sys

latest_report = sys.argv[1]
history_count = int(sys.argv[2])

technical = []

def add(name, method, result):
    technical.append({
        "name": name,
        "method": method,
        "result": result if result else "Information indisponible"
    })

if latest_report and os.path.isfile(latest_report):

    with open(latest_report, "r", encoding="utf-8", errors="replace") as f:
        report = f.read()

    def section(name, next_name):
        start_marker = name + "\n"
        start = report.find(start_marker)

        if start == -1:
            return ""

        start += len(start_marker)

        if next_name:
            end = report.find(next_name + "\n", start)
            if end == -1:
                end = len(report)
        else:
            end = len(report)

        return report[start:end].strip()

    system = section("SYSTEME", "CPU")
    cpu = section("CPU", "MEMOIRE")
    memory = section("MEMOIRE", "STOCKAGE")
    storage = section("STOCKAGE", "ESPACE DISQUE")
    disk = section("ESPACE DISQUE", "SSD / TRIM")
    trim = section("SSD / TRIM", "PAQUETS")
    packages = section("PAQUETS", "MISES A JOUR")
    updates = section("MISES A JOUR", "FIN DU RAPPORT")

    add(
        "Système",
        "hostname ; grep PRETTY_NAME /etc/os-release ; uname -r ; uname -m",
        system
    )

    add(
        "CPU",
        'lscpu | grep -i "Nom de modèle"',
        cpu
    )

    add(
        "Mémoire",
        "free -h",
        memory
    )

    add(
        "Stockage",
        "lsblk -o NAME,MODEL,SIZE,FSTYPE,MOUNTPOINTS",
        storage
    )

    add(
        "Espace disque",
        "df -h /",
        disk
    )

    add(
        "SSD / TRIM",
        "systemctl status fstrim.timer --no-pager",
        trim
    )

    add(
        "Paquets",
        "dpkg --audit",
        packages
    )

    add(
        "Mises à jour",
        'apt list --upgradable 2>/dev/null | grep -v "Listing"',
        updates
    )

else:

    for name in [
        "Système",
        "CPU",
        "Mémoire",
        "Stockage",
        "Espace disque",
        "SSD / TRIM",
        "Paquets",
        "Mises à jour"
    ]:
        add(
            name,
            "Information indisponible",
            "Information indisponible"
        )

data = {
    "collected": bool(latest_report),
    "history_count": history_count,
    "latest_report": (
        latest_report
        if latest_report
        else "Information indisponible"
    ),
    "technical": technical
}

print(json.dumps(data, ensure_ascii=False, indent=2))
PY
