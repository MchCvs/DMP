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

# Rôle d'un paquet : la description Debian est en anglais ; on la traduit pour les paquets courants
vrole() {
  local p="$1" s="$2" r=""
  [ "${LG:-fr}" = en ] && { echo "$s"; return; }
  local L=${LG:-fr}; [ "$L" = de ] || L=fr
  case "$p" in
    code|code-*) r="éditeur de code (Visual Studio Code)|Code-Editor (Visual Studio Code)";;
    linux-image*) r="noyau Linux, cœur du système|Linux-Kernel, Kern des Systems";;
    linux-headers*|linux-kbuild*|linux-compiler*) r="fichiers pour compiler des modules du noyau|Dateien zum Kompilieren von Kernel-Modulen";;
    libreoffice*) r="suite bureautique|Office-Paket";;
    firefox*|chromium*) r="navigateur web|Webbrowser";;
    thunderbird*) r="messagerie|E-Mail-Programm";;
    firmware-*) r="microprogrammes pour le matériel (Wi-Fi, carte graphique…)|Firmware für Hardware (WLAN, Grafikkarte …)";;
    libllvm*) r="bibliothèque de compilation utilisée par les pilotes graphiques|Compiler-Bibliothek für Grafiktreiber";;
    gimp*) r="retouche d'images|Bildbearbeitung";;
    libc6*|libc-bin) r="bibliothèque C standard, base du système|C-Standardbibliothek, Basis des Systems";;
    python3*|libpython3*) r="langage Python et ses bibliothèques|Programmiersprache Python und Bibliotheken";;
    mesa*|libgl*|libegl*|libdrm*) r="bibliothèques graphiques 3D|3D-Grafikbibliotheken";;
    fonts-*) r="polices de caractères|Schriftarten";;
    locales*) r="langues et formats régionaux|Sprachen und Regionalformate";;
    libgtk*|libqt*) r="bibliothèque d'interface graphique|Bibliothek für grafische Oberflächen";;
    systemd*|libsystemd*) r="gestionnaire de services du système|Dienstverwaltung des Systems";;
    gnome*|kde*|plasma*) r="environnement de bureau|Desktop-Umgebung";;
    nvidia*) r="pilote de carte graphique NVIDIA|NVIDIA-Grafiktreiber";;
    qemu*|virtualbox*) r="machines virtuelles|virtuelle Maschinen";;
  esac
  if [ -n "$r" ]; then
    if [ "$L" = de ]; then echo "${r#*|}"; else echo "${r%%|*}"; fi
  else
    if [ "$L" = de ]; then echo "$s (auf Englisch)"; else echo "$s (en anglais)"; fi
  fi
}
