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
      'Menu': 'Menu', 'Aide': 'Help', 'Accueil': 'Home',
      'Comprendre': 'Understand', "Ce qu'on voit": 'What we see',
      'Ce que ça veut dire': 'What it means',
      'Infos techniques (pour experts)': 'Technical info (for experts)',
      'Chargement...': 'Loading...',
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
      'Menu': 'Menü', 'Aide': 'Hilfe', 'Accueil': 'Startseite',
      'Comprendre': 'Verstehen', "Ce qu'on voit": 'Was wir sehen',
      'Ce que ça veut dire': 'Was das bedeutet',
      'Infos techniques (pour experts)': 'Technische Infos (für Experten)',
      'Chargement...': 'Lädt...',
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
    var nav = document.querySelector('nav') || document.querySelector('header');
    if (!nav) return;
    var box = document.createElement('span');
    box.style.cssText = 'float:right;margin-right:10px';
    SUP.forEach(function (l) {
      var a = document.createElement('a');
      a.href = '#';
      a.textContent = l.toUpperCase();
      a.style.cssText = 'color:white;margin:0 6px;text-decoration:none;' +
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
