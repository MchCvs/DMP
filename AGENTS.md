# AGENTS.md : DMP (Debian Maintenance Professionnel)

Logiciel de Thierry Chevassus (La Réunion) qui explique en mots simples l'état d'une machine Debian. Dépôt : `~/DMP-FINAL`, branche `main`.

## Architecture

- `modules/collecteurs/*.sh` : un script par indicateur (a1 à f4). Chaque script calcule une valeur, charge ses textes et écrit un JSON (`comprendre`, `observations`, `resultat`, `niveau`).
- `modules/collecteurs/lib.sh` : fonctions communes (`j`, niveaux).
- `modules/i18n/langues/{fr,en,de}.json` : **dictionnaires de traduction, source unique des textes**. Clés stables (`a1.comp`, `b5.surveiller.texte`, `page.titre.a1`…). Un texte absent d'une langue retombe sur le français.
- `modules/i18n/langues.sh` : fonction `tr_cle clé [nom=valeur…]` lue par les scripts (remplace les emplacements `{nom}`).
- `modules/i18n/fr|en|de/*.sh` : anciens fichiers de textes, en cours de remplacement par les dictionnaires.
- `web/server/dmp_simple.py` : serveur HTTP (port 8765). Sert les pages, `/api/<collecteur>?lang=xx`, et `/i18n/<langue>.json`.
- `web/html/*.html` : pages (41). Chacune charge `page-i18n.js`.
- `web/html/page-i18n.js` : script commun de traduction (fil d'Ariane, titres `page.titre.*`, liens Suivant/Précédent, boutons `bouton.*`, libellés de section).
- `web/html/i18n.js` : sélecteur de langue, et traduction des textes dynamiques des pages.
- `debian/` : paquet Debian (`dmp`). Service utilisateur `dmp.service`.
- `test-integration.sh` : tests de non-régression (syntaxe, pages, niveaux).

## Règles de travail

- Commits sur `main`. Un commit par changement, message court en français.
- Avant une modification large : dire en une phrase ce qui va changer, puis attendre l'accord.
- Après chaque changement : vérifier la syntaxe (`bash -n`, `node --check`, `python3 -m json.tool`), puis tester l'API ou la page.
- Un texte nouveau va dans les trois dictionnaires (`fr`, `en`, `de`), pas dans le code.
- Ne jamais écrire un texte français en dur dans un script ou une page.
- Redémarrer le serveur après une modification de `dmp_simple.py` : `pkill -f dmp_simple.py` puis relancer.

## Ajouter une langue

1. Copier `modules/i18n/langues/fr.json` vers `xx.json` et traduire les valeurs (les clés ne changent pas).
2. Ajouter la langue dans le sélecteur de `web/html/i18n.js` et dans `dmp_simple.py` (liste des langues acceptées).
3. Vérifier qu'aucune clé ne manque (comparer les clés de `fr.json` et `xx.json`).

## Reste à faire

- Relecture de l'allemand par Michel (en attente de sa réponse), puis application de ses corrections et publication éventuelle d'une 1.8.9.
- Sous-pages C, D, E, F : textes à migrer vers les dictionnaires.

## Style

- Réponses courtes et directes, sans introduction ni conclusion creuse.
- Modifications ciblées (`grep`, `sed -n`) plutôt que réécriture de fichiers entiers.
- Commenter seulement ce qui est complexe.
- Découper les gros fichiers (pages de traduction, script de E5) plutôt que de les grossir.
