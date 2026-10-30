T_COMP="The graphics card is your computer's painter: it draws everything shown on the screen (windows, videos, games)."
T_COMP_NO="The graphics card produces the image you see on the screen."
T_NO_O="No graphics card could be identified. Why: the detection tool may be missing, or the computer is a virtual machine."
T_NO_R="Not identified"
T_CMD="lspci"
T_O() {
case $GK in
ded) K="This is a dedicated card: a separate, powerful component designed for games and video editing."
XU="It is enough for games and video editing, because it is a dedicated component with its own power.";;
*) K="This is an integrated graphics chip: it is inside the processor, is enough for internet, video and office work, but is less suited to recent games."
XU="It is enough for internet, videos (even in HD), photos and office work. For recent 3D games or heavy video editing it will be limited, because it shares power with the processor.";;
esac
if [ -n "$Y" ]; then
 case $AC in new) D="recent";; mid) D="mid-aged";; *) D="old";; esac
 AG="Age: judging by its name, this is a $D chip, released around $Y (about $A year(s) ago). Why it matters: a recent chip is faster, uses less energy and can play the latest videos without tiring the processor; an older one remains fine for internet and office work, but struggles with modern videos and recent games."
else AG=""; fi
X="$XU $AG"
O="Your computer uses: “${G}”. $K Why it is useful to know: it tells you whether the computer can handle games or editing, or whether it is rather made for everyday use."
R="Detected"
}
