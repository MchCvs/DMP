T_COMP="Debian is the operating system: the great conductor that makes all the hardware and all your programs work together."
T_CMD="/etc/os-release, uname"
T_O() {
case $VC in
13) XU="Debian 13 is the current stable version: it receives security updates, you are up to date.";;
12) XU="Debian 12 is the previous version: it is still supported (extended support), but plan to move to Debian 13.";;
none) XU="Your version is not numbered (testing or unstable): more recent, but less stable.";;
*) XU="This version of Debian is old and no longer supported for security: an upgrade is recommended, because newly discovered flaws are no longer fixed.";;
esac
X="$XU For everyday use, Debian is perfectly sufficient: browser, office work and multimedia run without trouble."
O="You are using $PRETTY_NAME. Its kernel (the core of the system, which talks directly to the hardware) is version $(uname -r), for a $(uname -m) architecture. Why it matters: knowing its version tells you whether it is still supported and updated. Debian is known for its stability."
R="System recognised"
}
