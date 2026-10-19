T_COMP="The power supply is what gives energy to the computer: mains power, or the battery when you unplug."
T_COMP_NO="The power supply is what gives energy to the computer: mains power, sometimes a battery."
T_NO_O="No battery detected: this is a desktop computer, permanently plugged into the mains. Why: a desktop computer has no battery, which is perfectly normal."
T_NO_R="Desktop computer (normal)"
T_CMD="/sys/class/power_supply"
T_O() {
case $WL in
good) XU="Your battery has kept $W % of its original capacity: it is in good health.";;
mid) XU="Your battery has kept $W % of its original capacity: it is a little worn, battery life is reduced.";;
bad) XU="Your battery has kept only $W % of its original capacity: it is very worn, replacing it is advised.";;
*) XU="Battery wear could not be measured.";;
esac
X="$XU Why: a battery loses a little capacity with each charge cycle, this is normal over the years."
O="Your battery is charged at $P % (status: $S). Why it is useful: it tells you how long you can work without a power outlet. A battery that no longer lasts long is worn out with the years."
R="Battery detected"
}
