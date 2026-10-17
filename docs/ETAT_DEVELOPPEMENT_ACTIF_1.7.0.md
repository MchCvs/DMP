# État du développement actif DMP 1.7.0

**Date :** 24 juillet 2026  
**Version :** 1.7.0  

---

# 1. Objet du document

Ce document décrit l'état validé du développement actif du projet DMP.

Il constitue un point de référence après la mise en place d'une organisation séparant clairement :

- le développement en cours ;
- l'historique des versions ;
- les corrections réalisées ;
- les expérimentations temporaires.

L'objectif est de garantir un projet lisible, maintenable et transmissible.

---

# 2. État validé du projet

## Version active

Version actuelle :

1.7.0

La base active est située dans :

DMP/developpement/dmp/

Cette version constitue la référence pour les futures évolutions.

---

# 3. Organisation du développement actif

Structure principale :

DMP/

├── developpement/
│ └── dmp/
│ Projet actif
│ README_DEVELOPPEUR.md
│ Méthode de travail de la base active
├── archives/
│ └── developpement_1.7.0/
│ Historique organisé

└── sauvegardes/
Points de restauration validés

---

# 4. Séparation entre développement et historique

## Développement actif

Le dossier :

developpement/dmp/

contient uniquement :

- les fichiers actuellement utilisés ;
- les modules fonctionnels ;
- la documentation active ;
- les éléments nécessaires au développement.

---

## Historique de développement

Le dossier :

archives/developpement_1.7.0/

contient :

### anciennes_versions_fichiers

Anciennes variantes techniques conservées pour référence.

### corrections

Historique des corrections et problèmes rencontrés.

### essais

Espace destiné aux expérimentations temporaires.

---

# 5. Principes appliqués

Cette organisation respecte les principes DMP :

- vérifier avant de valider ;
- conserver l'historique sans polluer le présent ;
- privilégier la compréhension aux automatismes ;
- favoriser la maintenance à long terme ;
- permettre à un nouveau contributeur de comprendre rapidement le projet.

---

# 6. Vérifications effectuées

Contrôles réalisés :

- sauvegarde de la base active ;
- comparaison avec la source 1.7.0 validée ;
- nettoyage des fichiers temporaires ;
- contrôle de l'absence de fichiers `before`, `backup`, `bad`, `tmp` dans le développement actif ;
- validation de l'archive de restauration.

---

# 7. Point de restauration

Archive validée :

sauvegardes/
DMP_DEVELOPPEMENT_ACTIF_1.7.0_NETTOYE_VALIDE_20260724.tar.gz

---

# 8. Prochaines évolutions

Les futures évolutions devront partir uniquement de :

developpement/dmp/

Toute modification importante devra suivre la méthode DMP :

1. sauvegarde ;
2. modification contrôlée ;
3. vérification ;
4. validation ;
5. archivage si nécessaire.

---

# Validation du jalon

**DMP — Développement actif 1.7.0 validé**

Date :

24 juillet 2026

