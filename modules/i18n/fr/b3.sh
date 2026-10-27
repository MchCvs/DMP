# Textes français du collecteur b3. Ne modifier que le texte.
T_COMP="Cette page montre combien le bureau de travail de votre ordinateur (la mémoire) est rempli en ce moment, et par quoi."
T_CMD="/proc/meminfo, ps"
T_O() {
TOP=$(echo "$RAW" | awk '{printf "   • %s : %s %% de la mémoire\n",$2,$1}')
O="🧠 Mémoire utilisée : $P % sur $T Go (il reste $A Go disponibles)${NL}${NL}Les 3 plus gros consommateurs :${NL}$TOP${NL}${NL}🔁 Mémoire de secours (swap, sur le disque) : $SF Go utilisés sur $ST Go${NL}Pourquoi : quand le bureau est plein, le système range des choses sur le disque, bien plus lent. Beaucoup de swap utilisé veut dire que la mémoire a manqué."
case $PL in
2) R="Mémoire presque pleine"; X="Fermez des onglets ou des programmes (surtout ceux de la liste), sinon l'ordinateur va ralentir en utilisant le disque comme secours.";;
1) R="Mémoire bien utilisée, encore correcte"; X="C'est normal : Linux garde volontairement de la mémoire pour accélérer, et la rend dès qu'un programme en a besoin.";;
*) R="Mémoire à l'aise"; X="Il reste beaucoup de place : les programmes s'ouvrent vite.";;
esac
}
