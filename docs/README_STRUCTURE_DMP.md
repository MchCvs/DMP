# Debian Maintenance Professional (DMP)

## Charte de structure du projet

Version : 1.1  
Date : 16 juillet 2026  
Créateur : Thierry CHEVASSUS  
Origine : La Réunion, France


---

# 1. Philosophie du projet

Debian Maintenance Professional (DMP) est un projet destiné à simplifier,
sécuriser et professionnaliser la maintenance des systèmes Debian.

DMP repose sur quatre principes fondamentaux :

- simplicité d'utilisation ;
- fiabilité des opérations ;
- transparence des actions effectuées ;
- conservation d'un historique clair.

Le projet doit rester :

- lisible ;
- documenté ;
- maintenable ;
- évolutif ;
- compréhensible dans le temps.


---

# 2. Organisation générale

La structure principale du projet est :

~/DMP/

| Dossier | Rôle |
|---|---|
| archives | Conservation des anciennes versions, essais et historiques |
| developpement | Espace de développement actif et évolutions en cours |
| documents | Documentation officielle du projet |
| projet | Historique des constructions et versions de travail |
| releases | Versions exportées et distribuables |
| sauvegardes | Points de restauration du projet |
| tests | Environnements de validation |


---

# 3. Règle fondamentale de modification

Aucune modification importante ne doit être réalisée directement
sans sauvegarde préalable.

Cycle obligatoire :

1. Sauvegarde de l'état actuel.
2. Modification contrôlée.
3. Vérification syntaxique.
4. Test fonctionnel.
5. Validation.
6. Documentation.


---

# 4. Gestion des archives

Le dossier archives contient la mémoire technique du projet.

Organisation :

| Élément | Destination |
|---|---|
| anciennes versions | archives/anciennes_versions |
| essais abandonnés | archives/anciennes |
| fichiers de travail temporaires | archives dédiées |


Une archive ne doit jamais être supprimée sans vérification préalable.


---

# 5. Gestion des versions

Chaque version importante doit être identifiable.

Convention recommandée :

DMP_X.Y.Z_description

Exemple :

DMP_1.7.0_FINAL


Les versions validées doivent être conservées dans :

~/DMP/releases/


---

# 6. Gestion des sauvegardes

Avant toute opération importante :

- création d'une sauvegarde ;
- vérification de l'archive ;
- conservation d'un point de retour.

Les sauvegardes principales sont conservées dans :

~/DMP/sauvegardes/


---

# 7. Contrôle qualité DMP

Toute évolution doit être contrôlée.

Contrôles recommandés :

| Type | Commande |
|---|---|
| Syntaxe Bash | bash -n fichier.sh |
| Structure projet | tree -L 3 ~/DMP |
| Archive | tar -tzf archive.tar.gz |
| Intégrité | sha256sum fichier |


---

# 8. Philosophie de développement

Une erreur n'est pas un échec.

Une erreur doit :

- être identifiable ;
- être conservée si elle apporte une information ;
- permettre d'améliorer la méthode.

DMP privilégie :

- la stabilité ;
- la sécurité ;
- la compréhension ;
- la qualité.


---

# 9. Historique de réorganisation

Le 16 juillet 2026, le projet DMP a été restructuré afin de :

- centraliser les fichiers du projet ;
- séparer développement, tests, archives et releases ;
- améliorer la lisibilité ;
- préparer une maintenance durable.


Cette organisation constitue la base officielle du projet DMP.

---

# 10. Documentation officielle

Les documents principaux du projet DMP sont organisés selon leur rôle.

| Document | Rôle |
|---|---|
| README.md | Présentation générale du projet |
| README_STRUCTURE_DMP.md | Organisation et règles structurelles |
| DMP_GUIDE_UTILISATEUR.md | Guide destiné aux utilisateurs |
| DMP_MODULE_GUIDE.md | Méthode de conception des modules |
| METHODE_DE_DEVELOPPEMENT_DMP.md | Méthode officielle d'évolution du projet |

Cette séparation permet de conserver une documentation claire,
accessible et maintenable.

Chaque document possède une mission précise et complète les autres
éléments de la documentation DMP.

---

# Fin du document

Debian Maintenance Professional  
Structure validée - Version 1.1
