T_COMP="This page shows how full your computer's work desk (the memory) is right now, and by what."
T_CMD="/proc/meminfo, ps"
T_O() {
TOP=$(echo "$RAW" | awk '{printf "   • %s: %s %% of memory\n",$2,$1}')
O="🧠 Memory used: $P % of $T GB ($A GB still available)${NL}${NL}The 3 biggest consumers:${NL}$TOP${NL}${NL}🔁 Backup memory (swap, on the disk): $SF GB used out of $ST GB${NL}Why: when the desk is full, the system puts things away on the disk, which is much slower. A lot of swap in use means memory ran short."
case $PL in
2) R="Memory almost full"; X="Close tabs or programs (especially those in the list), otherwise the computer will slow down by using the disk as backup.";;
1) R="Memory well used, still fine"; X="This is normal: Linux deliberately keeps memory to speed things up, and gives it back as soon as a program needs it.";;
*) R="Plenty of memory"; X="There is plenty of room: programs open quickly.";;
esac
}
