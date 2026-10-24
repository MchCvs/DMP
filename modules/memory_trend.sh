#!/usr/bin/env bash
DMP_DATA="${DMP_DATA:-${XDG_DATA_HOME:-$HOME/.local/share}/dmp}"

set -u

HISTORY="${DMP_DATA}/memory_snapshots/history.csv"

STABILITY_PERCENT=5

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

PREVIOUS=${VALUES[$((COUNT - 2))]}
CURRENT=${VALUES[$((COUNT - 1))]}

if (( PREVIOUS <= 0 )); then
    echo "INSUFFICIENT_DATA"
    exit 0
fi

DIFF=$((CURRENT - PREVIOUS))

ABS_DIFF=${DIFF#-}

PERCENT=$(
    awk -v diff="$ABS_DIFF" -v previous="$PREVIOUS" '
        BEGIN {
            printf "%.2f", (diff / previous) * 100
        }
    '
)

if awk -v p="$PERCENT" -v limit="$STABILITY_PERCENT" \
    'BEGIN { exit !(p < limit) }'
then
    TREND="STABLE"
elif (( CURRENT > PREVIOUS )); then
    TREND="INCREASING"
else
    TREND="DECREASING"
fi

echo "previous_firefox_kb=$PREVIOUS"
echo "current_firefox_kb=$CURRENT"
echo "variation_percent=$PERCENT"
echo "trend=$TREND"
