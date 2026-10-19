# Textes français du collecteur b2. Ne modifier que le texte.
T_COMP="Cette page montre à quel point le cerveau de votre ordinateur travaille en ce moment, comme un coureur dont on mesure l'effort."
T_CMD="/proc/stat, ps"
T_O() {
TOP=$(echo "$RAW" | awk '{printf "   • %s : %s %% en moyenne depuis son lancement\n",$2,$1}')
O="📊 Le processeur travaille à $P % en ce moment.${NL}${NL}Les 3 programmes qui le sollicitent le plus :${NL}$TOP${NL}${NL}Pourquoi : un processeur à 100 % pendant longtemps rend l'ordinateur lent, car il n'a plus de temps libre pour de nouvelles demandes."
case $PL in
2) R="Très sollicité : l'ordinateur peut ralentir"; X="Un programme lourd est probablement en cours (regardez la liste ci-dessus). Si cela dure alors que vous ne faites rien, c'est anormal, car un ordinateur au repos reste sous 20 %.";;
1) R="Activité soutenue, normale si vous travaillez"; X="C'est courant pendant une vidéo, un jeu ou une installation. Cela devrait redescendre une fois la tâche finie.";;
*) R="Au repos, tout va bien"; X="Le processeur est peu sollicité : il garde de la marge pour réagir vite quand vous lancez quelque chose.";;
esac
}
