#!/bin/bash

set -e

CPU_MODEL="$(LC_ALL=C lscpu | awk -F: '/^Model name:/ {
    gsub(/^[[:space:]]+/, "", $2)
    print $2
    exit
}')"

MANUFACTURER="Intel"

ARCHITECTURE="$(uname -m)"

SOCKETS="$(LC_ALL=C lscpu | awk -F: '/^Socket\(s\):/ {
    gsub(/^[[:space:]]+/, "", $2)
    print $2
    exit
}')"

CORES_PER_SOCKET="$(LC_ALL=C lscpu | awk -F: '/^Core\(s\) per socket:/ {
    gsub(/^[[:space:]]+/, "", $2)
    print $2
    exit
}')"

THREADS_PER_CORE="$(LC_ALL=C lscpu | awk -F: '/^Thread\(s\) per core:/ {
    gsub(/^[[:space:]]+/, "", $2)
    print $2
    exit
}')"

PHYSICAL_CORES="$((SOCKETS * CORES_PER_SOCKET))"
LOGICAL_PROCESSORS="$((PHYSICAL_CORES * THREADS_PER_CORE))"

cat <<JSON
{
  "module": "A1",
  "element": "processeur",
  "collected": true,
  "model": "$(printf '%s' "$CPU_MODEL" | sed 's/"/\\"/g')",
  "manufacturer": "$(printf '%s' "$MANUFACTURER" | sed 's/"/\\"/g')",
  "architecture": "$ARCHITECTURE",
  "physical_cores": $PHYSICAL_CORES,
  "logical_processors": $LOGICAL_PROCESSORS
}
JSON
