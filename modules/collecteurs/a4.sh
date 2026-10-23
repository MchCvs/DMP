#!/bin/bash
source "$(dirname "$0")/lib.sh"
F=$(ip route | awk '/default/{print $5;exit}')
if [ -z "$F" ]; then dmp_niveau 2; j "Le réseau est la porte de votre ordinateur vers le reste du monde : internet, imprimante, autres appareils." "Aucune connexion active n'est détectée : l'ordinateur n'a pas de chemin vers internet. Pourquoi : le câble est peut-être débranché ou le Wi-Fi désactivé. Sans connexion, impossible de naviguer ou de faire les mises à jour." "Non connecté" "ip route"; exit; fi
A=$(ip -4 -o addr show "$F" | awk '{print $4}' | head -1)
[ -d /sys/class/net/$F/wireless ] && K="en Wi-Fi (sans fil)" || K="par câble"
if [ -d /sys/class/net/$F/wireless ]; then XU="Le Wi-Fi est pratique, mais sa qualité dépend de la distance à la box et des murs : si les pages sont lentes, rapprochez-vous ou passez par un câble."; else XU="Le câble est en général plus stable et plus rapide que le Wi-Fi, car le signal ne subit pas d'interférences."; fi
dmp_niveau 0
export X="Cette connexion suffit pour naviguer, regarder des vidéos et faire les mises à jour. $XU"
j "Le réseau est la porte de votre ordinateur vers le reste du monde : internet, imprimante, autres appareils." "Votre ordinateur est connecté $K, via l'interface « $F ». Son adresse sur le réseau est $A : c'est comme son numéro de maison, qui permet aux autres appareils de le trouver. Pourquoi c'est important : sans cette adresse, aucune page web ni mise à jour ne pourrait arriver jusqu'à vous." "Connecté" "ip route, ip addr"
