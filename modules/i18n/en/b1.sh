T_COMP="This page tells you how long your computer has been on without interruption, and whether it is tired. It is like asking someone how many hours they have been working without a break."
T_CMD="uptime, /proc/uptime, /proc/loadavg"
T_O() {
if [ $J -gt 0 ]; then T="$J day(s), $H h $M min"; else T="$H h $M min"; fi
O="⏱️ On since: $T (started on $DEP)${NL}${NL}⚙️ Processor load: $L for $C cores${NL}Why: as long as this number stays below $C, each core has its own task and the computer stays smooth."
case $UL in
long) R="On for a long time: a restart is advised"; X="After a month, some programs have left leftovers in memory and some updates (notably the kernel, the core of the system) only apply after a restart, so you are not benefiting from them yet.";;
mid) R="On for several days: all is well"; X="Restarting from time to time (once or twice a week) is a good habit, because it resets memory and applies updates.";;
*) R="Recent start, everything is fresh"; X="A computer that has just started is in its cleanest state: memory is cleared and updates are taken into account.";;
esac
[ -n "$RB" ] && X="$X Important: the system reports that a restart is needed to finish an update."
}
