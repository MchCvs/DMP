#!/usr/bin/env bash
lsblk_parse() {
    local line="$1" re='([A-Z][A-Z_]*)="([^"]*)"' key val
    NAME="" SIZE="" TYPE="" FSTYPE="" PARTTYPENAME="" MOUNTPOINTS="" PKNAME="" MODEL="" TRAN=""
    while [[ $line =~ $re ]]; do
        key=${BASH_REMATCH[1]}
        val=${BASH_REMATCH[2]}
        case "$key" in
            NAME|SIZE|TYPE|FSTYPE|PARTTYPENAME|MOUNTPOINTS|PKNAME|MODEL|TRAN)
                printf -v "$key" '%s' "$val" ;;
        esac
        line=${line#*"${BASH_REMATCH[0]}"}
    done
}

set -u

system_source="$(findmnt -no SOURCE / 2>/dev/null || true)"
system_disk="$(
    lsblk -no PKNAME "$system_source" 2>/dev/null |
    head -n 1
)"

printf '{\n'
printf '  "module": "A3",\n'
printf '  "element": "disques",\n'
printf '  "collected": true,\n'
printf '  "disks": ['

first_disk=1

while IFS= read -r line; do
    lsblk_parse "$line"

    [ "${TYPE:-}" = "disk" ] || continue

    disk_name="$NAME"
    disk_size="$SIZE"
    disk_model="$MODEL"
    disk_transport="$TRAN"

    if [ "$first_disk" -eq 0 ]; then
        printf ','
    fi
    first_disk=0

    printf '\n    {\n'
    printf '      "name": "%s",\n' "$disk_name"
    printf '      "size": "%s",\n' "$disk_size"
    printf '      "model": "%s",\n' "$disk_model"
    printf '      "transport": "%s",\n' "$disk_transport"

    if [ "$disk_name" = "$system_disk" ]; then
        printf '      "system": true,\n'
    else
        printf '      "system": false,\n'
    fi

    printf '      "partitions": ['

    first_partition=1

    while IFS= read -r partition_line; do
        lsblk_parse "$partition_line"

        [ "${TYPE:-}" = "part" ] || continue
        [ "${PKNAME:-}" = "$disk_name" ] || continue

        if [ "$first_partition" -eq 0 ]; then
            printf ','
        fi
        first_partition=0

        printf '\n        {\n'
        printf '          "name": "%s",\n' "$NAME"
        printf '          "size": "%s",\n' "$SIZE"
        printf '          "filesystem": "%s",\n' "${FSTYPE:-}"
        printf '          "mountpoint": "%s"\n' "${MOUNTPOINTS:-}"
        printf '        }'

    done < <(
        lsblk -P -o NAME,PKNAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS
    )

    printf '\n      ]\n'
    printf '    }'

done < <(
    lsblk -P -o NAME,PKNAME,SIZE,TYPE,MODEL,TRAN
)

printf '\n  ]\n'
printf '}\n'
