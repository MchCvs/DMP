# Verdicts ⛔ / 🟠 (B8 services lents, C2 paquets lourds) — FR / EN / DE
case ${LG:-fr} in
en) V_STOP="⛔ Keep: essential to the system. Do not disable or remove."
    V_JUDGE="🟠 Your call: useful depending on your use or hardware. Check before touching it."
    V_LEG="Legend: ⛔ keep · 🟠 your call, depending on what you use"
    V_FW="The firmware is stored on the motherboard: it cannot be uninstalled and has nothing to do with Debian. Only a BIOS/UEFI setting (fast boot, disk order) can shorten this step." ;;
de) V_STOP="⛔ Behalten: für das System unverzichtbar. Weder deaktivieren noch entfernen."
    V_JUDGE="🟠 Ihre Entscheidung: je nach Nutzung oder Hardware nützlich. Vor Änderungen prüfen."
    V_LEG="Legende: ⛔ behalten · 🟠 Ihre Entscheidung, je nach Nutzung"
    V_FW="Die Firmware ist auf der Hauptplatine gespeichert: Sie lässt sich nicht deinstallieren und hat nichts mit Debian zu tun. Nur eine BIOS/UEFI-Einstellung (Schnellstart, Festplattenreihenfolge) kann diesen Schritt verkürzen." ;;
*)  V_STOP="⛔ À garder : indispensable au système. Ne pas désactiver ni retirer."
    V_JUDGE="🟠 À vous de juger : utile selon votre usage ou votre matériel. Vérifiez avant d'y toucher."
    V_LEG="Légende : ⛔ à garder · 🟠 à vous de juger selon ce que vous utilisez"
    V_FW="Le firmware est inscrit sur la carte mère : il ne se désinstalle pas et n'a rien à voir avec Debian. Seul un réglage du BIOS/UEFI (démarrage rapide, ordre des disques) peut raccourcir cette étape." ;;
esac
vsvc() { case "$1" in
  NetworkManager-wait-online*|plymouth*|apt*|udisks2*|fwupd*|ModemManager*|cups*|bluetooth*|systemd-udev-settle*) echo judge;;
  *) echo stop;; esac; }
vpkg() { case "$1" in
  linux-image*|linux-base*|libc6*|libc-bin|systemd*|libsystemd*|udev|dpkg|apt|apt-*|bash|coreutils|util-linux|grub*|initramfs-tools*|libssl*|openssl|libgl*|libegl*|libllvm*|mesa-*|libdrm*|xserver-xorg*|xorg*|libx11*|libgtk*|libqt*|libpython3*|python3|python3.*|perl|perl-base|perl-modules*|libstdc++*|libgcc*|network-manager|networkmanager*|gnome-shell*|plasma-desktop*|kde-plasma*) echo stop;;
  *) echo judge;; esac; }
vline() { local k; if [ "$1" = svc ]; then k=$(vsvc "$2"); else k=$(vpkg "$2"); fi
  if [ "$k" = stop ]; then echo "$V_STOP"; else echo "$V_JUDGE"; fi; }
