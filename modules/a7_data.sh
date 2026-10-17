#!/usr/bin/env bash

set -u

debian_name=""
debian_version=""
debian_codename=""
kernel=""
architecture=""
hostname=""
hardware_vendor=""
hardware_model=""
firmware_version=""
firmware_date=""

if [ -r /etc/os-release ]; then
    . /etc/os-release
    debian_name="${PRETTY_NAME:-}"
    debian_version="${DEBIAN_VERSION_FULL:-${VERSION_ID:-}}"
    debian_codename="${VERSION_CODENAME:-}"
fi

kernel="$(uname -r 2>/dev/null || true)"
architecture="$(uname -m 2>/dev/null || true)"
hostname="$(hostname 2>/dev/null || true)"

hardware_vendor="$(
    cat /sys/class/dmi/id/sys_vendor 2>/dev/null || true
)"

hardware_model="$(
    cat /sys/class/dmi/id/product_name 2>/dev/null || true
)"

firmware_version="$(
    cat /sys/class/dmi/id/bios_version 2>/dev/null || true
)"

firmware_date="$(
    cat /sys/class/dmi/id/bios_date 2>/dev/null || true
)"

[ -n "$debian_name" ] || debian_name="Information non disponible"
[ -n "$debian_version" ] || debian_version="Information non disponible"
[ -n "$debian_codename" ] || debian_codename="Information non disponible"
[ -n "$kernel" ] || kernel="Information non disponible"
[ -n "$architecture" ] || architecture="Information non disponible"
[ -n "$hostname" ] || hostname="Information non disponible"
[ -n "$hardware_vendor" ] || hardware_vendor="Information non disponible"
[ -n "$hardware_model" ] || hardware_model="Information non disponible"
[ -n "$firmware_version" ] || firmware_version="Information non disponible"
[ -n "$firmware_date" ] || firmware_date="Information non disponible"

printf '{\n'
printf '  "module": "A7",\n'
printf '  "element": "systeme_debian",\n'
printf '  "collected": true,\n'
printf '  "debian": "%s",\n' "$debian_name"
printf '  "debian_version": "%s",\n' "$debian_version"
printf '  "debian_codename": "%s",\n' "$debian_codename"
printf '  "kernel": "%s",\n' "$kernel"
printf '  "architecture": "%s",\n' "$architecture"
printf '  "hostname": "%s",\n' "$hostname"
printf '  "hardware_vendor": "%s",\n' "$hardware_vendor"
printf '  "hardware_model": "%s",\n' "$hardware_model"
printf '  "firmware_version": "%s",\n' "$firmware_version"
printf '  "firmware_date": "%s"\n' "$firmware_date"
printf '}\n'
