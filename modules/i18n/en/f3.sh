T_COMP="The speed test (benchmark) is like timing a runner: the computer is given the same effort each time, so we know how fast it goes and can follow how it changes."
T_CMD="python3, dd (DMP only)"
T_DKU="type not readable"
T_SSD="SSD"
T_HDD="mechanical hard disk"
T_V0="✅ very good"
T_V1="🟡 fair"
T_V2="🔴 weak"
T_O() {
O="⚡ The test measures the speed of three parts right now. It takes a few seconds and writes 512 MB temporarily in your personal folder, deleted immediately.${NL}${NL}1) 🧮 Calculation (processor): $CT s for 5 million operations${NL}   • Why: this is how fast the computer “thinks”. The shorter, the better.${NL}   • Benchmarks: under 0.8 s very good, 0.8 to 1.6 s fair, over 1.6 s weak.${NL}   • Your result: $(vd $LC)${NL}${NL}2) 🧠 Memory: $MM MB/s${NL}   • Why: this is how fast data moves around in the work desk. It determines how smooth all programs feel.${NL}   • Benchmarks: over 4000 MB/s very good, 1500 to 4000 fair, under 1500 weak.${NL}   • Your result: $(vd $LM)${NL}${NL}3) 💽 Disk (write, $DK): $DW MB/s${NL}   • Why: this is how fast files, updates and startup are saved.${NL}   • Benchmarks: over 300 MB/s very good (SSD), 100 to 300 fair, under 100 weak (mechanical hard disk or busy disk).${NL}   • Your result: $(vd $LD)"
}
T_RX() {
case $W in
0) R="Fast machine"; X="All three measurements are good: processor, memory and disk keep up. Repeat this test from time to time: a clear drop signals a problem (tired disk, background program).";;
1) R="Average speed: to watch"; X="At least one measurement is only fair. Nothing unusual for everyday use. If the machine feels slow, the weakest measurement points to the part to look at.";;
*) R="Low speed: to improve"; X="At least one measurement is weak: it is the part that limits your computer. The disk is the easiest to improve (an SSD changes everything). Run the test again with no other program open to check that it is not temporary.";;
esac
}
