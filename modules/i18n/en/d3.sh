# English texts of collector d3. Edit the text only.
T_COMP="Benefits are what you gain from looking after your computer well: it stays fast, safe and lasts longer. This page measures what you have already gained today."
T_CMD="df, /proc/meminfo, apt, systemctl"
T_ALL="all"
T_PEND="pending"
T_ON="active"
T_OFF="inactive"
T_X="The more ✅, the more you enjoy the benefits of regular maintenance. A 🟡 is not a fault: it is a gain still within reach, explained on the relevant page. Why: a few minutes of maintenance a week prevent breakdowns and bad surprises."
T_O() {
O="Here is what you gained today thanks to a computer that is monitored and maintained:${NL}${NL}$E1 Free space: $DF available ($DP used)${NL}   Why: a disk that is not full stays fast and can receive updates and new files.${NL}${NL}$E2 Available memory: $MG GB ($MP % free)${NL}   Why: the more free memory there is, the faster programs open without slowing down.${NL}${NL}$E3 Software up to date: $UPT${NL}   Why: up-to-date software no longer has the known flaws; it is your best protection.${NL}${NL}$E4 Firewall: $FW${NL}   Why: it refuses incoming connections from outside that you have not allowed.${NL}${NL}🎁 In summary: DMP monitors 18 topics for you and turns each figure into plain words, with the reason why. You gain time, security and a machine that lasts longer."
R="$S benefit(s) gained out of 4"
}
