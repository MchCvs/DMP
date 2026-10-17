#!/bin/bash
source "$(dirname "$0")/lib.sh"; NL=$'\n'; export LC_ALL=C
L=$(systemd-analyze 2>/dev/null | head -1)
[ -z "$L" ] && { j "Cette page mesure le temps que met votre ordinateur à démarrer, de l'appui sur le bouton jusqu'au bureau prêt." "La mesure n'est pas disponible. Pourquoi : l'outil systemd-analyze est absent, ou le démarrage n'est pas terminé." "Mesure indisponible" "systemd-analyze"; exit; }
eval "$(python3 - "$L" <<'P'
import re,sys
l=sys.argv[1]
def sec(t):
    s=0
    for v,u in re.findall(r'([\d.]+)(min|ms|us|s)',t):
        v=float(v); s+=v*60 if u=="min" else v/1000 if u=="ms" else v/1e6 if u=="us" else v
    return s
body=l.split(" in ",1)[-1]; parts=body.split("=")[0].split("+"); d={"firmware":0,"loader":0,"kernel":0,"initrd":0,"userspace":0}
for p in parts:
    m=re.search(r'(.*)\((\w+)\)',p)
    if m and m.group(2) in d: d[m.group(2)]=sec(m.group(1))
m=re.search(r'=\s*(.+)$',l); d["total"]=sec(m.group(1)) if m else sum(d.values())
for k,v in d.items(): print(f'{k}={v:.1f}')
P
)"
BL=$(systemd-analyze blame --no-pager 2>/dev/null | head -8)
desc(){ case "$1" in
 NetworkManager-wait-online*) echo "attend que le réseau soit prêt avant de continuer. Souvent le plus long, sans gravité : il ne bloque que ce qui a besoin d'internet.";;
 plymouth*) echo "affiche l'écran de démarrage (logo ou animation).";;
 apt-daily*|apt*) echo "vérifie s'il existe des mises à jour.";;
 udisks2*) echo "gère les disques et clés USB branchés.";;
 fwupd*) echo "gère les mises à jour du matériel (BIOS, périphériques).";;
 ModemManager*) echo "gère les modems 3G/4G, inutile sans clé mobile.";;
 cups*) echo "prépare l'impression.";;
 bluetooth*) echo "prépare le Bluetooth.";;
 accounts-daemon*) echo "gère la liste des comptes utilisateurs.";;
 gdm*|lightdm*|sddm*) echo "prépare l'écran de connexion.";;
 dev-*.device) echo "attend qu'un disque ou une partition soit prêt.";;
 systemd-journal-flush*) echo "transfère le journal des événements vers le disque.";;
 systemd-udev-settle*) echo "attend que tout le matériel soit détecté : service lent par nature.";;
 e2scrub*|fstrim*) echo "entretien des disques.";;
 *) echo "service du système lancé au démarrage.";; esac; }
BLT=""; i=0
while read -r t n; do [ -z "$n" ] && continue; i=$((i+1)); BLT="$BLT${NL}$i) $n : $t${NL}   • Rôle : $(desc "$n")${NL}"; done <<< "$BL"
dev=$(lsblk -no PKNAME "$(findmnt -no SOURCE /)" 2>/dev/null | head -1); DK=""
if [ -n "$dev" ] && [ -r /sys/block/$dev/queue/rotational ]; then [ "$(cat /sys/block/$dev/queue/rotational)" = 0 ] && DK="Votre disque système est un SSD : c'est l'un des meilleurs atouts pour démarrer vite." || DK="Votre disque système est un disque dur mécanique : c'est la première cause d'un démarrage lent. Un SSD diviserait le temps par 3 ou 4."; fi
if [ "$firmware" = 0.0 ]; then FW="non mesurable (normal sur certaines machines ou en machine virtuelle)"; else FW="${firmware} s"; fi
KP=$(awk -v k=$kernel -v i=$initrd 'BEGIN{printf "%.1f",k+i}'); TT=${total%.*}
BIG=$(awk -v a=$firmware -v b=$loader -v c=$KP -v d=$userspace 'BEGIN{m=a;n="le firmware";if(b>m){m=b;n="le chargeur de démarrage"};if(c>m){m=c;n="le chargement du noyau"};if(d>m){m=d;n="le lancement des services"};print n}')
DB=$(uptime -s)
O="Démarrer un ordinateur se fait en 5 étapes, comme préparer un restaurant avant l'ouverture. Chacune est mesurée ici. Pourquoi cette page : un démarrage qui s'allonge avec le temps signale un système encombré ou un disque qui vieillit.${NL}${NL}⏱️ Démarrage du $DB : ${total} s au total${NL}${NL}1) 🔌 Firmware (BIOS/UEFI) : $FW${NL}   • Rôle : le tout premier programme, inscrit sur la carte mère. Il vérifie que le matériel est présent (mémoire, processeur, disque).${NL}   • Pourquoi : cette étape ne dépend pas de Debian, seulement de votre machine.${NL}${NL}2) 🚪 Chargeur de démarrage (GRUB) : ${loader} s${NL}   • Rôle : il propose, si besoin, un choix de système puis lance Debian.${NL}   • Pourquoi : un menu qui attend longtemps une réponse allonge cette étape.${NL}${NL}3) 🫀 Chargement du noyau : ${KP} s (noyau ${kernel} s + préparation initiale ${initrd} s)${NL}   • Rôle : le noyau (kernel) est le cœur de Debian : il parle directement au matériel. Il se charge en mémoire, détecte les composants, puis une phase préparatoire (initrd) active les pilotes nécessaires pour accéder au disque.${NL}   • Pourquoi : cette étape dépend surtout de la vitesse du disque et du nombre de composants à reconnaître.${NL}${NL}4) 🧩 Services et bureau : ${userspace} s${NL}   • Rôle : tous les petits programmes de fond (réseau, son, impression, écran de connexion) démarrent ici, jusqu'à l'apparition du bureau.${NL}   • Pourquoi : c'est l'étape la plus variable, car plus vous avez de services, plus elle est longue.${NL}${NL}🐢 Les 8 services les plus lents${NL}   Pourquoi : ils montrent ce qui retarde l'étape 4. Un service lent n'est pas forcément un problème : plusieurs démarrent en même temps.${NL}$BLT${NL}💽 $DK"
if [ "$TT" -lt 30 ]; then R="Démarrage rapide"; X="Moins de 30 secondes est un bon résultat : rien à améliorer. Le plus long est $BIG."
elif [ "$TT" -lt 60 ]; then R="Démarrage correct"; X="Entre 30 et 60 secondes est acceptable. L'étape la plus longue est $BIG : c'est là qu'on gagnerait du temps. Si l'un des services lents ci-dessus ne vous sert pas, il peut être désactivé."
else R="Démarrage lent"; X="Au-delà d'une minute, quelque chose retarde le démarrage. L'étape la plus longue est $BIG. Regardez les 8 services les plus lents, et vérifiez la santé du disque (page Disque B4) : un disque fatigué est une cause fréquente."; fi
export X; j "Cette page mesure combien de temps votre ordinateur met à démarrer, de l'appui sur le bouton jusqu'au bureau prêt, et ce qui prend du temps." "$O" "$R" "systemd-analyze, systemd-analyze blame (DMP uniquement)"
