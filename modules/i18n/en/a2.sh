T_COMP="Memory (RAM) is your computer's work desk: everything you open is placed there to be used very quickly. When you switch off, the desk is cleared."
T_CMD="/proc/meminfo"
T_O() {
case $LV in
3) Q="a very large amount: you can open many things at the same time without worry"
XU="It is more than enough, even for video editing or several heavy programs at the same time, because these tasks keep a lot of data on the desk.";;
2) Q="a comfortable amount for internet, office work, videos and a little creative work"
XU="It is enough for everyday use (internet with many tabs, office work, videos, photos). For heavy video editing it would be tight, because these tasks quickly fill the desk.";;
1) Q="a decent amount, but tight if you open many things"
XU="It is enough for internet and office work, but becomes tight with many tabs, because recent browsers are demanding.";;
*) Q="a small amount: the computer can quickly slow down"
XU="It is small: the computer will be slow as soon as you open several things, because the desk is too small.";;
esac
case $PL in
0) XE="Right now you are using only part of it ($P %): you have room to spare.";;
1) XE="It is fairly well used ($P %) but still fine.";;
*) XE="It is almost full ($P %): close some programs or tabs.";;
esac
R="Memory in good shape"; [ "$PL" = 1 ] && R="Memory fairly used, to watch"; [ "$PL" = 2 ] && R="Memory almost full: the computer may slow down"
X="$XU $XE"
O="Your computer has $T GB of memory, $Q. Right now $P % is in use and $D GB remain free. Why it matters: when the desk is full, the computer has to put things away on the disk, which is much slower, and everything slows down. As long as there is free space, everything stays smooth."
}
