T_COMP="This page shows how hard your computer's brain is working right now, like a runner whose effort is being measured."
T_CMD="/proc/stat, ps"
T_O() {
TOP=$(echo "$RAW" | awk '{printf "   • %s: %s %% on average since it started\n",$2,$1}')
O="📊 The processor is working at $P % right now.${NL}${NL}The 3 programs that use it the most:${NL}$TOP${NL}${NL}Why: a processor at 100 % for a long time makes the computer slow, because it has no free time left for new requests."
case $PL in
2) R="Heavily used: the computer may slow down"; X="A heavy program is probably running (look at the list above). If this lasts while you are doing nothing, it is abnormal, because a computer at rest stays below 20 %.";;
1) R="Sustained activity, normal if you are working"; X="This is common during a video, a game or an installation. It should drop back once the task is finished.";;
*) R="At rest, all is well"; X="The processor is lightly used: it keeps room to react quickly when you start something.";;
esac
}
