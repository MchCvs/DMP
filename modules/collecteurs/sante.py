import sys,json,subprocess
d=sys.argv[1]
lg=sys.argv[2] if len(sys.argv)>2 and sys.argv[2] in ("fr","en","de") else "fr"
TX={
"fr":{
"ok":"   ✅ Verdict : le disque se déclare en bonne santé.\n      Pourquoi : un disque s'auto-surveille en permanence ; ce verdict ne passe au rouge que lorsqu'une panne est proche.",
"bad":"   ❌ Verdict : le disque annonce une défaillance.\n      Pourquoi : c'est son propre système d'alerte, il est fiable. Sauvegardez vos fichiers sans attendre.",
"t_ok":"normale","t_warm":"un peu chaude","t_hot":"trop chaude",
"temp":"   🌡️ Température : {t} °C ({s}).\n      Pourquoi : la chaleur use un disque plus vite. Sous 50 °C tout va bien ; au-delà de 60 °C, vérifiez l'aération.",
"hours":"   ⏳ Heures de fonctionnement : {h} h (environ {days} jours, soit {years} an(s) d'allumage cumulé).\n      Pourquoi : un disque dur mécanique dure souvent 3 à 5 ans d'usage continu ; un SSD s'use surtout selon la quantité de données écrites, pas son âge.",
"wear":"   🔋 Usure : {pu} % de la durée de vie prévue est consommée (reste environ {left} %).\n      Pourquoi : un SSD supporte un nombre limité d'écritures, comme une gomme qui s'use. En dessous de 70 %, aucun souci ; au-delà de 90 %, prévoyez de le remplacer.",
"spare":"   🧰 Réserve de secours : {sp} % disponible.\n      Pourquoi : le SSD garde des cellules de rechange pour remplacer celles qui s'abîment. Quand elles s'épuisent, il perd des données.",
"media":"   🔎 Erreurs de lecture/écriture : {me}.\n      Pourquoi : {why}",
"media_bad":"des erreurs signalent des zones abîmées, c'est un signe de défaillance.",
"media_ok":"zéro, c'est le résultat attendu : aucune zone abîmée détectée.",
"crit":"   🚨 Alerte critique activée par le disque : sauvegardez vos fichiers maintenant.",
"atawear":"   🔋 Usure SSD : il reste environ {v} % de vie.\n      Pourquoi : un SSD supporte un nombre limité d'écritures. Au-dessus de 30 % de vie restante, aucun souci ; sous 10 %, remplacez-le.",
"sec":"   🔎 {nom} : {r}.\n      Pourquoi : {why}",
"sec_ok":"zéro, c'est le résultat attendu : aucune zone abîmée.",
"n5":"Secteurs défectueux remplacés","e5":"Le disque a remplacé des zones abîmées par des zones de rechange. Quelques-uns sont tolérables, mais s'ils augmentent, la panne approche.",
"n197":"Secteurs en attente de vérification","e197":"Des zones instables sont suspectées. Cela peut précéder une panne.",
"n198":"Secteurs illisibles","e198":"Des zones ne peuvent plus être lues : des fichiers peuvent déjà être touchés."},
"en":{
"ok":"   ✅ Verdict: the disk reports itself in good health.\n      Why: a disk monitors itself constantly; this verdict only turns red when a failure is near.",
"bad":"   ❌ Verdict: the disk announces a failure.\n      Why: this is its own warning system, and it is reliable. Back up your files without waiting.",
"t_ok":"normal","t_warm":"a little hot","t_hot":"too hot",
"temp":"   🌡️ Temperature: {t} °C ({s}).\n      Why: heat wears a disk out faster. Below 50 °C all is well; above 60 °C, check the ventilation.",
"hours":"   ⏳ Power-on hours: {h} h (about {days} days, or {years} year(s) of cumulative running time).\n      Why: a mechanical hard drive often lasts 3 to 5 years of continuous use; an SSD wears out mainly according to the amount of data written, not its age.",
"wear":"   🔋 Wear: {pu} % of the expected lifespan is used up (about {left} % left).\n      Why: an SSD withstands a limited number of writes, like an eraser that wears down. Below 70 %, no worry; beyond 90 %, plan to replace it.",
"spare":"   🧰 Spare reserve: {sp} % available.\n      Why: the SSD keeps spare cells to replace those that get damaged. When they run out, it loses data.",
"media":"   🔎 Read/write errors: {me}.\n      Why: {why}",
"media_bad":"errors point to damaged areas, which is a sign of failure.",
"media_ok":"zero is the expected result: no damaged area detected.",
"crit":"   🚨 Critical alert raised by the disk: back up your files now.",
"atawear":"   🔋 SSD wear: about {v} % of life remaining.\n      Why: an SSD withstands a limited number of writes. Above 30 % life remaining, no worry; below 10 %, replace it.",
"sec":"   🔎 {nom}: {r}.\n      Why: {why}",
"sec_ok":"zero is the expected result: no damaged area.",
"n5":"Reallocated bad sectors","e5":"The disk has replaced damaged areas with spare ones. A few are tolerable, but if they increase, failure is approaching.",
"n197":"Sectors pending verification","e197":"Unstable areas are suspected. This can come before a failure.",
"n198":"Unreadable sectors","e198":"Some areas can no longer be read: files may already be affected."},
"de":{
"ok":"   ✅ Urteil: Der Datenträger meldet sich selbst als gesund.\n      Warum: Ein Datenträger überwacht sich ständig selbst; dieses Urteil wird erst rot, wenn ein Ausfall naht.",
"bad":"   ❌ Urteil: Der Datenträger kündigt einen Ausfall an.\n      Warum: Das ist sein eigenes Warnsystem, und es ist zuverlässig. Sichern Sie Ihre Dateien ohne Verzögerung.",
"t_ok":"normal","t_warm":"etwas warm","t_hot":"zu heiß",
"temp":"   🌡️ Temperatur: {t} °C ({s}).\n      Warum: Hitze nutzt einen Datenträger schneller ab. Unter 50 °C ist alles in Ordnung; über 60 °C prüfen Sie die Belüftung.",
"hours":"   ⏳ Betriebsstunden: {h} Std. (etwa {days} Tage, also {years} Jahr(e) kumulierte Laufzeit).\n      Warum: Eine mechanische Festplatte hält oft 3 bis 5 Jahre Dauerbetrieb; eine SSD verschleißt vor allem nach der Menge der geschriebenen Daten, nicht nach ihrem Alter.",
"wear":"   🔋 Verschleiß: {pu} % der vorgesehenen Lebensdauer sind verbraucht (es bleiben etwa {left} %).\n      Warum: Eine SSD verträgt nur eine begrenzte Zahl von Schreibvorgängen, wie ein Radiergummi, der sich abnutzt. Unter 70 % ist alles in Ordnung; über 90 % sollten Sie einen Ersatz einplanen.",
"spare":"   🧰 Ersatzreserve: {sp} % verfügbar.\n      Warum: Die SSD hält Ersatzzellen bereit, um beschädigte zu ersetzen. Wenn sie aufgebraucht sind, gehen Daten verloren.",
"media":"   🔎 Lese-/Schreibfehler: {me}.\n      Warum: {why}",
"media_bad":"Fehler deuten auf beschädigte Bereiche hin, das ist ein Anzeichen für einen Ausfall.",
"media_ok":"null ist das erwartete Ergebnis: Es wurde kein beschädigter Bereich erkannt.",
"crit":"   🚨 Kritischer Alarm des Datenträgers: Sichern Sie jetzt Ihre Dateien.",
"atawear":"   🔋 SSD-Verschleiß: Es bleiben etwa {v} % Lebensdauer.\n      Warum: Eine SSD verträgt nur eine begrenzte Zahl von Schreibvorgängen. Über 30 % verbleibender Lebensdauer ist alles in Ordnung; unter 10 % sollten Sie sie ersetzen.",
"sec":"   🔎 {nom}: {r}.\n      Warum: {why}",
"sec_ok":"null ist das erwartete Ergebnis: kein beschädigter Bereich.",
"n5":"Ersetzte defekte Sektoren","e5":"Der Datenträger hat beschädigte Bereiche durch Ersatzbereiche ersetzt. Einige wenige sind tolerierbar, aber wenn es mehr werden, naht der Ausfall.",
"n197":"Sektoren, die auf Überprüfung warten","e197":"Instabile Bereiche werden vermutet. Das kann einem Ausfall vorausgehen.",
"n198":"Unlesbare Sektoren","e198":"Manche Bereiche können nicht mehr gelesen werden: Dateien könnten bereits betroffen sein."}
}
T=TX[lg]
try: j=json.loads(subprocess.run(["sudo","-n","smartctl","-j","-a","/dev/"+d],capture_output=True,text=True).stdout or "{}")
except Exception: j={}
if "smart_status" not in j: sys.exit(3)
niv=0; L=[]
def up(n):
    global niv; niv=max(niv,n)
if j["smart_status"].get("passed"):
    L.append(T["ok"])
else:
    up(2); L.append(T["bad"])
t=j.get("temperature",{}).get("current")
if t is not None:
    if t<50: s=T["t_ok"]
    elif t<60: s=T["t_warm"]; up(1)
    else: s=T["t_hot"]; up(1)
    L.append(T["temp"].format(t=t,s=s))
h=j.get("power_on_time",{}).get("hours")
if h is not None:
    L.append(T["hours"].format(h=h,days=h//24,years="%.1f"%(h/8760)))
n=j.get("nvme_smart_health_information_log")
if n:
    pu=n.get("percentage_used")
    if pu is not None:
        if pu>=90: up(2)
        elif pu>=70: up(1)
        L.append(T["wear"].format(pu=pu,left=max(0,100-pu)))
    sp=n.get("available_spare")
    if sp is not None:
        if sp<20: up(2)
        L.append(T["spare"].format(sp=sp))
    me=n.get("media_errors",0)
    if me>0: up(2)
    L.append(T["media"].format(me=me,why=(T["media_bad"] if me>0 else T["media_ok"])))
    if n.get("critical_warning",0)>0: up(2); L.append(T["crit"])
else:
    a={x["id"]:x for x in j.get("ata_smart_attributes",{}).get("table",[])}
    for i in (231,233,177):
        if i in a:
            v=a[i]["value"]
            if v<=10: up(2)
            elif v<=30: up(1)
            L.append(T["atawear"].format(v=v))
            break
    for i,lv in ((5,1),(197,1),(198,2)):
        if i in a:
            r=a[i]["raw"]["value"]
            if r>0: up(lv)
            L.append(T["sec"].format(nom=T["n%d"%i],r=r,why=(T["e%d"%i] if r>0 else T["sec_ok"])))
print("\n".join(L)); sys.exit(niv)
