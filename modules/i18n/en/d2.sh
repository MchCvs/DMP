# English texts of collector d2. Edit the text only.
T_COMP="Removing means uninstalling software you no longer need. This page shows you the biggest ones, what they are for, and how to remove them safely. Why: a lighter computer starts faster and keeps space for what matters."
T_R="No removal needed"
T_CMD="apt-mark showmanual, dpkg-query"
T_MO="MB"
T_ROLE="Role:"
T_CAN="Can it be removed?"
T_X="DMP removes nothing: this page shows you what, why and how, and you keep the decision. Simple rule for a beginner: do not remove anything here. Not recognising a name does not mean it is useless: the most important parts of the system are precisely the ones you never see. Remove only software whose role you understand (for example a game or an application you installed yourself) AND that you are certain you no longer need."
T_PKG(){ case "$1" in
 linux-image*) echo "The Linux kernel: the heart of Debian. It links the hardware (screen, disk, keyboard) to the programs. Without it, the computer does not start.";;
 linux-headers*|linux-kbuild*|linux-compiler*) echo "Files used to build drivers for the kernel (for example for a graphics card). Mostly useful to advanced users.";;
 firefox*) echo "Firefox: the web browser that displays websites.";;
 chromium*|google-chrome*|brave*) echo "A web browser: it displays websites.";;
 thunderbird*) echo "Thunderbird: the email program.";;
 libreoffice*) echo "LibreOffice: the office suite (word processor, spreadsheet, presentations), a free alternative to Word and Excel.";;
 gimp*) echo "GIMP: photo and image editing, a free alternative to Photoshop.";;
 inkscape*) echo "Inkscape: vector drawing (logos, illustrations that stay sharp at any size).";;
 vlc*|mpv*) echo "Video and music player that plays almost every format.";;
 audacity*) echo "Audacity: sound recording and editing.";;
 kdenlive*|openshot*|shotcut*) echo "Video editing software.";;
 blender*) echo "Blender: creation of 3D images and films.";;
 steam*) echo "Steam: video game store and launcher.";;
 wine*) echo "Wine: lets you run some Windows programs on Linux.";;
 code|codium) echo "Visual Studio Code: an editor for writing programs.";;
 nodejs|npm) echo "Node.js: an environment for running programs written in JavaScript.";;
 openjdk*|default-jre*|default-jdk*) echo "Java: needed to run some software written in Java.";;
 docker*|podman*) echo "Management of “containers”: isolated boxes for running software without touching the rest of the system.";;
 virtualbox*|qemu*) echo "Creation of virtual computers: another system runs in a window.";;
 texlive*) echo "TeX Live: typesetting of scientific documents and books (LaTeX). Very large.";;
 nvidia*|xserver-xorg-video*) echo "Graphics card driver: it lets you use the card at full power.";;
 firmware-*|amd64-microcode|intel-microcode) echo "Firmware: a small program built into a component (Wi-Fi, graphics card, processor) so that it works properly.";;
 task-*) echo "A bundle of software installed at once (desktop, language...). Removing it does not remove the software, only the grouping.";;
 gnome-*|gnome|kde-*|plasma-*|xfce4*) echo "A part of the graphical desktop: windows, menus, icons, settings.";;
 grub*) echo "GRUB: the program that starts Debian when the computer is switched on.";;
 libc6*|systemd|systemd-*) echo "A basic part of the system, essential to almost every program.";;
 python3*|python3-*) echo "Python: a programming language. Several Debian tools use it.";;
 gcc*|g++*|build-essential|make|cmake) echo "Tools for building software from its source code. Useless if you do not program.";;
 git|git-*) echo "Git: version tracking for a programming project.";;
 mariadb*|mysql*|postgresql*) echo "A database manager: it stores large amounts of information in an organised way.";;
 apache2*|nginx*) echo "A web server: it makes websites available on the network.";;
 cups*) echo "Printing management.";;
 ufw) echo "ufw: the firewall; it blocks incoming connections from outside that you have not allowed.";;
 smartmontools) echo "Monitors the health of disks (used by page B4).";;
 locales*|keyboard-configuration|console-setup*) echo "Language and keyboard settings.";;
 esac; }
T_SEC(){ case "$1" in
 libs|libdevel|oldlibs) echo "A library: a piece of code shared by several programs, like a recipe book that several cooks consult. It is installed because another program needs it.";;
 python|perl|interpreters) echo "A module for a programming language, which other programs depend on.";;
 kernel) echo "A part of the kernel (the heart of the system).";;
 fonts) echo "Fonts: they give letters their look on screen and in documents.";;
 doc) echo "Documentation: manuals and help files.";;
 devel|vcs) echo "A programming tool. Useless if you do not create software.";;
 games) echo "A game.";;
 graphics|photo) echo "A photo, drawing or image program.";;
 video|sound|libs/multimedia) echo "A video or sound program.";;
 web|net|mail|httpd) echo "A program for the internet or the network.";;
 admin|utils|shells|misc) echo "A system maintenance tool or a utility.";;
 x11|gnome|kde|xfce) echo "A part of the graphical desktop: windows, menus, icons.";;
 editors|text) echo "An editor or a text tool.";;
 science|math) echo "A scientific or calculation program.";;
 database) echo "A database manager.";;
 *) echo "A program installed on your computer (category: $1). For its official description, type “apt show program_name” (in English).";;
 esac; }
T_SU(){ local p="$1" pri="$2"; case "$p" in
 linux-image*) echo "⛔ NO: without a kernel the computer does not start. Debian keeps the old one as a backup, let it do so.";;
 grub*) echo "⛔ NO: GRUB starts Debian when you switch on. Removing it can make the computer impossible to start and block future kernel updates.";;
 intel-microcode|amd64-microcode) echo "⛔ NO: at startup it fixes processor security flaws (Spectre type). Without it the computer starts, but these flaws stay open.";;
 firmware-*) echo "⛔ NO: it is the internal program a component needs to work (graphics, Wi-Fi...). Without it: degraded or black screen, unusable component.";;
 locales*) echo "⛔ NO: it handles language, accents and dates. Without it: error messages, broken characters, and many programs stop working.";;
 systemd*|libc6*|apt|dpkg|bash|coreutils|sudo|initramfs-tools*|xserver*|network-manager*|tzdata|ca-certificates|keyboard-configuration|console-setup*|ufw) echo "⛔ NO: basic part of the system, other software depends on it. Removing it can stop the computer from working.";;
 *) case $pri in required|important) echo "⛔ NO: the system needs it to work.";; *) echo "🟠 Leave it, unless you know exactly what it is for and are certain you do not need it. An unknown name is NOT a reason to remove it: many useful programs are invisible.";; esac;;
 esac; }
T_O() {
O="🗑️ Removing software means uninstalling it to free up space and lighten the system.${NL}Why do it: unused software takes up space, may receive updates for nothing and increases the risk of security flaws.${NL}${NL}📖 The 3 ways to remove${NL}   • apt remove name: removes the software but keeps its settings (handy if you reinstall it).${NL}   • apt purge name: removes the software AND its settings (clean and complete).${NL}   • apt autoremove: removes software that is no longer needed (installed to support other software).${NL}${NL}⛔ DANGER: safety rules${NL}   • Always read the list proposed by apt before answering Y. If it contains “linux-image”, “systemd”, “grub” or “libc”, answer N: the computer might no longer start.${NL}   • When in doubt, do not remove.${NL}${NL}🏋️ Your 12 heaviest software packages that you installed deliberately${NL}   Why: these are the largest, not the ones you should remove. For each one: what it is for, and whether you can remove it.${NL}$TOP"
}
