# Guide de conception des modules DMP

## Debian Maintenance Professionnel (DMP)

**Version : 1.0**  
**Date : 23 juillet 2026**  
**Auteur : Thierry CHEVASSUS**  
**Origine : La Réunion, France**

---

# 1. Objet du document

## 1.1 Rôle du guide

Ce document définit la méthode officielle de conception, d'intégration,
de test et de maintenance des modules du projet DMP.

Un module DMP n'est pas considéré comme une simple fonctionnalité technique.

Il représente une partie organisée de la méthode DMP et doit respecter les
principes fondamentaux du projet :

- simplicité pour l'utilisateur ;
- qualité technique ;
- compréhension avant automatisation ;
- vérification avant validation ;
- respect du système Debian.

Ce guide permet de garantir que l'évolution du projet reste cohérente,
même lorsque plusieurs personnes participent à son développement.

---

## 1.2 Pourquoi une méthode pour les modules ?

Un outil de maintenance système peut rapidement devenir un ensemble de
scripts indépendants et difficiles à maintenir.

DMP adopte une approche différente.

Chaque module doit avoir :

- une raison d'exister ;
- une mission clairement définie ;
- des limites précises ;
- un comportement prévisible ;
- une documentation associée.

Le développement d'un module ne commence donc pas par du code.

Il commence par une question :

> Quel besoin réel de l'utilisateur ce module doit-il résoudre ?

---

## 1.3 Place du module dans DMP

L'architecture DMP repose sur des modules spécialisés.

Chaque module apporte une capacité précise au logiciel tout en restant intégré
dans une méthode commune.

Exemple :

```text
DMP
│
├── Module diagnostic système
├── Module analyse SMART
├── Module maintenance Debian
├── Module nettoyage
├── Module rapports
└── Module historique
```


---

# 2. Philosophie d'un module DMP

## 2.1 Un module n'est pas seulement du code

Dans DMP, un module ne représente pas uniquement un ensemble de fonctions
ou de commandes.

Il représente une partie de la méthode du projet.

Un module doit permettre à l'utilisateur de mieux comprendre son système
avant de proposer une action.

La valeur d'un module ne se mesure donc pas uniquement à ce qu'il exécute,
mais également à ce qu'il explique.

---

## 2.2 La méthode DMP

Chaque module DMP suit une démarche commune :

# 3. Anatomie d'un module DMP

Un module DMP possède une structure claire afin de rester compréhensible,
maintenable et cohérent avec l'architecture générale du projet.

Avant d'être développé, un module doit être défini par son rôle,
ses limites et ses responsabilités.

Un module bien conçu ne cherche pas à tout faire.

Il possède une mission précise et s'intègre naturellement dans l'ensemble DMP.

---

## 3.1 Mission d'un module

La mission définit la raison d'exister du module.

Elle répond à une question essentielle :

> Quel besoin réel de l'utilisateur ce module doit-il résoudre ?

La mission d'un module doit être :

- clairement identifiée ;
- utile à l'utilisateur ;
- compréhensible ;
- limitée à un domaine précis.

Exemple :

