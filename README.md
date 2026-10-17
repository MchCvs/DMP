# DMP — Debian Maintenance Professionnel

DMP aide les utilisateurs de **Debian GNU/Linux**, même débutants, à comprendre, suivre et entretenir leur machine.

Chaque page suit le même cycle : **observation → compréhension → explication → décision de l'utilisateur**. DMP observe et explique en langage simple. Il ne modifie jamais le système de lui-même.

## Fonctionnement

Chaque page affiche quatre blocs :

1. **Comprendre** : de quoi on parle, en mots simples
2. **Ce qu'on voit** : les données réelles de votre machine, avec le pourquoi
3. **Ce que ça veut dire** : l'interprétation
4. **Infos techniques** : commandes et valeurs brutes (« DMP uniquement »)

## Sections

| Section | Contenu |
|---------|---------|
| A | Matériel : processeur, mémoire, disques, réseau, carte graphique, USB, alimentation… |
| B | Activité en temps réel : disponibilité, utilisation, services, processus, démarrage, sécurité |
| C | Maintenance : mises à jour, paquets, entretien, noyau |
| D | Aide à la décision : recherche, suppression prudente, bénéfices |
| E | Résumé, score, analyse, rapports et données graphiques |
| F | Contrôle qualité, sauvegarde, benchmark, historique |

## Prérequis

- Debian 13 (testé)
- Python 3
- `bash`
- Optionnel : `smartctl` (paquet `smartmontools`) pour l'état de santé des disques

## Installation

```bash
git clone https://github.com/MchCvs/DMP.git ~/DMP
bash ~/DMP/install.sh
```

DMP démarre ensuite automatiquement à chaque session. Ouvrir : <http://127.0.0.1:8765/> ou l'icône **DMP** du menu des applications.

Ne supprimez pas le dossier `~/DMP`. Mise à jour : `cd ~/DMP && git pull && systemctl --user restart dmp.service`. Désinstallation : `bash ~/DMP/uninstall.sh`.

## Structure

```
modules/collecteurs/   scripts bash qui collectent les données (JSON)
web/server/            serveur Python (API)
web/html/              pages web
```

## Sécurité et vie privée

- Lecture seule : aucune action cachée, aucune modification du système
- Aucune donnée envoyée sur Internet : tout reste sur votre machine
- Serveur accessible uniquement depuis votre ordinateur

## Licence

[PolyForm Noncommercial 1.0.0](LICENSE) : usage non commercial libre, mention de l'auteur obligatoire.

## Auteur

Créé par Thierry CHEVASSUS, Piton Sainte Rose, île de la Réunion, France.
