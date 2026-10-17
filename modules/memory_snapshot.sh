#!/usr/bin/env bash

set -u

BASE_DIR="${DMP_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
SNAPSHOT_DIR="$BASE_DIR/memory_snapshots"

mkdir -p "$SNAPSHOT_DIR"

TIMESTAMP=$(date --iso-8601=seconds)
FILE_TIMESTAMP=$(date '+%Y%m%d_%H%M%S')

mem_total_kb=$(awk '/^MemTotal:/ {print $2}' /proc/meminfo)
mem_available_kb=$(awk '/^MemAvailable:/ {print $2}' /proc/meminfo)
swap_total_kb=$(awk '/^SwapTotal:/ {print $2}' /proc/meminfo)
swap_free_kb=$(awk '/^SwapFree:/ {print $2}' /proc/meminfo)

swap_used_kb=$((swap_total_kb - swap_free_kb))

firefox_pid=$(pgrep -xo firefox-esr || true)

firefox_total_kb=0
contributor_pid=""
contributor_name=""
contributor_rss_kb=0

if [[ -n "$firefox_pid" ]]; then

    firefox_total_kb=$(
        ps -eo pid,ppid,rss,comm --no-headers |
        awk -v parent="$firefox_pid" '
            $1 == parent || $2 == parent {
                sum += $3
            }
            END {
                print sum + 0
            }
        '
    )

    read -r contributor_pid contributor_name contributor_rss_kb < <(
        ps -eo pid,ppid,rss,comm --no-headers |
        awk -v parent="$firefox_pid" '
            $1 == parent || $2 == parent {
                if ($3 > max) {
                    max = $3
                    pid = $1
                    comm = $4
                }
            }
            END {
                printf "%s %s %s\n", pid, comm, max + 0
            }
        '
    )
fi

OUTPUT="$SNAPSHOT_DIR/memory_${FILE_TIMESTAMP}.csv"

if [[ ! -f "$SNAPSHOT_DIR/history.csv" ]]; then
    echo "timestamp,mem_total_kb,mem_available_kb,swap_used_kb,firefox_total_kb,contributor_pid,contributor_name,contributor_rss_kb" \
        > "$SNAPSHOT_DIR/history.csv"
fi

echo "$TIMESTAMP,$mem_total_kb,$mem_available_kb,$swap_used_kb,$firefox_total_kb,$contributor_pid,$contributor_name,$contributor_rss_kb" \
    >> "$SNAPSHOT_DIR/history.csv"

echo "Snapshot enregistré : $OUTPUT"

printf '%s\n' \
    "$TIMESTAMP,$mem_total_kb,$mem_available_kb,$swap_used_kb,$firefox_total_kb,$contributor_pid,$contributor_name,$contributor_rss_kb" \
    > "$OUTPUT"
