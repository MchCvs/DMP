# DMP — Debian Maintenance Professionnel

DMP aide les utilisateurs de **Debian GNU/Linux**, même débutants, à comprendre, suivre et entretenir leur machine.

Chaque page suit le même cycle : **observation → compréhension → explication → décision de l'utilisateur**. DMP observe et explique en langage simple. Il ne modifie jamais le système de lui-même.

## Aperçu

**Le menu d'accueil** : toutes les sections d'un coup d'œil.

![Menu d'accueil de DMP](web/assets/captures/menu-accueil.png)

**Chaque page explique** : ce que c'est, ce que DMP voit sur votre machine, et ce que cela veut dire.

![Page explicative de DMP](web/assets/captures/page-explicative.png)

**Un score sur 100** qui résume l'état de votre machine.

![Score de DMP](web/assets/captures/score.png)

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
| E | Résumé, score et analyse |
| F | Contrôle qualité, sauvegarde, benchmark, historique |

## Prérequis et compatibilité

- **Testé** : Debian 13 (Python 3.13)
- **Compatibles en principe, non testés** : Debian 11 et 12, Ubuntu et dérivés (`apt`, `dpkg`, `systemd`)
- **Non compatibles** : Windows, macOS, Fedora, Arch (DMP s'appuie sur `apt`, `dpkg` et `systemd`)
- Python 3 et les outils courants (`lsblk`, `df`, `ip`, `ss`, `free`, `journalctl`), présents par défaut
- `lspci` et `lsusb` : si absents, `sudo apt install pciutils usbutils`
- `smartmontools` (santé des disques) : `sudo apt install smartmontools`, puis la règle sudo décrite dans « Santé des disques (SMART) » ci-dessous

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

### Santé des disques (SMART)

La page de santé des disques lit les données SMART, fournies par `smartmontools`.
Lire ces données demande les droits administrateur, mais DMP ne demande jamais
de mot de passe : il utilise `sudo -n`, qui échoue au lieu de bloquer.

Autorisez uniquement la lecture SMART, avec `sudo visudo` ou un fichier dans
`/etc/sudoers.d/` :

    votre_utilisateur ALL=(root) NOPASSWD: /usr/sbin/smartctl

Sans cette règle, la page signale que les données SMART sont indisponibles.
Ce n'est pas une panne du disque, c'est un problème d'accès.

## Sécurité et vie privée

- Lecture seule : aucune action cachée, aucune modification durable du système (le test de vitesse écrit 64 Mo temporaires dans votre dossier personnel, supprimés aussitôt)
- Aucune donnée envoyée sur Internet : tout reste sur votre machine
- Serveur accessible uniquement depuis votre ordinateur

## Licence

[GPL-3.0-or-later](LICENSE) : logiciel libre, gratuit, modifiable et redistribuable sous la même licence, avec mention de l'auteur.

## Auteur

Créé par Thierry CHEVASSUS, Piton Sainte Rose, île de la Réunion, France.
