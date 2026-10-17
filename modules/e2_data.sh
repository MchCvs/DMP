#!/bin/bash

set -e

DMP_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$DMP_ROOT/lib/score.sh"

set +e
dmp_calculate_score
set -e



python3 - \
    "$DMP_SCORE" \
    "$DMP_STATE" \
    "$DMP_PAQUETS" \
    "$DMP_DISQUE" \
    "$DMP_TRIM" \
    "$DMP_RAM" \
    "$DMP_SMART" \
    "$DMP_TECH_DISQUE_USAGE" \
    "$DMP_TECH_MEM_USAGE" \
    "$DMP_TECH_PAQUETS_RAW" \
    "$DMP_TECH_PAQUETS_EXIT_CODE" \
    "$DMP_TECH_DISQUE_RAW" \
    "$DMP_TECH_DISQUE_EXIT_CODE" \
    "$DMP_TECH_DISQUE_FILESYSTEM" \
    "$DMP_TECH_DISQUE_SIZE" \
    "$DMP_TECH_DISQUE_USED" \
    "$DMP_TECH_DISQUE_AVAILABLE" \
    "$DMP_TECH_TRIM_RAW" \
    "$DMP_TECH_TRIM_EXIT_CODE" \
    "$DMP_TECH_MEMOIRE_RAW" \
    "$DMP_TECH_MEMOIRE_EXIT_CODE" \
    "$DMP_TECH_MEM_TOTAL" \
    "$DMP_TECH_MEM_USED" \
    "$DMP_TECH_MEM_FREE" \
    "$DMP_TECH_MEM_SHARED" \
    "$DMP_TECH_MEM_BUFF_CACHE" \
    "$DMP_TECH_MEM_AVAILABLE" \
    "$DMP_TECH_SWAP_TOTAL" \
    "$DMP_TECH_SWAP_USED" \
    "$DMP_TECH_SWAP_FREE" \
    "$DMP_TECH_SMART_RAW" \
    "$DMP_TECH_SMART_SOURCE_PARTITION" \
    "$DMP_TECH_SMART_DEVICE" \
    "$DMP_TECH_SMART_EXIT_CODE" \
    "${DMP_TECH_STEPS[@]}" <<'PY'
import json
import sys

(
    score,
    state,
    paquets,
    disque,
    trim,
    ram,
    smart,
    disk_usage,
    mem_usage,
    packages_raw,
    packages_exit,
    disk_raw,
    disk_exit,
    disk_filesystem,
    disk_size,
    disk_used,
    disk_available,
    trim_raw,
    trim_exit,
    memory_raw,
    memory_exit,
    mem_total,
    mem_used,
    mem_free,
    mem_shared,
    mem_buff_cache,
    mem_available,
    swap_total,
    swap_used,
    swap_free,
    smart_raw,
    smart_partition,
    smart_device,
    smart_exit,
    *step_args,
) = sys.argv[1:]

def contribution(status, penalty):
    return -penalty if status == "PROBLEME" else 0

elements = [
    {
        "element": "Paquets Debian",
        "result": paquets,
        "criterion": "Paquets cassés",
        "value": paquets,
        "contribution": contribution(paquets, 15),
    },
    {
        "element": "Espace disque",
        "result": f"{disk_usage}% utilisés",
        "criterion": "Utilisation du système de fichiers /",
        "value": disk_usage,
        "contribution": contribution(disque, 20),
    },
    {
        "element": "TRIM SSD",
        "result": trim,
        "criterion": "TRIM actif",
        "value": trim,
        "contribution": 0,
    },
    {
        "element": "Mémoire",
        "result": f"{mem_usage}% utilisés",
        "criterion": "Utilisation de la mémoire",
        "value": mem_usage,
        "contribution": contribution(ram, 10),
    },
    {
        "element": "SSD SMART",
        "result": smart,
        "criterion": "État SMART",
        "value": smart,
        "contribution": contribution(smart, 20),
    },
]

def parse_step(value):
    fields = value.split("|", 7)
    return {
        "element": fields[0],
        "command": fields[1],
        "criterion": fields[2],
        "evaluation": fields[3],
        "planned_penalty": int(fields[4]),
        "contribution": int(fields[5]),
        "score_before": int(fields[6]),
        "score_after": int(fields[7]),
    }

calculation_steps = [parse_step(step) for step in step_args]

payload = {
    "module": "E2",
    "collected": True,
    "score": int(score),
    "state": state,
    "elements": elements,
    "technical": {
        "initial_score": 100,
        "score": int(score),
        "state": state,

        "calculation_steps": calculation_steps,

        "observations": {
            "paquets": {
                "command": "dpkg --audit",
                "exit_code": int(packages_exit),
                "raw": packages_raw,
            },
            "disque": {
                "command": "df /",
                "exit_code": int(disk_exit),
                "raw": disk_raw,
                "filesystem": disk_filesystem,
                "size_kib": int(disk_size) if disk_size else None,
                "used_kib": int(disk_used) if disk_used else None,
                "available_kib": int(disk_available) if disk_available else None,
                "usage_percent": int(disk_usage) if disk_usage else None,
            },
            "trim": {
                "command": "systemctl is-enabled fstrim.timer",
                "exit_code": int(trim_exit),
                "raw": trim_raw,
            },
            "memoire": {
                "command": "free",
                "exit_code": int(memory_exit),
                "raw": memory_raw,
                "total_kib": int(mem_total) if mem_total else None,
                "used_kib": int(mem_used) if mem_used else None,
                "free_kib": int(mem_free) if mem_free else None,
                "shared_kib": int(mem_shared) if mem_shared else None,
                "buff_cache_kib": int(mem_buff_cache) if mem_buff_cache else None,
                "available_kib": int(mem_available) if mem_available else None,
                "swap_total_kib": int(swap_total) if swap_total else None,
                "swap_used_kib": int(swap_used) if swap_used else None,
                "swap_free_kib": int(swap_free) if swap_free else None,
                "usage_percent": int(mem_usage) if mem_usage else None,
            },
            "smart": {
                "command": f"sudo -n smartctl -H {smart_device}".strip(),
                "source_partition": smart_partition,
                "device": smart_device,
                "exit_code": int(smart_exit) if smart_exit else None,
                "raw": smart_raw,
            },
        },

        "criteria": [
            {
                "element": "Paquets Debian",
                "condition": "Paquets cassés détectés",
                "penalty": -15,
            },
            {
                "element": "Espace disque",
                "condition": "Utilisation supérieure à 85 %",
                "penalty": -20,
            },
            {
                "element": "TRIM SSD",
                "condition": "TRIM non disponible ou non actif",
                "penalty": 0,
            },
            {
                "element": "Mémoire",
                "condition": "Utilisation supérieure à 90 %",
                "penalty": -10,
            },
            {
                "element": "SSD SMART",
                "condition": "Échec SMART",
                "penalty": -20,
            },
        ],
    },
}

print(json.dumps(payload, ensure_ascii=False))
PY
