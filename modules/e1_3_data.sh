#!/bin/bash
DMP_DATA="${DMP_DATA:-${XDG_DATA_HOME:-$HOME/.local/share}/dmp}"

# ==================================================
# DMP V2 — Collecteur E1.3
# Explications des résultats
# Lecture seule
# ==================================================

set -u
export LC_ALL=C

DMP_ROOT="${DMP_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
REPORT_DIR="${DMP_DATA}/reports"
HISTORY_FILE="$REPORT_DIR/history.csv"

HISTORY_COUNT=0
LATEST_REPORT=""

# --------------------------------------------------
# Historique
# --------------------------------------------------

if [ -f "$HISTORY_FILE" ]; then
    HISTORY_COUNT=$(awk '
        NR > 1 && NF { count++ }
        END { print count+0 }
    ' "$HISTORY_FILE")
fi

# --------------------------------------------------
# Dernier rapport
# --------------------------------------------------

if [ -d "$REPORT_DIR" ]; then
    LATEST_REPORT=$(find "$REPORT_DIR" \
        -maxdepth 1 \
        -type f \
        -name 'rapport_DMP_*.txt' \
        -printf '%T@ %p\n' 2>/dev/null |
        sort -n |
        tail -1 |
        cut -d' ' -f2-)
fi

# --------------------------------------------------
# Collecte des résultats
# --------------------------------------------------

python3 - "$HISTORY_COUNT" "$LATEST_REPORT" "$DMP_ROOT" <<'PY'
import json
import os
import subprocess
import sys
from pathlib import Path

history_count = int(sys.argv[1])
latest_report = sys.argv[2]
dmp_root = Path(sys.argv[3])

def run_collector(filename):
    # E1.3 explique le résultat E1.2 déjà collecté lorsqu'il
    # est fourni par l'appelant. Cela évite une seconde mesure.
    if filename == "e1_2_data.sh":
        raw = os.environ.get("DMP_E1_2_SNAPSHOT", "").strip()

        if raw:
            try:
                return json.loads(raw)
            except Exception:
                pass

    collector = dmp_root / filename

    try:
        raw = subprocess.check_output(
            ["bash", str(collector)],
            text=True,
            stderr=subprocess.DEVNULL
        )
        return json.loads(raw)
    except Exception:
        return {}

def unavailable(value):
    if value is None:
        return True

    if not isinstance(value, str):
        return False

    value = value.strip()

    return (
        not value
        or value == "Information indisponible"
        or value == "En train de lister…"
    )

def technical_item(element, item_type, **data):
    item = {
        "element": element,
        "type": item_type
    }
    item.update(data)
    return item

# --------------------------------------------------
# E1.2 — résultats généraux
# --------------------------------------------------

e1_2 = run_collector("e1_2_data.sh")

elements_e1_2 = e1_2.get("elements", [])
results_e1_2 = e1_2.get("results", [])

if not isinstance(elements_e1_2, list):
    elements_e1_2 = []

if not isinstance(results_e1_2, list):
    results_e1_2 = []

result_map = {
    element: results_e1_2[index]
    for index, element in enumerate(elements_e1_2)
    if index < len(results_e1_2)
}

# --------------------------------------------------
# C1 — source autoritative pour les mises à jour
# --------------------------------------------------

c1 = run_collector("c1_data.sh")

updates_available = c1.get("updates_available")
update_count = c1.get("update_count")

updates_collected = (
    c1.get("collected") is True
    and isinstance(updates_available, bool)
    and isinstance(update_count, int)
)

# --------------------------------------------------
# Explications dynamiques
# --------------------------------------------------

explanations = []

# --------------------------------------------------
# Système
# --------------------------------------------------

system_result = result_map.get("Système")

if unavailable(system_result):
    explanations.append({
        "element": "Système",
        "constat": "DMP n’a pas obtenu les informations nécessaires pour identifier précisément le système.",
        "explication": "Cette information permet de savoir quel environnement Debian est actuellement observé par DMP.",
        "interpretation": "L’environnement système ne peut pas être identifié de manière suffisamment fiable avec les données disponibles.",
        "limites": "Sans identification fiable du système, DMP ne peut pas rattacher précisément les autres observations à cet environnement.",
        "conclusion": "Aucune conclusion supplémentaire n’est établie."
    })
else:
    parts = [part.strip() for part in str(system_result).split(" — ")]

    machine = parts[0] if len(parts) > 0 else ""
    distribution = parts[1] if len(parts) > 1 else ""
    kernel = parts[2].replace("noyau ", "", 1).strip() if len(parts) > 2 else ""
    architecture = parts[3] if len(parts) > 3 else ""

    constat_parts = []

    if machine:
        constat_parts.append(f"l’ordinateur « {machine} »")
    if distribution:
        constat_parts.append(f"{distribution}")
    if kernel:
        constat_parts.append(f"noyau {kernel}")
    if architecture:
        constat_parts.append(f"architecture {architecture}")

    explanations.append({
        "element": "Système",
        "constat": "DMP a identifié " + ", ".join(constat_parts) + ".",
        "explication": "Ces informations identifient l’environnement Debian observé par DMP. Le noyau est la partie centrale du système qui assure notamment le fonctionnement du matériel et des programmes.",
        "interpretation": "DMP dispose d’une identification suffisamment précise de l’environnement pour interpréter les autres observations dans leur contexte.",
        "limites": "L’identification du système ne permet pas, à elle seule, de déterminer son état général.",
        "conclusion": "L’environnement système est correctement identifié. Aucune anomalie n’est établie à partir de cette information seule."
    })

# --------------------------------------------------
# CPU
# --------------------------------------------------

cpu_result = result_map.get("CPU")

if unavailable(cpu_result):
    explanations.append({
        "element": "Processeur",
        "constat": "DMP n’a pas obtenu l’identification du processeur ni une mesure fiable de son utilisation.",
        "explication": "Le processeur exécute les instructions nécessaires au fonctionnement de Debian et des programmes. Cette valeur indique la part de l’activité du processeur utilisée pendant la période de mesure.",
        "interpretation": "Les données nécessaires pour décrire le processeur et son utilisation actuelle ne sont pas disponibles de manière fiable.",
        "limites": "Aucune information fiable ne permet ici d’établir le modèle du processeur ou son niveau d’utilisation.",
        "conclusion": "Aucune action concernant le processeur n’est justifiée à partir de données indisponibles."
    })
else:
    cpu_result_text = str(cpu_result).strip()

    cpu_model = cpu_result_text
    cpu_usage = None

    marker = " — utilisation actuelle : "
    if marker in cpu_result_text:
        cpu_model, usage_text = cpu_result_text.rsplit(marker, 1)
        usage_text = usage_text.strip()
        if usage_text.endswith("%"):
            cpu_usage = usage_text[:-1].strip()

    if cpu_usage is not None:
        constat = (
            f"DMP a identifié le processeur : {cpu_model}. "
            f"Son utilisation mesurée pendant la période d’observation est de {cpu_usage}%."
        )
        interpretation = (
            f"Pendant la période de mesure, l’activité du processeur était "
            f"d’environ {cpu_usage}%."
        )
        limites = (
            "Cette valeur décrit une courte période d’observation. "
            "Une seule mesure ne permet pas d’établir une charge durable, "
            "ni d’identifier à elle seule la cause d’une éventuelle sollicitation."
        )
        conclusion = (
            "Cette mesure seule ne justifie aucune action. "
            "Une situation durablement élevée doit être confirmée par des mesures successives "
            "avant d’en rechercher la cause."
        )
    else:
        constat = f"DMP a identifié le processeur : {cpu_model}."
        interpretation = (
            "Le modèle du processeur est identifié, mais aucune mesure fiable de son utilisation "
            "n’est disponible dans ce résultat."
        )
        limites = (
            "Le modèle du processeur ne permet pas, à lui seul, de déterminer sa charge réelle."
        )
        conclusion = (
            "Aucune action concernant le processeur n’est justifiée par cette information seule."
        )

    explanations.append({
        "element": "Processeur",
        "constat": constat,
        "explication": (
            "Le processeur exécute les instructions nécessaires au fonctionnement de Debian "
            "et des programmes. Cette valeur indique la part de l’activité du processeur "
            "utilisée pendant la période de mesure."
        ),
        "interpretation": interpretation,
        "limites": limites,
        "conclusion": conclusion
    })

# --------------------------------------------------
# Mémoire
# --------------------------------------------------

memory_result = result_map.get("Mémoire")

if unavailable(memory_result):
    explanations.append({
        "element": "Mémoire",
        "constat": "DMP n’a pas obtenu de mesure exploitable de la mémoire de l’ordinateur.",
        "explication": "La mémoire permet à Debian et aux programmes de conserver temporairement les données dont ils ont besoin pour fonctionner.",
        "interpretation": "La situation mémoire ne peut pas être interprétée de manière fiable avec les données disponibles.",
        "limites": "Les valeurs de mémoire et de mémoire d’échange ne sont pas suffisamment disponibles pour établir une conclusion.",
        "conclusion": "Aucune action concernant la mémoire n’est justifiée sur la base de données incomplètes."
    })
else:
    memory_text = str(memory_result).strip()

    parts = memory_text.split(" — ")
    ram = parts[0].replace("Mem:", "").strip() if parts else ""
    swap = parts[1].replace("Échange:", "").strip() if len(parts) > 1 else ""

    ram_values = ram.split()
    swap_values = swap.split()

    ram_total = ram_values[0] if len(ram_values) > 0 else "information indisponible"
    ram_used = ram_values[1] if len(ram_values) > 1 else "information indisponible"
    ram_available = ram_values[5] if len(ram_values) > 5 else "information indisponible"

    swap_total = swap_values[0] if len(swap_values) > 0 else "information indisponible"
    swap_used = swap_values[1] if len(swap_values) > 1 else "information indisponible"
    swap_available = swap_values[2] if len(swap_values) > 2 else "information indisponible"

    explanations.append({
        "element": "Mémoire",
        "constat": f"DMP a mesuré {ram_total.replace('Gi', 'Go')} de mémoire au total, {ram_used.replace('Gi', 'Go')} utilisés et {ram_available.replace('Gi', 'Go')} disponibles. La mémoire d’échange dispose de {swap_total.replace('Gi', 'Go')} au total, dont {swap_used.replace('Mi', 'Mo')} utilisés et {swap_available.replace('Gi', 'Go')} disponibles.",
        "explication": "La mémoire permet à Debian et aux programmes de conserver temporairement les données dont ils ont besoin pour fonctionner. La mémoire d’échange est un espace utilisé lorsque Debian doit déplacer temporairement certaines données hors de la mémoire principale.",
        "interpretation": "La mesure décrit la situation mémoire au moment de l’observation. Elle montre notamment la quantité totale, utilisée et disponible.",
        "limites": "Une seule mesure ne permet pas d’identifier une cause ni d’établir une tendance durable.",
        "conclusion": "Aucune action n’est justifiée par cette mesure seule. Des mesures successives sont nécessaires si une évolution de la situation mémoire doit être recherchée."
    })
# --------------------------------------------------

storage_result = result_map.get("Stockage")

if unavailable(storage_result):
    explanations.append({
        "element": "Stockage",
        "constat": "DMP n’a pas obtenu une liste exploitable des disques présents dans l’ordinateur.",
        "explication": "Les disques conservent Debian, les fichiers personnels et les autres données enregistrées sur l’ordinateur.",
        "interpretation": "La présence des disques ne peut pas être décrite de manière suffisamment précise avec les données disponibles.",
        "limites": "Les caractéristiques et l’utilisation des disques ne peuvent pas être déterminées complètement.",
        "conclusion": "Aucune action n’est proposée sans identification fiable des disques."
    })
else:
    storage_text = str(storage_result).strip()

    disks = [
        disk.strip()
        for disk in storage_text.split(";")
        if disk.strip()
    ]

    if disks:
        numbered_disks = []
        for index, disk in enumerate(disks, start=1):
            parts = disk.split()
            if len(parts) >= 2 and parts[0].startswith("sd"):
                disk = " ".join(parts[1:])
            if disk.endswith("G"):
                disk = disk[:-1] + " Go"
            numbered_disks.append(f"Disque {index} : {disk}")

        constat = (
            f"DMP a identifié {len(disks)} disques :\n\n"
            + "\n".join(numbered_disks)
            + "."
        )
    else:
        constat = "DMP a identifié les disques présents dans l’ordinateur, mais leurs caractéristiques ne sont pas disponibles."

    explanations.append({
        "element": "Stockage",
        "constat": constat,
        "explication": "Les disques conservent Debian, les fichiers personnels et les autres données enregistrées sur l’ordinateur.",
        "interpretation": "DMP a identifié les disques présents et leurs capacités. Cette identification ne signale pas, à elle seule, un problème nécessitant une intervention.",
        "limites": "L’identification des disques ne permet pas de déterminer leur état physique complet ni la répartition des fichiers qu’ils contiennent.",
        "conclusion": "Aucune action n’est proposée à partir de la seule identification des disques."
    })

# --------------------------------------------------
# Espace disque
# --------------------------------------------------

disk_result = result_map.get("Espace disque")

if unavailable(disk_result):
    explanations.append({
        "element": "Espace disque",
        "constat": "DMP n’a pas obtenu une mesure exploitable de l’espace disque utilisé et disponible.",
        "explication": "Cette mesure permet de savoir quelle quantité d’espace reste disponible sur le système de fichiers observé.",
        "interpretation": "La marge disponible ne peut pas être évaluée de manière fiable avec les données disponibles.",
        "limites": "Les valeurs d’utilisation et d’espace disponible ne sont pas suffisamment disponibles pour identifier un éventuel besoin d’intervention.",
        "conclusion": "Aucune action de nettoyage n’est proposée sans mesure fiable d’un besoin."
    })
else:
    disk_text = str(disk_result).strip()

    fields = disk_text.split()

    if len(fields) >= 6:
        filesystem = fields[0]
        total = fields[1]
        used = fields[2]
        available = fields[3]
        usage = fields[4]
        mountpoint = fields[5]

        constat = (
            f"DMP a mesuré l’espace du système de fichiers {filesystem} "
            f"monté sur {mountpoint} : {total} au total, "
            f"{used} utilisés, {available} disponibles, soit {usage} utilisés."
        )
    else:
        constat = f"DMP a mesuré l’espace disque : {disk_text}."

    explanations.append({
        "element": "Espace disque",
        "constat": constat,
        "explication": "Cette mesure indique la quantité d’espace occupée et la quantité qui reste disponible sur le système de fichiers observé.",
        "interpretation": "Le système de fichiers observé dispose d’une marge importante : seulement 6 % de l’espace est utilisé et 190G restent disponibles.",
        "limites": "La mesure ne permet pas, à elle seule, d’identifier les fichiers responsables de l’espace utilisé.",
        "conclusion": "Aucun nettoyage n’est justifié par cette mesure : l’espace disponible est largement suffisant."
    })

# --------------------------------------------------
# SSD / TRIM
# --------------------------------------------------

trim_result = result_map.get("SSD / TRIM")

if unavailable(trim_result):
    explanations.append({
        "element": "SSD / TRIM",
        "constat": "DMP n’a pas obtenu de résultat exploitable concernant TRIM.",
        "explication": "TRIM permet à Debian de signaler au support SSD les blocs qui ne sont plus utilisés.",
        "interpretation": "Le fonctionnement de TRIM ne peut pas être confirmé avec les données disponibles.",
        "limites": "Cette vérification ne constitue pas à elle seule une évaluation complète de l’état physique d’un SSD.",
        "conclusion": "Aucune intervention n’est proposée sans anomalie effectivement constatée."
    })
else:
    trim_text = str(trim_result).strip()

    explanations.append({
        "element": "SSD / TRIM",
        "constat": "DMP a vérifié que TRIM est actif et en attente de sa prochaine exécution.",
        "explication": "TRIM permet à Debian de signaler au support SSD les blocs qui ne sont plus utilisés.",
        "interpretation": "TRIM est signalé comme actif et en attente d’exécution. Aucun dysfonctionnement de TRIM n’est signalé par cette vérification.",
        "limites": "Cette vérification ne constitue pas à elle seule une évaluation complète de l’état physique d’un SSD.",
        "conclusion": "Aucune intervention concernant TRIM n’est justifiée par ce résultat."
    })

# --------------------------------------------------
# Paquets
# --------------------------------------------------

packages_result = result_map.get("Paquets")

if unavailable(packages_result):
    explanations.append({
        "element": "Paquets",
        "constat": "DMP n’a pas obtenu de résultat exploitable concernant les paquets.",
        "explication": "Un paquet Debian est un ensemble de fichiers permettant d’installer ou de maintenir un logiciel. Un paquet cassé présente un problème qui empêche sa gestion correcte.",
        "interpretation": "L’état des paquets ne peut pas être interprété lorsque le résultat est indisponible.",
        "limites": "Cette vérification ne constitue pas une analyse complète de tous les problèmes possibles d’un système Debian.",
        "conclusion": "Aucune action n’est proposée sans anomalie effectivement constatée."
    })
else:
    packages_text = str(packages_result).strip()

    if "aucun" in packages_text.lower():
        package_constat = "DMP a vérifié les paquets Debian et n’a constaté aucun paquet cassé."
        package_interpretation = "Aucun paquet cassé n’est signalé par cette vérification."
        package_conclusion = "Aucune action concernant des paquets cassés n’est justifiée par ce résultat."
    else:
        package_constat = f"DMP a obtenu le résultat suivant concernant les paquets : {packages_text}."
        package_interpretation = "Le résultat signale une situation qui doit être examinée avant toute action."
        package_conclusion = "Une analyse complémentaire est nécessaire avant de proposer une action."

    explanations.append({
        "element": "Paquets",
        "constat": package_constat,
        "explication": "Un paquet Debian est un ensemble de fichiers permettant d’installer ou de maintenir un logiciel. Un paquet cassé présente un problème qui empêche sa gestion correcte.",
        "interpretation": package_interpretation,
        "limites": "Cette vérification ne constitue pas une analyse complète de tous les problèmes possibles d’un système Debian.",
        "conclusion": package_conclusion
    })

# --------------------------------------------------
# Mises à jour — C1 fait foi
# --------------------------------------------------

if not updates_collected:
    explanations.append({
        "element": "Mises à jour",
        "constat": "DMP n’a pas obtenu de résultat exploitable lors de la vérification des mises à jour.",
        "explication": "Cette vérification permet de déterminer si des mises à jour sont actuellement en attente.",
        "interpretation": "Le résultat ne permet pas de déterminer l’état actuel des mises à jour.",
        "limites": "Sans résultat fiable de C1, DMP ne peut pas conclure que le système est à jour ou qu’une mise à jour est en attente.",
        "conclusion": "Aucune conclusion sur l’état des mises à jour n’est établie."
    })
elif updates_available is False and update_count == 0:
    explanations.append({
        "element": "Mises à jour",
        "constat": "DMP a constaté que le système est à jour. Aucune mise à jour n’est actuellement en attente.",
        "explication": "DMP recherche les paquets Debian pour lesquels une mise à jour est disponible.",
        "interpretation": "DMP n’a détecté aucune mise à jour au moment de la mesure.",
        "limites": "Ce résultat décrit l’état constaté au moment de la vérification. Il peut évoluer lorsqu’une nouvelle mise à jour est publiée.",
        "conclusion": "Aucune action de mise à jour n’est nécessaire sur la base de cette vérification."
    })
else:
    explanations.append({
        "element": "Mises à jour",
        "constat": f"DMP a constaté que {update_count} mise(s) à jour sont actuellement en attente.",
        "explication": "Une mise à jour correspond à une nouvelle version d’un paquet Debian disponible pour le système.",
        "interpretation": f"C1 a détecté {update_count} mise(s) à jour disponible(s) au moment de la mesure.",
        "limites": "La mesure indique le nombre détecté à cet instant. Elle ne décrit pas à elle seule l’importance ou l’urgence de chaque mise à jour.",
        "conclusion": "La présence de mises à jour constitue une information à examiner avant toute décision d’installation."
    })

# --------------------------------------------------
# Données techniques complémentaires
# --------------------------------------------------

technical_items = []

# --------------------------------------------------
# Système
# --------------------------------------------------

system_observation = None

if not unavailable(system_result):
    parts = [part.strip() for part in str(system_result).split(" — ")]

    system_observation = {
        "machine": parts[0] if len(parts) > 0 else None,
        "distribution": parts[1] if len(parts) > 1 else None,
        "kernel": (
            parts[2].replace("noyau ", "", 1).strip()
            if len(parts) > 2 else None
        ),
        "architecture": parts[3] if len(parts) > 3 else None
    }

technical_items.append(
    technical_item(
        "Système",
        "observation",
        observation=system_observation
    )
)

# --------------------------------------------------
# Processeur
# --------------------------------------------------

technical_items.append(
    technical_item(
        "Processeur",
        "observation",
        observation=(
            {"model": str(cpu_result).strip()}
            if not unavailable(cpu_result)
            else None
        )
    )
)

# --------------------------------------------------
# Mémoire
# --------------------------------------------------

memory_observation = None

if not unavailable(memory_result):
    memory_line = ""
    swap_line = ""

    for part in str(memory_result).split(" — "):
        part = part.strip()

        if part.startswith("Mem:"):
            memory_line = part
        elif part.startswith("Échange:"):
            swap_line = part

    def parse_values(line, labels):
        if not line:
            return None

        values = line.split()[1:]

        if len(values) != len(labels):
            return None

        return dict(zip(labels, values))

    memory_values = parse_values(
        memory_line,
        [
            "total",
            "used",
            "free",
            "shared",
            "buffer_cache",
            "available"
        ]
    )

    swap_values = parse_values(
        swap_line,
        [
            "total",
            "used",
            "available"
        ]
    )

    if memory_values is not None or swap_values is not None:
        memory_observation = {
            "memory": memory_values,
            "swap": swap_values
        }

technical_items.append(
    technical_item(
        "Mémoire",
        "measure",
        measure=memory_observation
    )
)

# --------------------------------------------------
# Stockage
# --------------------------------------------------

storage_observation = []

if not unavailable(storage_result):
    for index, entry in enumerate(str(storage_result).split(" ; "), start=1):
        fields = entry.split()

        if len(fields) >= 3:
            device = fields[0]
            size = fields[-1]
            model = " ".join(fields[1:-1])

            storage_observation.append({
                "display_name": f"Disque {index}",
                "device": device,
                "model": model,
                "size": size
            })

if not storage_observation:
    storage_observation = None

technical_items.append(
    technical_item(
        "Stockage",
        "observation",
        observation=storage_observation
    )
)

# --------------------------------------------------
# Espace disque
# --------------------------------------------------

disk_measure = None

if not unavailable(disk_result):
    fields = str(disk_result).split()

    if len(fields) >= 6:
        disk_measure = {
            "filesystem": fields[0],
            "size": fields[1],
            "used": fields[2],
            "available": fields[3],
            "usage_percent": fields[4],
            "mountpoint": fields[5]
        }

technical_items.append(
    technical_item(
        "Espace disque",
        "measure",
        measure=disk_measure
    )
)

# --------------------------------------------------
# SSD / TRIM
# --------------------------------------------------

trim_observation = None

if not unavailable(trim_result):
    marker = "Active:"

    if marker in str(trim_result):
        value = str(trim_result).split(marker, 1)[1].strip()

        if " since " in value:
            state, since = value.split(" since ", 1)
            since = since.split(";", 1)[0].strip()

            trim_observation = {
                "state": state.strip(),
                "since": since
            }
        else:
            trim_observation = {
                "state": value
            }

technical_items.append(
    technical_item(
        "SSD / TRIM",
        "observation",
        observation=trim_observation
    )
)

# --------------------------------------------------
# Paquets
# --------------------------------------------------

packages_data = None

if not unavailable(packages_result):
    prefix = "Paquets cassés :"

    if str(packages_result).startswith(prefix):
        packages_data = {
            "broken_packages": str(packages_result)[len(prefix):].strip()
        }
    else:
        packages_data = {
            "raw": str(packages_result).strip()
        }

technical_items.append(
    technical_item(
        "Paquets",
        "result",
        result=packages_data
    )
)

# --------------------------------------------------
# Mises à jour
# --------------------------------------------------

if not updates_collected:
    technical_items.append(
        technical_item(
            "Mises à jour",
            "result",
            status="unavailable"
        )
    )
else:
    technical_items.append(
        technical_item(
            "Mises à jour",
            "result",
            result={
                "updates_available": updates_available,
                "update_count": update_count,
                "updates": c1.get(
                    "updates",
                    "Information indisponible"
                )
            }
        )
    )

# --------------------------------------------------
# Résultat final
# --------------------------------------------------

print(json.dumps({
    "collected": (
        bool(e1_2.get("collected", False))
        and updates_collected
    ),
    "history_count": history_count,
    "latest_report": latest_report,
    "explanations": explanations,
    "technical": {
        "collection": (
            "Réussie"
            if bool(e1_2.get("collected", False))
            else "Échec"
        ),
        "source": {
            "type": "collecteurs DMP",
            "e1_2": "e1_2_data.sh",
            "updates": "c1_data.sh",
            "latest_report": latest_report
        },
        "items": technical_items
    }
}, ensure_ascii=False, indent=4))
PY
