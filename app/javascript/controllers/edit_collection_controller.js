import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["infos", "form", "card"]

  connect() {
    console.log("this.infosTarget", this.infosTarget)
    console.log("this.formTarget", this.formTarget)
  }

  reveal() {
    this.infosTarget.classList.add("d-none")
    this.formTarget.classList.remove("d-none")
  }

  update(event) {
    event.preventDefault();
    console.log(this.formTarget.action)
    const url = `${this.formTarget.action}`;
    fetch(url, {
      headers: { accept: "text/plain" },
      method: "PATCH",
      body: new FormData(this.formTarget),
    })
      .then((response) => response.text())
      .then((data) => {
        this.element.outerHTML = data;
      });
  }
}
