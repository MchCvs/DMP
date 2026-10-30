# Textes français du collecteur a2. Ne modifier que le texte.
T_COMP="La mémoire (RAM) est le bureau de travail de votre ordinateur : tout ce que vous ouvrez y est posé pour être utilisé très vite. Quand vous éteignez, le bureau est vidé."
T_CMD="/proc/meminfo"
T_O() {
case $LV in
3) Q="une très grande quantité : vous pouvez ouvrir beaucoup de choses en même temps sans souci"
XU="Elle est largement suffisante, même pour le montage vidéo ou plusieurs logiciels lourds en même temps, car ces tâches gardent beaucoup de données sur le bureau.";;
2) Q="une quantité confortable pour internet, la bureautique, les vidéos et un peu de création"
XU="Elle est suffisante pour un usage courant (internet avec beaucoup d'onglets, bureautique, vidéos, photos). Pour du montage vidéo lourd elle serait juste, car ces tâches remplissent vite le bureau.";;
1) Q="une quantité correcte mais juste si vous ouvrez beaucoup de choses"
XU="Elle suffit pour internet et la bureautique, mais devient juste avec beaucoup d'onglets, car les navigateurs récents sont gourmands.";;
*) Q="une quantité faible : l'ordinateur peut vite ralentir"
XU="Elle est faible : l'ordinateur sera lent dès qu'on ouvre plusieurs choses, car le bureau est trop petit.";;
esac
case $PL in
0) XE="En ce moment vous n'en utilisez qu'une partie ($P %) : vous avez de la marge.";;
1) XE="Elle est assez utilisée ($P %) : elle commence à peser, fermez les programmes dont vous n'avez plus besoin.";;
*) XE="Elle est presque pleine ($P %) : fermez des programmes ou des onglets.";;
esac
R="Mémoire en bonne forme"; [ "$PL" = 1 ] && R="Mémoire assez utilisée, à surveiller"; [ "$PL" = 2 ] && R="Mémoire presque pleine : l'ordinateur risque de ralentir"
X="$XU $XE"
O="Votre ordinateur a $T Go de mémoire, $Q. En ce moment $P % est occupé et il reste $D Go libres. Pourquoi c'est important : quand le bureau est plein, l'ordinateur doit ranger des choses sur le disque, qui est bien plus lent, et tout ralentit. Tant qu'il reste de la place libre, tout reste fluide."
}
