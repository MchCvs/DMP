#!/bin/bash
source "$(dirname "$0")/lib.sh"
I18="$(dirname "$0")/../i18n"; LG=${DMP_LANG:-fr}; [ -f "$I18/$LG/d1.sh" ] || LG=fr
. "$I18/$LG/d1.sh"
export X="$T_X"
export NV=3   # page de recherche : sans objet
j "$T_COMP" "$T_O" "$T_R" "$T_CMD"
