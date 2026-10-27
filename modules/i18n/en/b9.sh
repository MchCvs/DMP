T_COMP="This page checks that the doors of your computer are properly closed: security updates, firewall, open doors, remote access."
T_CMD="apt, ss, systemctl, last (DMP uniquement)"
T_NOHIST="   • History not available"
pd(){ case $1 in 3000) echo "Open WebUI: chat interface with AI models, started by Docker.";; 22) echo "Remote access (SSH): lets you control the computer from another device.";; 631) echo "Printing (CUPS).";; 80|443|8080) echo "Web server.";; 8765) echo "The DMP server, which displays these pages.";; 3306) echo "MySQL/MariaDB database.";; 5432) echo "PostgreSQL database.";; 25|587) echo "Internal mail service (here Postfix): it delivers the messages the system sends to itself, such as alerts from scheduled tasks. It sends nothing over the internet.";; 445|139) echo "Windows file sharing (Samba).";; 53) echo "Local website-name directory (DNS).";; *) echo "Program waiting for connections on this number.";; esac; }
T_PORTL() { PT="$PT${NL}🔒 Door $p: internal to the computer${NL}   • Role: $(pd $p)${NL}   • Why harmless: it only listens to this computer, nobody else can connect to it.${NL}"; }
T_PORTE() { PT="$PT${NL}🚪 Door $p: reachable from the network${NL}   • Role: $(pd $p)${NL}   • Why keep an eye on it: any device on your network can try to connect to it. If you do not need it, close it by stopping the service.${NL}"; }
T_O() {
case $MC in
sec) MJ="⚠️ $SU security update(s) pending ($UP in total).${NL}   Why: a security update closes an already known hole; as long as it is not installed, the hole can be used by an attacker.";;
ord) MJ="🟡 No security update pending, but $UP ordinary update(s).${NL}   Why: they bring fixes and improvements, less urgent.";;
*) MJ="✅ Everything is up to date.${NL}   Why: no known hole is left open by old software.";;
esac
case $AC in
old) MJ="$MJ${NL}   ⚠️ The update list dates from $AG days ago: it may no longer be current, run “sudo apt update”.";;
recent) MJ="$MJ${NL}   Last check: $AG day(s) ago.";;
esac
if [ $AUC = 1 ]; then AU="✅ Automatic security updates: installed.${NL}   Why: they happen on their own, without you having to think about it."; else AU="⚪ Automatic updates: not installed.${NL}   Why: you therefore have to run them yourself regularly (package unattended-upgrades to automate)."; fi
if [ $RBC = 1 ]; then RB="⚠️ A restart is needed.${NL}   Why: an update (often of the kernel) is only active after a restart; without it, the fixed hole stays open."; else RB="✅ No restart pending."; fi
if [ -n "$FW" ]; then PF="✅ Firewall active ($FW).${NL}   Why: it is a bouncer at the entrance: it refuses connections from outside that you have not allowed."; else PF="🟡 No firewall detected (ufw, nftables, firewalld).${NL}   Why: without a bouncer, any open door (see below) can be reached from your network. If no door is open, the risk stays low. Simple installation: sudo apt install ufw && sudo ufw enable."; fi
case $SSHC in
danger) SSH="🔴 Remote access active, direct login of the administrator account ALLOWED.${NL}   Why dangerous: everybody knows the name “root”; an attacker only has to find the password. Set PermitRootLogin no.";;
active) SSH="🟡 Remote access (SSH) active.${NL}   Why: useful if you need it. Otherwise, disable it: a closed door cannot be forced.";;
*) SSH="✅ Remote access (SSH) stopped.${NL}   Why: nobody can connect to this computer remotely.";;
esac
if [ $AAC = 1 ]; then AP="✅ AppArmor active.${NL}   Why: it confines each program in a box; a hacked program cannot touch the rest."; else AP="⚪ AppArmor inactive.${NL}   Why: it is an extra protection that is not in use; this does not mean an immediate risk."; fi
O="Security is like locking your house: you check the locks (updates), the bouncer (firewall), the doors left open (ports) and who came in recently. Why this page: most intrusions go through a hole that has already been fixed but not installed, or through a door that is needlessly open.${NL}${NL}🛠️ Updates${NL}$MJ${NL}$AU${NL}$RB${NL}${NL}🧱 Firewall${NL}$PF${NL}${NL}🚪 Doors (ports) listening: $EXP reachable from the network, $LOC internal${NL}   Why: a “port” is a numbered door through which a program receives connections. The more doors reachable from outside, the more possible entry points.$PT${NL}🔑 Remote access${NL}$SSH${NL}${NL}🛡️ Program protection${NL}$AP${NL}${NL}👤 Last 5 connections to this computer${NL}   Why: to spot a connection you do not recognise.${NL}${LG:-$T_NOHIST}"
case $SC in
0) R="System well protected"; X="No update pending, no needlessly open door, nothing to report: the main entrances are closed. Keep the habit of installing updates every week.";;
1) R="Protected, a few points to improve"; X="Nothing serious: the system is not in immediate danger, but some points above (ordinary updates, missing firewall, reachable door, restart) would make the protection stronger. Deal with them in the order shown.";;
*) R="Holes to fix quickly"; X="A serious point is flagged (pending security update, too many open doors or remote administrator access). Fix it first: sudo apt update && sudo apt upgrade.";;
esac
}
