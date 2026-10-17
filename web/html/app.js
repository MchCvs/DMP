const computerButton =
  document.getElementById("computerButton");

const discoverButton =
  document.getElementById("discoverButton");

function enterDmp() {
  window.location.href = "machine.html";
}

computerButton.addEventListener(
  "click",
  enterDmp
);

discoverButton.addEventListener(
  "click",
  enterDmp
);
