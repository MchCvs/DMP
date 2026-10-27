# Textes français du collecteur e5. Ne modifier que le texte.
T_COMP="Analyse = regarder tous les détails en microscope. Utile si vous avez un problème à diagnostiquer."
T_R="Diagnostic complet disponible"
T_CMD="uptime -p + /proc/loadavg (DMP uniquement)"
T_NOTE="Si Load > nombre de cœurs: système surchargé. Sinon: c'est bon"
T_O() {
O="Système actif depuis: $UPTIME | Charge moyenne (dernière minute): $LOAD (0-4 sur 4 cœurs c'est normal)"
}
