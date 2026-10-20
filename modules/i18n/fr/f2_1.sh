T_COMP="La sauvegarde est l'assurance de vos fichiers : elle ne sert à rien jusqu'au jour où l'on en a besoin, et ce jour-là elle sauve tout."
T_CMD="command -v, /timeshift, /var/backups, lsblk"
T_NOTOOL="aucun"
T_NOSN="aucun trouvé"
T_NOBK="aucune"
T_NOBR="aucune trouvée"
T_O1() {
O="💾 Une sauvegarde est une copie de vos fichiers rangée ailleurs, à l'abri. Pourquoi : un disque finit toujours par tomber en panne, et une erreur de manipulation ou un virus peut tout effacer. Sans copie, ces fichiers sont perdus pour toujours.${NL}${NL}🧰 Outils de sauvegarde installés : ${T:-$T_NOTOOL}${NL}   Pourquoi : il faut un outil pour copier régulièrement sans y penser (timeshift : copie du système ; borg et restic : copies de fichiers ; rsync : copie simple).${NL}${NL}📸 Dernier instantané du système : ${SN:-$T_NOSN}${NL}   Pourquoi : il permet de revenir à un état précédent si une mise à jour tourne mal.${NL}${NL}🗃️ Copie automatique des réglages de Debian (/var/backups) : $BKD${NL}   Pourquoi : Debian garde seul la liste de ses logiciels et de ses comptes. Cela ne contient PAS vos documents ni vos photos.${NL}${NL}🔌 Disques externes branchés (clé, disque USB) : $EXT${NL}   Pourquoi : une sauvegarde doit être sur un autre support que l'ordinateur ; sur le même disque, elle disparaît avec lui."
}
T_O2() {
O="$O${NL}${NL}🗄️ Dernière sauvegarde Borg (Pika Backup) sur un support branché : ${BRD:-$T_NOBR}${NL}   Pourquoi : Pika Backup range ses copies dans un dépôt Borg. DMP retrouve ce dépôt s'il est sur un disque ou une clé branché et lit la date de la dernière copie (le contenu, chiffré, reste illisible)."
}
T_RX() {
case $ST in
old) R="Dernière sauvegarde ancienne ($BRD) : à surveiller"; X="La dernière copie date de $BAGE jours. Plus elle est ancienne, plus vous perdez de travail en cas de panne. Lancez une sauvegarde Pika et programmez-la (au minimum une par semaine).";;
recent) R="Sauvegarde récente trouvée ($BRD)"; X="Une copie Pika Backup date de $BAGE jour(s) : vos fichiers sont protégés. Branchez le support de temps en temps pour que DMP puisse la vérifier.";;
none) R="Aucune sauvegarde de vos fichiers : à surveiller"; X="DMP ne trouve ni outil ni copie de vos documents. Règle simple : trois copies, sur deux supports différents, dont une ailleurs. Pour commencer : sudo apt install timeshift (copies du système), puis copiez vos documents sur un disque externe avec rsync.";;
tool) R="Outil installé, aucune copie trouvée : à surveiller"; X="Un outil sans copie ne protège rien. Lancez une première sauvegarde et programmez-la.";;
*) R="Sauvegarde du système présente"; X="Un instantané existe. Vérifiez aussi que vos documents personnels sont copiés sur un autre support.";;
esac
}
