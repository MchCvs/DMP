# Changelog DMP

Toutes les évolutions importantes de Debian Maintenance Professional.

---

## Version 1.8.3 - 24 octobre 2026

- Paquet Debian `dmp` (lanceur, service utilisateur, icône et entrée de menu)
- Score fondé sur des niveaux explicites déclarés par chaque collecteur
- Sécurité : validation des noms de collecteurs et des chemins web, échappement du rapport HTML, plus de `eval` sur `lsblk`
- Données utilisateur dans les dossiers XDG, benchmark disque réduit à 64 Mo
- Confirmations avant les actions de maintenance, tests des collecteurs

## Version 1.8.2 - 17 octobre 2026

- Passage à la licence GPL-3.0-or-later

## Version 1.8.1 - 17 octobre 2026

- Délai des collecteurs porté à 90 s (machines lentes)

## Version 1.7.0 - 15 juillet 2026

### Ajouts
- Installateur système
- Désinstallateur propre
- Gestionnaire de plugins
- Contrôle qualité automatique
- Support multilingue
- Sélection de langue au démarrage

### Corrections
- Correction des fichiers manquants dans l'installation
- Validation complète du paquet

---

## Version 1.5.0 - 15 juillet 2026

### Internationalisation
- Ajout d'un système de langues séparées
- Ajout des fichiers de traduction fr.lang et en.lang
- Chargement dynamique des textes d'interface

### Assistant de langue
- Ajout du choix de langue au premier lancement
- Enregistrement automatique de la préférence utilisateur
- Chargement automatique de la langue configurée

### Interface
- Nouveau menu aligné
- Amélioration de la lisibilité générale
- Séparation complète entre code et traductions

### Préparation communauté
- Architecture prête pour l'ajout de nouvelles langues
- Traductions pouvant être proposées par les utilisateurs

### Maintenance
- Séparation du code et des traductions
- Gestion centralisée des textes d'interface
- Structure préparée pour les futures extensions
# Version 1.4.0 - 2026-07-14

## Nouvelles fonctionnalités

- Ajout de l'identité du projet
- Ajout des informations auteur et origine
- Ajout de la commande :
  - `dmp --version`
  - `dmp -v`
- Installation possible comme commande système Linux
- Amélioration du menu principal
- Ajout des rapports HTML
- Ajout de l'historique machine
- Ajout des graphiques d'évolution

## Améliorations

- Organisation modulaire des scripts
- Centralisation de la configuration
- Amélioration de la présentation utilisateur

---

# Version 1.3.0

- Ajout du tableau de bord HTML
- Ajout du suivi historique
- Ajout des fonctions d'optimisation

---

# Versions précédentes

Développement initial de DMP :
- diagnostics système ;
- maintenance Debian ;
- contrôle SSD SMART ;
- nettoyage système.
