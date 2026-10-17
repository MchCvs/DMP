#!/bin/bash

set -u

PASS=0
FAIL=0

TEST_JSON="/tmp/dmp-e2-current.json"

pass()
{
    echo "PASS : $1"
    PASS=$((PASS + 1))
}

fail()
{
    echo "FAIL : $1"
    FAIL=$((FAIL + 1))
}

echo "=== TEST E3.1 — Préparation du rapport ==="

# --------------------------------------------------
# 1. Présence du JSON E2
# --------------------------------------------------

if [ -f "$TEST_JSON" ]; then
    pass "JSON E2 disponible"
else
    fail "JSON E2 absent"
    echo
    echo "Résultat : PASS=$PASS FAIL=$FAIL"
    exit 1
fi

# --------------------------------------------------
# 2. Validité JSON
# --------------------------------------------------

if python3 - "$TEST_JSON" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as f:
    json.load(f)
PY
then
    pass "JSON E2 valide"
else
    fail "JSON E2 invalide"
fi

# --------------------------------------------------
# 3. Structure racine
# --------------------------------------------------

if python3 - "$TEST_JSON" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as f:
    d = json.load(f)

expected = {
    "module",
    "collected",
    "score",
    "state",
    "elements",
    "technical"
}

assert expected.issubset(d.keys())
PY
then
    pass "Structure racine E2 présente"
else
    fail "Structure racine E2 incomplète"
fi

# --------------------------------------------------
# 4. Données nécessaires présentes
# --------------------------------------------------

if python3 - "$TEST_JSON" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as f:
    d = json.load(f)

technical = d["technical"]

assert len(d["elements"]) > 0
assert len(technical["calculation_steps"]) > 0
assert len(technical["observations"]) > 0
assert len(technical["criteria"]) > 0
PY
then
    pass "Données nécessaires à E3.1 présentes"
else
    fail "Données nécessaires à E3.1 absentes"
fi

# --------------------------------------------------
# 5. Cohérence du score
# --------------------------------------------------

if python3 - "$TEST_JSON" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as f:
    d = json.load(f)

assert d["score"] == d["technical"]["score"]
PY
then
    pass "Score E2 cohérent"
else
    fail "Score E2 incohérent"
fi

# --------------------------------------------------
# 6. Cohérence de l'état
# --------------------------------------------------

if python3 - "$TEST_JSON" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as f:
    d = json.load(f)

assert d["state"] == d["technical"]["state"]
PY
then
    pass "État E2 cohérent"
else
    fail "État E2 incohérent"
fi

# --------------------------------------------------
# 7. Présence des cinq éléments observés
# --------------------------------------------------

if python3 - "$TEST_JSON" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as f:
    d = json.load(f)

names = {e["element"] for e in d["elements"]}

expected = {
    "Paquets Debian",
    "Espace disque",
    "TRIM SSD",
    "Mémoire",
    "SSD SMART"
}

assert expected.issubset(names)
PY
then
    pass "Éléments observés E2 présents"
else
    fail "Éléments observés E2 incomplets"
fi

# --------------------------------------------------
# 8. SMART INCONNU conservé
# --------------------------------------------------

if python3 - "$TEST_JSON" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as f:
    d = json.load(f)

smart = next(
    e for e in d["elements"]
    if e["element"] == "SSD SMART"
)

assert smart["result"] == "INCONNU"
assert smart["value"] == "INCONNU"
assert smart["contribution"] == 0
PY
then
    pass "SMART INCONNU conservé"
else
    fail "SMART INCONNU modifié ou incohérent"
fi

# --------------------------------------------------
# 9. Cohérence des contributions
# --------------------------------------------------

if python3 - "$TEST_JSON" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as f:
    d = json.load(f)

for element in d["elements"]:
    assert "contribution" in element

for step in d["technical"]["calculation_steps"]:
    assert "contribution" in step
    assert "score_before" in step
    assert "score_after" in step
PY
then
    pass "Données de calcul nécessaires à la préparation présentes"
else
    fail "Données de calcul incomplètes"
fi

# --------------------------------------------------
# 10. Vérification finale de cohérence
# --------------------------------------------------

if python3 - "$TEST_JSON" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as f:
    d = json.load(f)

steps = d["technical"]["calculation_steps"]

assert steps[-1]["score_after"] == d["technical"]["score"]
assert d["technical"]["score"] == d["score"]
assert d["technical"]["state"] == d["state"]
PY
then
    pass "Résultat final cohérent avec la trace de calcul"
else
    fail "Résultat final incohérent avec la trace de calcul"
fi

echo
echo "=== RÉSULTAT E3.1 ==="
echo "PASS : $PASS"
echo "FAIL : $FAIL"

if [ "$FAIL" -eq 0 ]; then
    echo "E3.1 : PRÉPARATION POSSIBLE"
    exit 0
else
    echo "E3.1 : PRÉPARATION NON RÉALISABLE"
    exit 1
fi
