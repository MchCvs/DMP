T_COMP="Diese Seite zeigt, seit wann Ihr Computer ohne Unterbrechung eingeschaltet ist und ob er müde ist. Das ist, als würde man jemanden fragen, seit wie vielen Stunden er ohne Pause arbeitet."
T_CMD="uptime, /proc/uptime, /proc/loadavg"
T_O() {
if [ $J -gt 0 ]; then T="$J Tag(e), $H Std. $M Min."; else T="$H Std. $M Min."; fi
O="⏱️ Eingeschaltet seit: $T (Start am $DEP)${NL}${NL}⚙️ Prozessorlast: $L bei $C Kernen${NL}Warum: Solange diese Zahl unter $C bleibt, hat jeder Kern seine Aufgabe und der Computer bleibt flüssig."
case $UL in
long) R="Schon lange eingeschaltet: Ein Neustart wird empfohlen"; X="Nach einem Monat haben Programme Reste im Arbeitsspeicher hinterlassen, und manche Updates (insbesondere des Kernels, des Kerns des Systems) werden erst nach einem Neustart wirksam, sodass Sie davon noch nicht profitieren.";;
mid) R="Seit mehreren Tagen eingeschaltet: Alles in Ordnung"; X="Von Zeit zu Zeit neu zu starten (ein- oder zweimal pro Woche) ist eine gute Gewohnheit, da dadurch der Arbeitsspeicher zurückgesetzt und Updates angewendet werden.";;
*) R="Frischer Start, alles ist sauber"; X="Ein Computer, der gerade gestartet wurde, ist im saubersten Zustand: Der Arbeitsspeicher ist geleert und Updates sind berücksichtigt.";;
esac
[ -n "$RB" ] && X="$X Wichtig: Das System meldet, dass ein Neustart nötig ist, um ein Update abzuschließen."
}
