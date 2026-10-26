#!/bin/bash
source "$(dirname "$0")/lib.sh"
b=$(ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -1)
if [ -z "$b" ]; then dmp_niveau 3; j "L'alimentation est ce qui donne l'énergie à l'ordinateur : le courant du réseau électrique, parfois une batterie." "Aucune batterie détectée : c'est un ordinateur fixe, branché en permanence sur le secteur. Pourquoi : un ordinateur fixe n'a pas de batterie, c'est tout à fait normal." "Ordinateur fixe (normal)" "/sys/class/power_supply"; exit; fi
P=$(cat $b/capacity); S=$(cat $b/status)
full=$(cat $b/energy_full 2>/dev/null || cat $b/charge_full 2>/dev/null); des=$(cat $b/energy_full_design 2>/dev/null || cat $b/charge_full_design 2>/dev/null)
if [ -n "$full" ] && [ -n "$des" ] && [ "$des" -gt 0 ]; then W=$((full*100/des)); if [ $W -ge 80 ]; then XU="Votre batterie a gardé $W % de sa capacité d'origine : elle est en bonne santé."; elif [ $W -ge 60 ]; then XU="Votre batterie a gardé $W % de sa capacité d'origine : elle est un peu usée, l'autonomie est réduite."; else XU="Votre batterie n'a gardé que $W % de sa capacité d'origine : elle est très usée, son remplacement est conseillé."; fi; else XU="L'usure de la batterie n'a pas pu être mesurée."; fi
dmp_niveau 0
export X="$XU Pourquoi : une batterie perd un peu de capacité à chaque cycle de charge, c'est normal avec les années."
j "L'alimentation est ce qui donne l'énergie à l'ordinateur : le courant du réseau électrique, ou la batterie quand on débranche." "Votre batterie est chargée à $P % (état : $S). Pourquoi c'est utile : cela indique combien de temps vous pouvez travailler sans prise. Une batterie qui ne tient plus longtemps est usée avec les années." "Batterie détectée" "/sys/class/power_supply"
