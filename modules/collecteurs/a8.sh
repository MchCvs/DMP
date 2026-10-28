#!/bin/bash
source "$(dirname "$0")/lib.sh"; NL=$'\n'
I18="$(dirname "$0")/../i18n"; LG=${DMP_LANG:-fr}; [ -f "$I18/$LG/a8.sh" ] || LG=fr
. "$I18/$LG/a8.sh"
O=""; N=0
for d in /sys/bus/usb/devices/*; do
 [[ "$(basename $d)" == *:* ]] && continue
 [ -f "$d/idVendor" ] || continue
 v=$(cat $d/idVendor); [ "$v" = 1d6b ] && continue
 p=$(cat $d/product 2>/dev/null); m=$(cat $d/manufacturer 2>/dev/null)
 [ -z "$p" ] && p=$(LC_ALL=C lsusb -d $v:$(cat $d/idProduct) 2>/dev/null | cut -d' ' -f7-)
 nom=$(echo "$m $p" | xargs | tr -d '"\\')
 c=$(cat $d/bDeviceClass); [ "$c" = 00 ] && c=$(cat $d/*:1.0/bInterfaceClass 2>/dev/null | head -1)
 sp=$(cat $d/speed 2>/dev/null)
  case "$nom" in
   *[Kk]eyboard*) type_device="keyboard";;
   *[Mm]ouse*) type_device="mouse";;
   *[Gg]amepad*|*[Jj]oystick*) type_device="gamepad";;
   *) type_device="generic";;
  esac
 T_V; T_T
 N=$((N+1)); T_DEV
done
if [ "$N" -eq 0 ]; then j "$T_COMP_NO" "$T_NO_O" "$T_NO_R" "$T_CMD"; exit; fi
T_O
export X
j "$T_COMP" "$O" "$R" "$T_CMD"
