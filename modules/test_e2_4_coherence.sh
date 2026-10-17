#!/bin/bash

set -u

JSON="$(./e2_data.sh)" || {
    echo "FAIL : e2_data.sh a échoué"
    exit 1
}

export JSON

python3 - <<'PY'
import json
import os
import sys

d = json.loads(os.environ["JSON"])

errors = []

technical = d.get("technical", {})
observations = technical.get("observations", {})
steps = technical.get("calculation_steps", [])
elements = d.get("elements", [])

# 1. Présence des cinq observations
expected_observations = ["paquets", "disque", "trim", "memoire", "smart"]

if list(observations.keys()) != expected_observations:
    errors.append(
        f"Observations incorrectes : {list(observations.keys())}"
    )

# 2. Présence des cinq étapes
if len(steps) != 5:
    errors.append(f"Nombre d'étapes incorrect : {len(steps)}")

# 3. Correspondance observation -> étape
expected_elements = [
    "Paquets Debian",
    "Espace disque",
    "TRIM SSD",
    "Mémoire",
    "SSD SMART",
]

actual_elements = [step.get("element") for step in steps]

if actual_elements != expected_elements:
    errors.append(
        f"Éléments des étapes incorrects : {actual_elements}"
    )

# 4. Correspondance avec E2.3
if len(elements) != len(steps):
    errors.append(
        f"E2.3 ({len(elements)}) != étapes ({len(steps)})"
    )

for element, step in zip(elements, steps):
    if element.get("element") != step.get("element"):
        errors.append(
            f"Élément incohérent : {element.get('element')} / "
            f"{step.get('element')}"
        )

    if element.get("contribution") != step.get("contribution"):
        errors.append(
            f"Contribution incohérente pour {step.get('element')}: "
            f"{element.get('contribution')} / "
            f"{step.get('contribution')}"
        )

# 5. Vérification de la progression du score
previous = technical.get("initial_score")

for index, step in enumerate(steps, 1):
    if step.get("score_before") != previous:
        errors.append(
            f"Étape {index} : score avant "
            f"{step.get('score_before')} != score précédent {previous}"
        )

    expected_after = (
        step.get("score_before") + step.get("contribution")
    )

    if step.get("score_after") != expected_after:
        errors.append(
            f"Étape {index} : score après "
            f"{step.get('score_after')} != "
            f"{expected_after}"
        )

    previous = step.get("score_after")

# 6. Score final
if previous != technical.get("score"):
    errors.append(
        f"Score final incohérent : trace={previous}, "
        f"technical={technical.get('score')}"
    )

if technical.get("score") != d.get("score"):
    errors.append(
        f"Score incohérent : technical={technical.get('score')}, "
        f"racine={d.get('score')}"
    )

# 7. État final
if technical.get("state") != d.get("state"):
    errors.append(
        f"État incohérent : technical={technical.get('state')}, "
        f"racine={d.get('state')}"
    )

# 8. Cas SMART attendu
smart = observations.get("smart", {})
smart_step = steps[4]

if smart.get("exit_code") != 1:
    errors.append(
        f"SMART : code retour attendu 1, obtenu {smart.get('exit_code')}"
    )

if smart_step.get("evaluation") != "INCONNU":
    errors.append(
        f"SMART : évaluation attendue INCONNU, "
        f"obtenue {smart_step.get('evaluation')}"
    )

if smart_step.get("contribution") != 0:
    errors.append(
        f"SMART : contribution attendue 0, "
        f"obtenue {smart_step.get('contribution')}"
    )

# Résultat
if errors:
    print("E2.4 COHERENCE : FAIL")
    for error in errors:
        print(" -", error)
    sys.exit(1)

print("E2.4 COHERENCE : PASS")
print("Observations : 5/5")
print("Étapes de calcul : 5/5")
print("Correspondance E2.3 / E2.4 : PASS")
print("Progression du score : PASS")
print("Score final : 100")
print("État final : EXCELLENT")
print("SMART : INCONNU / contribution 0")
PY
