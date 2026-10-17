#!/bin/bash
source "$(dirname "$0")/lib.sh"
d=/sys/class/dmi/id
V=$(cat $d/board_vendor 2>/dev/null); N=$(cat $d/board_name 2>/dev/null); B=$(cat $d/bios_version 2>/dev/null); Y=$(cat $d/bios_date 2>/dev/null)
if [ -z "$V$N" ]; then j "La carte mère est la grande plaque centrale où tout se branche : processeur, mémoire, disque. C'est le squelette de l'ordinateur." "Ses informations ne sont pas lisibles ici. Pourquoi : c'est fréquent sur une machine virtuelle ou un portable qui les cache." "Non disponible" "/sys/class/dmi/id"; exit; fi
yr=${Y##*/}
if [[ "$yr" =~ ^[0-9]{4}$ ]]; then XA=$(( $(date +%Y) - yr )); XU="Le programme de démarrage date de $yr, soit environ $XA an(s) : cela donne un ordre d'idée de l'âge de la carte mère. "; else XU=""; fi
export X="${XU}Si l'ordinateur démarre et fonctionne bien, il n'y a rien à faire : mettre à jour le BIOS comporte un risque, donc on ne le fait que pour corriger un problème précis."
j "La carte mère est la grande plaque centrale où tout se branche : processeur, mémoire, disque. C'est le squelette de l'ordinateur : si elle ne fonctionne pas, rien ne fonctionne." "Votre carte mère est une « $N » du fabricant $V. Son programme de démarrage (BIOS) est en version $B, datée du $Y. Pourquoi c'est utile : le BIOS est le premier programme lancé quand vous allumez l'ordinateur. Une version très ancienne peut manquer de corrections, mais on ne la modifie que si nécessaire." "Identifiée" "/sys/class/dmi/id"
