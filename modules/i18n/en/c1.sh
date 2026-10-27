T_COMP="Updates are vaccines for your computer: whenever a hole or a defect is found in a piece of software, its authors publish a fixed version. Why install them: software that is not updated keeps its holes, and those are what hackers and viruses exploit."
T_CMD="apt list --upgradable (DMP uniquement)"
T_SECL="🔴 security"; T_ORDL="🔵 ordinary"
T_LFMT='   • %s: %s → %s (%s)\n'
T_O() {
if [ $UP -eq 0 ]; then O="✅ No update pending: all your software is at the latest known version.${NL}   Why: no already-fixed hole is left open."
else O="📦 $UP update(s) pending, of which $SU are security updates.${NL}${NL}List (most important first, 15 at most):${NL}$LST${NL}${NL}🔴 Security: fixes a known hole, which a hacker can use as long as it is not installed.${NL}🔵 Ordinary: fixes a defect or brings an improvement, less urgent.${NL}   Reading a line: software name: current version → available version."; fi
[ $AG -ge 0 ] && O="$O${NL}${NL}🕒 Last check for news: $AG day(s) ago.${NL}   Why: this list is only reliable if it is recent. Beyond 7 days, first run “sudo apt update”."
O="$O${NL}${NL}🛠️ How to install (to type in a terminal)${NL}   1) sudo apt update: refreshes the list of news (installs nothing).${NL}   2) sudo apt upgrade: installs the updates. Debian removes nothing without telling you.${NL}   Why in two steps: you first look at what exists, then decide to install."
if [ $SU -gt 0 ]; then R="To do quickly"; X="$SU security update(s) are waiting: as long as they are not installed, known holes stay open. Like a vaccine, the sooner it is done, the better you are protected. Run the two commands above."
elif [ $UP -gt 0 ]; then R="To do, not urgent"; X="No security hole pending, only improvements. Install them this week: this keeps the system consistent and avoids build-up."
else R="System up to date"; X="Nothing to do. Keep the habit of checking every week, because new holes are fixed regularly."; fi
}
