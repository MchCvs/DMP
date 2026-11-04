# Textes français du collecteur d3. Ne modifier que le texte.
T_COMP="$(tr_cle d3.comp)"
T_CMD="$(tr_cle d3.cmd)"
T_ALL="tous"
T_PEND="en attente"
T_ON="actif"
T_OFF="inactif"
T_X="$(tr_cle d3.x)"
T_O() {
O="Ce que l'entretien régulier vous apporte :${NL}${NL}$E1 Place libre : $DF disponibles ($DP utilisés)${NL}   Pourquoi : un disque qui n'est pas plein reste rapide et peut recevoir mises à jour et nouveaux fichiers.${NL}${NL}$E2 Mémoire disponible : $MG Go ($MP % libres)${NL}   Pourquoi : plus la mémoire libre est grande, plus les programmes s'ouvrent vite sans ralentir.${NL}${NL}$E3 Logiciels à jour : $UPT${NL}   Pourquoi : un logiciel à jour n'a plus les failles déjà connues, c'est votre meilleure protection.${NL}${NL}$E4 Pare-feu : $FW${NL}   Pourquoi : il refuse les connexions venues de l'extérieur que vous n'avez pas autorisées.${NL}${NL}🎁 En résumé : DMP surveille 18 sujets pour vous et traduit chaque chiffre en mots simples, avec le pourquoi. Vous gagnez du temps, de la sécurité et une machine qui dure plus longtemps."
R="$S bénéfice(s) acquis sur 4"
}
