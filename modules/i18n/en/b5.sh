T_COMP="This page shows whether your computer's door to the internet works: the connection, what flows through it, its quality and its speed."
T_COMP_NO="This page shows whether your computer is connected to the internet and whether that link works well."
T_NO_O="No active connection is detected. Why: the cable is unplugged, Wi-Fi is off or the router is switched off. Without a connection, you cannot browse or run updates."
T_NO_R="Not connected"
T_NO_CMD="ip route"
T_CMD="ip, ping, /sys/class/net, getent (DMP uniquement)"
T_BYTE="B"
t1(){ if [ -z "$2" ] || [ "$2" = 100 ]; then echo "❌ no response"; else a=${3%.*}; if [ "$a" -lt 30 ]; then q="excellent"; elif [ "$a" -lt 100 ]; then q="decent"; else q="slow"; fi; echo "✅ responds in $3 ms ($q), $2 % loss"; fi; }
T_NM() {
case $N1 in en) NM="“en” means Ethernet, so a cable connection";; wl) NM="“wl” means Wi-Fi";; *) NM="name given by the system";; esac
case $N2 in onboard) NM="$NM; “o” means built into the motherboard; the digit is its number";; pci) NM="$NM; the rest indicates its location on the motherboard";; esac
}
T_SPT() {
case $SQ in
3) SQT="excellent: enough for all uses, even 4K video and big downloads";;
2) SQT="decent for internet and video, slower for big files";;
*) SQT="very slow: check the cable, it may be damaged";;
esac
if [ $SQ -gt 0 ]; then SPT="$SP Mb/s ($SQT)"; else SPT="not measurable (normal on Wi-Fi)"; fi
}
T_QL() {
case $LV in 0) VD="✅ negligible, nothing to do";; 1) VD="🟡 low but worth watching: it may come from harmless ignored messages, or from a slightly fragile link";; *) VD="🔴 too high: real data is being lost";; esac
if [ "$SK" = delta ]; then SUIV="Tracking: $DD more packet(s) dropped since the previous check ($MN min ago). If this number stays at or near 0, the counted packets date from before and are not worrying; if it climbs quickly while you browse, there is a real problem."
else SUIV="Tracking: this is the first check. Next time, DMP will tell you whether this number is increasing."; fi
QL="   • Hardware errors: $ER${NL}      Why: these are packets that arrived damaged (faulty cable, socket or network card). Zero is the expected result.${NL}   • Dropped (lost) packets: $DR out of $TOT packets, or $PCT % of the traffic${NL}      What it is: a packet is a small parcel of data; “dropped” means the computer threw it away without processing it. Two possible causes. Harmless: network broadcast messages that do not concern you, or a protocol you do not use. Problem: the link is of poor quality or saturated, and useful data is lost.${NL}      Why keep an eye on it: a lost packet has to be requested again, which causes slow pages, stuttering videos and dropped calls. Below 0.1 % it is negligible, from 0.1 to 1 % worth watching, beyond that it is a problem.${NL}      Verdict: $VD${NL}      $SUIV"
}
T_O() {
T_NM; T_SPT; T_QL
if [ $KW = 1 ]; then K="Wi-Fi (wireless)"; else K="Ethernet cable"; fi
UT="$UD d $UHR h"
case $BL in
dl) BAL="You receive far more than you send: this is normal, because browsing, watching a video or updating is mostly downloading.";;
up) BAL="You send more than you receive: this is unusual. It may come from an online backup or from sending large files.";;
*) BAL="Receiving and sending are close: balanced use.";;
esac
O="🔗 Your connection${NL}   • Technical name: $F (${NM})${NL}   • Type: $K${NL}   • Your computer's address: $IP${NL}      Why: it is its house number on your network, which lets other devices find it.${NL}   • Router (gateway): $GW${NL}      Why: it is the exit door to the internet. Everything that goes out or comes in passes through it.${NL}   • Website directory (DNS): ${DNS:-unknown}${NL}      Why: it translates a name like debian.org into a numeric address, like a phone book.${NL}   • Link speed: $SPT${NL}      Why: it is the width of the pipe between your computer and the router (not your internet subscription).${NL}${NL}📦 What has flowed since power-on ($UT)${NL}   • ⬇️ Received: $RH (about $PH photos of 1 MB), in $RP packets${NL}   • ⬆️ Sent: $TH, in $TP packets${NL}   • Average received: about $MH per hour${NL}      Why: a packet is a small parcel of data; a page or a video arrives in thousands of parcels. $BAL${NL}${NL}🩺 Link quality${NL}${QL}${NL}${NL}🏓 Live tests${NL}   • Your router: $(t1 x "$GL" "$GA")${NL}   • Internet: $(t1 x "$IL" "$IA")${NL}   • Directory (website names): $([ $DN = 1 ] && echo '✅ working' || echo '❌ not responding')${NL}      Why: each link is tested in order (router, then internet, then directory) to know exactly where a possible problem lies."
case $ST in
nobox) R="The router does not respond"; X="The problem is between your computer and the router: check the cable or Wi-Fi, then restart the router.";;
noinet) R="Local network fine, but no internet"; X="The router responds, so your computer is fine: the problem comes from the router or your provider. Restart the router, and if it persists, contact the provider.";;
unstable) R="Unstable connection"; X="Packets are being lost: this causes dropouts and slowness. Check the cable or move closer to the router.";;
nodns) R="Internet responds, but website names are not resolved"; X="Websites will not open by name: the directory service (DNS) is down, restart the router.";;
*) R="Healthy connection"; X="Every link responds well: browsing, videos and updates work normally.";;
esac
[ $LV -eq 1 ] && { R="Connection to watch"; X="Every link responds, but $DR packet(s) out of $TOT were lost on the way ($PCT % of the traffic). Why keep an eye on it: lost packets have to be requested again, which slows pages and makes videos stutter. Details under “Link quality”."; }
[ $LV -eq 2 ] && { R="Poor link quality"; X="$X $DR dropped packet(s) ($PCT %) and $ER error(s): real data is being lost. Check the cable (replace it if possible) or move closer to the router on Wi-Fi."; }
}
