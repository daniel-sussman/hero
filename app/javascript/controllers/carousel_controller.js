import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="carousel"
export default class extends Controller {
  static targets = ['item', 'inner']
  static values = {
    length: Number,
    userid: Number
  }
  connect() {
    this.steps = 0
  }

  moveRight() {
    this.increaseStep()
    const transformInstruction = `translateX(-${this.steps * 100}%)`
    console.log(transformInstruction);
    this.innerTarget.style.transform = `translateX(-${this.steps * 100}%)`;
  }

  moveLeft() {
    this.decreaseStep()
    this.innerTarget.style.transform = `translateX(-${this.steps * 100}%)`;
  }

  decreaseStep() {
    this.steps -= 1
    if (this.steps < 0) {
      console.log('skip to end')
      this.steps = this.lengthValue - 1
    }
  }

  increaseStep() {
    this.steps += 1
    if (this.steps >= this.lengthValue) {
      console.log('back to start')
      this.steps = 0
    }
  }
}
