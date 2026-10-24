#!/usr/bin/env bash
DMP_DATA="${DMP_DATA:-${XDG_DATA_HOME:-$HOME/.local/share}/dmp}"

set -u

HISTORY="${DMP_DATA}/memory_snapshots/history.csv"

if [[ ! -f "$HISTORY" ]]; then
    echo "INSUFFICIENT_DATA"
    exit 0
fi

mapfile -t AVAILABLE < <(
    tail -n +2 "$HISTORY" |
    awk -F',' '$3 != "" {print $3}'
)

mapfile -t SWAP < <(
    tail -n +2 "$HISTORY" |
    awk -F',' '$4 != "" {print $4}'
)

COUNT=${#AVAILABLE[@]}

if (( COUNT < 2 )); then
    echo "INSUFFICIENT_DATA"
    exit 0
fi

CURRENT_AVAILABLE=${AVAILABLE[$((COUNT - 1))]}
PREVIOUS_AVAILABLE=${AVAILABLE[$((COUNT - 2))]}

CURRENT_SWAP=${SWAP[$((COUNT - 1))]}
PREVIOUS_SWAP=${SWAP[$((COUNT - 2))]}

echo "current_available_kb=$CURRENT_AVAILABLE"
echo "previous_available_kb=$PREVIOUS_AVAILABLE"
echo "current_swap_used_kb=$CURRENT_SWAP"
echo "previous_swap_used_kb=$PREVIOUS_SWAP"

if (( CURRENT_AVAILABLE < PREVIOUS_AVAILABLE )) &&
   (( CURRENT_SWAP > PREVIOUS_SWAP )); then
    echo "pressure=INCREASING"

elif (( CURRENT_AVAILABLE < PREVIOUS_AVAILABLE )); then
    echo "pressure=WATCH"

else
    echo "pressure=NORMAL"
fi
