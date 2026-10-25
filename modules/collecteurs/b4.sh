#!/bin/bash
source "$(dirname "$0")/lib.sh"; NL=$'\n'
D=""; ND=0
while read -r n s r ty m; do [ "$ty" = disk ] || continue; [[ "$n" == zram* ]] && continue
 RMV=$(cat /sys/block/$n/removable 2>/dev/null); TR=$(lsblk -dno TRAN /dev/$n 2>/dev/null)
 if [ "$RMV" = 1 ] || [ "$TR" = usb ]; then K="support USB amovible (peut être une clé USB sans pièces mobiles ou un disque dur externe avec un plateau qui tourne ; DMP ne peut pas les distinguer)"; elif [ "$r" = 0 ]; then K="SSD (sans pièce mobile : rapide, silencieux, résistant aux chocs)"; else K="disque dur mécanique (un plateau tourne : plus lent, et il s'use avec les années)"; fi
 ND=$((ND+1)); D="$D${NL}💽 Disque « $n » : ${m:-modèle inconnu}${NL}   • Capacité : $s${NL}   • Type : $K${NL}"; done < <(LC_ALL=C lsblk -dno NAME,SIZE,ROTA,TYPE,MODEL)
SA=""; HN=0
for dk in $(LC_ALL=C lsblk -dno NAME,TYPE | awk '$2=="disk" && $1!~/^zram/{print $1}'); do
 T=$(python3 "$(dirname "$0")/sante.py" "$dk"); c=$?
 if [ $c -eq 3 ]; then T="   ℹ️ État non lisible. Pourquoi : l'outil de lecture (smartmontools) n'a pas l'autorisation, ou c'est une clé USB ou un disque virtuel, qui n'ont en général pas de capteurs de santé lisibles."; elif [ $c -gt $HN ]; then HN=$c; fi
 SA="$SA${NL}🩺 Disque « $dk »${NL}$T${NL}"
done
P=""; W=0
while read -r s f t u a p tg; do n=${p%\%}; [ "$n" -gt "$W" ] && W=$n
 case "$f" in ext4|ext3) FS="ext4, le format habituel de Linux : fiable et rapide";; vfat) FS="FAT32, un format simple compris par tous les systèmes (Windows, Linux, appareils photo)";; ntfs|fuseblk) FS="NTFS, le format de Windows";; exfat) FS="exFAT, un format pour clés et disques externes, compris par Windows, Mac et Linux";; btrfs) FS="Btrfs, un format moderne de Linux avec instantanés";; *) FS="$f";; esac
 case "$tg" in
 /) RO="Partition système : elle contient Debian, tous les programmes installés et, si rien d'autre n'est prévu, vos fichiers. Pourquoi c'est important : si elle est pleine, l'ordinateur ne peut plus fonctionner correctement.";;
 /boot) RO="Partition de démarrage : elle contient le noyau, le cœur du système lancé à l'allumage. Pourquoi c'est important : petite par nature, si elle est pleine les mises à jour du noyau échouent.";;
 /boot/efi) RO="Partition de lancement (UEFI) : minuscule, elle permet à l'ordinateur de trouver et de démarrer Debian quand on l'allume. Pourquoi c'est important : sans elle, l'ordinateur ne démarre pas. Il est normal qu'elle soit petite : n'y touchez pas.";;
 /home) RO="Partition personnelle : vos documents, photos, téléchargements et réglages. Pourquoi elle est séparée : on peut réinstaller ou changer de système sans perdre vos fichiers.";;
 /media/*|/run/media/*) RO="Support amovible (clé USB ou disque externe) actuellement branché. Pourquoi c'est important : retirez-le toujours proprement (clic droit, « Éjecter ») avant de le débrancher, sinon des fichiers peuvent être perdus.";;
 /mnt/*) RO="Disque ajouté manuellement à cet endroit. Il sert à stocker des fichiers en plus, comme un second meuble de rangement.";;
 *) RO="Partition montée à cet endroit pour un usage particulier du système ou d'un programme.";; esac
 P="$P${NL}🗂️ $tg  ($s)${NL}   • Occupation : $p ($u utilisés, $a libres)${NL}   • Format : $FS${NL}   • Emplacement physique : $s${NL}   • Rôle : $RO${NL}"
done < <(LC_ALL=C df -h --output=source,fstype,size,used,avail,pcent,target -x tmpfs -x devtmpfs -x squashfs -x efivarfs -x overlay | tail -n +2)
O="Un disque est l'objet physique. Il est découpé en parties appelées partitions, comme une armoire séparée en tiroirs : chaque partition a son rôle, et l'ordinateur les utilise séparément. Pourquoi ce découpage : séparer le système de vos fichiers rend l'ensemble plus sûr et plus facile à réparer.${NL}${NL}══ $ND disque(s) physique(s) ══$D${NL}══ État de santé des disques ══$SA${NL}══ Partitions utilisées en ce moment ══$P"
R="Espace largement suffisant"; X="Aucune partition n'est proche d'être pleine, vous pouvez continuer sans souci."
[ $W -ge 75 ] && { R="Une partition se remplit : à surveiller"; X="Au-delà de 75 %, pensez à supprimer ou déplacer des fichiers volumineux (vidéos, téléchargements)."; }
[ $W -ge 90 ] && { R="Une partition est presque pleine : à libérer vite"; X="Au-dessus de 90 %, l'ordinateur ralentit et risque de ne plus pouvoir enregistrer. Libérez de la place maintenant."; }
[ $HN -ge 2 ] && { R="Un disque montre des signes de défaillance : sauvegardez vos fichiers maintenant"; X="$X Les signes relevés dans la section santé indiquent un vrai risque de panne : copiez vos fichiers importants sur un autre support dès aujourd'hui."; }
[ $HN -eq 1 ] && [ $W -lt 90 ] && { R="Un disque est à surveiller"; X="$X Un indicateur de santé est à surveiller : faites une sauvegarde de vos fichiers importants par précaution."; }
NV=0; { [ $W -ge 75 ] || [ $HN -eq 1 ]; } && NV=1; { [ $W -ge 90 ] || [ $HN -ge 2 ]; } && NV=2; dmp_niveau $NV
export X; j "Cette page montre combien chaque espace de rangement de votre ordinateur est rempli, et à quoi il sert." "$O" "$R" "lsblk, df -h"
