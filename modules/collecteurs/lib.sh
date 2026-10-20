j(){ python3 - "$@" <<'P'
import sys,json,os
c,o,r,t=sys.argv[1:5]
x=os.environ.get("X","").strip()
if x: r=r+". "+x
print(json.dumps({"comprendre":c,"observations":o,"resultat":r,"informations_techniques":{"cmd":t+{"en":" (DMP only)","de":" (nur DMP)"}.get(os.environ.get("DMP_LANG","fr")," (DMP uniquement)")}},ensure_ascii=False))
P
}
