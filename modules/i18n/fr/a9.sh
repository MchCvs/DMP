# Textes français du collecteur a9. Ne modifier que le texte.
T_COMP="L'alimentation est ce qui donne l'énergie à l'ordinateur : le courant du réseau électrique, ou la batterie quand on débranche."
T_COMP_NO="L'alimentation est ce qui donne l'énergie à l'ordinateur : le courant du réseau électrique, parfois une batterie."
T_NO_O="Aucune batterie détectée : c'est un ordinateur fixe, branché en permanence sur le secteur. Pourquoi : un ordinateur fixe n'a pas de batterie, c'est tout à fait normal."
T_NO_R="Ordinateur fixe (normal)"
T_CMD="/sys/class/power_supply"
T_O() {
case $WL in
good) XU="Votre batterie a gardé $W % de sa capacité d'origine : elle est en bonne santé.";;
mid) XU="Votre batterie a gardé $W % de sa capacité d'origine : elle est un peu usée, l'autonomie est réduite.";;
bad) XU="Votre batterie n'a gardé que $W % de sa capacité d'origine : elle est très usée, son remplacement est conseillé.";;
*) XU="L'usure de la batterie n'a pas pu être mesurée.";;
esac
X="$XU Pourquoi : une batterie perd un peu de capacité à chaque cycle de charge, c'est normal avec les années."
O="Votre batterie est chargée à $P % (état : $S). Pourquoi c'est utile : cela indique combien de temps vous pouvez travailler sans prise. Une batterie qui ne tient plus longtemps est usée avec les années."
R="Batterie détectée"
}
