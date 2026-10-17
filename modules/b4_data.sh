#!/usr/bin/env bash

set -u

root_mount="$(
    findmnt -no SOURCE,FSTYPE,SIZE,USED,AVAIL,USE%,TARGET / 2>/dev/null || true
)"

disks="$(
    lsblk -dn -o NAME,MODEL,SIZE,TYPE 2>/dev/null || true
)"

root_device="$(
    findmnt -no SOURCE / 2>/dev/null || true
)"

disk_name="$(
    basename "$root_device" 2>/dev/null |
    sed 's/[0-9]*$//' |
    sed 's/p$//' || true
)"

smartctl_path=""

if [ -x /usr/sbin/smartctl ]; then
    smartctl_path="/usr/sbin/smartctl"
elif command -v smartctl >/dev/null 2>&1; then
    smartctl_path="$(command -v smartctl)"
fi

smart_available="false"
smart_access="DENIED"
smart_health="Information non disponible"
smart_temperature="Information non disponible"
smart_life="Information non disponible"
smart_errors="Information non disponible"
smart_writes="Information non disponible"
smart_reads="Information non disponible"

if [ -n "$smartctl_path" ] && [ -n "$disk_name" ]; then
    smart_available="true"

    smart_prefix=""

    if sudo -n "$smartctl_path" -H "/dev/$disk_name" >/dev/null 2>&1; then
        smart_prefix="sudo -n"
    elif "$smartctl_path" -H "/dev/$disk_name" >/dev/null 2>&1; then
        smart_prefix=""
    fi

    if [ "$smart_prefix" = "sudo -n" ]; then
        smart_access="GRANTED"

        smart_health="$(
            sudo -n "$smartctl_path" -H "/dev/$disk_name" 2>/dev/null |
            awk -F': ' '/SMART overall-health self-assessment test result:/ {
                print $2
                exit
            }'
        )"

    elif [ -z "$smart_prefix" ] && "$smartctl_path" -H "/dev/$disk_name" >/dev/null 2>&1; then
        smart_access="GRANTED"

        smart_health="$(
            "$smartctl_path" -H "/dev/$disk_name" 2>/dev/null |
            awk -F': ' '/SMART overall-health self-assessment test result:/ {
                print $2
                exit
            }'
        )"
    fi

    [ -n "$smart_health" ] || smart_health="Information non disponible"

    smart_attributes="$(
        if [ "$smart_prefix" = "sudo -n" ]; then
            sudo -n "$smartctl_path" -A "/dev/$disk_name" 2>/dev/null || true
        else
            "$smartctl_path" -A "/dev/$disk_name" 2>/dev/null || true
        fi
    )"

    smart_temperature="$(
        printf '%s\n' "$smart_attributes" |
        awk '/Temperature_Celsius/ {
            print $10
            exit
        }'
    )"

    smart_life="$(
        printf '%s\n' "$smart_attributes" |
        awk '/SSD_Life_Left/ {
            print $10
            exit
        }'
    )"

    smart_errors="$(
        printf '%s\n' "$smart_attributes" |
        awk '
            /Reported_Uncorrect/ || /SATA_CRC_Error_Count/ || /CRC_Error_Count/ {
                if ($10 != 0) {
                    errors++
                }
            }
            END {
                print errors + 0
            }
        '
    )"

    smart_writes="$(
        printf '%s\n' "$smart_attributes" |
        awk '/Lifetime_Writes_GiB/ {
            print $10
            exit
        }'
    )"

    smart_reads="$(
        printf '%s\n' "$smart_attributes" |
        awk '/Lifetime_Reads_GiB/ {
            print $10
            exit
        }'
    )"

    [ -n "$smart_temperature" ] || smart_temperature="Information non disponible"
    [ -n "$smart_life" ] || smart_life="Information non disponible"
    [ -n "$smart_errors" ] || smart_errors="Information non disponible"
    [ -n "$smart_writes" ] || smart_writes="Information non disponible"
    [ -n "$smart_reads" ] || smart_reads="Information non disponible"
fi

fstrim_enabled="$(
    systemctl is-enabled fstrim.timer 2>/dev/null || true
)"

fstrim_active="$(
    systemctl is-active fstrim.timer 2>/dev/null || true
)"

[ -n "$root_mount" ] || root_mount="Information non disponible"
[ -n "$disks" ] || disks="Information non disponible"
[ -n "$disk_name" ] || disk_name="Information non disponible"
[ -n "$fstrim_enabled" ] || fstrim_enabled="Information non disponible"
[ -n "$fstrim_active" ] || fstrim_active="Information non disponible"

python3 -     "$root_mount"     "$disks"     "$disk_name"     "$smart_available"     "$smart_access"     "$smart_health"     "$smart_temperature"     "$smart_life"     "$smart_errors"     "$smart_writes"     "$smart_reads"     "$fstrim_enabled"     "$fstrim_active" <<'JSON_DATA'
import json
import sys

(
    root_mount,
    disks,
    disk_name,
    smart_available,
    smart_access,
    smart_health,
    smart_temperature,
    smart_life,
    smart_errors,
    smart_writes,
    smart_reads,
    fstrim_enabled,
    fstrim_active
) = sys.argv[1:]

result = {
    "module": "B4",
    "element": "disque_systeme",
    "collected": True,
    "root_mount": root_mount,
    "disks": disks,
    "disk_name": disk_name,
    "smart_available": smart_available == "true",
    "smart_access": smart_access,
    "smart_health": smart_health,
    "smart_temperature": smart_temperature,
    "smart_life": smart_life,
    "smart_errors": smart_errors,
    "smart_writes": smart_writes,
    "smart_reads": smart_reads,
    "fstrim_enabled": fstrim_enabled,
    "fstrim_active": fstrim_active
}

print(json.dumps(result, ensure_ascii=False, indent=2))
JSON_DATA
