# Textes français du collecteur b5. Ne modifier que le texte.
T_COMP="Cette page montre si la porte de votre ordinateur vers internet fonctionne : la connexion, ce qui y circule, sa qualité et sa vitesse."
T_COMP_NO="Cette page montre si votre ordinateur est relié à internet et si cette liaison fonctionne bien."
T_NO_O="Aucune connexion active n'est détectée. Pourquoi : le câble est débranché, le Wi-Fi est coupé ou la box est éteinte. Sans connexion, impossible de naviguer ou de faire les mises à jour."
T_NO_R="Non connecté"
T_NO_CMD="ip route"
T_CMD="ip, ping, /sys/class/net, getent (DMP uniquement)"
T_BYTE="o"
t1(){ if [ -z "$2" ] || [ "$2" = 100 ]; then echo "❌ aucune réponse"; else a=${3%.*}; if [ "$a" -lt 30 ]; then q="excellent"; elif [ "$a" -lt 100 ]; then q="correct"; else q="lent"; fi; echo "✅ répond en $3 ms ($q), $2 % de pertes"; fi; }
T_NM() {
case $N1 in en) NM="« en » veut dire Ethernet, donc connexion par câble";; wl) NM="« wl » veut dire Wi-Fi";; *) NM="nom donné par le système";; esac
case $N2 in onboard) NM="$NM ; « o » veut dire intégrée à la carte mère ; le chiffre est son numéro";; pci) NM="$NM ; la suite indique son emplacement sur la carte mère";; esac
}
T_SPT() {
case $SQ in
3) SQT="excellent : suffisant pour tous les usages, même la vidéo 4K et les gros téléchargements";;
2) SQT="correct pour internet et la vidéo, plus lent pour les gros fichiers";;
*) SQT="très lent : vérifiez le câble, il est peut-être abîmé";;
esac
if [ $SQ -gt 0 ]; then SPT="$SP Mb/s ($SQT)"; else SPT="non mesurable (normal en Wi-Fi)"; fi
}
T_QL() {
case $LV in 0) VD="✅ négligeable, rien à faire";; 1) VD="🟡 faible mais à surveiller : cela peut venir de messages ignorés sans gravité, ou d'une liaison un peu fragile";; *) VD="🔴 trop élevé : de vraies données se perdent";; esac
if [ "$SK" = delta ]; then SUIV="Suivi : $DD paquet(s) abandonné(s) de plus depuis la consultation précédente (il y a $MN min). Si ce nombre reste à 0 ou presque, les paquets comptés datent d'avant et ne sont pas inquiétants ; le nombre augmente pendant la navigation, notez la date/heure et prévenez votre FAI : c'est un problème de qualité du réseau."
else SUIV="Suivi : c'est la première consultation. À la prochaine, DMP indiquera si ce nombre augmente."; fi
QL="   • Erreurs matérielles : $ER${NL}      Pourquoi : ce sont des paquets arrivés abîmés (câble, prise ou carte réseau défectueux). Zéro est le résultat attendu.${NL}   • Paquets abandonnés (perdus) : $DR sur $TOT paquets, soit $PCT % du trafic${NL}      Qu'est-ce que c'est : un paquet est un petit colis de données ; « abandonné » veut dire que l'ordinateur l'a jeté sans le traiter. Deux causes possibles. Sans danger : des messages de diffusion du réseau qui ne vous concernent pas, ou un protocole que vous n'utilisez pas. Problème : la liaison est de mauvaise qualité ou saturée, et des données utiles se perdent.${NL}      Pourquoi surveiller : un paquet perdu doit être redemandé, ce qui cause des pages lentes, des vidéos qui saccadent et des appels coupés. Sous 0,1 % c'est négligeable, de 0,1 à 1 % à surveiller, au-delà c'est un problème.${NL}      Verdict : $VD${NL}      $SUIV"
}
T_O() {
T_NM; T_SPT; T_QL
if [ $KW = 1 ]; then K="Wi-Fi (sans fil)"; else K="câble Ethernet"; fi
UT="$UD j $UHR h"
case $BL in
dl) BAL="Vous recevez bien plus que vous n'envoyez : c'est normal, car naviguer, regarder une vidéo ou mettre à jour consiste surtout à télécharger.";;
up) BAL="Vous envoyez plus que vous ne recevez : c'est inhabituel. Cela peut venir d'une sauvegarde en ligne ou de l'envoi de gros fichiers.";;
*) BAL="Réception et envoi sont proches : usage équilibré.";;
esac
O="🔗 Votre connexion${NL}   • Nom technique : $F (${NM})${NL}   • Type : $K${NL}   • Adresse de votre ordinateur : $IP${NL}      Pourquoi : c'est son numéro de maison sur votre réseau, il permet aux autres appareils de le trouver.${NL}   • Box (passerelle) : $GW${NL}      Pourquoi : c'est la porte de sortie vers internet. Tout ce qui sort ou entre passe par elle.${NL}   • Annuaire des sites (DNS) : ${DNS:-inconnu}${NL}      Pourquoi : il traduit un nom comme debian.org en adresse chiffrée, comme un annuaire téléphonique.${NL}   • Vitesse du lien : $SPT${NL}      Pourquoi : c'est la largeur du tuyau entre votre ordinateur et la box (pas votre abonnement internet).${NL}${NL}📦 Ce qui a circulé depuis l'allumage ($UT)${NL}   • ⬇️ Reçu : $RH (environ $PH photos de 1 Mo), en $RP paquets${NL}   • ⬆️ Envoyé : $TH, en $TP paquets${NL}   • Moyenne reçue : environ $MH par heure${NL}      Pourquoi : un paquet est un petit colis de données ; une page ou une vidéo arrive en milliers de colis. $BAL${NL}${NL}🩺 Qualité de la liaison${NL}${QL}${NL}${NL}🏓 Tests en direct${NL}   • Votre box : $(t1 x "$GL" "$GA")${NL}   • Internet : $(t1 x "$IL" "$IA")${NL}   • Annuaire (noms de sites) : $([ $DN = 1 ] && echo '✅ fonctionne' || echo '❌ ne répond pas')${NL}      Pourquoi : on teste chaque maillon dans l'ordre (box, puis internet, puis annuaire) pour savoir exactement où se situe un éventuel problème."
case $ST in
nobox) R="La box ne répond pas"; X="Le problème est entre votre ordinateur et la box : vérifiez le câble ou le Wi-Fi, puis redémarrez la box.";;
noinet) R="Réseau local correct, mais pas d'internet"; X="La box répond, donc votre ordinateur va bien : le problème vient de la box ou de votre fournisseur. Redémarrez la box, et si cela persiste, contactez-le.";;
unstable) R="Connexion instable"; X="Des paquets se perdent : cela cause des coupures et des lenteurs. Vérifiez le câble ou rapprochez-vous de la box.";;
nodns) R="Internet répond, mais les noms de sites ne sont pas résolus"; X="Les sites ne s'ouvriront pas par leur nom : le service d'annuaire (DNS) est en panne, redémarrez la box.";;
*) R="Connexion saine"; X="Chaque maillon répond bien : navigation, vidéos et mises à jour fonctionnent normalement.";;
esac
[ $LV -eq 1 ] && { R="Connexion à surveiller"; X="Chaque maillon répond, mais $DR paquet(s) sur $TOT ont été perdus en route (soit $PCT % du trafic). Pourquoi surveiller : des paquets perdus doivent être redemandés, ce qui ralentit les pages et saccade les vidéos. Détail dans « Qualité de la liaison »."; }
[ $LV -eq 2 ] && { R="Liaison de mauvaise qualité"; X="$X $DR paquet(s) abandonné(s) ($PCT %) et $ER erreur(s) : des données utiles se perdent."; if [ "$KW" = 1 ]; then X="$X Rapprochez-vous de la box, ou passez en câble si c'est possible."; else X="$X Redémarrez la box. Si le problème persiste, signalez-le à votre fournisseur d'accès en notant la date et l'heure."; fi; }
}
