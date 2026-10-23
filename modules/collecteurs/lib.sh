j(){ python3 - "$@" <<'P'
import sys,json,os
c,o,r,t=sys.argv[1:5]
x=os.environ.get("X","").strip()
if x: r=r+". "+x
d={"comprendre":c,"observations":o,"resultat":r,"informations_techniques":{"cmd":t+" (DMP uniquement)"}}
n=os.environ.get("DMP_NIVEAU","")
if n in ("0","1","2","3"): d["niveau"]=int(n)
print(json.dumps(d,ensure_ascii=False))
P
}
dmp_niveau(){ case "$1" in 0|1|2|3) DMP_NIVEAU=$1;; *) DMP_NIVEAU=;; esac; export DMP_NIVEAU; }
