fetch("/api/e2", { cache: "no-store" })
  .then(response => {
    if (!response.ok) {
      throw new Error("API E2 indisponible");
    }
    return response.json();
  })
  .then(data => {
    document.getElementById("e2-2-score").textContent =
      `${data.score} / 100`;

    document.getElementById("e2-2-signification").textContent =
      data.state;

    document.getElementById("e2-2-result-technique").textContent =
      JSON.stringify(data, null, 2);

    const interpretation = document.getElementById("e2-2-interpretation");
    interpretation.innerHTML = "";

    const score = document.createElement("p");
    score.textContent = `Score calculé : ${data.score} / 100`;
    interpretation.appendChild(score);

    const state = document.createElement("p");
    state.textContent = `État correspondant : ${data.state}`;
    interpretation.appendChild(state);

    const stateExplanation = document.createElement("p");
    stateExplanation.textContent = "Dans le calcul actuel de DMP, cet état signifie que le score obtenu se situe dans la plage correspondant à un état excellent. Il ne signifie pas que tous les aspects de l'ordinateur ont été contrôlés.";
    interpretation.appendChild(stateExplanation);

    const elementsTitle = document.createElement("h4");
    elementsTitle.textContent = "Éléments observés";
    interpretation.appendChild(elementsTitle);

    const explanations = {
      "Paquets Debian": "DMP n'a trouvé aucun paquet Debian signalé comme cassé. Cette vérification ne montre donc pas de problème de paquets nécessitant une intervention.",
      "Espace disque": "Le système de fichiers observé utilise une faible partie de son espace. Il reste donc une marge importante et cette observation ne justifie pas de nettoyage.",
      "TRIM SSD": "DMP a vérifié que le mécanisme TRIM est actif. Cette vérification ne révèle pas de problème nécessitant une intervention.",
      "Mémoire": "La valeur mesurée décrit la situation mémoire au moment de l'observation. Elle ne permet pas à elle seule de conclure à un problème durable de mémoire.",
      "SSD SMART": "DMP n'a pas pu déterminer l'état SMART du SSD lors de cette observation. Ce résultat ne permet donc ni de confirmer un fonctionnement normal ni d'établir un problème SMART."
    };

    data.elements.forEach(item => {
      const p = document.createElement("p");
      p.textContent = `${item.element} : ${item.result} → ${item.contribution === 0 ? "aucune diminution du score" : `contribution : ${item.contribution} points`}`;
      interpretation.appendChild(p);

      const explanation = document.createElement("p");
      explanation.textContent = explanations[item.element] || "Aucune explication humaine disponible pour cet élément.";
      interpretation.appendChild(explanation);
    });

    const criteriaTitle = document.createElement("h4");
    criteriaTitle.textContent = "Critères pris en compte";
    interpretation.appendChild(criteriaTitle);

    const criteriaExplanations = {
      "Paquets cassés détectés": "Si DMP détecte des paquets cassés, le score peut diminuer de 15 points. Ce critère permet de tenir compte d'un problème réel dans la gestion des logiciels Debian.",
      "Utilisation supérieure à 85 %": "Lorsque l'espace utilisé dépasse 85 %, DMP considère que la situation mérite d'être prise en compte dans le score. Une diminution de 20 points peut alors être appliquée.",
      "TRIM non disponible ou non actif": "Si TRIM n'est pas disponible ou n'est pas actif, DMP signale cette situation dans les éléments observés. Ce critère ne retire actuellement aucun point du score.",
      "Utilisation supérieure à 90 %": "Une utilisation de la mémoire supérieure à 90 % peut entraîner une diminution de 10 points. Ce seuil permet de prendre en compte une forte occupation de la mémoire.",
      "Échec SMART": "Un échec SMART peut entraîner une diminution de 20 points, car il constitue un signal important concernant l'état du disque concerné."
    };

    data.technical.criteria.forEach(item => {
      const p = document.createElement("p");
      p.textContent = `${item.condition} → ${item.penalty === 0 ? "aucun retrait de points" : `diminution possible de ${Math.abs(item.penalty)} points`}`;
      interpretation.appendChild(p);

      const explanation = document.createElement("p");
      explanation.textContent = criteriaExplanations[item.condition] || "Aucune explication humaine disponible pour ce critère.";
      interpretation.appendChild(explanation);
    });

    const limitsTitle = document.createElement("h4");
    limitsTitle.textContent = "Limites du calcul";
    interpretation.appendChild(limitsTitle);

    const limits = document.createElement("p");
    limits.textContent = "Ce score est une synthèse des critères effectivement calculés par DMP. Il ne constitue pas un diagnostic complet de l'état du système. Les éléments détaillés permettent de comprendre les observations qui ont conduit au résultat.";
    interpretation.appendChild(limits);
  })
  .catch(() => {
    document.getElementById("e2-2-score").textContent =
      "Information non disponible";

    document.getElementById("e2-2-signification").textContent =
      "Information non disponible";

    document.getElementById("e2-2-result-technique").textContent =
      "Résultat technique indisponible.";
  });
