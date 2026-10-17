#!/usr/bin/env bash

set -u

chassis_type=""
hardware_model=""
battery=""

chassis_type="$(
    cat /sys/class/dmi/id/chassis_type 2>/dev/null || true
)"

hardware_model="$(
    cat /sys/class/dmi/id/product_name 2>/dev/null || true
)"

if find /sys/class/power_supply -mindepth 1 -maxdepth 1 -type d 2>/dev/null | grep -q .; then
    battery="détectée"
else
    battery="non détectée"
fi

case "$chassis_type" in
    3|4|5|6|7|15|16|23)
        computer_type="ordinateur de bureau"
        ;;
    8|9|10|11|12|14|18|21|30|31|32)
        computer_type="ordinateur portable"
        ;;
    *)
        computer_type="type d'ordinateur non déterminé"
        ;;
esac

python3 - "$computer_type" "$hardware_model" "$battery" <<'PY'
import json
import sys

computer_type = sys.argv[1]
hardware_model = sys.argv[2]
battery = sys.argv[3]

print(json.dumps({
    "module": "A9",
    "element": "alimentation",
    "collected": True,
    "computer_type": computer_type,
    "hardware_model": hardware_model or "Information non disponible",
    "battery": battery
}, ensure_ascii=False, indent=2))
PY
