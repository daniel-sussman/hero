import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search-conllections"
export default class extends Controller {
  connect() {
  }

  search() {
    fetch(`${this.formTarget.action}?query=${this.inputTarget.value}`, {
      headers: { accept: "text/plain" },
    })
      .then((response) => response.text())
      .then((data) => {
        this.listTarget.outerHTML = data;
      });
    }
}
