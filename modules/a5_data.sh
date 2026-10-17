#!/usr/bin/env bash

set -u

gpu_line="$(
    lspci -nn |
    grep -Ei 'VGA compatible controller|3D controller|Display controller' |
    head -n 1
)"

if [ -z "$gpu_line" ]; then
    printf '{\n'
    printf '  "module": "A5",\n'
    printf '  "element": "carte graphique",\n'
    printf '  "collected": false,\n'
    printf '  "error": "Aucune carte graphique détectée."\n'
    printf '}\n'
    exit 0
fi

gpu_info="${gpu_line#*: }"

manufacturer=""
model=""

case "$gpu_info" in
    Intel\ Corporation\ *)
        manufacturer="Intel"
        model="${gpu_info#Intel Corporation }"
        ;;
    AMD\ *)
        manufacturer="AMD"
        model="${gpu_info#AMD }"
        ;;
    NVIDIA\ Corporation\ *)
        manufacturer="NVIDIA"
        model="${gpu_info#NVIDIA Corporation }"
        ;;
    *)
        manufacturer="${gpu_info%% *}"
        model="${gpu_info#"$manufacturer"}"
        model="${model# }"
        ;;
esac

driver="$(
    lspci -nnk |
    grep -A3 -Ei 'VGA compatible controller|3D controller|Display controller' |
    grep 'Kernel driver in use:' |
    head -n 1 |
    sed 's/.*Kernel driver in use: //'
)"

integrated="false"

if printf '%s\n' "$gpu_line" | grep -qi 'Intel Corporation'; then
    integrated="true"
fi

printf '{\n'
printf '  "module": "A5",\n'
printf '  "element": "carte graphique",\n'
printf '  "collected": true,\n'
printf '  "manufacturer": "%s",\n' "$manufacturer"
printf '  "model": "%s",\n' "$model"
printf '  "driver": "%s",\n' "$driver"
printf '  "integrated": %s,\n' "$integrated"
printf '  "integration": "carte mère"\n'
printf '}\n'
