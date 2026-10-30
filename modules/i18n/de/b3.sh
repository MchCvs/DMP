T_COMP="Diese Seite zeigt, wie voll der Schreibtisch Ihres Computers (der Arbeitsspeicher) im Moment ist und womit."
T_CMD="/proc/meminfo, ps"
T_O() {
TOP=$(echo "$RAW" | awk '{printf "   • %s: %s %% des Arbeitsspeichers\n",$2,$1}')
O="🧠 Arbeitsspeicher belegt: $P % von $T GB (noch $A GB verfügbar)${NL}${NL}Die 3 größten Verbraucher:${NL}$TOP${NL}${NL}🔁 Ersatzspeicher (Swap, auf der Festplatte): $SF GB belegt von $ST GB${NL}Warum: Wenn der Schreibtisch voll ist, lagert das System Dinge auf die Festplatte aus, die viel langsamer ist. Viel genutzter Swap bedeutet, dass der Arbeitsspeicher knapp wurde."
case $PL in
2) R="Arbeitsspeicher fast voll"; X="Schließen Sie Tabs oder Programme (vor allem die aus der Liste), sonst wird der Computer langsamer, weil er die Festplatte als Ersatz nutzt.";;
1) R="Arbeitsspeicher gut genutzt, nicht ausgelastet"; X="Das ist normal: Linux behält absichtlich Speicher, um alles zu beschleunigen, und gibt ihn sofort zurück, sobald ein Programm ihn braucht.";;
*) R="Arbeitsspeicher hat viel Luft"; X="Es ist noch viel Platz: Programme öffnen sich schnell.";;
esac
}
