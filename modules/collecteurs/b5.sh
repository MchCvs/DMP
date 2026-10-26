#!/bin/bash
source "$(dirname "$0")/lib.sh"; NL=$'\n'; export LC_ALL=C
F=$(ip route | awk '/default/{print $5;exit}')
[ -z "$F" ] && { dmp_niveau 2; j "Cette page montre si votre ordinateur est relié à internet et si cette liaison fonctionne bien." "Aucune connexion active n'est détectée. Pourquoi : le câble est débranché, le Wi-Fi est coupé ou la box est éteinte. Sans connexion, impossible de naviguer ou de faire les mises à jour." "Non connecté" "ip route"; exit; }
GW=$(ip route | awk '/default/{print $3;exit}'); IP=$(ip -4 -o addr show "$F" | awk '{print $4}' | head -1)
DNS=$(awk '/^nameserver/{print $2}' /etc/resolv.conf | head -2 | paste -sd, | sed 's/,/, /g')
[ -d /sys/class/net/$F/wireless ] && K="Wi-Fi (sans fil)" || K="câble Ethernet"
case "$F" in en*) NM="« en » veut dire Ethernet, donc connexion par câble";; wl*) NM="« wl » veut dire Wi-Fi";; *) NM="nom donné par le système";; esac
case "$F" in *o[0-9]*) NM="$NM ; « o » veut dire intégrée à la carte mère ; le chiffre est son numéro";; en*p*s*) NM="$NM ; la suite indique son emplacement sur la carte mère";; esac
SP=$(cat /sys/class/net/$F/speed 2>/dev/null)
if [ -n "$SP" ] && [ "$SP" -gt 0 ] 2>/dev/null; then
 if [ "$SP" -ge 1000 ]; then SQ="excellent : suffisant pour tous les usages, même la vidéo 4K et les gros téléchargements"; elif [ "$SP" -ge 100 ]; then SQ="correct pour internet et la vidéo, plus lent pour les gros fichiers"; else SQ="très lent : vérifiez le câble, il est peut-être abîmé"; fi
 SPT="$SP Mb/s ($SQ)"; else SPT="non mesurable (normal en Wi-Fi)"; fi
S=/sys/class/net/$F/statistics
RB=$(cat $S/rx_bytes); TB=$(cat $S/tx_bytes); RP=$(cat $S/rx_packets); TP=$(cat $S/tx_packets)
ER=$(( $(cat $S/rx_errors)+$(cat $S/tx_errors) )); DR=$(( $(cat $S/rx_dropped)+$(cat $S/tx_dropped) ))
RH=$(numfmt --to=iec --suffix=o $RB); TH=$(numfmt --to=iec --suffix=o $TB)
US=$(cut -d. -f1 /proc/uptime); UH=$((US/3600)); [ $UH -lt 1 ] && UH=1; UT="$((US/86400)) j $((US%86400/3600)) h"
MH=$(numfmt --to=iec --suffix=o $((RB/UH))); PH=$((RB/1048576))
if [ $RB -gt $((TB*3)) ]; then BAL="Vous recevez bien plus que vous n'envoyez : c'est normal, car naviguer, regarder une vidéo ou mettre à jour consiste surtout à télécharger."; elif [ $TB -gt $RB ]; then BAL="Vous envoyez plus que vous ne recevez : c'est inhabituel. Cela peut venir d'une sauvegarde en ligne ou de l'envoi de gros fichiers."; else BAL="Réception et envoi sont proches : usage équilibré."; fi
pg(){ o=$(ping -c3 -i0.2 -W1 "$1" 2>/dev/null); L=$(echo "$o" | sed -n 's/.* \([0-9]*\)% packet loss.*/\1/p'); A=$(echo "$o" | sed -n 's#.*= [0-9.]*/\([0-9.]*\)/.*#\1#p'); }
pg "$GW"; GL=$L; GA=$A; pg 1.1.1.1; IL=$L; IA=$A
getent hosts debian.org >/dev/null 2>&1 && DN=1 || DN=0
t1(){ if [ -z "$2" ] || [ "$2" = 100 ]; then echo "❌ aucune réponse"; else a=${3%.*}; if [ "$a" -lt 30 ]; then q="excellent"; elif [ "$a" -lt 100 ]; then q="correct"; else q="lent"; fi; echo "✅ répond en $3 ms ($q), $2 % de pertes"; fi; }
TOT=$((RP+TP)); [ $TOT -lt 1 ] && TOT=1
PCT=$(awk -v d=$DR -v t=$TOT 'BEGIN{printf "%.2f",d*100/t}')
LV=0; awk -v p=$PCT 'BEGIN{exit !(p>=0.1)}' && LV=1; awk -v p=$PCT 'BEGIN{exit !(p>=1)}' && LV=2; [ $ER -gt 0 ] && LV=2
PF=/tmp/dmp-b5-drops; SUIV="Suivi : c'est la première consultation. À la prochaine, DMP indiquera si ce nombre augmente."
if [ -f $PF ]; then read PD PT < $PF; if [ "$DR" -ge "$PD" ]; then MN=$(( ($(date +%s)-PT)/60 )); SUIV="Suivi : $((DR-PD)) paquet(s) abandonné(s) de plus depuis la consultation précédente (il y a $MN min). Si ce nombre reste à 0 ou presque, les paquets comptés datent d'avant et ne sont pas inquiétants ; s'il grimpe vite pendant que vous naviguez, votre liaison perd des paquets : c'est généralement un problème de qualité ou de congestion chez votre fournisseur internet. Notez les horaires des pertes et contactez-le pour signaler."; fi; fi
echo "$DR $(date +%s)" > $PF
case $LV in 0) VD="✅ négligeable, rien à faire";; 1) VD="🟡 faible mais à surveiller : cela peut venir de messages ignorés sans gravité, ou d'une liaison un peu fragile";; 2) VD="🔴 trop élevé : de vraies données se perdent";; esac
QL="   • Erreurs matérielles : $ER${NL}      Pourquoi : ce sont des paquets arrivés abîmés (câble, prise ou carte réseau défectueux). Zéro est le résultat attendu.${NL}   • Paquets abandonnés (perdus) : $DR sur $TOT paquets, soit $PCT % du trafic${NL}      Qu'est-ce que c'est : un paquet est un petit colis de données ; « abandonné » veut dire que l'ordinateur l'a jeté sans le traiter. Deux causes possibles. Sans danger : des messages de diffusion du réseau qui ne vous concernent pas, ou un protocole que vous n'utilisez pas. Problème : la liaison est de mauvaise qualité ou saturée, et des données utiles se perdent.${NL}      Pourquoi surveiller : un paquet perdu doit être redemandé, ce qui cause des pages lentes, des vidéos qui saccadent et des appels coupés. Sous 0,1 % c'est négligeable, de 0,1 à 1 % à surveiller, au-delà c'est un problème.${NL}      Verdict : $VD${NL}      $SUIV"
O="🔗 Votre connexion${NL}   • Nom technique : $F (${NM})${NL}   • Type : $K${NL}   • Adresse de votre ordinateur : $IP${NL}      Pourquoi : c'est son numéro de maison sur votre réseau, il permet aux autres appareils de le trouver.${NL}   • Box (passerelle) : $GW${NL}      Pourquoi : c'est la porte de sortie vers internet. Tout ce qui sort ou entre passe par elle.${NL}   • Annuaire des sites (DNS) : ${DNS:-inconnu}${NL}      Pourquoi : il traduit un nom comme debian.org en adresse chiffrée, comme un annuaire téléphonique.${NL}   • Vitesse du lien : $SPT${NL}      Pourquoi : c'est la largeur du tuyau entre votre ordinateur et la box (pas votre abonnement internet).${NL}${NL}📦 Ce qui a circulé depuis l'allumage ($UT)${NL}   • ⬇️ Reçu : $RH (environ $PH photos de 1 Mo), en $RP paquets${NL}   • ⬆️ Envoyé : $TH, en $TP paquets${NL}   • Moyenne reçue : environ $MH par heure${NL}      Pourquoi : un paquet est un petit colis de données ; une page ou une vidéo arrive en milliers de colis. $BAL${NL}${NL}🩺 Qualité de la liaison${NL}${QL}${NL}${NL}🏓 Tests en direct${NL}   • Votre box : $(t1 x "$GL" "$GA")${NL}   • Internet : $(t1 x "$IL" "$IA")${NL}   • Annuaire (noms de sites) : $([ $DN = 1 ] && echo '✅ fonctionne' || echo '❌ ne répond pas')${NL}      Pourquoi : on teste chaque maillon dans l'ordre (box, puis internet, puis annuaire) pour savoir exactement où se situe un éventuel problème."
if [ -z "$GL" ] || [ "$GL" = 100 ]; then R="La box ne répond pas"; X="Le problème est entre votre ordinateur et la box : vérifiez le câble ou le Wi-Fi, puis redémarrez la box."
elif [ -z "$IL" ] || [ "$IL" = 100 ]; then R="Réseau local correct, mais pas d'internet"; X="La box répond, donc votre ordinateur va bien : le problème vient de la box ou de votre fournisseur. Redémarrez la box, et si cela persiste, contactez-le."
elif [ "$IL" -gt 0 ]; then R="Connexion instable"; X="Des paquets se perdent : cela cause des coupures et des lenteurs. Vérifiez le câble ou rapprochez-vous de la box."
elif [ $DN = 0 ]; then R="Internet répond, mais les noms de sites ne sont pas résolus"; X="Les sites ne s'ouvriront pas par leur nom : le service d'annuaire (DNS) est en panne, redémarrez la box."
else R="Connexion saine"; X="Chaque maillon répond bien : navigation, vidéos et mises à jour fonctionnent normalement."; fi
[ $LV -eq 1 ] && X="$X Point d'attention : $DR paquet(s) abandonné(s), soit $PCT % du trafic. Pourquoi surveiller : des paquets perdus doivent être redemandés, ce qui ralentit les pages et saccade les vidéos. Détail dans « Qualité de la liaison »."
[ $LV -eq 2 ] && { R="Liaison de mauvaise qualité"; X="$X $DR paquet(s) abandonné(s) ($PCT %) et $ER erreur(s) : de vraies données se perdent. Vérifiez le câble (changez-le si possible) ou rapprochez-vous de la box en Wi-Fi."; }
if [ "$R" = "Connexion saine" ]; then
  NV=0  # Tests directs OK → pas de problème actuel
else
  NV=0; case "$R" in "La box ne répond pas"|"Réseau local correct"*|"Internet répond, mais"*) NV=2;; "Connexion instable") NV=1;; esac
  [ $NV -lt $LV ] && NV=$LV
fi
export X; j "Cette page montre si la porte de votre ordinateur vers internet fonctionne : la connexion, ce qui y circule, sa qualité et sa vitesse." "$O" "$R" "ip, ping, /sys/class/net, getent (DMP uniquement)"
