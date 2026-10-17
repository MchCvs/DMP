#!/bin/bash
source "$(dirname "$0")/lib.sh"
G=$(LC_ALL=C lspci 2>/dev/null | grep -iE 'vga|3d|display' | cut -d: -f3- | xargs)
if [ -z "$G" ]; then j "La carte graphique fabrique l'image que vous voyez à l'écran." "Aucune carte graphique n'a pu être identifiée. Pourquoi : l'outil de détection est peut-être absent, ou l'ordinateur est une machine virtuelle." "Non identifiée" "lspci"; exit; fi
case "$G" in *NVIDIA*|*Radeon\ RX*|*Radeon\ Pro*) K="C'est probablement une carte dédiée : une pièce séparée, puissante, pensée pour les jeux et le montage vidéo.";; *) K="C'est probablement une puce graphique intégrée : elle est dans le processeur, suffit pour internet, la vidéo et la bureautique, mais est moins adaptée aux jeux récents.";; esac
case "$G" in *NVIDIA*|*Radeon\ RX*|*Radeon\ Pro*) XU="Elle est suffisante pour les jeux et le montage vidéo, car c'est une pièce dédiée avec sa propre puissance.";; *) XU="Elle est suffisante pour internet, les vidéos (même en HD), les photos et la bureautique. Pour les jeux 3D récents ou le montage vidéo lourd elle sera limitée, car elle partage la puissance avec le processeur.";; esac
Y=""
case "$G" in
*"HD Graphics 2500"*|*"HD Graphics 4000"*|*Ivy*) Y=2012;; *Haswell*|*"HD Graphics 4600"*) Y=2013;; *Broadwell*|*Skylake*) Y=2015;; *Kaby*|*Coffee*|*"UHD Graphics 6"*) Y=2017;; *Comet*|*"Ice Lake"*|*Tiger*|*"Iris Xe"*) Y=2020;; *Alder*|*Raptor*) Y=2022;; *Meteor*|*Arrow*|*Lunar*) Y=2024;;
*Raven*) Y=2018;; *Picasso*) Y=2019;; *Renoir*) Y=2020;; *Cezanne*) Y=2021;;
esac
if [ -z "$Y" ] && [[ "$G" =~ (GTX|RTX|GT)\ ?([0-9]{3,4}) ]]; then n=${BASH_REMATCH[2]}; s=${n:0:${#n}-2}
 case $s in 4|5) Y=2012;; 6) Y=2012;; 7) Y=2014;; 9) Y=2015;; 10) Y=2016;; 16) Y=2019;; 20) Y=2018;; 30) Y=2020;; 40) Y=2022;; 50) Y=2025;; esac; fi
if [ -z "$Y" ] && [[ "$G" =~ RX\ ?([0-9]{3,4}) ]]; then n=${BASH_REMATCH[1]}
 if [ ${#n} -eq 3 ]; then [ "${n:0:1}" = 4 ] && Y=2016 || Y=2017; else case ${n:0:1} in 5) Y=2019;; 6) Y=2020;; 7) Y=2022;; 9) Y=2025;; esac; fi; fi
if [ -n "$Y" ]; then A=$(( $(date +%Y) - Y ))
 if [ $A -le 3 ]; then D="récente"; elif [ $A -le 6 ]; then D="d'âge moyen"; else D="ancienne"; fi
 AG="Âge : d'après son nom, c'est une puce $D, sortie vers $Y (il y a environ $A an(s)). Pourquoi cela compte : une puce récente est plus rapide, consomme moins d'énergie et sait lire les vidéos les plus récentes sans fatiguer le processeur ; une ancienne reste correcte pour internet et la bureautique, mais peine sur les vidéos modernes et les jeux récents."
else AG="Âge : il n'a pas pu être déterminé, car le nom « $G » ne contient pas d'indication de date que DMP sait lire. Pour le connaître, tapez ce nom exact dans un moteur de recherche avec « date de sortie »."; fi
export X="$XU $AG"
j "La carte graphique est la peintre de votre ordinateur : elle dessine tout ce qui s'affiche à l'écran (fenêtres, vidéos, jeux)." "Votre ordinateur utilise : « $G ». $K Pourquoi c'est utile de le savoir : cela vous dit si l'ordinateur peut gérer des jeux ou du montage, ou s'il est plutôt fait pour un usage courant." "Détectée" "lspci"
