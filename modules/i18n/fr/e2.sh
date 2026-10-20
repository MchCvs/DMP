# Textes français du collecteur e2. Ne modifier que le texte.
T_COMP="Score = une note de santé globale (0-100). Comme un bulletin du médecin pour votre ordinateur."
T_CMD="ps aux + free + df (DMP uniquement)"
T_EXC="Excellent"
T_GOOD="Bon"
T_IMP="À améliorer"
T_NOTE="Score >80 = Excellent | 60-80 = Bon | <60 = Nettoyage recommandé"
T_O() {
O="CPU: $CPU_USAGE% | RAM: $MEM_USAGE% | Disque: $DISK_USAGE% | Score final: $SCORE/100"
}
