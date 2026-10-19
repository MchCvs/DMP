T_COMP="Diese Seite zeigt, wie stark das Gehirn Ihres Computers gerade arbeitet, wie bei einem Läufer, dessen Anstrengung gemessen wird."
T_CMD="/proc/stat, ps"
T_O() {
TOP=$(echo "$RAW" | awk '{printf "   • %s: %s %% im Durchschnitt seit dem Start\n",$2,$1}')
O="📊 Der Prozessor arbeitet im Moment mit $P % Auslastung.${NL}${NL}Die 3 Programme, die ihn am meisten beanspruchen:${NL}$TOP${NL}${NL}Warum: Ein Prozessor, der lange bei 100 % läuft, macht den Computer langsam, da er keine freie Zeit mehr für neue Anfragen hat."
case $PL in
2) R="Stark ausgelastet: Der Computer kann langsamer werden"; X="Wahrscheinlich läuft ein aufwendiges Programm (sehen Sie sich die Liste oben an). Wenn das anhält, obwohl Sie nichts tun, ist es nicht normal, denn ein Computer in Ruhe bleibt unter 20 %.";;
1) R="Anhaltende Aktivität, normal, wenn Sie arbeiten"; X="Das ist bei einem Video, einem Spiel oder einer Installation üblich. Es sollte wieder sinken, sobald die Aufgabe beendet ist.";;
*) R="In Ruhe, alles in Ordnung"; X="Der Prozessor wird wenig beansprucht: Er hat Reserven, um schnell zu reagieren, wenn Sie etwas starten.";;
esac
}
