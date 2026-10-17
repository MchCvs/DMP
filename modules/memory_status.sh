#!/usr/bin/env bash

set -u

BASE="${DMP_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"

COLLECT="$BASE/memory_collect.sh"
TREND="$BASE/memory_trend.sh"
RECOVERY="$BASE/memory_recovery.sh"
PRESSURE="$BASE/memory_pressure.sh"
DIAGNOSIS="$BASE/memory_diagnosis.sh"
ACTION="$BASE/memory_action.sh"

TIMESTAMP=$(date --iso-8601=seconds)

COLLECT_OUTPUT=$("$COLLECT")

MEM_TOTAL=$(awk -F= '/^mem_total_kb=/{print $2}' <<< "$COLLECT_OUTPUT")
MEM_AVAILABLE=$(awk -F= '/^mem_available_kb=/{print $2}' <<< "$COLLECT_OUTPUT")
SWAP_TOTAL=$(awk -F= '/^swap_total_kb=/{print $2}' <<< "$COLLECT_OUTPUT")
SWAP_USED=$(awk -F= '/^swap_used_kb=/{print $2}' <<< "$COLLECT_OUTPUT")

FIREFOX_PRESENT=$(awk -F= '/^firefox_present=/{print $2}' <<< "$COLLECT_OUTPUT")
FIREFOX_PID=$(awk -F= '/^firefox_pid=/{print $2}' <<< "$COLLECT_OUTPUT")
FIREFOX_TOTAL=$(awk -F= '/^firefox_total_kb=/{print $2}' <<< "$COLLECT_OUTPUT")

CONTRIBUTOR_PID=$(awk -F= '/^contributor_pid=/{print $2}' <<< "$COLLECT_OUTPUT")
CONTRIBUTOR_NAME=$(awk -F= '/^contributor_name=/{print $2}' <<< "$COLLECT_OUTPUT")
CONTRIBUTOR_RSS=$(awk -F= '/^contributor_rss_kb=/{print $2}' <<< "$COLLECT_OUTPUT")

TREND_VALUE=$("$TREND" | awk -F= '/^trend=/{print $2}')
RECOVERY_VALUE=$("$RECOVERY" | awk -F= '/^recovery=/{print $2}')
PRESSURE_VALUE=$("$PRESSURE" | awk -F= '/^pressure=/{print $2}')
DIAGNOSIS_VALUE=$("$DIAGNOSIS" | awk -F= '/^diagnosis=/{print $2}')
ACTION_VALUE=$("$ACTION" | awk -F= '/^action=/{print $2}')

cat <<EOF
DMP_MEMORY_STATUS
timestamp=$TIMESTAMP

mem_total_kb=$MEM_TOTAL
mem_available_kb=$MEM_AVAILABLE

swap_total_kb=$SWAP_TOTAL
swap_used_kb=$SWAP_USED

firefox_present=$FIREFOX_PRESENT
firefox_pid=$FIREFOX_PID
firefox_total_kb=$FIREFOX_TOTAL

contributor_pid=$CONTRIBUTOR_PID
contributor_name=$CONTRIBUTOR_NAME
contributor_rss_kb=$CONTRIBUTOR_RSS

trend=$TREND_VALUE
recovery=$RECOVERY_VALUE
pressure=$PRESSURE_VALUE
diagnosis=$DIAGNOSIS_VALUE
action=$ACTION_VALUE
EOF
