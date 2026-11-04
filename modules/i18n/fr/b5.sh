# Textes français du collecteur b5. Ne modifier que le texte.
T_COMP="$(tr_cle b5.comp)"
T_COMP_NO="Cette page montre si votre ordinateur est relié à internet et si cette liaison fonctionne bien."
T_NO_O="$(tr_cle b5.no_o)"
T_NO_R="$(tr_cle b5.no_r)"
T_NO_CMD="ip route"
T_CMD="$(tr_cle b5.cmd)"
T_BYTE="o"
t1(){ if [ -z "$2" ] || [ "$2" = 100 ]; then echo "❌ aucune réponse"; else a=${3%.*}; if [ "$a" -lt 30 ]; then q="excellent"; elif [ "$a" -lt 100 ]; then q="correct"; else q="lent"; fi; echo "✅ répond en $3 ms ($q), $2 % de pertes"; fi; }
T_NM() {
case $N1 in en) NM="« en » veut dire Ethernet, donc connexion par câble";; wl) NM="« wl » veut dire Wi-Fi";; *) NM="nom donné par le système";; esac
case $N2 in onboard) NM="$NM ; « o » veut dire intégrée à la carte mère ; le chiffre est son numéro";; pci) NM="$NM ; la suite indique son emplacement sur la carte mère";; esac
}
T_SPT() {
case $SQ in
3) SQT="$(tr_cle b5.debit.excellent)";;
2) SQT="$(tr_cle b5.debit.correct)";;
*) SQT="$(tr_cle b5.debit.lent)";;
esac
if [ $SQ -gt 0 ]; then SPT="$SP Mb/s ($SQT)"; else SPT="non mesurable (normal en Wi-Fi)"; fi
}
T_QL() {
case $LV in 0) VD="✅ aucune perte, connexion parfaite : rien à faire";; 1) VD="🟡 Quelques paquets perdus : rien de grave pour l'instant, mais la connexion mérite d'être observée.";; *) VD="🔴 Pertes importantes : les pages et les vidéos sont perturbées. $( [ "$KW" = 1 ] && echo "Rapprochez-vous de la box." || echo "Vérifiez le câble et la prise." )";; esac
if [ "$SK" = delta ]; then SUIV="Suivi : $DD trame(s) non destinée(s) à votre ordinateur de plus depuis la consultation précédente (il y a $MN min). Ce compteur ne mesure pas les pertes de votre connexion : c'est un trafic normal des adaptateurs CPL et de la box."; else SUIV="Suivi : c'est la première consultation. À la prochaine, DMP indiquera si ce nombre augmente."; fi
QL="   • Erreurs matérielles : $ER${NL}      Pourquoi : ce sont des paquets arrivés abîmés (câble, prise ou carte réseau défectueux). Zéro est le résultat attendu.${NL}   • Trames non destinées à votre ordinateur : $DR sur $TOT trames, soit $PCT % du trafic${NL}      Ce que c'est : ce sont des messages de gestion du réseau (adaptateurs CPL, box) que votre ordinateur reçoit sans les attendre. Il les écarte. Ce n'est pas une perte pour vous : vos pages et vos vidéos ne sont pas touchées.${NL}      Pertes réelles mesurées vers la box et Internet : box $GL %, Internet $IL %.${NL}      Verdict : $VD${NL}      $SUIV"
}
T_O() {
T_NM; T_SPT; T_QL
if [ $KW = 1 ]; then K="$(tr_cle b5.type.wifi)"; else K="$(tr_cle b5.type.cable)"; fi
UT="$UD j $UHR h"
case $BL in
dl) BAL="$(tr_cle b5.trafic.dl)";;
up) BAL="$(tr_cle b5.trafic.up)";;
*) BAL="$(tr_cle b5.trafic.equilibre)";;
esac
O="🔗 Votre connexion${NL}   • Nom technique : $F (${NM})${NL}   • Type : $K${NL}   • Adresse de votre ordinateur : $IP${NL}      Pourquoi : c'est son numéro de maison sur votre réseau, il permet aux autres appareils de le trouver.${NL}   • Box (passerelle) : $GW${NL}      Pourquoi : c'est la porte de sortie vers internet. Tout ce qui sort ou entre passe par elle.${NL}   • Annuaire des sites (DNS) : ${DNS:-inconnu}${NL}      Pourquoi : il traduit un nom comme debian.org en adresse chiffrée, comme un annuaire téléphonique.${NL}   • Vitesse du lien : $SPT${NL}      Pourquoi : c'est le débit maximal du câble ou du Wi-Fi entre votre ordinateur et la box (ce n'est pas le débit de votre abonnement internet).${NL}${NL}📦 Ce qui a circulé depuis l'allumage ($UT)${NL}   • ⬇️ Reçu : $RH (environ $PH photos de 1 Mo), en $RP paquets${NL}   • ⬆️ Envoyé : $TH, en $TP paquets${NL}   • Moyenne reçue : environ $MH par heure${NL}      Pourquoi : un paquet est un petit colis de données ; une page ou une vidéo arrive en milliers de colis. $BAL${NL}${NL}🩺 Qualité de la liaison${NL}${QL}${NL}${NL}🏓 Tests en direct${NL}   • Votre box : $(t1 x "$GL" "$GA")${NL}   • Internet : $(t1 x "$IL" "$IA")${NL}   • Annuaire (noms de sites) : $([ $DN = 1 ] && echo '✅ fonctionne' || echo '❌ ne répond pas')${NL}      Pourquoi : on teste chaque maillon dans l'ordre (box, puis internet, puis annuaire) pour savoir exactement où se situe un éventuel problème."
case $ST in
nobox) R="$(tr_cle b5.nobox.titre)"; X="Le problème est entre votre ordinateur et la box : vérifiez le câble ou le Wi-Fi, puis redémarrez la box.";;
noinet) R="$(tr_cle b5.noinet.titre)"; X="$(tr_cle b5.noinet.texte)";;
unstable) R="$(tr_cle b5.unstable.titre)"; X="Des paquets se perdent : cela cause des coupures et des lenteurs. Vérifiez le câble ou rapprochez-vous de la box.";;
nodns) R="$(tr_cle b5.nodns.titre)"; X="Les sites ne s'ouvriront pas par leur nom : le service d'annuaire (DNS) est en panne, redémarrez la box.";;
*) R="$(tr_cle b5.saine.titre)"; X="Chaque maillon répond bien : navigation, vidéos et mises à jour fonctionnent normalement.";;
esac
[ $LV -eq 1 ] && { R="$(tr_cle b5.surveiller.titre)"; X="$(tr_cle b5.surveiller.texte dr=$DR tot=$TOT pct=$PCT)"; }
[ $LV -eq 2 ] && { R="$(tr_cle b5.mauvaise.titre)"; X="$(tr_cle b5.mauvaise.texte dr=$DR pct=$PCT er=$ER)"; if [ "$KW" = 1 ]; then X="$X $(tr_cle b5.mauvaise.wifi)"; else X="$X $(tr_cle b5.mauvaise.cable)"; fi; }
}
