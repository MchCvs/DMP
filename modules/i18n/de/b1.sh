T_COMP="Diese Seite zeigt, seit wann Ihr Computer ohne Unterbrechung eingeschaltet ist und ob er müde ist. Das ist, als würde man jemanden fragen, seit wie vielen Stunden er ohne Pause arbeitet."
T_CMD="uptime, /proc/uptime, /proc/loadavg"
T_O() {
if [ $J -gt 0 ]; then T="$J Tag(e), $H Std. $M Min."; else T="$H Std. $M Min."; fi
O="⏱️ Eingeschaltet seit: $T (Start am $DEP)${NL}${NL}⚙️ Prozessorlast: $L bei $C Kernen${NL}Warum: Solange diese Zahl unter $C bleibt, hat jeder Kern seine Aufgabe und der Computer bleibt flüssig."
R="Kein Neustart ausstehend"; X="Der Computer läuft seit einiger Zeit, und kein Update wartet auf einen Neustart."
[ -n "$RB" ] && X="$X Wichtig: Das System meldet, dass ein Neustart nötig ist, um ein Update abzuschließen."
}
