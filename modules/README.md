# Debian Maintenance Professional (DMP)

## Présentation

Debian Maintenance Professional (DMP) est un outil libre de diagnostic, de maintenance et d'optimisation pour Debian GNU/Linux.

Son objectif est de proposer un ensemble d'outils simples, accessibles et compréhensibles pour surveiller l'état d'une machine Debian et faciliter son entretien quotidien.

---

## Informations du projet

**Nom :** Debian Maintenance Professional (DMP)
**Version :** 1.7.0
**Créateur :** Thierry CHEVASSUS
**Origine :** La Réunion, France 🇷🇪
**Licence :** MIT

---

## Fonctionnalités

DMP propose actuellement :

* Diagnostic système
* Diagnostic SSD / SMART
* Maintenance Debian
* Nettoyage système
* Rapport complet
* Score santé DMP
* Optimisation système
* Optimisations recommandées
* Analyse des performances
* Historique de la machine
* Analyse de l'historique
* Génération de rapports HTML
* Graphiques historiques
* Contrôle qualité intégré
* Gestionnaire de plugins

---

## Internationalisation

DMP est compatible avec plusieurs langues.

Langues actuellement disponibles :

* 🇫🇷 Français
* 🇬🇧 English

Le choix de la langue est proposé au premier lancement et mémorisé dans :

```text
config/dmp.conf
```

Les nouvelles traductions peuvent être créées à partir du modèle :

```text
languages/template.lang
```

Un vérificateur contrôle automatiquement la cohérence des fichiers de langue :

```bash
./dmp-check-language.sh
```

---

## Contrôle qualité

DMP possède un système intégré de contrôle qualité permettant de vérifier :

* la présence des fichiers essentiels ;
* la syntaxe de tous les scripts Bash ;
* la validité des fichiers de langue ;
* la structure des plugins.

Exécution :

```bash
./dmp-check.sh
```

---

## Architecture des plugins

DMP supporte les extensions communautaires.

Chaque plugin est installé dans :

```text
plugins/
```

Structure minimale :

```text
plugins/
└── mon_plugin/
    ├── plugin.conf
    └── mon_plugin.sh
```

Le fichier `plugin.conf` contient notamment :

* nom du plugin ;
* version ;
* auteur ;
* description ;
* script principal.

Le gestionnaire de plugins intégré permet d'afficher les plugins disponibles directement depuis le menu principal.

---

## Installation

Cloner le projet :

```bash
git clone <url-du-projet>
cd dmp
```

Ou lancer directement :

```bash
./bin/dmp
```

---

## Structure du projet

```text
dmp/
├── bin/
├── config/
├── docs/
├── languages/
├── lib/
├── plugins/
├── reports/
├── AUTHORS
├── CHANGELOG.md
├── dmp-check.sh
├── dmp-check-language.sh
├── LICENSE
└── README.md
```

---

## Contribution

Les contributions sont les bienvenues.

Avant toute proposition, il est recommandé de lancer :

```bash
./dmp-check.sh
```

afin de vérifier que le projet est conforme aux contrôles qualité.

---

## Licence

Ce projet est distribué sous licence MIT.

---

**Debian Maintenance Professional (DMP)**
Développé avec passion à **La Réunion 🇷🇪** par **Thierry CHEVASSUS**.
