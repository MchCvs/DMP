fetch("/api/e2", { cache: "no-store" })
  .then(response => {
    if (!response.ok) {
      throw new Error("API E2 indisponible");
    }
    return response.json();
  })
  .then(data => {
    const elements = document.getElementById("e2-3-elements");
    const technical = document.getElementById("e2-3-result-technique");

    elements.innerHTML = "";

    data.elements.forEach(item => {
      const row = document.createElement("tr");

      const element = document.createElement("td");
      element.textContent = item.element;
      row.appendChild(element);

      const result = document.createElement("td");
      result.textContent = item.result;
      row.appendChild(result);

      const contribution = document.createElement("td");
      contribution.textContent =
        item.contribution === 0
          ? "Aucune diminution du score"
          : `${item.contribution} points`;
      row.appendChild(contribution);

      elements.appendChild(row);
    });

    technical.textContent = JSON.stringify(data, null, 2);
  })
  .catch(() => {
    document.getElementById("e2-3-elements").innerHTML =
      '<tr><td colspan="3">Information non disponible</td></tr>';

    document.getElementById("e2-3-result-technique").textContent =
      "Résultat technique indisponible.";
  });
