import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["field", "submit"]

  connect() {
    this.validate()
  }

  validate() {
    const allFilled = this.fieldTargets.every((field) => field.value.trim() !== "")
    this.allFilled = allFilled

    const btn = this.submitTarget
    if (allFilled) {
      btn.style.backgroundColor = "#16a34a"
      btn.style.color = "white"
      btn.style.cursor = "pointer"
    } else {
      btn.style.backgroundColor = "#9ca3af"
      btn.style.color = "white"
      btn.style.cursor = "not-allowed"
    }
  }

  preventSubmit(event) {
    if (!this.allFilled) {
      event.preventDefault()
    }
  }
}
