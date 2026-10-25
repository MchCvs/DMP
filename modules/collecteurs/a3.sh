#!/bin/bash
source "$(dirname "$0")/lib.sh"; NL=$'\n'; export LC_ALL=C
read S U A P <<< $(df -h --output=size,used,avail,pcent / | tail -1); NP=${P%\%}; SG=$(df -BG --output=size / | tail -1 | tr -dc 0-9)
D=""; N=0
while read -r n s r ty m; do [ "$ty" = disk ] || continue; [[ "$n" == zram* ]] && continue; N=$((N+1))
 G=$(awk -v b=$s 'BEGIN{printf "%.1f",b/1e9}'); RMV=$(cat /sys/block/$n/removable 2>/dev/null); TR=$(lsblk -dno TRAN /dev/$n 2>/dev/null)
 if [ "$RMV" = 1 ] || [ "$TR" = usb ]; then K="support USB amovible (peut être une clé USB en mémoire flash ou un disque dur externe ; DMP ne peut pas les distinguer)"; elif [ "$r" = 0 ]; then K="SSD (sans pièce mobile : rapide, silencieux, résistant aux chocs)"; else K="disque dur mécanique (un plateau tourne : plus lent, il s'use avec les années)"; fi
 PT=""; while read -r pn ps pf pm; do [ -z "$pm" ] && continue; u=$(df -h --output=used,pcent "$pm" 2>/dev/null | tail -1 | awk '{print $1" ("$2")"}'); PT="$PT${NL}   • Partition $pn ($ps, $pf) montée sur $pm : $u utilisé"; done < <(lsblk -nrpo NAME,SIZE,FSTYPE,MOUNTPOINT /dev/$n | tail -n +2)
 D="$D${NL}${NL}💽 Disque $N : « $n » — ${m:-modèle inconnu}${NL}   • Capacité : $G Go${NL}   • Type : $K$PT"
done < <(lsblk -dnbo NAME,SIZE,ROTA,TYPE,MODEL)
if [ $SG -ge 500 ]; then SU="Cette capacité est largement suffisante pour documents, photos et de nombreux films. Seuls les jeux lourds ou la vidéo 4K en grande quantité pourraient la remplir, car ces fichiers sont très volumineux."; elif [ $SG -ge 200 ]; then SU="Cette capacité est suffisante pour un usage courant, mais photos et vidéos la remplissent vite : surveillez l'espace restant."; else SU="Cette capacité est limitée : photos et vidéos la rempliront vite, pensez à un disque externe."; fi
P_display=$([ "$P" = "non lu" ] && echo "non lisible" || echo "occupé à $P")
O="...${NL}🏠 Disque principal (celui du système) : capacité $S, $P_display ($U utilisés, $A libres)${NL}..."
R="Espace suffisant"; [ $NP -ge 75 ] && R="Espace à surveiller"; [ $NP -ge 90 ] && R="Disque principal presque plein : à libérer rapidement"
NV=0; [ $NP -ge 75 ] && NV=1; [ $NP -ge 90 ] && NV=2; dmp_niveau $NV
export X="$SU"; j "Les disques sont les armoires de votre ordinateur : c'est là que tout est rangé de façon permanente." "$O" "$R" "lsblk, df -h"
