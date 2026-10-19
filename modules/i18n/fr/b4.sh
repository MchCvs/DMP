# Textes français du collecteur b4. Ne modifier que le texte.
T_COMP="Cette page montre combien chaque espace de rangement de votre ordinateur est rempli, et à quoi il sert."
T_CMD="lsblk, df -h"
T_K() {
case $KT in
usb) K="support USB amovible (une clé USB est en mémoire flash, sans pièce mobile ; un disque dur externe contient un plateau qui tourne, et DMP ne peut pas les distinguer par cette voie)";;
ssd) K="SSD (sans pièce mobile : rapide, silencieux, résistant aux chocs)";;
*) K="disque dur mécanique (un plateau tourne : plus lent, et il s'use avec les années)";;
esac
}
T_DISK() { D="$D${NL}💽 Disque « $n » : ${m:-modèle inconnu}${NL}   • Capacité : $s${NL}   • Type : $K${NL}"; }
T_NOHEALTH() { T="   ℹ️ État non lisible. Pourquoi : l'outil de lecture (smartmontools) n'a pas l'autorisation, ou c'est une clé USB ou un disque virtuel, qui n'ont en général pas de capteurs de santé lisibles."; }
T_SAD() { SA="$SA${NL}🩺 Disque « $dk »${NL}$T${NL}"; }
T_FS() {
case "$f" in
ext4|ext3) FS="ext4, le format habituel de Linux : fiable et rapide";;
vfat) FS="FAT32, un format simple compris par tous les systèmes (Windows, Linux, appareils photo)";;
ntfs|fuseblk) FS="NTFS, le format de Windows";;
exfat) FS="exFAT, un format pour clés et disques externes, compris par Windows, Mac et Linux";;
btrfs) FS="Btrfs, un format moderne de Linux avec instantanés";;
*) FS="$f";;
esac
}
T_RO() {
case "$tg" in
/) RO="Partition système : elle contient Debian, tous les programmes installés et, si rien d'autre n'est prévu, vos fichiers. Pourquoi c'est important : si elle est pleine, l'ordinateur ne peut plus fonctionner correctement.";;
/boot) RO="Partition de démarrage : elle contient le noyau, le cœur du système lancé à l'allumage. Pourquoi c'est important : petite par nature, si elle est pleine les mises à jour du noyau échouent.";;
/boot/efi) RO="Partition de lancement (UEFI) : minuscule, elle permet à l'ordinateur de trouver et de démarrer Debian quand on l'allume. Pourquoi c'est important : sans elle, l'ordinateur ne démarre pas. Il est normal qu'elle soit petite : n'y touchez pas.";;
/home) RO="Partition personnelle : vos documents, photos, téléchargements et réglages. Pourquoi elle est séparée : on peut réinstaller ou changer de système sans perdre vos fichiers.";;
/media/*|/run/media/*) RO="Support amovible (clé USB ou disque externe) actuellement branché. Pourquoi c'est important : retirez-le toujours proprement (clic droit, « Éjecter ») avant de le débrancher, sinon des fichiers peuvent être perdus.";;
/mnt/*) RO="Disque ajouté manuellement à cet endroit. Il sert à stocker des fichiers en plus, comme un second meuble de rangement.";;
*) RO="Partition montée à cet endroit pour un usage particulier du système ou d'un programme.";;
esac
}
T_PART() { P="$P${NL}🗂️ $tg  ($s)${NL}   • Occupation : $p ($u utilisés, $a libres)${NL}   • Format : $FS${NL}   • Emplacement physique : $s${NL}   • Rôle : $RO${NL}"; }
T_O() {
O="Un disque est l'objet physique. Il est découpé en parties appelées partitions, comme une armoire séparée en tiroirs : chaque partition a son rôle, et l'ordinateur les utilise séparément. Pourquoi ce découpage : séparer le système de vos fichiers rend l'ensemble plus sûr et plus facile à réparer.${NL}${NL}══ $ND disque(s) physique(s) ══$D${NL}══ État de santé des disques ══$SA${NL}══ Partitions utilisées en ce moment ══$P"
case $WL in
2) R="Une partition est presque pleine : à libérer vite"; X="Au-dessus de 90 %, l'ordinateur ralentit et risque de ne plus pouvoir enregistrer. Libérez de la place maintenant.";;
1) R="Une partition se remplit : à surveiller"; X="Au-delà de 75 %, pensez à supprimer ou déplacer des fichiers volumineux (vidéos, téléchargements).";;
*) R="Espace largement suffisant"; X="Aucune partition n'est proche d'être pleine, vous pouvez continuer sans souci.";;
esac
[ $HN -ge 2 ] && { R="Un disque montre des signes de défaillance : sauvegardez vos fichiers maintenant"; X="$X Les signes relevés dans la section santé indiquent un vrai risque de panne : copiez vos fichiers importants sur un autre support dès aujourd'hui."; }
[ $HN -eq 1 ] && [ $WL -lt 2 ] && { R="Un disque est à surveiller"; X="$X Un indicateur de santé est à surveiller : faites une sauvegarde de vos fichiers importants par précaution."; }
}
