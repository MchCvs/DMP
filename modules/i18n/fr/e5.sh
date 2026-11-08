# Textes français du collecteur e5. Ne modifier que le texte.
T_COMP="Analyse = regarder tous les détails en microscope. Utile si vous avez un problème à diagnostiquer."
T_R="Diagnostic complet disponible"
T_CMD="uptime -p + /proc/loadavg"
T_NOTE="Si Load > nombre de cœurs: système surchargé. Sinon: c'est bon"
T_O() {
O="$(tr_cle e5.observations uptime="$UPTIME" load="$LOAD")"
}
