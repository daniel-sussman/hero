import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="edit-collection"
export default class extends Controller {
  static target = ["infos", "form", "card"]
  connect() {
  }

  reveal() {
    this.infosTarget.classList.add("d-none")
    this.formTarget.classList.remove("d-none")
  }

  update(event) {
    event.preventDefault();
    const url = `${this.formTarget.action}`;
    fetch(url, {
      headers: { accept: "text/plain" },
      method: "PATCH",
      body: new FormData(this.formTarget),
    })
      .then((response) => response.text())
      .then((data) => {
        this.listTarget.outerHTML = data;
      });
  }
}
