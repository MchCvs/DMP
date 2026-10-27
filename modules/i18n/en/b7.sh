T_COMP="This page shows all the programs running right now, including those you do not see, and which ones weigh the most."
T_CMD="ps (DMP uniquement)"
T_GB="GB"; T_MB="MB"
T_TCFMT='   • %s: %s %%\n'
T_TCNONE="   • No program is using the processor in any notable way."
desc(){ case "$1" in
 systemd) echo "The conductor of the system: it starts and monitors all the other services. Without it, nothing starts.";;
 systemd-*|dbus-daemon|dbus-broker*) echo "Internal service that lets programs talk to each other and manage the system (journal, time, connections).";;
 NetworkManager|wpa_supplicant) echo "Manages the connection to the network and the internet.";;
 sshd|ssh) echo "Lets you connect to the computer remotely.";;
 cron|cron.service) echo "Runs scheduled tasks (cleanups, backups).";;
 Xorg|Xwayland|gnome-shell|plasmashell|kwin*|xfwm4|xfdesktop|mutter) echo "Draws your desktop, the windows and the screen. Without it, you see nothing.";;
 gdm*|lightdm|sddm) echo "Shows the login screen and opens your session.";;
 firefox*|chrome*|chromium*|brave*) echo "Your web browser: it displays websites.";;
 "Web Content"|WebExtensions|"Isolated Web Co"|"Privileged Cont"|RDD*|"Socket Process") echo "Pieces of the browser: each tab or extension runs in its own process.";;
 thunderbird*) echo "Your mail client (email).";;
 soffice*|libreoffice*) echo "LibreOffice: word processor, spreadsheet, presentations.";;
 vlc|mpv|totem) echo "Video and music player.";;
 pipewire*|wireplumber|pulseaudio) echo "Manages sound: speakers, microphone, headset.";;
 python*|node|java) echo "A program written in a scripting language (or a development tool). Here it may be the DMP server itself.";;
 bash|sh|zsh|dash|fish) echo "A terminal (the window where you type commands) or the script running in it.";;
 cupsd|cups-browsed) echo "Manages printing.";;
 bluetoothd) echo "Manages Bluetooth.";;
 avahi-daemon) echo "Helps the computer discover printers and devices on the local network.";;
 rsyslogd) echo "Keeps the log of system events (useful for understanding a problem).";;
 polkitd|udisksd|upowerd|accounts-daemon|colord) echo "System service: manages permissions, connected disks, power or screen profiles.";;
 gvfs*|tracker*|localsearch*) echo "Desktop service: access to files (network, USB sticks) and search in your documents.";;
 code|codium) echo "The Visual Studio Code editor.";;
 claude*) echo "The Claude Code assistant used in the terminal.";;
 *) if [ "$2" = root ]; then echo "System program started by the administrator (root). It works in the background for a Debian service."; else echo "Program started by you or by one of your applications."; fi;;
 esac; }
T_ITEM() {
PL=""; [ "$n" -gt 1 ] && PL="${NL}   • Why $n processes: a modern program splits into several independent pieces so that a crash in one does not bring down everything else; the total above adds them up."
LIST="$LIST${NL}$i) $c${NL}   • Memory: $MEM ($PC % of the total)${NL}   • Processor: $cp % on average since it started${NL}   • Processes: $n (owner: $u)${NL}   • Role: $(desc "$c" "$u")$PL${NL}"
}
T_O() {
O="A program is an application that you start (browser, music player…). A process is a program that is running. One program can have several processes, hence a larger number than what you see on screen. Why this page: knowing what is running helps you understand why the computer slows down, or spot a program that has no business being there.${NL}${NL}📊 The $ALL running processes break down as follows${NL}   • $KT kernel processes (the core of Debian): internal to the system, invisible and normal${NL}   • $MINE started by you ($ME), directly or through your applications${NL}   • $SYS started by the system and its services (root and other accounts)${NL}   • They correspond to $NP different programs${NL}      Why: a desktop Debian computer generally has between 150 and 400 at rest: this number is therefore normal.${NL}${NL}🧟 “Zombie” processes: $ZO${NL}      Why: a zombie is a finished process whose parent has not yet noted its end. It uses nothing, but if there are many and they stay, a program is badly written.${NL}${NL}🔥 The 3 most active on the processor right now${NL}$TC${NL}      Why: this value is the average since the program started, not the instantaneous one. A program that has been running for a long time therefore looks less active than it is.${NL}${NL}🧠 The 20 programs that use the most memory${NL}      Why this list: memory is the resource that runs short first. The figures are approximate: the processes of one program share part of the memory, so the total may be slightly overestimated.${NL}$LIST"
case $RL in
mem) R="One program uses a lot of memory"; X="The first program in the list takes more than 40 % of the memory. If the computer slows down, close it (or restart it): it is the first suspect.";;
cpu) R="One program is putting heavy load on the processor"; X="A program is working intensively. Normal during a video or an installation; if it lasts while you are doing nothing, close it.";;
zomb) R="Several zombies detected"; X="They do no harm, but if they pile up, restarting the parent program or the computer makes them disappear.";;
*) R="The running programs are normal"; X="No program is monopolising memory or the processor, and the number of processes is usual: nothing to do.";;
esac
}
