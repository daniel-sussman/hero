import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="showmap"
export default class extends Controller {
  static targets = ['modal' ,'mapbutton']

  connect() {
    console.log("connercted");
  }
  show(){
    console.log("click is called");
    this.modalTarget.classList.add('show')
  }
  collapse(){
    this.closed = true
    this.modalTarget.classList.remove('show')
  }
}
