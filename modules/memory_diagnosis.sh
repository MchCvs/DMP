#!/usr/bin/env bash

set -u

TREND_SCRIPT="${DMP_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}/memory_trend.sh"
RECOVERY_SCRIPT="${DMP_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}/memory_recovery.sh"
PRESSURE_SCRIPT="${DMP_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}/memory_pressure.sh"

TREND=$("$TREND_SCRIPT" | awk -F= '/^trend=/{print $2}')
RECOVERY=$("$RECOVERY_SCRIPT" | awk -F= '/^recovery=/{print $2}')
PRESSURE=$("$PRESSURE_SCRIPT" | awk -F= '/^pressure=/{print $2}')

echo "trend=$TREND"
echo "recovery=$RECOVERY"
echo "pressure=$PRESSURE"

if [[ "$TREND" == "INSUFFICIENT_DATA" ||
      "$RECOVERY" == "INSUFFICIENT_DATA" ||
      "$PRESSURE" == "INSUFFICIENT_DATA" ]]; then

    echo "diagnosis=IMPOSSIBLE"
    exit 0
fi

if [[ "$TREND" == "INCREASING" &&
      "$RECOVERY" == "NO_RECOVERY" &&
      "$PRESSURE" == "INCREASING" ]]; then

    echo "diagnosis=PROBLEM"
    exit 0
fi

if [[ "$PRESSURE" == "WATCH" ]]; then

    echo "diagnosis=WATCH"
    exit 0
fi

if [[ "$TREND" == "INCREASING" &&
      "$RECOVERY" == "NO_RECOVERY" ]]; then

    echo "diagnosis=WATCH"
    exit 0
fi

if [[ "$TREND" == "STABLE" ||
      "$TREND" == "DECREASING" ]]; then

    echo "diagnosis=NORMAL"
    exit 0
fi

if [[ "$TREND" == "INCREASING" &&
      "$RECOVERY" == "PARTIAL_RECOVERY" ]]; then

    echo "diagnosis=NORMAL"
    exit 0
fi

echo "diagnosis=IMPOSSIBLE"
