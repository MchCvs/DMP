# Gabarit de traduction de DMP

## La règle

Tout texte affiché à l'écran se trouve dans `modules/i18n/langues/fr.json`, `en.json` et `de.json`.
Aucun texte français n'est écrit dans un fichier `.sh`, `.html` ou `.js`.

## Le gabarit par page

Chaque page a les mêmes clés, toujours identiques :

| Clé | Contenu |
|---|---|
| `<id>.titre` | Titre de la page |
| `<id>.comprendre` | Paragraphe « Comprendre » |
| `<id>.voit` | Bloc « Ce qu'on voit » |
| `<id>.veut` | Bloc « Ce que ça veut dire » |
| `<id>.infos` | Bloc « Informations techniques » |

Exemple pour la page B7 : `b7.titre`, `b7.comprendre`, `b7.voit`, `b7.veut`, `b7.infos`.

## Les textes dynamiques

Les chiffres et les listes se mettent dans des clés, avec des emplacements `{nom}` :

    "b7.rang": "{rang}) {nom}"
    "b7.memoire": "Mémoire : {mo} Mo"

Les noms de programmes et de paquets ne se traduisent pas.

## Pour ajouter une langue

Copier `fr.json` vers `xx.json`, traduire les valeurs, garder les clés identiques.

## Le contrôle automatique

`test-integration.sh` échoue si :
- une clé française n'existe pas en anglais ou en allemand ;
- un accent français apparaît dans un fichier `.sh` ou `.html` hors d'une clé.
