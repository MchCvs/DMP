#!/bin/bash
C=$(nproc)
#M=$(lscpu | sed -n 's/^Model name: *//p' | head -1 | tr -d '"\\')
M=$(grep -m1 'model name' /proc/cpuinfo | cut -d: -f2 | tr -d '"\\' | xargs)
L=$(cut -d' ' -f1 /proc/loadavg)
if [ "$C" -ge 8 ]; then Q="un nombre élevé : votre ordinateur peut faire beaucoup de choses en même temps (vidéo, navigation, jeux) sans ralentir"
elif [ "$C" -ge 4 ]; then Q="un nombre confortable pour un usage courant : internet, bureautique, vidéos"
else Q="un nombre modeste : l'ordinateur peut ralentir si on lance beaucoup de choses en même temps"; fi
O="Votre processeur est un « $M ». Il possède $C cœurs. Un cœur est comme un ouvrier : plus il y en a, plus le travail se partage et va vite. Avec $C cœurs, c'est $Q. Charge actuelle : $L. Cette valeur mesure combien de tâches attendent leur tour : si elle reste sous $C, le processeur travaille sans être débordé, car chaque cœur a sa tâche. Au-dessus de $C, des tâches font la queue et l'ordinateur ralentit."
case "$M" in
*Core*i3*) N="entrée de gamme"; X="un i3 suffit pour internet, la bureautique et les vidéos, mais peut peiner si on fait beaucoup de choses à la fois";;
*Core*i5*) N="milieu de gamme"; X="un i5 est le choix le plus courant car il offre le meilleur équilibre entre vitesse et prix : il suffit largement pour internet, la bureautique, les vidéos, les photos et les jeux courants";;
*Core*i7*) N="haut de gamme"; X="un i7 est rapide et à l'aise pour le montage vidéo, la création et les jeux exigeants";;
*Core*i9*) N="très haut de gamme"; X="un i9 est un processeur de grande puissance, pensé pour les usages très lourds";;
esac
case "$M" in
*Core*i[3579]*) E="Qu'est-ce qu'un Core i5, i7... ? Intel est l'un des deux grands fabricants de processeurs (l'autre est AMD). « Core » est sa gamme grand public, classée par niveau, comme les tailles d'une même marque : i3 (entrée de gamme), i5 (milieu de gamme), i7 (haut de gamme), i9 (très haut de gamme). Le vôtre est $N : $X. Le nombre qui suit la lettre i (par exemple 12400) indique la génération et la puissance : plus il est grand, plus le processeur est récent et efficace. Pourquoi c'est utile de le savoir : cela vous dit ce que votre ordinateur peut faire confortablement, et quand il sera peut-être temps de le changer.";;
*Ryzen*) E="Qu'est-ce qu'un Ryzen ? AMD est l'un des deux grands fabricants de processeurs (l'autre est Intel). Ryzen est sa gamme grand public, classée par niveau : Ryzen 3 (entrée de gamme), 5 (milieu de gamme, le plus courant), 7 (haut de gamme), 9 (très haut de gamme). Le nombre qui suit indique la génération : plus il est grand, plus le processeur est récent. Pourquoi c'est utile de le savoir : cela vous dit ce que votre ordinateur peut faire confortablement.";;
*) E="Le nom de votre processeur indique son fabricant et son niveau de puissance. Comparez-le à d'autres modèles du même fabricant pour savoir s'il est récent et puissant.";;
esac
O="$O $E"
R="Fonctionne bien"; awk "BEGIN{exit !($L>$C)}" && R="Surchargé en ce moment : trop de tâches en attente"
Y=""
if [[ "$M" =~ i[3579]-([0-9]{4,5}) ]]; then n=${BASH_REMATCH[1]}
 if [ ${#n} -eq 5 ] || [ "${n:0:1}" = 1 ]; then g=${n:0:2}; else g=${n:0:1}; fi; Y=$((2009+g))
elif [[ "$M" =~ Ryzen\ [3579]\ ([0-9]{4}) ]]; then
 case ${BASH_REMATCH[1]:0:1} in 1) Y=2017;; 2) Y=2018;; 3) Y=2019;; 4) Y=2021;; 5) Y=2020;; 6|7) Y=2022;; *) Y=2024;; esac
fi
if [ "$C" -ge 8 ]; then U="Pour un usage courant (internet, bureautique, vidéos, photos), il est largement suffisant. Il convient aussi aux usages exigeants comme le montage vidéo ou les jeux, car avec $C cœurs le travail se répartit bien."
elif [ "$C" -ge 4 ]; then U="Pour un usage courant (internet, bureautique, vidéos, photos), il est suffisant. Pour du montage vidéo ou des jeux très récents, il sera plus juste, car ces tâches demandent beaucoup de cœurs en même temps."
else U="Il suffit pour internet et la bureautique légère, mais il est limité dès qu'on fait plusieurs choses à la fois, car $C cœurs seulement se partagent le travail."; fi
if [ -n "$Y" ]; then A=$(( $(date +%Y) - Y ))
 if [ $A -le 3 ]; then D="récent"; elif [ $A -le 6 ]; then D="d'âge moyen"; else D="ancien"; fi
 AG="Âge : c'est un processeur $D, sorti vers $Y. Pourquoi cela compte : un processeur récent est plus rapide et consomme moins d'énergie ; un ancien reste utilisable tant que vos usages sont simples, mais il finit par ralentir avec des logiciels de plus en plus exigeants."
else AG="Son âge n'a pas pu être déterminé automatiquement : plus le numéro dans son nom est grand, plus il est récent."; fi
R="$R. $U $AG"
printf '{"comprendre":"C'\''est le cerveau de votre ordinateur. Il pense et fait les calculs. Plus il est rapide, plus vos programmes vont vite.","observations":"%s","resultat":"%s","informations_techniques":{"cores":%s,"load":%s,"model":"%s","cmd":"nproc, lscpu, /proc/loadavg (DMP uniquement)"}}\n' "$O" "$R" "$C" "$L" "$M"
