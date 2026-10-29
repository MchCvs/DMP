j(){ python3 - "$@" <<'P'
import sys,json,os
c,o,r,t=sys.argv[1:5]
x=os.environ.get("X","").strip()
if x: r=r+". "+x
nv_raw = os.environ.get("NV", "").strip()
NV = int(nv_raw) if nv_raw.isdigit() else 3
d={"comprendre":c,"observations":o,"resultat":r,"niveau":NV,"informations_techniques":{"cmd":t+{"en":" (DMP only)","de":" (nur DMP)"}.get(os.environ.get("DMP_LANG","fr")," (DMP uniquement)")}}
p=os.environ.get("POSS","").strip()
if p: d["possibilities"]=json.loads(p)
print(json.dumps(d,ensure_ascii=False))
P
}
