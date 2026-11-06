# Textes français du collecteur e1. Ne modifier que le texte.
T_COMP="Résumé = regarder le tableau de bord de votre voiture. En un coup d'œil, vous voyez l'essentiel."
T_R="Système complet"
T_O() {
O="$(tr_cle e1.observations h="$HOSTNAME" c="$CORES" r="$RAM" d="$DISK")"
}
