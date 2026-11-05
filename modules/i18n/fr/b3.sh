# Textes français du collecteur b3. Ne modifier que le texte.
T_COMP="Cette page montre combien le bureau de travail de votre ordinateur (la mémoire) est rempli en ce moment, et par quoi."
T_CMD="/proc/meminfo, ps"
T_O() {
TOP=$(echo "$RAW" | awk '{printf "   • %s : %s %% de la mémoire\n",$2,$1}')
O="$(tr_cle b3.observations p="$P" t="$T" a="$A" top="$TOP" sf="$SF" st="$ST")"
case $PL in
2) R="Mémoire saturée, fermez des programmes"; X="Fermez des onglets ou des programmes (surtout ceux de la liste), sinon l'ordinateur va ralentir en utilisant le disque comme secours.";;
1) R="Mémoire très sollicitée, sans blocage"; X="C'est normal : Linux garde volontairement de la mémoire pour accélérer, et la rend dès qu'un programme en a besoin.";;
*) R="Mémoire utilisée à un niveau normal"; X="Il reste beaucoup de place : les programmes s'ouvrent vite.";;
esac
}
