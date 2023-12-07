import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="landingmodel"
export default class extends Controller {
  static targets = ['modal','body']
  connect() {
    console.log("called");
    if (!localStorage.getItem('modalClosed')) {
      this.modalTarget.classList.add('show')
    }
  }
  collapse(){
    this.closed = true
    this.modalTarget.classList.remove('show')
    localStorage.setItem('modalClosed', true)
    this.bodyTarget.classList.add('dontshow-landing')
  }
}
