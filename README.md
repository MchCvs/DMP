# 🚀 DMP — Debian Maintenance Professionnel

**Version** : 1.8.0  
**Date** : 14 Octobre 2026  
**Status** : Production-Ready ✅

---

## 📋 Table des matières

1. [Vue d'ensemble](#vue-densemble)
2. [Installation](#installation)
3. [Utilisation](#utilisation)
4. [Architecture](#architecture)
5. [Collecteurs](#collecteurs)
6. [Support](#support)

---

## 🎯 Vue d'ensemble

DMP est une **plateforme pédagogique** pour comprendre et gérer Debian.

**Philosophie** : Transformer l'information technique en compréhension utile.

**Structure** : 4 niveaux pour chaque donnée :
- **Comprendre** : Explication humaine
- **Observations** : Résultats observés
- **Résultat** : Interprétation
- **Infos techniques** : JSON brut

---

## ⚡ Installation rapide

### Prérequis
- Debian 13+ 
- Python 3
- Bash

### Démarrage

```bash
cd /home/thierry/DMP-FINAL/web/server
python3 dmp_web_server.py
```

Puis ouvre : **http://127.0.0.1:8765/menu.html**

---

## 🌐 Utilisation

### Web
- Menu principal : http://127.0.0.1:8765/menu.html
- Pages A1-A9 : http://127.0.0.1:8765/a1-processeur.html
- Pages B1-B9 : http://127.0.0.1:8765/b1-etat-general.html
- Pages E3+ : http://127.0.0.1:8765/e3-1-preparer.html

### CLI
```bash
# Tester une API
curl http://127.0.0.1:8765/api/a1 | jq

# Lancer un collecteur
/home/thierry/DMP-FINAL/modules/collecteurs/a1.sh
```

---

## 🏗️ Architecture

---

## 🔧 Collecteurs (42 total)

### Section A — Découverte (9)
CPU, RAM, Disques, Réseau, GPU, Mère, Debian, USB, Alimentation

### Section B — Activité (9)
Général, CPU%, RAM%, Disque%, Réseau, Services, Processus, Boot, Sécurité

### Section C — Maintenance (4)
Mises à jour, Paquets, Entretien, Technique

### Section D — Décision (3)
Recherche, Suppression, Bénéfices

### Section E — Rapports (9)
Résumé, Score, Analyse

### Section F — Contrôle (8)
Contrôle, Résultats, Anomalies, Benchmark, Historique

---

## 📊 Données

Chaque collecteur retourne JSON :
```json
{
  "comprendre": "Explication pédagogique",
  "observations": "Données observées",
  "resultat": "Interprétation",
  "informations_techniques": { ... }
}
```

---

## 🚀 Prochaines étapes

- [ ] Graphiques E4 (Chart.js)
- [ ] Base de données historique
- [ ] Refactoriser serveur (Flask)
- [ ] Interface graphique avancée
- [ ] Mobile responsive

---

## 📞 Support

Documentation : `/home/thierry/DMP-FINAL/docs/`  
TODO : `/home/thierry/DMP-FINAL/TODO_PROCHAINES_SESSIONS.md`  

---

**Créé par Thierry | Réunion 🏝️**
