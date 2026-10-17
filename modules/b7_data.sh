#!/usr/bin/env bash
set -u

process_count="$(ps -e --no-headers 2>/dev/null | wc -l)"
top_cpu="$(ps -eo pid=,comm=,%cpu=,%mem= --sort=-%cpu 2>/dev/null | awk '$2 != "ps" && $2 != "python3" && $2 != "curl"' | head -n 10 || true)"
top_memory="$(ps -eo pid=,comm=,%cpu=,%mem= --sort=-%mem 2>/dev/null | awk '$2 != "ps" && $2 != "python3" && $2 != "curl"' | head -n 10 || true)"

process_list="$(ps -eo pid=,comm=,%cpu=,%mem=,rss= --sort=-%mem 2>/dev/null | awk '$2 != "ps" && $2 != "python3" && $2 != "curl"' || true)"
firefox_process_count="$(ps -eo comm= 2>/dev/null | awk '
$1 == "firefox-esr" ||
$1 == "Isolated" ||
$1 == "WebExtensions" ||
$1 == "Privileged" ||
$1 == "Socket" ||
$1 == "RDD" ||
$1 == "Utility" ||
$1 == "Web" {
    count++
}
END {
    print count+0
}')"

firefox_memory_kb="$(ps -eo comm=,rss= 2>/dev/null | awk '
$1 == "firefox-esr" ||
$1 == "Isolated" ||
$1 == "WebExtensions" ||
$1 == "Privileged" ||
$1 == "Socket" ||
$1 == "RDD" ||
$1 == "Utility" ||
$1 == "Web" {
    total += $2
}
END {
    print total+0
}')"

memory="$(free -h 2>/dev/null || true)"

[ -n "$process_count" ] || process_count="Information non disponible"
[ -n "$top_cpu" ] || top_cpu="Information non disponible"
[ -n "$top_memory" ] || top_memory="Information non disponible"
[ -n "$memory" ] || memory="Information non disponible"

python3 - "$process_count" "$top_cpu" "$top_memory" "$process_list" "$memory" "$firefox_process_count" "$firefox_memory_kb" <<'PY'
import json, sys

print(json.dumps({
    "module": "B7",
    "element": "programmes_en_cours",
    "collected": True,
    "process_count": sys.argv[1],
    "top_cpu": sys.argv[2],
    "top_memory": sys.argv[3],
    "process_list": sys.argv[4],
    "memory": sys.argv[5],
    "firefox_process_count": sys.argv[6],
    "firefox_memory_kb": sys.argv[7]
}, ensure_ascii=False, indent=2))
PY
