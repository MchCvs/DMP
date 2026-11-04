# Verdicts ⛔ / 🟠 (B8 services lents, C2 paquets lourds) — FR / EN / DE
case ${LG:-fr} in
en) V_STOP="⛔ Keep: essential to the system. Do not disable or remove."
    V_JUDGE="🟠 Your call: useful depending on your use or hardware. Check before touching it."
    V_LEG="Legend: ⛔ keep · 🟠 your call, depending on what you use"
    V_FW="The firmware is stored on the motherboard: it cannot be uninstalled and has nothing to do with Debian. Only a BIOS/UEFI setting (fast boot, disk order) can shorten this step." ;;
de) V_STOP="⛔ Behalten: für das System unverzichtbar. Weder deaktivieren noch entfernen."
    V_JUDGE="🟠 Nicht verändern, ohne genau zu wissen, was Sie tun: Das Deaktivieren dieses Dienstes kann den Systemstart, ein Update oder die Anzeige beeinträchtigen. Wenn Sie unsicher sind, behalten Sie ihn aktiviert."
    V_LEG="Legende: ⛔ behalten · 🟠 Ihre Entscheidung, je nach Nutzung"
    V_FW="Die Firmware ist auf der Hauptplatine gespeichert: Sie lässt sich nicht deinstallieren und hat nichts mit Debian zu tun. Nur eine BIOS/UEFI-Einstellung (Schnellstart, Festplattenreihenfolge) kann diesen Schritt verkürzen." ;;
*)  V_STOP="$(tr_cle verdict.stop)"
    V_JUDGE="$(tr_cle verdict.judge)"
    V_LEG="$(tr_cle verdict.leg)"
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
    gnome-software) r="$(tr_cle verdict.role.gnome_software)";;
    mutter*) r="$(tr_cle verdict.role.mutter)";;
    xdg-desktop-portal*) r="$(tr_cle verdict.role.xdg_desktop_portal)";;
    evolution-alarm*) r="$(tr_cle verdict.role.evolution_alarm)";;
    evolution-source*) r="$(tr_cle verdict.role.evolution_source)";;
    *Utility*|*utility*) r="$(tr_cle verdict.role.utility_utility)";;
    containerd|containerd.io|runc) r="$(tr_cle verdict.role.containerd_containerd_io_runc)|Container-Laufzeit (von Docker und manchen Programmen genutzt). Dieses Dienstprogramm zu entfernen kann Docker oder davon abhängige Programme beschädigen.";;
    code|code-*) r="$(tr_cle verdict.role.code_code)|Code-Editor (Visual Studio Code)";;
    linux-image*) r="$(tr_cle verdict.role.linux_image)|Linux-Kernel, Kern des Systems";;
    linux-headers*|linux-kbuild*|linux-compiler*) r="$(tr_cle verdict.role.linux_headers_linux_kbuild_linux_compiler)|Dateien zum Kompilieren von Kernel-Modulen";;
    libreoffice*) r="$(tr_cle verdict.role.libreoffice)|Office-Paket";;
    firefox*|chromium*) r="$(tr_cle verdict.role.firefox_chromium)|Webbrowser";;
    thunderbird*) r="$(tr_cle verdict.role.thunderbird)|E-Mail-Programm";;
    firmware-*) r="$(tr_cle verdict.role.firmware)|Firmware für Hardware (WLAN, Grafikkarte …)";;
    libllvm*) r="$(tr_cle verdict.role.libllvm)|Compiler-Bibliothek für Grafiktreiber";;
    gimp*) r="$(tr_cle verdict.role.gimp)|Bildbearbeitung";;
    libc6*|libc-bin) r="$(tr_cle verdict.role.libc6_libc_bin)|C-Standardbibliothek, Basis des Systems";;
    python3*|libpython3*) r="$(tr_cle verdict.role.python3_libpython3)|Programmiersprache Python und Bibliotheken";;
    mesa*|libgl*|libegl*|libdrm*) r="$(tr_cle verdict.role.mesa_libgl_libegl_libdrm)|3D-Grafikbibliotheken";;
    fonts-*) r="$(tr_cle verdict.role.fonts)|Schriftarten";;
    locales*) r="$(tr_cle verdict.role.locales)|Sprachen und Regionalformate";;
    libgtk*|libqt*) r="$(tr_cle verdict.role.libgtk_libqt)|Bibliothek für grafische Oberflächen";;
    systemd*|libsystemd*) r="$(tr_cle verdict.role.systemd_libsystemd)|Dienstverwaltung des Systems";;
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

# Conclusion de B8 : remplace X selon la durée totale (TT) et l'étape la plus longue (BIGC)
vx() {
  local L=${LG:-fr} N A S
  case "$L:$BIGC" in
    en:fw) N="the firmware (BIOS/UEFI)";; en:loader) N="the bootloader";; en:kernel) N="kernel loading";; en:*) N="service startup";;
    de:fw) N="die Firmware (BIOS/UEFI)";; de:loader) N="der Bootloader";; de:kernel) N="das Laden des Kernels";; de:*) N="der Start der Dienste";;
    *:fw) N="le firmware (BIOS/UEFI)";; *:loader) N="le chargeur de démarrage";; *:kernel) N="le chargement du noyau";; *) N="le lancement des services";;
  esac
  case "$L" in
  en) if [ "$TT" -lt 30 ]; then X="Under 30 seconds is a good result: nothing to improve. The longest step is $N."; return; fi
      if [ "$TT" -lt 60 ]; then X="Between 30 and 60 seconds is acceptable. The longest step is $N."
      else X="Beyond one minute, something is slowing down startup. The longest step is $N. Look at the 8 slowest services and check the disk health (Disk page B4): a tired disk is a common cause."; fi
      case $BIGC in
        fw) X="$X It depends on your machine, not on Debian: the firmware cannot be uninstalled. Only a BIOS/UEFI setting (fast boot, disk order) can shorten it.";;
        loader) X="$X Shortening the wait in the boot menu (GRUB) would shorten this step.";;
        svc) X="$X To save time among the slow services above, only those marked 🟠 can be disabled if you do not use them; those marked ⛔ must be kept.";;
      esac;;
  de) if [ "$TT" -lt 30 ]; then X="Unter 30 Sekunden ist ein gutes Ergebnis: nichts zu verbessern. Der längste Schritt ist $N."; return; fi
      if [ "$TT" -lt 60 ]; then X="Zwischen 30 und 60 Sekunden ist akzeptabel. Der längste Schritt ist $N."
      else X="Über einer Minute verzögert etwas den Systemstart. Der längste Schritt ist $N. Sehen Sie sich die 8 langsamsten Dienste an und prüfen Sie den Zustand der Festplatte (Seite Festplatte B4): Eine ermüdete Festplatte ist eine häufige Ursache."; fi
      case $BIGC in
        fw) X="$X Er hängt von Ihrem Rechner ab, nicht von Debian: Die Firmware lässt sich nicht deinstallieren. Nur eine BIOS/UEFI-Einstellung (Schnellstart, Festplattenreihenfolge) kann ihn verkürzen.";;
        loader) X="$X Eine kürzere Wartezeit im Startmenü (GRUB) würde diesen Schritt verkürzen.";;
        svc) X="$X Um Zeit zu sparen: Die oben genannten langsamen Dienste sollten nicht leichtfertig deaktiviert werden: Nehmen Sie keine Änderungen an einem Dienst vor, ohne dessen Funktion verstanden zu haben.";;
      esac;;
  *)  if [ "$TT" -lt 30 ]; then X="Moins de 30 secondes est un bon résultat : rien à améliorer. Le plus long est $N."; return; fi
      if [ "$TT" -lt 60 ]; then X="Entre 30 et 60 secondes est acceptable. L'étape la plus longue est $N."
      else X="Au-delà d'une minute, quelque chose retarde le démarrage. L'étape la plus longue est $N. Regardez les 8 services les plus lents, et vérifiez la santé du disque (page Disque B4) : un disque fatigué est une cause fréquente."; fi
      case $BIGC in
        fw) X="$X Elle dépend de votre machine, pas de Debian : le firmware ne se désinstalle pas. Seul un réglage du BIOS/UEFI (démarrage rapide, ordre des disques) peut la raccourcir.";;
        loader) X="$X Réduire l'attente du menu de démarrage (GRUB) raccourcirait cette étape.";;
        svc) X="$X Les services lents ci-dessus ne sont pas à désactiver à la légère : ne touchez à aucun service sans avoir compris son rôle. Le temps de démarrage se gagne surtout par les mises à jour et le matériel, pas en retirant des services.";;
      esac;;
  esac
}
