T_COMP="The network is your computer's door to the rest of the world: internet, printer, other devices."
T_NO_O="No active connection is detected: the computer has no path to the internet. Why: the cable may be unplugged or Wi-Fi switched off. Without a connection, you cannot browse or run updates."
T_NO_R="Not connected"
T_NO_CMD="ip route"
T_CMD="ip route, ip addr"
T_O() {
if [ -n "$WL" ]; then K="over Wi-Fi (wireless)"; XU="Wi-Fi is convenient, but its quality depends on the distance to the router and on walls: if pages are slow, move closer or use a cable."
else K="by cable"; XU="A cable is generally more stable and faster than Wi-Fi, because the signal suffers no interference."; fi
X="This connection is enough for browsing, watching videos and running updates. $XU"
O="Your computer is connected $K, through the interface “${F}”. Its address on the network is $A: it is like its house number, which lets other devices find it. Why it matters: without this address, no web page or update could reach you."
R="Connected"
}
