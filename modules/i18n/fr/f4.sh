T_COMP="Historique = se souvenir de ce qui s'est passé. Comme un journal intime de votre ordinateur."
T_R="Historique complet"
T_CMD="/var/log/apt/history.log"
T_NOTE="Cet historique sert à tracer les modifications. Utile si quelque chose s'est cassé"
T_O() {
O="$(tr_cle f4.observations last="$LAST_BOOT" changes="$CHANGES")"
}
