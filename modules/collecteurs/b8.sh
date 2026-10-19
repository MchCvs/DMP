#!/bin/bash
source "$(dirname "$0")/lib.sh"; NL=$'\n'; export LC_ALL=C
I18="$(dirname "$0")/../i18n"; LG=${DMP_LANG:-fr}; [ -f "$I18/$LG/b8.sh" ] || LG=fr
. "$I18/$LG/b8.sh"
L=$(systemd-analyze 2>/dev/null | head -1)
[ -z "$L" ] && { j "$T_COMP_NO" "$T_NO_O" "$T_NO_R" "$T_NO_CMD"; exit; }
eval "$(python3 - "$L" <<'P'
import re,sys
l=sys.argv[1]
def sec(t):
    s=0
    for v,u in re.findall(r'([\d.]+)(min|ms|us|s)',t):
        v=float(v); s+=v*60 if u=="min" else v/1000 if u=="ms" else v/1e6 if u=="us" else v
    return s
body=l.split(" in ",1)[-1]; parts=body.split("=")[0].split("+"); d={"firmware":0,"loader":0,"kernel":0,"initrd":0,"userspace":0}
for p in parts:
    m=re.search(r'(.*)\((\w+)\)',p)
    if m and m.group(2) in d: d[m.group(2)]=sec(m.group(1))
m=re.search(r'=\s*(.+)$',l); d["total"]=sec(m.group(1)) if m else sum(d.values())
for k,v in d.items(): print(f'{k}={v:.1f}')
P
)"
BL=$(systemd-analyze blame --no-pager 2>/dev/null | head -8)
BLT=""; i=0
while read -r t n; do [ -z "$n" ] && continue; i=$((i+1)); T_BLITEM; done <<< "$BL"
dev=$(lsblk -no PKNAME "$(findmnt -no SOURCE /)" 2>/dev/null | head -1); DKC=none
if [ -n "$dev" ] && [ -r /sys/block/$dev/queue/rotational ]; then if [ "$(cat /sys/block/$dev/queue/rotational)" = 0 ]; then DKC=ssd; else DKC=hdd; fi; fi
FWZ=0; [ "$firmware" = 0.0 ] && FWZ=1
KP=$(awk -v k=$kernel -v i=$initrd 'BEGIN{printf "%.1f",k+i}'); TT=${total%.*}
BIGC=$(awk -v a=$firmware -v b=$loader -v c=$KP -v d=$userspace 'BEGIN{m=a;n="fw";if(b>m){m=b;n="loader"};if(c>m){m=c;n="kernel"};if(d>m){m=d;n="svc"};print n}')
DB=$(uptime -s)
T_O
export X; j "$T_COMP" "$O" "$R" "$T_CMD"
