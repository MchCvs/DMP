# Textes français du collecteur b6. Ne modifier que le texte.
T_COMP="Cette page vérifie que les petits programmes invisibles qui font fonctionner votre ordinateur tournent tous correctement."
T_CMD="systemctl, journalctl (DMP uniquement)"
T_FICHE() {
case $RS in
exit-code) CA="le programme s'est arrêté en signalant une erreur (code $EX)";;
signal|core-dump) CA="le programme a été interrompu brutalement, il a planté";;
timeout) CA="le programme n'a pas répondu à temps au démarrage ou à l'arrêt";;
start-limit-hit) CA="le programme a planté plusieurs fois de suite : le système a renoncé à le relancer";;
dependency) CA="il dépend d'un autre service qui n'a pas démarré";;
resources) CA="le système n'avait pas assez de ressources pour le lancer";;
*) CA="cause indiquée par le système : ${RS:-inconnue}";;
esac
case $u in
NetworkManager-wait-online*) RO="fait patienter le démarrage jusqu'à ce que le réseau soit prêt. Souvent en erreur sans conséquence si le réseau arrive un peu plus tard.";;
bluetooth*) RO="gère le Bluetooth (casque, souris, manette sans fil). En erreur : le Bluetooth ne fonctionnera pas, le reste oui.";;
cups*) RO="gère l'impression. En erreur : impossible d'imprimer.";;
ModemManager*) RO="gère les clés et modems 3G/4G. Sans objet si vous n'en avez pas.";;
ssh*) RO="permet de se connecter à distance à cet ordinateur. En erreur : personne ne peut s'y connecter à distance.";;
apache2*|nginx*) RO="serveur de sites web local. En erreur : les sites hébergés ici sont inaccessibles.";;
smartmontools*|smartd*) RO="surveille la santé des disques. En erreur : les alertes de panne ne seront plus envoyées.";;
cron*) RO="lance les tâches programmées (sauvegardes, nettoyages). En erreur : elles ne se lancent plus.";;
*) RO="${D:-service du système}.";;
esac
[ -z "$LOG" ] && LOG="         (journal non lisible avec vos droits : tapez sudo journalctl -u $u)"
echo "${NL}❌ $u${NL}   • Rôle : $RO${NL}   • Cause de l'arrêt : $CA${NL}      Pourquoi : c'est le motif noté par le système au moment où le service s'est arrêté.${NL}   • Depuis : ${SI:-date inconnue}${NL}   • Derniers messages du journal :${NL}$LOG${NL}   • Que faire :${NL}      1) Essayer de le relancer : systemctl $sc restart $u${NL}      2) Si l'erreur revient, lire le journal complet : journalctl $sc -u $u${NL}      3) Si ce service ne vous sert pas, vous pouvez l'ignorer : un service en erreur qui n'est pas utilisé ne gêne pas le reste."
}
T_SVC() {
case $SK in active) e="✅ actif";; failed) e="❌ en erreur";; *) e="⚪ arrêté";; esac
IM="$IM${NL}   • $2 ($1) : $e${NL}      Pourquoi : $3"
}
T_SVCS() {
svc NetworkManager.service "Gestion du réseau" "c'est lui qui connecte l'ordinateur à internet."
svc systemd-timesyncd.service "Mise à l'heure" "il règle l'horloge sur internet ; une heure fausse bloque certains sites et les mises à jour."
svc cron.service "Tâches programmées" "il lance seul les nettoyages et sauvegardes planifiés."
svc ssh.service "Accès à distance" "il permet de se connecter à l'ordinateur depuis un autre appareil ; s'il est arrêté, personne ne peut entrer à distance, ce qui est plus sûr si vous n'en avez pas besoin."
svc cups.service "Impression" "il gère les imprimantes."
if [ $BT = 1 ]; then svc bluetooth.service "Bluetooth" "il gère les appareils sans fil."; else IM="$IM${NL}   • Bluetooth : ➖ non disponible${NL}      Pourquoi : cet ordinateur n'a pas de module Bluetooth, le service n'a donc rien à gérer. Son arrêt est normal et sans conséquence."; fi
if [ $WF = 1 ]; then svc wpa_supplicant.service "Wi-Fi" "il connecte l'ordinateur aux réseaux sans fil."; else IM="$IM${NL}   • Wi-Fi : ➖ non disponible${NL}      Pourquoi : cet ordinateur n'a pas de carte Wi-Fi, il se connecte uniquement par câble. C'est plus stable et sans conséquence."; fi
}
T_O() {
O="Un service est un petit programme invisible qui travaille en arrière-plan, comme le personnel d'un hôtel : on ne le voit pas, mais le réseau, l'impression, l'heure ou le son en dépendent. Pourquoi cette page : si un employé tombe malade, une fonction peut s'arrêter sans que vous compreniez pourquoi.${NL}${NL}📊 En ce moment${NL}   • Services en marche : $RUN${NL}   • Services lancés à chaque démarrage : $ENA${NL}   • Services en erreur : $T${NL}      Pourquoi : zéro est le résultat attendu, cela veut dire que personne ne manque à l'appel.${NL}${NL}🔧 Services importants${NL}$IM"
[ $T -gt 0 ] && O="$O${NL}${NL}🚨 Détail des services en erreur$NL$FI"
case $TL in
0) R="Tous les services fonctionnent"; X="Aucun service ne signale de problème : le réseau, l'heure, les tâches programmées et le reste travaillent normalement, donc rien à faire.";;
1) R="$T service(s) en erreur : à regarder, sans urgence"; X="Un ou deux services en erreur ne bloquent pas l'ordinateur en général, car chaque service est indépendant. Lisez les fiches ci-dessus : si le rôle ne vous concerne pas (par exemple Bluetooth sans appareil), vous pouvez l'ignorer ; sinon, essayez de le relancer.";;
*) R="$T services en erreur : à traiter"; X="Plusieurs services en erreur en même temps peuvent signaler un problème commun (réseau, disque plein, mise à jour interrompue). Commencez par la page Disque (B4) et Réseau (B5), puis relancez les services listés.";;
esac
}
