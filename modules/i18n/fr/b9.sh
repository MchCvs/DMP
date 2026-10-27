# Textes français du collecteur b9. Ne modifier que le texte.
T_COMP="Cette page vérifie que les portes de votre ordinateur sont bien fermées : mises à jour de sécurité, pare-feu, portes ouvertes, accès à distance."
T_CMD="apt, ss, systemctl, last (DMP uniquement)"
T_NOHIST="   • Historique non disponible"
pd(){ case $1 in 3000) echo "Open WebUI : interface de chat avec des modèles d'IA, lancée par Docker.";; 22) echo "Accès à distance (SSH) : permet de piloter l'ordinateur depuis un autre appareil.";; 631) echo "Impression (CUPS).";; 80|443|8080) echo "Serveur de sites web.";; 8765) echo "Le serveur DMP, qui affiche ces pages.";; 3306) echo "Base de données MySQL/MariaDB.";; 5432) echo "Base de données PostgreSQL.";; 25|587) echo "Service de courrier interne (ici Postfix) : il distribue les messages que le système s'envoie à lui-même, comme les alertes des tâches programmées. Il n'envoie rien sur internet.";; 445|139) echo "Partage de fichiers Windows (Samba).";; 53) echo "Annuaire des noms de sites (DNS) local.";; *) echo "Programme qui attend des connexions sur ce numéro.";; esac; }
T_PORTL() { PT="$PT${NL}🔒 Porte $p : interne à l'ordinateur${NL}   • Rôle : $(pd $p)${NL}   • Pourquoi sans risque : elle n'écoute que cet ordinateur, personne d'autre ne peut s'y connecter.${NL}"; }
T_PORTE() { PT="$PT${NL}🚪 Porte $p : joignable depuis le réseau${NL}   • Rôle : $(pd $p)${NL}   • Pourquoi à surveiller : n'importe quel appareil de votre réseau peut tenter de s'y connecter. Si vous n'en avez pas besoin, fermez-la en arrêtant le service.${NL}"; }
T_O() {
case $MC in
sec) MJ="⚠️ $SU mise(s) à jour de sécurité en attente ($UP au total).${NL}   Pourquoi : une mise à jour de sécurité bouche une faille déjà connue ; tant qu'elle n'est pas installée, la faille reste utilisable par un attaquant.";;
ord) MJ="🟡 Aucune mise à jour de sécurité en attente, mais $UP mise(s) à jour ordinaires.${NL}   Pourquoi : elles apportent des corrections et améliorations, moins urgentes.";;
*) MJ="✅ Tout est à jour.${NL}   Pourquoi : aucune faille connue n'est laissée ouverte par un logiciel ancien.";;
esac
case $AC in
old) MJ="$MJ${NL}   ⚠️ La liste des mises à jour date de $AG jours : elle n'est peut-être plus à jour, lancez « sudo apt update ».";;
recent) MJ="$MJ${NL}   Dernière vérification : il y a $AG jour(s).";;
esac
if [ $AUC = 1 ]; then AU="✅ Mises à jour de sécurité automatiques : installées.${NL}   Pourquoi : elles se font toutes seules, sans que vous ayez à y penser."; else AU="⚪ Mises à jour automatiques : non installées.${NL}   Pourquoi : il faut donc les lancer vous-même régulièrement (paquet unattended-upgrades pour automatiser)."; fi
if [ $RBC = 1 ]; then RB="⚠️ Un redémarrage est nécessaire.${NL}   Pourquoi : une mise à jour (souvent du noyau) n'est active qu'après redémarrage ; sans cela, la faille corrigée reste ouverte."; else RB="✅ Aucun redémarrage en attente."; fi
if [ -n "$FW" ]; then PF="✅ Pare-feu actif ($FW).${NL}   Pourquoi : c'est un videur à l'entrée : il refuse les connexions venues de l'extérieur que vous n'avez pas autorisées."; else PF="🟡 Aucun pare-feu détecté (ufw, nftables, firewalld).${NL}   Pourquoi : sans videur, toute porte ouverte (voir ci-dessous) est joignable depuis votre réseau. Si aucune porte n'est ouverte, le risque reste faible. Installation simple : sudo apt install ufw && sudo ufw enable."; fi
case $SSHC in
danger) SSH="🔴 Accès distant actif, connexion directe du compte administrateur AUTORISÉE.${NL}   Pourquoi dangereux : tout le monde connaît le nom « root » ; un pirate n'a plus qu'à trouver le mot de passe. Mettez PermitRootLogin no.";;
active) SSH="🟡 Accès distant (SSH) actif.${NL}   Pourquoi : utile si vous en avez besoin. Sinon, désactivez-le : une porte fermée ne peut pas être forcée.";;
*) SSH="✅ Accès distant (SSH) arrêté.${NL}   Pourquoi : personne ne peut se connecter à distance à cet ordinateur.";;
esac
if [ $AAC = 1 ]; then AP="✅ AppArmor actif.${NL}   Pourquoi : il enferme chaque programme dans un cadre ; un programme piraté ne peut pas toucher au reste."; else AP="⚪ AppArmor inactif.${NL}   Pourquoi : c'est une protection supplémentaire non utilisée ; cela ne signifie pas un risque immédiat."; fi
O="La sécurité, c'est comme fermer sa maison : on vérifie les serrures (mises à jour), le videur (pare-feu), les portes laissées ouvertes (ports) et qui est entré récemment. Pourquoi cette page : la plupart des intrusions passent par une faille déjà corrigée mais non installée, ou par une porte inutilement ouverte.${NL}${NL}🛠️ Mises à jour${NL}$MJ${NL}$AU${NL}$RB${NL}${NL}🧱 Pare-feu${NL}$PF${NL}${NL}🚪 Portes (ports) en écoute : $EXP joignable(s) depuis le réseau, $LOC interne(s)${NL}   Pourquoi : un « port » est une porte numérotée par laquelle un programme reçoit des connexions. Plus il y a de portes joignables depuis l'extérieur, plus il y a de points d'entrée possibles.$PT${NL}🔑 Accès à distance${NL}$SSH${NL}${NL}🛡️ Protection des programmes${NL}$AP${NL}${NL}👤 5 dernières connexions à cet ordinateur${NL}   Pourquoi : repérer une connexion que vous ne reconnaissez pas.${NL}${LG:-$T_NOHIST}"
case $SC in
0) R="Système bien protégé"; X="Aucune mise à jour en attente, aucune porte inutilement ouverte, rien à signaler : les principales entrées sont fermées. Gardez l'habitude d'installer les mises à jour chaque semaine.";;
1) R="Protégé, quelques points à améliorer"; X="Rien de grave : le système n'est pas en danger immédiat, mais certains points ci-dessus (mises à jour ordinaires, pare-feu absent, porte joignable, redémarrage) rendraient la protection plus solide. Traitez-les dans l'ordre affiché.";;
*) R="Failles à corriger rapidement"; X="Un point sérieux est signalé (mise à jour de sécurité en attente, trop de portes ouvertes ou accès administrateur à distance). Corrigez-le en priorité : sudo apt update && sudo apt upgrade.";;
esac
}
