# DMP v1.0 — Debian Maintenance Professionnel

## Qu'est-ce que DMP ?

DMP est une plateforme web qui explique votre ordinateur Debian en langage simple.

- ZERO FLOU : Chaque information expliquée
- 42 collecteurs : Tout sur votre système
- 104 pages : Navigation facile
- 100% transparent : Aucune action cachée

## Démarrer

```bash
cd /home/thierry/DMP-FINAL/web/server
python3 dmp_simple.py &
```

http://127.0.0.1:8765/

## Les 6 Sections

- **A** (A1-A9) : Découverte du matériel
- **B** (B1-B9) : Activité en temps réel
- **C** (C1-C4) : Maintenance
- **D** (D1-D3) : Décision
- **E** (E1-E5, E3, E4) : Rapports et graphiques
- **F** (F1, F2, F3, F4) : Contrôle et extensions

## Tester

```bash
curl http://127.0.0.1:8765/api/a1
curl http://127.0.0.1:8765/menu.html
```

---
DMP v1.0 — 15 octobre 2026 — Production Ready
