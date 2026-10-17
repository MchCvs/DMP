import sys,json,subprocess
d=sys.argv[1]
try: j=json.loads(subprocess.run(["sudo","-n","smartctl","-j","-a","/dev/"+d],capture_output=True,text=True).stdout or "{}")
except Exception: j={}
if "smart_status" not in j: sys.exit(3)
niv=0; L=[]
def up(n):
    global niv; niv=max(niv,n)
if j["smart_status"].get("passed"):
    L.append("   ✅ Verdict : le disque se déclare en bonne santé.\n      Pourquoi : un disque s'auto-surveille en permanence ; ce verdict ne passe au rouge que lorsqu'une panne est proche.")
else:
    up(2); L.append("   ❌ Verdict : le disque annonce une défaillance.\n      Pourquoi : c'est son propre système d'alerte, il est fiable. Sauvegardez vos fichiers sans attendre.")
t=j.get("temperature",{}).get("current")
if t is not None:
    if t<50: s="normale"
    elif t<60: s="un peu chaude"; up(1)
    else: s="trop chaude"; up(1)
    L.append(f"   🌡️ Température : {t} °C ({s}).\n      Pourquoi : la chaleur use un disque plus vite. Sous 50 °C tout va bien ; au-delà de 60 °C, vérifiez l'aération.")
h=j.get("power_on_time",{}).get("hours")
if h is not None:
    L.append(f"   ⏳ Heures de fonctionnement : {h} h (environ {h//24} jours, soit {h/8760:.1f} an(s) d'allumage cumulé).\n      Pourquoi : un disque dur mécanique dure souvent 3 à 5 ans d'usage continu ; un SSD s'use surtout selon la quantité de données écrites, pas son âge.")
n=j.get("nvme_smart_health_information_log")
if n:
    pu=n.get("percentage_used")
    if pu is not None:
        if pu>=90: up(2)
        elif pu>=70: up(1)
        L.append(f"   🔋 Usure : {pu} % de la durée de vie prévue est consommée (reste environ {max(0,100-pu)} %).\n      Pourquoi : un SSD supporte un nombre limité d'écritures, comme une gomme qui s'use. En dessous de 70 %, aucun souci ; au-delà de 90 %, prévoyez de le remplacer.")
    sp=n.get("available_spare")
    if sp is not None:
        if sp<20: up(2)
        L.append(f"   🧰 Réserve de secours : {sp} % disponible.\n      Pourquoi : le SSD garde des cellules de rechange pour remplacer celles qui s'abîment. Quand elles s'épuisent, il perd des données.")
    me=n.get("media_errors",0)
    if me>0: up(2)
    L.append(f"   🔎 Erreurs de lecture/écriture : {me}.\n      Pourquoi : " + ("des erreurs signalent des zones abîmées, c'est un signe de défaillance." if me>0 else "zéro, c'est le résultat attendu : aucune zone abîmée détectée."))
    if n.get("critical_warning",0)>0: up(2); L.append("   🚨 Alerte critique activée par le disque : sauvegardez vos fichiers maintenant.")
else:
    a={x["id"]:x for x in j.get("ata_smart_attributes",{}).get("table",[])}
    for i in (231,233,177):
        if i in a:
            v=a[i]["value"]
            if v<=10: up(2)
            elif v<=30: up(1)
            L.append(f"   🔋 Usure SSD : il reste environ {v} % de vie.\n      Pourquoi : un SSD supporte un nombre limité d'écritures. Au-dessus de 30 % de vie restante, aucun souci ; sous 10 %, remplacez-le.")
            break
    for i,nom,expl,lv in ((5,"Secteurs défectueux remplacés","Le disque a remplacé des zones abîmées par des zones de rechange. Quelques-uns sont tolérables, mais s'ils augmentent, la panne approche.",1),(197,"Secteurs en attente de vérification","Des zones instables sont suspectées. Cela peut précéder une panne.",1),(198,"Secteurs illisibles","Des zones ne peuvent plus être lues : des fichiers peuvent déjà être touchés.",2)):
        if i in a:
            r=a[i]["raw"]["value"]
            if r>0: up(lv)
            L.append(f"   🔎 {nom} : {r}.\n      Pourquoi : " + (expl if r>0 else "zéro, c'est le résultat attendu : aucune zone abîmée."))
print("\n".join(L)); sys.exit(niv)
