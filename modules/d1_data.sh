#!/bin/bash
DMP_DATA="${DMP_DATA:-${XDG_DATA_HOME:-$HOME/.local/share}/dmp}"

REPORT_DIR="${REPORT_DIR:-${DMP_DATA}/reports}"
HISTORY_FILE="$REPORT_DIR/history.csv"

if [ ! -f "$HISTORY_FILE" ]; then
    printf '%s\n' \
    '{"collected":false,"error":"Historique indisponible"}'
    exit 0
fi

HISTORY_COUNT=$(awk 'NR > 1 && NF {count++} END {print count+0}' "$HISTORY_FILE")

if [ "$HISTORY_COUNT" -eq 0 ]; then
    printf '%s\n' \
    '{"collected":false,"error":"Aucune observation historique disponible"}'
    exit 0
fi

LAST_LINE=$(awk 'NR > 1 && NF {line=$0} END {print line}' "$HISTORY_FILE")

IFS=';' read -r LAST_DATE LAST_SCORE LAST_TEMP LAST_RAM LAST_DISK LAST_BOOT <<< "$LAST_LINE"

printf '{\n'
printf '  "collected": true,\n'
printf '  "history_count": %s,\n' "$HISTORY_COUNT"
printf '  "last_date": %s,\n' "$(printf '%s' "$LAST_DATE" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')"
printf '  "last_score": %s,\n' "$(printf '%s' "$LAST_SCORE" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')"
printf '  "last_temperature": %s,\n' "$(printf '%s' "$LAST_TEMP" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')"
printf '  "last_ram": %s,\n' "$(printf '%s' "$LAST_RAM" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')"
printf '  "last_disk": %s,\n' "$(printf '%s' "$LAST_DISK" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')"
printf '  "last_boot": %s,\n' "$(printf '%s' "$LAST_BOOT" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')"
printf '  "source": %s\n' "$(printf '%s' "$HISTORY_FILE" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')"
printf '}\n'
