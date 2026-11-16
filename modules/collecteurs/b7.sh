#!/bin/bash
source "$(dirname "$0")/lib.sh"; NL=$'\n'; export LC_ALL=C
. "$(dirname "$0")/../i18n/langues.sh"
I18="$(dirname "$0")/../i18n"; LG=${DMP_LANG:-fr}; [ -f "$I18/$LG/b7.sh" ] || LG=fr
. "$I18/$LG/b7.sh"
ME=$(id -un); MT=$(awk '/MemTotal/{print $2}' /proc/meminfo)
ALL=$(ps -e --no-headers | wc -l)
KT=$(ps -eo pid,ppid --no-headers | awk '$1==2||$2==2' | wc -l)
MINE=$(ps -u "$ME" --no-headers | wc -l); SYS=$((ALL-KT-MINE))
ZO=$(ps -eo stat --no-headers | grep -c '^Z')
SKIP=$(grep -l 'dmp\.service' /proc/[0-9]*/cgroup 2>/dev/null | cut -d/ -f3 | tr '\n' ' ')
DMPPID=$(grep -l 'dmp_simple\.py' /proc/[0-9]*/cmdline 2>/dev/null | cut -d/ -f3 | tr '\n' ' ')
OWPID=$(grep -l 'open_webui' /proc/[0-9]*/cmdline 2>/dev/null | cut -d/ -f3 | tr '\n' ' ')
UUPID=$(grep -l 'unattended-upgrade' /proc/[0-9]*/cmdline 2>/dev/null | cut -d/ -f3 | tr '\n' ' ')
AGG=$(ps -eo user:20,pid,ppid,pcpu,rss,stat,comm --no-headers | awk -v skip=" $SKIP " -v dmp=" $DMPPID " -v ow=" $OWPID " -v uu=" $UUPID " '{u=$1;pid=$2;pp=$3;cpu=$4;rss=$5;c=$0;for(i=1;i<=6;i++)sub(/^[ \t]*[^ \t]+[ \t]+/,"",c);if(pid==2||pp==2)next;if(c~/^ps$/)next;if(index(skip," "pid" ") && !index(dmp," "pid" "))next;if(index(dmp," "pid" "))c="DMP (serveur)";else if(index(ow," "pid" "))c="Open WebUI";else if(index(uu," "pid" "))c="Mises à jour automatiques";n[c]++;cp[c]+=cpu;m[c]+=rss;us[c]=u}END{for(c in n)printf "%s|%d|%.1f|%d|%s\n",c,n[c],cp[c],m[c],us[c]}')
NP=$(echo "$AGG" | grep -c .)
TOP=$(echo "$AGG" | sort -t'|' -k4 -nr | head -20)
LIST=""; i=0
while IFS='|' read -r c n cp m u; do [ -z "$c" ] && continue; i=$((i+1))
 MEM=$(awk -v k=$m -v g="$T_GB" -v mb="$T_MB" 'BEGIN{if(k>=1048576)printf "%.1f %s",k/1048576,g;else printf "%d %s",k/1024,mb}'); PC=$(awk -v k=$m -v t=$MT 'BEGIN{printf "%.1f",k*100/t}')
 T_ITEM
done <<< "$TOP"
if ! echo "$TOP" | grep -q "^DMP (serveur)|" && echo "$AGG" | grep -q "^DMP (serveur)|"; then LIST="$LIST${NL}   • ${T_DMP_LUI:-}"; fi
TC=$(echo "$AGG" | sort -t'|' -k3 -nr | head -3 | awk -F'|' -v f="$T_TCFMT" '$3>0{printf f,$1,$3}')
[ -z "$TC" ] && TC="$T_TCNONE"
TM=$(echo "$TOP" | head -1 | cut -d'|' -f4); TMP=$(awk -v k=${TM:-0} -v t=$MT 'BEGIN{printf "%d",k*100/t}'); TCP=$(echo "$AGG" | sort -t'|' -k3 -nr | head -1 | cut -d'|' -f3); TCP=${TCP%.*}
if [ "$TMP" -ge 40 ]; then RL=mem
elif [ "${TCP:-0}" -ge 80 ]; then RL=cpu
elif [ "$ZO" -gt 5 ]; then RL=zomb
else RL=ok; fi
T_O
export NV=3   # liste informative : sans objet
export X; j "$T_COMP" "$O" "$R" "$T_CMD"
