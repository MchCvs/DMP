#!/usr/bin/env bash

set -u

DIAGNOSIS_SCRIPT="${DMP_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}/memory_diagnosis.sh"
TREND_SCRIPT="${DMP_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}/memory_trend.sh"
RECOVERY_SCRIPT="${DMP_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}/memory_recovery.sh"
PRESSURE_SCRIPT="${DMP_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}/memory_pressure.sh"

DIAGNOSIS=$("$DIAGNOSIS_SCRIPT" | awk -F= '/^diagnosis=/{print $2}')
TREND=$("$TREND_SCRIPT" | awk -F= '/^trend=/{print $2}')
RECOVERY=$("$RECOVERY_SCRIPT" | awk -F= '/^recovery=/{print $2}')
PRESSURE=$("$PRESSURE_SCRIPT" | awk -F= '/^pressure=/{print $2}')

echo "diagnosis=$DIAGNOSIS"
echo "trend=$TREND"
echo "recovery=$RECOVERY"
echo "pressure=$PRESSURE"

if [[ "$DIAGNOSIS" == "IMPOSSIBLE" ]]; then
    echo "action=COLLECT_MORE_DATA"
    exit 0
fi

if [[ "$DIAGNOSIS" == "PROBLEM" ]]; then
    echo "action=CORRECTIVE"
    exit 0
fi

if [[ "$DIAGNOSIS" == "NORMAL" ]]; then
    echo "action=NONE"
    exit 0
fi

if [[ "$DIAGNOSIS" == "WATCH" ]]; then

    if [[ "$PRESSURE" == "WATCH" ]]; then
        echo "action=MONITOR"
        exit 0
    fi

    if [[ "$TREND" == "DECREASING" ]]; then
        echo "action=NONE"
        exit 0
    fi

    if [[ "$TREND" == "STABLE" ]]; then
        echo "action=MONITOR"
        exit 0
    fi

    if [[ "$TREND" == "INCREASING" ]]; then
        echo "action=MONITOR"
        exit 0
    fi
fi

echo "action=COLLECT_MORE_DATA"
