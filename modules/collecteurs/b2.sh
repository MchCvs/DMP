#!/bin/bash
source "$(dirname "$0")/lib.sh"; NL=$'\n'
read -r _ a b c d e f g _ < /proc/stat; t1=$((a+b+c+d+e+f+g)); i1=$((d+e)); sleep 1
read -r _ a b c d e f g _ < /proc/stat; t2=$((a+b+c+d+e+f+g)); i2=$((d+e))
dt=$((t2-t1)); [ $dt -le 0 ] && dt=1; P=$(( (dt-(i2-i1))*100/dt ))
CORES=$(nproc); TOP=$(ps -eo pcpu,comm --sort=-pcpu --no-headers | awk -v c=$CORES '$2!="ps" && $2!="python3" && $2!="curl" && $2!="awk" && $2!="head" {printf "%s %s\n",$1,$2}' | head -3 | awk -v c=$CORES '{printf "   • %s : %.1f %% de la capacité totale (moyenne depuis son lancement)\n",$2,$1/c}')
O="📊 Le processeur travaille à $P % en ce moment.${NL}${NL}Les 3 programmes qui le sollicitent le plus :${NL}$TOP${NL}${NL}Pourquoi : un processeur à 100 % pendant longtemps rend l'ordinateur lent, car il n'a plus de temps libre pour de nouvelles demandes."
R="Au repos, tout va bien"; X="Le processeur est peu sollicité : il garde de la marge pour réagir vite quand vous lancez quelque chose."
if [ $P -ge 85 ]; then R="Très sollicité : l'ordinateur peut ralentir"; X="Un programme lourd est probablement en cours (regardez la liste ci-dessus). Si cela dure alors que vous ne faites rien, c'est anormal, car un ordinateur au repos reste sous 20 %."
elif [ $P -ge 50 ]; then R="Activité soutenue, normale si vous travaillez"; X="C'est courant pendant une vidéo, un jeu ou une installation. Cela devrait redescendre une fois la tâche finie."; fi
NV=0; [ $P -ge 85 ] && NV=1; dmp_niveau $NV
export X; j "Cette page montre à quel point le cerveau de votre ordinateur travaille en ce moment, comme un coureur dont on mesure l'effort." "$O" "$R" "/proc/stat, ps"
