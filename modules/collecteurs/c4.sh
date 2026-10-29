#!/bin/bash
if [ -z "$XDG_CURRENT_DESKTOP" ] || [ -z "$XDG_SESSION_TYPE" ]; then
  _E=$(systemctl --user show-environment 2>/dev/null)
  : "${XDG_CURRENT_DESKTOP:=$(echo "$_E" | sed -n 's/^XDG_CURRENT_DESKTOP=//p')}"
  : "${XDG_SESSION_TYPE:=$(echo "$_E" | sed -n 's/^XDG_SESSION_TYPE=//p')}"
  _S=$(loginctl list-sessions --no-legend 2>/dev/null | awk -v u="$(id -un)" '$3==u{print $1; exit}')
  : "${XDG_SESSION_TYPE:=$(loginctl show-session "$_S" -p Type --value 2>/dev/null)}"
fi
source "$(dirname "$0")/lib.sh"; NL=$'\n'; export LC_ALL=C; . /etc/os-release
d=/sys/class/dmi/id; MOD="$(cat $d/sys_vendor 2>/dev/null) $(cat $d/product_name 2>/dev/null)"
HOST=$(hostname); KERNEL=$(uname -r); PYV=$(python3 -V | cut -d' ' -f2); BASHV=${BASH_VERSION%%(*}
DESK=${XDG_CURRENT_DESKTOP:-}; SESS=${XDG_SESSION_TYPE:-}
# Langue : variable DMP_LANG (fr, en, de) ; le français sert de secours
I="$(dirname "$0")/../i18n"; L=${DMP_LANG:-fr}; [ -f "$I/$L/c4.sh" ] || L=fr
. "$I/$L/c4.sh"
case $(uname -m) in x86_64) AR="$T_AR64";; i?86) AR="$T_AR32";; *) AR="$(uname -m)";; esac
T_O
export X="$T_X"
export NV=$LV
j "$T_COMP" "$O" "$T_TITLE" "uname, /etc/os-release, /sys/class/dmi/id"
