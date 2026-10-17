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

elements=""

if [ -n "$latest_report" ] && [ -f "$latest_report" ]; then
    elements="Système|CPU|Mémoire|Stockage|Espace disque|SSD / TRIM|Paquets|Mises à jour"
fi

if [ -z "$elements" ]; then
    elements="Information indisponible"
fi

measures="Information indisponible"
results="Information indisponible"

if [ -n "$latest_report" ] && [ -f "$latest_report" ]; then

    measures="Machine et version Debian|Modèle du processeur|Mémoire et échange|Disques et partitions|Espace disque du système|État du service TRIM|État des paquets|État des mises à jour"

    system_result=$(awk '
        /^SYSTEME$/ { section=1; next }
        /^CPU$/ { section=0 }
        section && /^Machine :/ { machine=$0 }
        section && /^Debian GNU\/Linux/ { debian=$0 }
        section && /^Noyau :/ { kernel=$0 }
        section && /^Architecture :/ { arch=$0 }
        END {
            sub(/^Machine :[[:space:]]*/, "", machine)
            sub(/^Debian GNU\/Linux[[:space:]]*/, "Debian GNU/Linux ", debian)
            sub(/^Noyau :[[:space:]]*/, "", kernel)
            sub(/^Architecture :[[:space:]]*/, "", arch)
            printf "%s — %s — noyau %s — %s", machine, debian, kernel, arch
        }
    ' "$latest_report")

    cpu_model=$(awk '
        /^CPU$/ { section=1; next }
        /^MEMOIRE$/ { section=0 }
        section && /Nom de modèle/ {
            sub(/^[^:]*:[[:space:]]*/, "")
            print
            exit
        }
    ' "$latest_report")

    read -r cpu_user1 cpu_nice1 cpu_system1 cpu_idle1 cpu_iowait1 cpu_irq1 cpu_softirq1 cpu_steal1 < <(
        awk '/^cpu / {print $2, $3, $4, $5, $6, $7, $8, $9; exit}' /proc/stat
    )

    sleep 1

    read -r cpu_user2 cpu_nice2 cpu_system2 cpu_idle2 cpu_iowait2 cpu_irq2 cpu_softirq2 cpu_steal2 < <(
        awk '/^cpu / {print $2, $3, $4, $5, $6, $7, $8, $9; exit}' /proc/stat
    )

    cpu_total1=$((cpu_user1 + cpu_nice1 + cpu_system1 + cpu_idle1 + cpu_iowait1 + cpu_irq1 + cpu_softirq1 + cpu_steal1))
    cpu_total2=$((cpu_user2 + cpu_nice2 + cpu_system2 + cpu_idle2 + cpu_iowait2 + cpu_irq2 + cpu_softirq2 + cpu_steal2))

    cpu_idle_total1=$((cpu_idle1 + cpu_iowait1))
    cpu_idle_total2=$((cpu_idle2 + cpu_iowait2))

    cpu_total_delta=$((cpu_total2 - cpu_total1))
    cpu_idle_delta=$((cpu_idle_total2 - cpu_idle_total1))

    if [ "$cpu_total_delta" -gt 0 ]; then
        cpu_usage=$(( (100 * (cpu_total_delta - cpu_idle_delta)) / cpu_total_delta ))
    else
        cpu_usage=""
    fi

    if [ -n "$cpu_model" ] && [ -n "$cpu_usage" ]; then
        cpu_result="$cpu_model — utilisation actuelle : ${cpu_usage}%"
    elif [ -n "$cpu_model" ]; then
        cpu_result="$cpu_model — utilisation actuelle : Information indisponible"
    else
        cpu_result="Information indisponible"
    fi

    memory_result=$(awk '
        /^MEMOIRE$/ { section=1; next }
        /^STOCKAGE$/ { section=0 }
        section && /^Mem:/ { mem=$0 }
        section && /^Échange:/ { swap=$0 }
        END {
            if (mem != "" && swap != "")
                printf "%s — %s", mem, swap
            else
                print "Information indisponible"
        }
    ' "$latest_report")

    storage_result=$(awk '
        /^STOCKAGE$/ { section=1; next }
        /^ESPACE DISQUE$/ { section=0 }
        section && (/^sda / || /^sdb / || /^sdc /) {
            line=$0
            sub(/^[[:space:]]*/, "", line)
            if (storage != "") storage=storage "; "
            storage=storage line
            found=1
        }
        END {
            if (found)
                print storage
            else
                print "Information indisponible"
        }
    ' "$latest_report")

    disk_result=$(awk '
        /^ESPACE DISQUE$/ { section=1; next }
        /^SSD \/ TRIM$/ { section=0 }
        section && /^\/dev\// { print; exit }
    ' "$latest_report")

    trim_result=$(awk '
        /^SSD \/ TRIM$/ { section=1; next }
        /^PAQUETS$/ { section=0 }
        section && /Active:/ { print; active=1 }
        END {
            if (!active)
                print "Information indisponible"
        }
    ' "$latest_report" | sed 's/^[[:space:]]*//')

    packages_result=$(awk '
        /^PAQUETS$/ { section=1; next }
        /^MISES A JOUR$/ { section=0 }
        section && /^Paquets cassés/ { print; found=1 }
        END {
            if (!found)
                print "Information indisponible"
        }
    ' "$latest_report")

    updates_result=$(awk '
        /^MISES A JOUR$/ { section=1; next }
        /^FIN DU RAPPORT$/ { section=0 }
        section && NF && $0 !~ /^-+$/ {
            line=$0
            sub(/^[[:space:]]*/, "", line)
            print line
            found=1
        }
        END {
            if (!found)
                print "Information indisponible"
        }
    ' "$latest_report")

    results=$(printf '%s|%s|%s|%s|%s|%s|%s|%s' \
        "$system_result" \
        "$cpu_result" \
        "$memory_result" \
        "$storage_result" \
        "$disk_result" \
        "$trim_result" \
        "$packages_result" \
        "$updates_result")
fi

python3 - "$history_count" "$latest_report" "$elements" "$measures" "$results" <<'PYJSON'
import json
import sys

history_count = int(sys.argv[1])
latest_report = sys.argv[2]

def split_values(value):
    if not value:
        return []
    return value.split("|")

elements = split_values(sys.argv[3])
measures = split_values(sys.argv[4])
results = split_values(sys.argv[5])

data = {
    "collected": bool(latest_report),
    "history_count": history_count,
    "latest_report": (
        latest_report
        if latest_report
        else "Information indisponible"
    ),
    "elements": elements,
    "measures": measures,
    "results": results
}

print(json.dumps(data, ensure_ascii=False, indent=2))
PYJSON
