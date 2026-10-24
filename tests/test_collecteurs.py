#!/usr/bin/env python3
# Test des collecteurs : JSON valide, champs de texte présents,
# et niveau 0 à 3 pour les 22 sujets notés par e2.html.
import json
import os
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
COL = ROOT / "modules" / "collecteurs"
NOTES = re.compile(r"[abc][0-9]")   # a1 à a9, b1 à b9, c1 à c4
CHAMPS = ("comprendre", "observations", "resultat")
IGNORES = {"lib", "template-zero-flou"}
BENCH = "f3"                        # écrit 64 Mo sur le disque


def verifier(nom):
    if nom == BENCH and not os.environ.get("DMP_TEST_BENCH"):
        return "IGNORÉ", "benchmark (DMP_TEST_BENCH=1 pour l'inclure)"
    try:
        r = subprocess.run(["bash", str(COL / f"{nom}.sh")],
                           capture_output=True, text=True, timeout=90)
    except subprocess.TimeoutExpired:
        return "ERREUR", "délai dépassé (90 s)"
    try:
        d = json.loads(r.stdout)
    except json.JSONDecodeError:
        return "ERREUR", "JSON invalide"
    for champ in CHAMPS:
        if not isinstance(d.get(champ), str) or not d.get(champ):
            return "ERREUR", f"champ « {champ} » absent ou vide"
    if NOTES.fullmatch(nom):
        n = d.get("niveau")
        if not (isinstance(n, int) and not isinstance(n, bool) and 0 <= n <= 3):
            return "ERREUR", f"niveau absent ou invalide ({n!r})"
    return "OK", ""


def main():
    total = echecs = 0
    for f in sorted(COL.glob("*.sh")):
        if f.stem in IGNORES:
            continue
        total += 1
        etat, detail = verifier(f.stem)
        if etat == "ERREUR":
            echecs += 1
        print(f"{etat:8} {f.stem:<12} {detail}".rstrip())
    print(f"\n{total} collecteurs examinés, {echecs} erreur(s)")
    return 1 if echecs else 0


if __name__ == "__main__":
    sys.exit(main())
