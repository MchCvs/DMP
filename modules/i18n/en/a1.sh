T_COMP="This is the brain of your computer. It thinks and does the calculations. The faster it is, the faster your programs run."
T_CMD="nproc, lscpu, /proc/loadavg (DMP uniquement)"
T_O() {
case $LV in
3) Q="a high number: your computer can do many things at the same time (video, browsing, games) without slowing down";;
2) Q="a comfortable number for everyday use: internet, office work, videos";;
*) Q="a modest number: the computer may slow down if you run many things at the same time";;
esac
O="Your processor is a “${M}”. It has $C cores. A core is like a worker: the more there are, the more the work is shared and the faster it gets done. With $C cores, that is $Q. Current load: $L. This value measures how many tasks are waiting for their turn: if it stays below $C, the processor works without being overwhelmed, because each core has its own task. Above $C, tasks queue up and the computer slows down."
case $GM in
3) GN="entry level"; GX="an i3 is enough for internet, office work and videos, but may struggle if you do many things at once";;
5) GN="mid range"; GX="an i5 is the most common choice because it offers the best balance between speed and price: it is more than enough for internet, office work, videos, photos and everyday games";;
7) GN="high end"; GX="an i7 is fast and comfortable for video editing, creative work and demanding games";;
9) GN="very high end"; GX="an i9 is a very powerful processor, designed for very heavy uses";;
esac
case $FA in
intel) E="What is a Core i5, i7...? Intel is one of the two big processor manufacturers (the other is AMD). “Core” is its mainstream range, ranked by level, like the sizes of a single brand: i3 (entry level), i5 (mid range), i7 (high end), i9 (very high end). Yours is ${GN}: ${GX}. The number after the letter i (for example 12400) indicates the generation and the power: the bigger it is, the more recent and efficient the processor. Why it is useful to know: it tells you what your computer can do comfortably, and when it might be time to replace it.";;
amd) E="What is a Ryzen? AMD is one of the two big processor manufacturers (the other is Intel). Ryzen is its mainstream range, ranked by level: Ryzen 3 (entry level), 5 (mid range, the most common), 7 (high end), 9 (very high end). The number that follows indicates the generation: the bigger it is, the more recent the processor. Why it is useful to know: it tells you what your computer can do comfortably.";;
*) E="The name of your processor indicates its manufacturer and its power level. Compare it with other models from the same manufacturer to know whether it is recent and powerful.";;
esac
O="$O $E"
case $LV in
3) U="For everyday use (internet, office work, videos, photos), it is more than enough. It is also suitable for demanding uses such as video editing or games, because with $C cores the work is shared well.";;
2) U="For everyday use (internet, office work, videos, photos), it is enough. For video editing or very recent games it will be tight, because these tasks need many cores at the same time.";;
*) U="It is enough for internet and light office work, but it is limited as soon as you do several things at once, because only $C cores share the work.";;
esac
if [ -n "$Y" ]; then
 case $AC in new) D="recent";; mid) D="mid-aged";; *) D="old";; esac
 AG="Age: this is a $D processor, released around $Y. Why it matters: a recent processor is faster and uses less energy; an older one remains usable as long as your needs are simple, but it eventually slows down with ever more demanding software."
else AG="Its age could not be determined automatically: the larger the number in its name, the more recent it is."; fi
if [ -n "$OV" ]; then R="Overloaded right now: too many tasks waiting"; else R="Working well"; fi
R="$R. $U $AG"
}
