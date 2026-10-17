#!/usr/bin/env bash

set -u

echo "===== DMP V2 — COLLECTE MÉMOIRE ====="
date --iso-8601=seconds

echo
echo "===== MÉMOIRE SYSTÈME ====="

mem_total_kb=$(awk '/^MemTotal:/ {print $2}' /proc/meminfo)
mem_available_kb=$(awk '/^MemAvailable:/ {print $2}' /proc/meminfo)
swap_total_kb=$(awk '/^SwapTotal:/ {print $2}' /proc/meminfo)
swap_free_kb=$(awk '/^SwapFree:/ {print $2}' /proc/meminfo)

swap_used_kb=$((swap_total_kb - swap_free_kb))

printf 'mem_total_kb=%s\n' "$mem_total_kb"
printf 'mem_available_kb=%s\n' "$mem_available_kb"
printf 'swap_total_kb=%s\n' "$swap_total_kb"
printf 'swap_used_kb=%s\n' "$swap_used_kb"

echo
echo "===== FIREFOX ====="

firefox_pid=$(pgrep -xo firefox-esr || true)

if [[ -z "$firefox_pid" ]]; then
    echo "firefox_present=0"
    exit 0
fi

echo "firefox_present=1"
echo "firefox_pid=$firefox_pid"

firefox_total_kb=$(
    ps -eo pid,ppid,rss,comm --no-headers |
    awk -v parent="$firefox_pid" '
        $1 == parent || $2 == parent {
            sum += $3
        }
        END {
            print sum
        }
    '
)

printf 'firefox_total_kb=%s\n' "$firefox_total_kb"

echo
echo "===== CONTRIBUTEUR PRINCIPAL ====="

ps -eo pid,ppid,rss,comm,args --no-headers |
awk -v parent="$firefox_pid" '
    $1 == parent || $2 == parent {
        if ($3 > max) {
            max = $3
            pid = $1
            comm = $4
        }
    }
    END {
        if (pid != "") {
            printf "contributor_pid=%s\n", pid
            printf "contributor_name=%s\n", comm
            printf "contributor_rss_kb=%s\n", max
        }
    }
'
