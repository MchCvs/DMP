// DMP : traduction du cadre commun des pages (FR / EN / DE)
// Copyright (C) 2026 Thierry CHEVASSUS — GPL-3.0-or-later — voir LICENSE
(function () {
  var SUP = ['fr', 'en', 'de'];
  function pick() {
    var p = new URLSearchParams(location.search).get('lang');
    var s = null;
    try { s = localStorage.getItem('dmp_lang'); } catch (e) {}
    var l = p || s || (navigator.language || 'fr').slice(0, 2);
    return SUP.indexOf(l) >= 0 ? l : 'fr';
  }
  var LANG = pick();
  try { localStorage.setItem('dmp_lang', LANG); } catch (e) {}
  window.DMP_LANG = LANG;
  document.documentElement.lang = LANG;

  // Les appels à l'API transmettent la langue au collecteur
  var realFetch = window.fetch;
  window.fetch = function (u, o) {
    if (typeof u === 'string' && u.indexOf('/api/') === 0 && u.indexOf('lang=') < 0) {
      u += (u.indexOf('?') < 0 ? '?' : '&') + 'lang=' + LANG;
    }
    return realFetch.call(this, u, o);
  };

  var DICT = {
    en: {
      "D2 Supprimer": "D2 Delete",
      "D3 Bénéfices": "D3 Benefits",
      "Infos techniques": "Technical info",
      "DANGER — EN CAS DE DOUTE, NE SUPPRIMEZ PAS.": "DANGER — IF IN DOUBT, DO NOT DELETE.",
      "Un logiciel peut sembler anodin et être vital :": "A piece of software may look harmless and be vital:",
      "le chargeur de démarrage (GRUB), les correctifs du processeur (microcode), les pilotes internes (firmware) ou les réglages de langue (locales). Les retirer peut empêcher l'ordinateur de démarrer, laisser des failles de sécurité ouvertes ou casser l'affichage. Avant toute suppression, lisez la liste que propose apt et cherchez le nom sur internet.": "the bootloader (GRUB), the processor fixes (microcode), the internal drivers (firmware) or the language settings (locales). Removing them can stop the computer from starting, leave security holes open or break the display. Before deleting anything, read the list apt proposes and look the name up online.",
      "Aide et API": "Help and API",
      "DMP est un logiciel qui examine votre ordinateur et vous l'explique en mots simples. Chaque page (A1 à B9) a deux visages : la page que vous lisez, et ses données brutes, que l'on appelle API, lisibles par d'autres logiciels. Cette page liste les deux.": "DMP is software that examines your computer and explains it in plain words. Each page (A1 to B9) has two faces: the page you read, and its raw data, called the API, readable by other software. This page lists both.",
      "Menu →": "Menu →",
      "Page": "Page",
      "Sujet": "Subject",
      "Données brutes (API)": "Raw data (API)",
      "Tableau de bord": "Dashboard",
      "Vérification santé": "Health check",
      "Chargement…": "Loading…",
      "Le tableau de bord est le tableau de commande d'une voiture : d'un seul coup d'œil, un voyant par sujet. Vert : tout va bien. Jaune : à regarder sans urgence. Rouge : à traiter en priorité. Gris : cet élément n'existe pas sur votre ordinateur (normal). Pourquoi cette page : voir tout de suite si quelque chose cloche, sans ouvrir 18 pages.": "The dashboard works like a car's instrument panel: at a glance, one indicator per subject. Green: all is well. Yellow: take a look, no rush. Red: handle first. Grey: this item does not exist on your computer (normal). Why this page: see right away if something is wrong, without opening 18 pages.",
      "La vérification santé est le bilan complet de votre ordinateur, comme une visite chez le médecin : chaque composant et chaque périphérique branché est examiné, avec un verdict clair et l'explication. Pourquoi cette page : un périphérique en mauvais état (disque fatigué, câble réseau abîmé, port USB muet) passe souvent inaperçu jusqu'à la panne.": "The health check is a full checkup of your computer, like a visit to the doctor: every component and every connected device is examined, with a clear verdict and an explanation. Why this page: a device in poor condition (tired disk, damaged network cable, silent USB port) often goes unnoticed until it fails.",
      "Aller plus loin": "Go further",
      "C3.1 Possibilités": "C3.1 Options",
      "C3.2 Comprendre": "C3.2 Understanding",
      "C3.3 Optimisation": "C3.3 Optimization",
      "C3.4 Vérification": "C3.4 Verification",
      "Suivant : Vérification santé →": "Next: Health check →",
      "Aide et API →": "Help and API →",
      'Menu': 'Menu', 'Aide': 'Help', 'Accueil': 'Home',
      'Comprendre': 'Understand', "Ce qu'on voit": 'What we see',
      'Ce que ça veut dire': 'What it means',
      'Infos techniques (pour experts)': 'Technical info (for experts)',
      'Chargement...': 'Loading...',
      "C — Prendre soin de ma machine": "C — Take care of my machine",
      "Découvrez ce qui peut être vérifié, entretenu ou amélioré sur votre ordinateur sans agir inutilement.": "Discover what can be checked, maintained or improved on your computer without acting needlessly.",
      "C1 — Entretenir mon système Debian": "C1 — Maintain my Debian system",
      "Vérifier les mises à jour, les paquets installés et les éléments qui peuvent nécessiter un entretien.": "Check the updates, the installed packages and the items that may need maintenance.",
      "C2 — Nettoyer les éléments inutiles": "C2 — Clean up unneeded items",
      "Rechercher ce qui peut être supprimé et comprendre le bénéfice éventuel du nettoyage.": "Find what can be removed and understand the possible benefit of cleaning up.",
      "C3 — Optimiser le fonctionnement du système": "C3 — Optimise how the system runs",
      "Identifier les possibilités d'amélioration, comprendre les propositions, les appliquer et vérifier leur résultat.": "Identify possible improvements, understand the proposals, apply them and check the result.",
      "C4 — Consulter les recommandations DMP": "C4 — View the DMP recommendations",
      "Voir les recommandations de DMP, comprendre leur intérêt et décider librement de ce qui mérite d'être fait.": "See DMP’s recommendations, understand why they matter and decide freely what is worth doing.",
      "Entretenez votre système Debian, nettoyez ce qui peut l'être et appliquez les améliorations utiles.": "Maintain your Debian system, clean up what can be cleaned and apply the useful improvements.",
      "Vérifier les mises à jour, les paquets installés et les éléments qui participent à l'entretien du système.": "Check the updates, the installed packages and the items involved in maintaining the system.",
      "Identifier ce qui peut être supprimé et comprendre le bénéfice réel d'un nettoyage.": "Identify what can be removed and understand the real benefit of cleaning up.",
      "Identifier les possibilités d'amélioration, comprendre leur intérêt et vérifier les résultats obtenus.": "Identify possible improvements, understand why they matter and check the results obtained.",
      "Consulter les recommandations, comprendre pourquoi elles sont proposées et évaluer leur intérêt.": "View the recommendations, understand why they are proposed and assess their value.",
      "Accéder à C1": "Go to C1",
      "Accéder à C2": "Go to C2",
      "Accéder à C3": "Go to C3",
      "Accéder à C4": "Go to C4",
      "D — Suivre les évolutions de mon système": "D — Follow the changes in my system",
      "Suivez ce qui s'est passé sur votre système Debian et comprenez comment il évolue dans le temps.": "Follow what has happened on your Debian system and understand how it changes over time.",
      "D1 — Consulter l'historique de mon système": "D1 — View my system’s history",
      "Retrouvez les observations, les actions réalisées et les résultats précédemment enregistrés.": "Find the observations, the actions carried out and the results recorded previously.",
      "D2 — Comprendre les évolutions de mon système": "D2 — Understand the changes in my system",
      "Observez les changements de votre système et identifiez les tendances qui se dessinent.": "Observe the changes in your system and identify the trends that emerge.",
      "D1.4 — Informations techniques": "D1.4 — Technical information",
      "D2.4 — Informations techniques": "D2.4 — Technical information",
      "Consultez les informations techniques utilisées pour suivre l'historique de votre système.": "View the technical information used to follow your system’s history.",
      "Consultez les informations techniques utilisées pour comprendre les évolutions de votre système.": "View the technical information used to understand your system’s changes.",
      "A — Comprendre ma machine Debian": "A — Understand my Debian machine",
      "Découvrez les principaux éléments de votre ordinateur et comprenez simplement leur rôle.": "Discover the main parts of your computer and simply understand their role.",
      "A1 — Processeur": "A1 — Processor",
      "Le processeur fait fonctionner les programmes de votre ordinateur.": "The processor runs the programs on your computer.",
      "A2 — Mémoire": "A2 — Memory",
      "La mémoire permet aux programmes de travailler pendant leur utilisation.": "Memory lets programs work while they are in use.",
      "A3 — Disques": "A3 — Disks",
      "Les disques conservent durablement le système et vos fichiers.": "Disks keep the system and your files for the long term.",
      "A4 — Réseau": "A4 — Network",
      "Le réseau permet à votre ordinateur de communiquer avec d'autres appareils et avec Internet.": "The network lets your computer communicate with other devices and with the Internet.",
      "A5 — Carte graphique": "A5 — Graphics card",
      "Elle participe à l'affichage de tout ce que vous voyez sur l'écran.": "It takes part in displaying everything you see on the screen.",
      "A6 — Carte mère": "A6 — Motherboard",
      "Elle permet aux différents éléments de votre ordinateur de fonctionner ensemble.": "It lets the different parts of your computer work together.",
      "A7 — Système Debian": "A7 — Debian system",
      "B — Comprendre l'état actuel de mon système Debian": "B — Understand the current state of my Debian system",
      "Découvrez comment votre système Debian fonctionne actuellement et ce qui mérite éventuellement votre attention.": "Discover how your Debian system is currently running and what may deserve your attention.",
      "B1 — État général": "B1 — General state",
      "Comprendre l'état général de votre système Debian.": "Understand the general state of your Debian system.",
      "B2 — Activité du processeur": "B2 — Processor activity",
      "Comprendre ce que fait actuellement le processeur.": "Understand what the processor is doing right now.",
      "B3 — Mémoire": "B3 — Memory",
      "Comprendre comment la mémoire de votre ordinateur est utilisée.": "Understand how your computer’s memory is being used.",
      "B4 — Disque système": "B4 — System disk",
      "Comprendre l'espace actuellement utilisé sur votre disque système.": "Understand the space currently used on your system disk.",
      "B5 — Réseau": "B5 — Network",
      "Comprendre comment votre ordinateur est actuellement relié au réseau.": "Understand how your computer is currently connected to the network.",
      "B6 — Services système": "B6 — System services",
      "Comprendre les services qui fonctionnent actuellement sur Debian.": "Understand the services currently running on Debian.",
      "B7 — Programmes en cours": "B7 — Running programs",
      "Comprendre les programmes qui travaillent actuellement sur votre ordinateur.": "Understand the programs currently working on your computer.",
      "B8 — Démarrage du système": "B8 — System startup",
      "Comprendre comment Debian démarre et combien de temps ce démarrage prend.": "Understand how Debian starts up and how long the startup takes.",
      "DMP — Debian Maintenance Professionnel": "DMP — Debian Maintenance Professional",
      "Démarrage rapide": "Quick start",
      "Tableau de bord": "Dashboard",
      "Vérification santé": "Health check",
      "API Docs": "API Docs",
      "Section A — Découverte": "Section A — Discovery",
      "Section B — Activité": "Section B — Activity",
      "Section C — Maintenance": "Section C — Maintenance",
      "Section D — Décision": "Section D — Decision",
      "Section E — Rapports & Analyses": "Section E — Reports & Analyses",
      "Section F — Contrôle & Extensions": "Section F — Check & Extensions",
      "A2 Mémoire": "A2 Memory",
      "A3 Disque": "A3 Disk",
      "A6 Carte-mère": "A6 Motherboard",
      "A7 Debian": "A7 Debian",
      "A8 USB": "A8 USB",
      "A9 Alimentation": "A9 Power supply",
      "B1 Disponibilité": "B1 Availability",
      "B2 Processeur %": "B2 Processor %",
      "B3 Mémoire %": "B3 Memory %",
      "B4 Disque %": "B4 Disk %",
      "B5 Réseau": "B5 Network",
      "B7 Processus": "B7 Processes",
      "C4 Technique": "C4 Technical",
      "D2 Suppression": "D2 Removal",
      "E3-1 Rapports": "E3-1 Reports",
      "Créé par Thierry CHEVASSUS, Piton Sainte Rose, île de la Réunion, France": "Created by Thierry CHEVASSUS, Piton Sainte Rose, Réunion Island, France",
      "E — Consulter mes résultats DMP": "E — View my DMP results",
      "Retrouvez les résultats produits par DMP, comprenez leur signification et consultez les informations disponibles.": "Find the results produced by DMP, understand what they mean and view the information available.",
      "E1 — Consulter mes résultats": "E1 — View my results",
      "Retrouvez le résumé, les résultats détaillés et les explications fournies par DMP.": "Find the summary, the detailed results and the explanations provided by DMP.",
      "E2 — Comprendre mon score": "E2 — Understand my score",
      "Consultez votre score, comprenez sa signification et découvrez les éléments pris en compte.": "View your score, understand what it means and discover the elements taken into account.",
      "E3 — Préparer et consulter mon rapport DMP": "E3 — Prepare and view my DMP report",
      "Préparez, générez et consultez le rapport produit par DMP.": "Prepare, generate and view the report produced by DMP.",
      "E4 — Préparer mes données": "E4 — Prepare my data",
      "Préparez et vérifiez les données afin de disposer d'informations correctement exploitables.": "Prepare and check the data so that you have information that can be properly used.",
      "E1.4 — Informations techniques": "E1.4 — Technical information",
      "E2.4 — Informations techniques": "E2.4 — Technical information",
      "E3.4 — Informations techniques": "E3.4 — Technical information",
      "E4.4 — Informations techniques": "E4.4 — Technical information",
      "Consultez les informations techniques utilisées pour produire et expliquer vos résultats.": "View the technical information used to produce and explain your results.",
      "Consultez les informations techniques utilisées pour établir et expliquer votre score.": "View the technical information used to establish and explain your score.",
      "Consultez les informations techniques utilisées pour préparer et générer votre rapport.": "View the technical information used to prepare and generate your report.",
      "Consultez les informations techniques utilisées pour préparer vos données.": "View the technical information used to prepare your data.",
      "F1-3 Anomalies": "F1-3 Anomalies",
      "Menu principal": "Main menu", "F — Accéder aux fonctions avancées": "F — Access advanced functions",
      "Accédez aux fonctions destinées aux utilisateurs qui souhaitent aller plus loin dans l'analyse de leur système Debian.": "Access the functions intended for users who want to go further in analysing their Debian system.",
      "F1 — Contrôler mon système": "F1 — Check my system",
      "Lancez un contrôle, consultez ses résultats et comprenez les éventuelles anomalies détectées.": "Run a check, view its results and understand any anomalies detected.",
      "F2 — Gérer les extensions": "F2 — Manage extensions",
      "Consultez les extensions présentes, ajoutez-en et gérez celles déjà installées.": "View the extensions present, add some and manage those already installed.",
      "F1.4 — Informations techniques": "F1.4 — Technical information", "F2.4 — Informations techniques": "F2.4 — Technical information",
      "Consultez les informations techniques utilisées pour effectuer le contrôle de votre système.": "View the technical information used to check your system.",
      "Consultez les informations techniques utilisées pour gérer les extensions de votre système.": "View the technical information used to manage your system’s extensions.",
      "Imprimer": "Print", "Exporter": "Export", "Enregistrer": "Save", "Retour": "Back",
      "F2 Monitoring et sauvegarde": "F2 Monitoring and backup", "F3-F4 Vitesse et historique": "F3-F4 Speed and history",
      "F1-1: Contrôle Système": "F1-1: System check", "F1-2: Résultats Contrôle": "F1-2: Check results", "F1-3: Anomalies Détectées": "F1-3: Anomalies detected",
      "Vérifier Maintenant": "Check now", "Menu →": "Menu →",
      "F1-1 Contrôle": "F1-1 Check", "F1 Contrôle": "F1 Check", "F1-2 Résultats": "F1-2 Results", "F1-3 Anomalies": "F1-3 Anomalies",
      "E3-1 Rapport complet": "E3-1 Full report", "E4 Graphiques": "E4 Charts",
      "E3-1: Préparer Rapport": "E3-1: Prepare report", "E3-2: Générer Rapport": "E3-2: Generate report",
      "E3-3: Consulter Rapports": "E3-3: View reports", "E4-2: Vérifier Données": "E4-2: Check data",
      "Observations": "Observations", "Résultat": "Result", "Données Techniques": "Technical data",
      "E1 Résumé": "E1 Summary", "E2 Score": "E2 Score", "E3 Rapports": "E3 Reports",
      "E4 Données graphiques": "E4 Chart data", "E5 Analyse": "E5 Analysis",
      "D1 Recherche": "D1 Search", "D1 — Recherche": "D1 — Search",
      "D2 Supprimer": "D2 Remove", "D2 — Supprimer": "D2 — Remove",
      "D3 Bénéfices": "D3 Benefits", "D3 — Bénéfices": "D3 — Benefits",
      "C2 Paquets": "C2 Packages",
      "C3 Entretien": "C3 Maintenance",
      "C1 Mises à jour": "C1 Updates",
      "C4 Infos techniques": "C4 Technical info",
      "B1 Depuis combien de temps ça tourne": "B1 How long it has been running",
      "B2 Utilisation Processeur maintenant (%)": "B2 Processor usage now (%)",
      "B3 Utilisation Mémoire maintenant (%)": "B3 Memory usage now (%)",
      "B4 Utilisation Disque maintenant (%)": "B4 Disk usage now (%)",
      "B5 Réseau maintenant": "B5 Network now",
      "B6 Services": "B6 Services",
      "B7 Programmes en cours": "B7 Running programs",
      "B8 Démarrage": "B8 Startup",
      "B9 Sécurité": "B9 Security",
      "Infos techniques": "Technical info",
      "A1 — Le processeur de votre ordinateur": "A1 — The processor of your computer",
      "A1 Processeur": "A1 Processor",
      "A2 Mémoire vive": "A2 Memory (RAM)",
      "A3 Disques": "A3 Disks",
      "A4 Réseau": "A4 Network",
      "A5 Carte graphique": "A5 Graphics card",
      "A6 Carte mère": "A6 Motherboard",
      "A7 Système Debian": "A7 Debian system",
      "A8 Ports USB": "A8 USB ports",
      "A9 Alimentation électrique": "A9 Power supply",
      'DMP — Maintenance Debian': 'DMP — Debian Maintenance'
    },
    de: {
      "D2 Supprimer": "D2 Löschen",
      "D3 Bénéfices": "D3 Vorteile",
      "Infos techniques": "Technische Infos",
      "DANGER — EN CAS DE DOUTE, NE SUPPRIMEZ PAS.": "ACHTUNG — IM ZWEIFEL NICHT LÖSCHEN.",
      "Un logiciel peut sembler anodin et être vital :": "Eine Software kann harmlos wirken und trotzdem lebenswichtig sein:",
      "le chargeur de démarrage (GRUB), les correctifs du processeur (microcode), les pilotes internes (firmware) ou les réglages de langue (locales). Les retirer peut empêcher l'ordinateur de démarrer, laisser des failles de sécurité ouvertes ou casser l'affichage. Avant toute suppression, lisez la liste que propose apt et cherchez le nom sur internet.": "der Bootloader (GRUB), die Prozessor-Korrekturen (Microcode), die internen Treiber (Firmware) oder die Spracheinstellungen (Locales). Wer sie entfernt, kann verhindern, dass der Computer startet, Sicherheitslücken offen lassen oder die Anzeige beschädigen. Lesen Sie vor jedem Löschen die von apt vorgeschlagene Liste und suchen Sie den Namen im Internet.",
      "Aide et API": "Hilfe und API",
      "DMP est un logiciel qui examine votre ordinateur et vous l'explique en mots simples. Chaque page (A1 à B9) a deux visages : la page que vous lisez, et ses données brutes, que l'on appelle API, lisibles par d'autres logiciels. Cette page liste les deux.": "DMP ist eine Software, die Ihren Computer untersucht und ihn Ihnen in einfachen Worten erklärt. Jede Seite (A1 bis B9) hat zwei Gesichter: die Seite, die Sie lesen, und ihre Rohdaten, API genannt, die von anderer Software gelesen werden können. Diese Seite listet beide auf.",
      "Menu →": "Menü →",
      "Page": "Seite",
      "Sujet": "Thema",
      "Données brutes (API)": "Rohdaten (API)",
      "Tableau de bord": "Dashboard",
      "Vérification santé": "Gesundheitscheck",
      "Chargement…": "Wird geladen…",
      "Le tableau de bord est le tableau de commande d'une voiture : d'un seul coup d'œil, un voyant par sujet. Vert : tout va bien. Jaune : à regarder sans urgence. Rouge : à traiter en priorité. Gris : cet élément n'existe pas sur votre ordinateur (normal). Pourquoi cette page : voir tout de suite si quelque chose cloche, sans ouvrir 18 pages.": "Das Dashboard ist wie die Armaturentafel eines Autos: auf einen Blick eine Kontrollleuchte pro Thema. Grün: alles in Ordnung. Gelb: ohne Eile ansehen. Rot: vorrangig beheben. Grau: Dieses Element gibt es auf Ihrem Computer nicht (normal). Warum diese Seite: sofort sehen, ob etwas nicht stimmt, ohne 18 Seiten zu öffnen.",
      "La vérification santé est le bilan complet de votre ordinateur, comme une visite chez le médecin : chaque composant et chaque périphérique branché est examiné, avec un verdict clair et l'explication. Pourquoi cette page : un périphérique en mauvais état (disque fatigué, câble réseau abîmé, port USB muet) passe souvent inaperçu jusqu'à la panne.": "Der Gesundheitscheck ist die vollständige Untersuchung Ihres Computers, wie ein Arztbesuch: Jede Komponente und jedes angeschlossene Gerät wird geprüft, mit klarem Urteil und Erklärung. Warum diese Seite: Ein Gerät in schlechtem Zustand (ermüdete Festplatte, beschädigtes Netzwerkkabel, stummer USB-Anschluss) bleibt oft unbemerkt, bis es ausfällt.",
      "Aller plus loin": "Weiter vertiefen",
      "C3.1 Possibilités": "C3.1 Möglichkeiten",
      "C3.2 Comprendre": "C3.2 Verstehen",
      "C3.3 Optimisation": "C3.3 Optimierung",
      "C3.4 Vérification": "C3.4 Überprüfung",
      "Suivant : Vérification santé →": "Weiter: Gesundheitscheck →",
      "Aide et API →": "Hilfe und API →",
      'Menu': 'Menü', 'Aide': 'Hilfe', 'Accueil': 'Startseite',
      'Comprendre': 'Verstehen', "Ce qu'on voit": 'Was wir sehen',
      'Ce que ça veut dire': 'Was das bedeutet',
      'Infos techniques (pour experts)': 'Technische Infos (für Experten)',
      'Chargement...': 'Lädt...',
      "C — Prendre soin de ma machine": "C — Meine Maschine pflegen",
      "Découvrez ce qui peut être vérifié, entretenu ou amélioré sur votre ordinateur sans agir inutilement.": "Entdecken Sie, was an Ihrem Computer geprüft, gewartet oder verbessert werden kann, ohne unnötig zu handeln.",
      "C1 — Entretenir mon système Debian": "C1 — Mein Debian-System warten",
      "Vérifier les mises à jour, les paquets installés et les éléments qui peuvent nécessiter un entretien.": "Prüfen Sie die Aktualisierungen, die installierten Pakete und die Elemente, die möglicherweise gewartet werden müssen.",
      "C2 — Nettoyer les éléments inutiles": "C2 — Überflüssiges bereinigen",
      "Rechercher ce qui peut être supprimé et comprendre le bénéfice éventuel du nettoyage.": "Suchen Sie, was entfernt werden kann, und verstehen Sie den möglichen Nutzen der Bereinigung.",
      "C3 — Optimiser le fonctionnement du système": "C3 — Den Betrieb des Systems optimieren",
      "Identifier les possibilités d'amélioration, comprendre les propositions, les appliquer et vérifier leur résultat.": "Erkennen Sie Verbesserungsmöglichkeiten, verstehen Sie die Vorschläge, wenden Sie sie an und prüfen Sie das Ergebnis.",
      "C4 — Consulter les recommandations DMP": "C4 — Die DMP-Empfehlungen ansehen",
      "Voir les recommandations de DMP, comprendre leur intérêt et décider librement de ce qui mérite d'être fait.": "Sehen Sie sich die Empfehlungen von DMP an, verstehen Sie ihren Nutzen und entscheiden Sie frei, was getan werden sollte.",
      "Entretenez votre système Debian, nettoyez ce qui peut l'être et appliquez les améliorations utiles.": "Warten Sie Ihr Debian-System, bereinigen Sie, was sich bereinigen lässt, und wenden Sie die nützlichen Verbesserungen an.",
      "Vérifier les mises à jour, les paquets installés et les éléments qui participent à l'entretien du système.": "Prüfen Sie die Aktualisierungen, die installierten Pakete und die Elemente, die zur Wartung des Systems beitragen.",
      "Identifier ce qui peut être supprimé et comprendre le bénéfice réel d'un nettoyage.": "Erkennen Sie, was entfernt werden kann, und verstehen Sie den tatsächlichen Nutzen einer Bereinigung.",
      "Identifier les possibilités d'amélioration, comprendre leur intérêt et vérifier les résultats obtenus.": "Erkennen Sie Verbesserungsmöglichkeiten, verstehen Sie ihren Nutzen und prüfen Sie die erzielten Ergebnisse.",
      "Consulter les recommandations, comprendre pourquoi elles sont proposées et évaluer leur intérêt.": "Sehen Sie sich die Empfehlungen an, verstehen Sie, warum sie vorgeschlagen werden, und bewerten Sie ihren Nutzen.",
      "Accéder à C1": "Zu C1",
      "Accéder à C2": "Zu C2",
      "Accéder à C3": "Zu C3",
      "Accéder à C4": "Zu C4",
      "D — Suivre les évolutions de mon système": "D — Die Entwicklung meines Systems verfolgen",
      "Suivez ce qui s'est passé sur votre système Debian et comprenez comment il évolue dans le temps.": "Verfolgen Sie, was auf Ihrem Debian-System geschehen ist, und verstehen Sie, wie es sich im Lauf der Zeit entwickelt.",
      "D1 — Consulter l'historique de mon système": "D1 — Den Verlauf meines Systems ansehen",
      "Retrouvez les observations, les actions réalisées et les résultats précédemment enregistrés.": "Finden Sie die Beobachtungen, die durchgeführten Aktionen und die zuvor gespeicherten Ergebnisse.",
      "D2 — Comprendre les évolutions de mon système": "D2 — Die Entwicklung meines Systems verstehen",
      "Observez les changements de votre système et identifiez les tendances qui se dessinent.": "Beobachten Sie die Veränderungen Ihres Systems und erkennen Sie die sich abzeichnenden Tendenzen.",
      "D1.4 — Informations techniques": "D1.4 — Technische Informationen",
      "D2.4 — Informations techniques": "D2.4 — Technische Informationen",
      "Consultez les informations techniques utilisées pour suivre l'historique de votre système.": "Sehen Sie sich die technischen Informationen an, die zur Verfolgung des Verlaufs Ihres Systems verwendet werden.",
      "Consultez les informations techniques utilisées pour comprendre les évolutions de votre système.": "Sehen Sie sich die technischen Informationen an, die zum Verständnis der Entwicklung Ihres Systems verwendet werden.",
      "A — Comprendre ma machine Debian": "A — Meine Debian-Maschine verstehen",
      "Découvrez les principaux éléments de votre ordinateur et comprenez simplement leur rôle.": "Entdecken Sie die wichtigsten Bestandteile Ihres Computers und verstehen Sie einfach ihre Aufgabe.",
      "A1 — Processeur": "A1 — Prozessor",
      "Le processeur fait fonctionner les programmes de votre ordinateur.": "Der Prozessor lässt die Programme Ihres Computers laufen.",
      "A2 — Mémoire": "A2 — Arbeitsspeicher",
      "La mémoire permet aux programmes de travailler pendant leur utilisation.": "Der Arbeitsspeicher ermöglicht den Programmen, während ihrer Nutzung zu arbeiten.",
      "A3 — Disques": "A3 — Datenträger",
      "Les disques conservent durablement le système et vos fichiers.": "Die Datenträger bewahren das System und Ihre Dateien dauerhaft auf.",
      "A4 — Réseau": "A4 — Netzwerk",
      "Le réseau permet à votre ordinateur de communiquer avec d'autres appareils et avec Internet.": "Das Netzwerk ermöglicht Ihrem Computer, mit anderen Geräten und mit dem Internet zu kommunizieren.",
      "A5 — Carte graphique": "A5 — Grafikkarte",
      "Elle participe à l'affichage de tout ce que vous voyez sur l'écran.": "Sie wirkt an der Darstellung von allem mit, was Sie auf dem Bildschirm sehen.",
      "A6 — Carte mère": "A6 — Hauptplatine",
      "Elle permet aux différents éléments de votre ordinateur de fonctionner ensemble.": "Sie ermöglicht den verschiedenen Bestandteilen Ihres Computers, zusammenzuarbeiten.",
      "A7 — Système Debian": "A7 — Debian-System",
      "B — Comprendre l'état actuel de mon système Debian": "B — Den aktuellen Zustand meines Debian-Systems verstehen",
      "Découvrez comment votre système Debian fonctionne actuellement et ce qui mérite éventuellement votre attention.": "Entdecken Sie, wie Ihr Debian-System derzeit arbeitet und was möglicherweise Ihre Aufmerksamkeit verdient.",
      "B1 — État général": "B1 — Allgemeiner Zustand",
      "Comprendre l'état général de votre système Debian.": "Verstehen Sie den allgemeinen Zustand Ihres Debian-Systems.",
      "B2 — Activité du processeur": "B2 — Prozessoraktivität",
      "Comprendre ce que fait actuellement le processeur.": "Verstehen Sie, was der Prozessor gerade tut.",
      "B3 — Mémoire": "B3 — Arbeitsspeicher",
      "Comprendre comment la mémoire de votre ordinateur est utilisée.": "Verstehen Sie, wie der Arbeitsspeicher Ihres Computers genutzt wird.",
      "B4 — Disque système": "B4 — Systemdatenträger",
      "Comprendre l'espace actuellement utilisé sur votre disque système.": "Verstehen Sie den derzeit auf Ihrem Systemdatenträger belegten Platz.",
      "B5 — Réseau": "B5 — Netzwerk",
      "Comprendre comment votre ordinateur est actuellement relié au réseau.": "Verstehen Sie, wie Ihr Computer derzeit mit dem Netzwerk verbunden ist.",
      "B6 — Services système": "B6 — Systemdienste",
      "Comprendre les services qui fonctionnent actuellement sur Debian.": "Verstehen Sie die Dienste, die derzeit unter Debian laufen.",
      "B7 — Programmes en cours": "B7 — Laufende Programme",
      "Comprendre les programmes qui travaillent actuellement sur votre ordinateur.": "Verstehen Sie die Programme, die derzeit auf Ihrem Computer arbeiten.",
      "B8 — Démarrage du système": "B8 — Systemstart",
      "Comprendre comment Debian démarre et combien de temps ce démarrage prend.": "Verstehen Sie, wie Debian startet und wie lange der Start dauert.",
      "DMP — Debian Maintenance Professionnel": "DMP — Professionelle Debian-Wartung",
      "Démarrage rapide": "Schnellstart",
      "Tableau de bord": "Dashboard",
      "Vérification santé": "Gesundheitsprüfung",
      "API Docs": "API-Dokumentation",
      "Section A — Découverte": "Bereich A — Entdecken",
      "Section B — Activité": "Bereich B — Aktivität",
      "Section C — Maintenance": "Bereich C — Wartung",
      "Section D — Décision": "Bereich D — Entscheidung",
      "Section E — Rapports & Analyses": "Bereich E — Berichte & Analysen",
      "Section F — Contrôle & Extensions": "Bereich F — Kontrolle & Erweiterungen",
      "A2 Mémoire": "A2 Arbeitsspeicher",
      "A3 Disque": "A3 Datenträger",
      "A6 Carte-mère": "A6 Hauptplatine",
      "A7 Debian": "A7 Debian",
      "A8 USB": "A8 USB",
      "A9 Alimentation": "A9 Stromversorgung",
      "B1 Disponibilité": "B1 Verfügbarkeit",
      "B2 Processeur %": "B2 Prozessor %",
      "B3 Mémoire %": "B3 Arbeitsspeicher %",
      "B4 Disque %": "B4 Datenträger %",
      "B5 Réseau": "B5 Netzwerk",
      "B7 Processus": "B7 Prozesse",
      "C4 Technique": "C4 Technik",
      "D2 Suppression": "D2 Entfernung",
      "E3-1 Rapports": "E3-1 Berichte",
      "Créé par Thierry CHEVASSUS, Piton Sainte Rose, île de la Réunion, France": "Erstellt von Thierry CHEVASSUS, Piton Sainte Rose, Insel La Réunion, Frankreich",
      "E — Consulter mes résultats DMP": "E — Meine DMP-Ergebnisse ansehen",
      "Retrouvez les résultats produits par DMP, comprenez leur signification et consultez les informations disponibles.": "Finden Sie die von DMP erzeugten Ergebnisse, verstehen Sie ihre Bedeutung und sehen Sie sich die verfügbaren Informationen an.",
      "E1 — Consulter mes résultats": "E1 — Meine Ergebnisse ansehen",
      "Retrouvez le résumé, les résultats détaillés et les explications fournies par DMP.": "Finden Sie die Zusammenfassung, die detaillierten Ergebnisse und die von DMP gelieferten Erklärungen.",
      "E2 — Comprendre mon score": "E2 — Meine Punktzahl verstehen",
      "Consultez votre score, comprenez sa signification et découvrez les éléments pris en compte.": "Sehen Sie sich Ihre Punktzahl an, verstehen Sie ihre Bedeutung und entdecken Sie die berücksichtigten Elemente.",
      "E3 — Préparer et consulter mon rapport DMP": "E3 — Meinen DMP-Bericht vorbereiten und ansehen",
      "Préparez, générez et consultez le rapport produit par DMP.": "Bereiten Sie den von DMP erstellten Bericht vor, erzeugen Sie ihn und sehen Sie ihn an.",
      "E4 — Préparer mes données": "E4 — Meine Daten vorbereiten",
      "Préparez et vérifiez les données afin de disposer d'informations correctement exploitables.": "Bereiten Sie die Daten vor und prüfen Sie sie, damit Sie über richtig verwertbare Informationen verfügen.",
      "E1.4 — Informations techniques": "E1.4 — Technische Informationen",
      "E2.4 — Informations techniques": "E2.4 — Technische Informationen",
      "E3.4 — Informations techniques": "E3.4 — Technische Informationen",
      "E4.4 — Informations techniques": "E4.4 — Technische Informationen",
      "Consultez les informations techniques utilisées pour produire et expliquer vos résultats.": "Sehen Sie sich die technischen Informationen an, die zur Erstellung und Erklärung Ihrer Ergebnisse verwendet werden.",
      "Consultez les informations techniques utilisées pour établir et expliquer votre score.": "Sehen Sie sich die technischen Informationen an, die zur Ermittlung und Erklärung Ihrer Punktzahl verwendet werden.",
      "Consultez les informations techniques utilisées pour préparer et générer votre rapport.": "Sehen Sie sich die technischen Informationen an, die zur Vorbereitung und Erstellung Ihres Berichts verwendet werden.",
      "Consultez les informations techniques utilisées pour préparer vos données.": "Sehen Sie sich die technischen Informationen an, die zur Vorbereitung Ihrer Daten verwendet werden.",
      "F1-3 Anomalies": "F1-3 Auffälligkeiten",
      "Menu principal": "Hauptmenü", "F — Accéder aux fonctions avancées": "F — Erweiterte Funktionen aufrufen",
      "Accédez aux fonctions destinées aux utilisateurs qui souhaitent aller plus loin dans l'analyse de leur système Debian.": "Rufen Sie die Funktionen auf, die für Nutzer gedacht sind, die bei der Analyse ihres Debian-Systems weiter gehen möchten.",
      "F1 — Contrôler mon système": "F1 — Mein System kontrollieren",
      "Lancez un contrôle, consultez ses résultats et comprenez les éventuelles anomalies détectées.": "Starten Sie eine Kontrolle, sehen Sie sich die Ergebnisse an und verstehen Sie die möglicherweise erkannten Auffälligkeiten.",
      "F2 — Gérer les extensions": "F2 — Erweiterungen verwalten",
      "Consultez les extensions présentes, ajoutez-en et gérez celles déjà installées.": "Sehen Sie sich die vorhandenen Erweiterungen an, fügen Sie neue hinzu und verwalten Sie die bereits installierten.",
      "F1.4 — Informations techniques": "F1.4 — Technische Informationen", "F2.4 — Informations techniques": "F2.4 — Technische Informationen",
      "Consultez les informations techniques utilisées pour effectuer le contrôle de votre système.": "Sehen Sie sich die technischen Informationen an, die für die Kontrolle Ihres Systems verwendet werden.",
      "Consultez les informations techniques utilisées pour gérer les extensions de votre système.": "Sehen Sie sich die technischen Informationen an, die zur Verwaltung der Erweiterungen Ihres Systems verwendet werden.",
      "Imprimer": "Drucken", "Exporter": "Exportieren", "Enregistrer": "Speichern", "Retour": "Zurück",
      "F2 Monitoring et sauvegarde": "F2 Monitoring und Datensicherung", "F3-F4 Vitesse et historique": "F3-F4 Geschwindigkeit und Verlauf",
      "F1-1: Contrôle Système": "F1-1: Systemkontrolle", "F1-2: Résultats Contrôle": "F1-2: Kontrollergebnisse", "F1-3: Anomalies Détectées": "F1-3: Erkannte Auffälligkeiten",
      "Vérifier Maintenant": "Jetzt prüfen", "Menu →": "Menü →",
      "F1-1 Contrôle": "F1-1 Kontrolle", "F1 Contrôle": "F1 Kontrolle", "F1-2 Résultats": "F1-2 Ergebnisse", "F1-3 Anomalies": "F1-3 Auffälligkeiten",
      "E3-1 Rapport complet": "E3-1 Vollständiger Bericht", "E4 Graphiques": "E4 Diagramme",
      "E3-1: Préparer Rapport": "E3-1: Bericht vorbereiten", "E3-2: Générer Rapport": "E3-2: Bericht erstellen",
      "E3-3: Consulter Rapports": "E3-3: Berichte ansehen", "E4-2: Vérifier Données": "E4-2: Daten prüfen",
      "Observations": "Beobachtungen", "Résultat": "Ergebnis", "Données Techniques": "Technische Daten",
      "E1 Résumé": "E1 Zusammenfassung", "E2 Score": "E2 Punktzahl", "E3 Rapports": "E3 Berichte",
      "E4 Données graphiques": "E4 Grafikdaten", "E5 Analyse": "E5 Analyse",
      "D1 Recherche": "D1 Suche", "D1 — Recherche": "D1 — Suche",
      "D2 Supprimer": "D2 Entfernen", "D2 — Supprimer": "D2 — Entfernen",
      "D3 Bénéfices": "D3 Vorteile", "D3 — Bénéfices": "D3 — Vorteile",
      "C2 Paquets": "C2 Pakete",
      "C3 Entretien": "C3 Wartung",
      "C1 Mises à jour": "C1 Aktualisierungen",
      "C4 Infos techniques": "C4 Technische Infos",
      "B1 Depuis combien de temps ça tourne": "B1 Wie lange er schon läuft",
      "B2 Utilisation Processeur maintenant (%)": "B2 Prozessorauslastung jetzt (%)",
      "B3 Utilisation Mémoire maintenant (%)": "B3 Arbeitsspeicherauslastung jetzt (%)",
      "B4 Utilisation Disque maintenant (%)": "B4 Datenträgerauslastung jetzt (%)",
      "B5 Réseau maintenant": "B5 Netzwerk jetzt",
      "B6 Services": "B6 Dienste",
      "B7 Programmes en cours": "B7 Laufende Programme",
      "B8 Démarrage": "B8 Systemstart",
      "B9 Sécurité": "B9 Sicherheit",
      "Infos techniques": "Technische Infos",
      "A1 — Le processeur de votre ordinateur": "A1 — Der Prozessor Ihres Computers",
      "A1 Processeur": "A1 Prozessor",
      "A2 Mémoire vive": "A2 Arbeitsspeicher",
      "A3 Disques": "A3 Datenträger",
      "A4 Réseau": "A4 Netzwerk",
      "A5 Carte graphique": "A5 Grafikkarte",
      "A6 Carte mère": "A6 Hauptplatine",
      "A7 Système Debian": "A7 Debian-System",
      "A8 Ports USB": "A8 USB-Anschlüsse",
      "A9 Alimentation électrique": "A9 Stromversorgung",
      'DMP — Maintenance Debian': 'DMP — Debian-Wartung'
    }
  };
  var PAT = {
    en: [[/^Section (\S+)$/, 'Section $1'], [/^Suivant : (.+) →$/, 'Next: $1 →'], [/^Précédent : (.+)$/, 'Previous: $1']],
    de: [[/^Section (\S+)$/, 'Bereich $1'], [/^Suivant : (.+) →$/, 'Weiter: $1 →'], [/^Précédent : (.+)$/, 'Zurück: $1']]
  };

  function tr(txt) {
    if (LANG === 'fr') return txt;
    var m = txt.match(/^([^\p{L}\p{N}]*)([\s\S]*?)(\s*)$/u);
    if (!m) return txt;
    var core = m[2].replace(/\s+/g, ' '), out = (DICT[LANG] || {})[core];
    if (out === undefined) {
      var pats = PAT[LANG] || [];
      for (var i = 0; i < pats.length; i++) {
        if (pats[i][0].test(core)) { out = core.replace(pats[i][0], pats[i][1]); break; }
      }
    }
    return out === undefined ? txt : m[1] + out + m[3];
  }

  function walk(root) {
    var w = document.createTreeWalker(root, NodeFilter.SHOW_TEXT, null);
    var x;
    while ((x = w.nextNode())) {
      var p = x.parentNode.nodeName;
      if (p === 'SCRIPT' || p === 'STYLE') continue;
      if (x.nodeValue.trim()) x.nodeValue = tr(x.nodeValue);
    }
  }

  document.addEventListener('DOMContentLoaded', function () {
    walk(document.body);
    if (LANG !== 'fr') {
      new MutationObserver(function (ms) {
        ms.forEach(function (m) {
          m.addedNodes.forEach(function (n) {
            if (n.nodeType === 3) {
              var p = n.parentNode ? n.parentNode.nodeName : '';
              if (p !== 'SCRIPT' && p !== 'STYLE' && n.nodeValue.trim()) {
                var v = tr(n.nodeValue);
                if (v !== n.nodeValue) n.nodeValue = v;
              }
            } else if (n.nodeType === 1) { walk(n); }
          });
        });
      }).observe(document.body, { childList: true, subtree: true });
    }
    var nav = document.querySelector('nav') || document.querySelector('header');
    if (!nav) return;
    var box = document.createElement('span');
    box.style.cssText = 'float:right;margin-right:10px;display:inline-flex;flex-direction:row;align-items:center;white-space:nowrap;';
    SUP.forEach(function (l) {
      var a = document.createElement('a');
      a.href = '#';
      a.textContent = l.toUpperCase();
      a.style.cssText = 'display:inline-block;color:white;margin:0 6px;text-decoration:none;' +
        (l === LANG ? 'font-weight:bold;text-decoration:underline;' : '');
      a.onclick = function (e) {
        e.preventDefault();
        try { localStorage.setItem('dmp_lang', l); } catch (x) {}
        location.reload();
      };
      box.appendChild(a);
    });
    nav.appendChild(box);
  });
})();
