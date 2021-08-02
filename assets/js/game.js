/*document.getElementById("form").addEventListener("submit", function (e) {
  e.preventDefault();
  document.getElementById("guess-input").value;
});
*/

import { Socket } from "phoenix";
import LiveSocket from "phoenix_live_view";

document.getElementById("guess-input").addEventListener("input", function () {
  document.getElementById("word").className = "";
});
