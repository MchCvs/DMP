#!/usr/bin/env bash

set -u

HISTORY="${DMP_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}/memory_snapshots/history.csv"

RECOVERY_LIMIT=5
PARTIAL_LIMIT=20

if [[ ! -f "$HISTORY" ]]; then
    echo "INSUFFICIENT_DATA"
    exit 0
fi

mapfile -t VALUES < <(
    tail -n +2 "$HISTORY" |
    awk -F',' '
        $5 != "" {
            print $5
        }
    '
)

COUNT=${#VALUES[@]}

if (( COUNT < 2 )); then
    echo "INSUFFICIENT_DATA"
    exit 0
fi

BASELINE=${VALUES[0]}
CURRENT=${VALUES[$((COUNT - 1))]}

if (( BASELINE <= 0 )); then
    echo "INSUFFICIENT_DATA"
    exit 0
fi

DIFF=$((CURRENT - BASELINE))
ABS_DIFF=${DIFF#-}

PERCENT=$(
    awk -v diff="$ABS_DIFF" -v baseline="$BASELINE" '
        BEGIN {
            printf "%.2f", (diff / baseline) * 100
        }
    '
)

if awk -v p="$PERCENT" -v limit="$RECOVERY_LIMIT" \
    'BEGIN { exit !(p <= limit) }'
then
    STATE="RECOVERED"

elif awk -v p="$PERCENT" -v limit="$PARTIAL_LIMIT" \
    'BEGIN { exit !(p <= limit) }'
then
    STATE="PARTIAL_RECOVERY"

else
    STATE="NO_RECOVERY"
fi

echo "baseline_firefox_kb=$BASELINE"
echo "current_firefox_kb=$CURRENT"
echo "distance_percent=$PERCENT"
echo "recovery=$STATE"
