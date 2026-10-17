# Debian Maintenance Professional (DMP)

## Charte de développement du projet

Version : 1.0  
Date : 16 juillet 2026  
Créateur : Thierry CHEVASSUS  
Origine : La Réunion, France


---

# 1. Philosophie du développement DMP

Debian Maintenance Professional (DMP) est développé selon une idée fondamentale :

Un outil de maintenance doit inspirer confiance avant même d'être utilisé.

La confiance repose sur plusieurs principes :

- la clarté ;
- la transparence ;
- la sécurité ;
- la transmission du savoir.


DMP n'a pas pour objectif de masquer la complexité d'un système Debian.

Son objectif est de rendre cette complexité :

- compréhensible ;
- contrôlable ;
- accessible aux utilisateurs Linux.


---

# 2. Principes fondamentaux DMP


## Principe fondamental n°1 — Clarté et transmission

Toute modification apportée au projet DMP doit être suffisamment claire pour qu'un autre développeur puisse la comprendre, la vérifier et la maintenir plusieurs mois plus tard, sans explication supplémentaire de son auteur.


Une modification terminée doit être :

- compréhensible ;
- documentée si nécessaire ;
- vérifiable ;
- cohérente avec l'organisation du projet ;
- reproductible.


Si une partie du code nécessite une longue explication orale pour être comprise, elle doit être simplifiée ou mieux documentée.


---

## Principe fondamental n°2 — Sécurité et maîtrise des changements

Aucune modification importante ne doit être appliquée directement.

Toute évolution du projet suit une procédure contrôlée :

Sauvegarde
    ↓
Préparation
    ↓
Fichier temporaire
    ↓
Lecture complète
    ↓
Double vérification
    ↓
Validation
    ↓
Installation finale


Cette méthode permet d'éviter :

- les fichiers partiellement écrits ;
- les erreurs de copier-coller ;
- les EOF mal positionnés ;
- les modifications non vérifiées.


---

## Principe fondamental n°3 — Respect de l'utilisateur

Un utilisateur ne doit jamais avoir besoin de faire confiance aveuglément à DMP.

Il doit pouvoir comprendre :

- ce qui est effectué ;
- pourquoi cela est effectué ;
- quelles conséquences sont possibles ;
- comment revenir en arrière si nécessaire.


---

# 3. Organisation du projet

L'organisation DMP sépare clairement les fonctions :

DMP/

├── developpement/
│   └── dmp/
│       Développement actif

├── documents/
│       Documentation officielle

├── archives/
│       Historique du projet, essais et anciennes versions

└── sauvegardes/
        Points de restauration validés


Cette séparation garantit :

- la lisibilité ;
- la sécurité ;
- la facilité de maintenance.


---

# 4. Règles de modification du code


Avant toute modification importante :

1. Identifier le fichier concerné.
2. Effectuer une sauvegarde.
3. Créer une version temporaire.
4. Modifier uniquement cette version.
5. Lire le résultat complet.
6. Effectuer les contrôles nécessaires.
7. Valider seulement après vérification.


---

# 5. Gestion des versions


Chaque version importante doit être :

- identifiée ;
- datée ;
- sauvegardée ;
- testée.


Une release doit pouvoir être retrouvée plusieurs mois ou années après sa publication.


---

# 6. Procédure de test


Avant toute diffusion :

- vérifier le fonctionnement général ;
- vérifier les erreurs éventuelles ;
- contrôler les permissions ;
- vérifier les scripts Bash ;
- tester les fonctionnalités principales.


Un test réussi doit être reproductible.


---

# 7. Procédure de release


Avant publication d'une version :

Contrôle du code
    ↓
Contrôle documentaire
    ↓
Tests
    ↓
Création de l'archive
    ↓
Vérification de l'intégrité
    ↓
Publication


---

# 8. Règles de contribution


Toute contribution au projet DMP doit respecter :

- la simplicité ;
- la lisibilité ;
- la documentation ;
- la compatibilité Debian.


Une contribution n'est pas seulement une modification du code.

Elle doit améliorer la qualité globale du projet.


---

# 9. Validation finale


Une évolution DMP est considérée comme terminée uniquement si :

- elle fonctionne ;
- elle est comprise ;
- elle est documentée ;
- elle peut être vérifiée ;
- elle peut être restaurée.


---

# Fin du document

Debian Maintenance Professional

Charte de développement - Version 1.0

