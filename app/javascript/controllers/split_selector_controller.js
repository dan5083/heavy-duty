import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="split-selector"
export default class extends Controller {
  static targets = ["card", "radio"]

  connect() {
    console.log("Split selector controller connected")
    // Highlight the initially selected card
    this.highlightSelection()
  }

  highlightSelection() {
    // Remove highlight from all cards
    this.cardTargets.forEach(card => {
      card.classList.remove("border-primary", "bg-light")
    })

    // Find the checked radio and highlight its card
    const checkedRadio = this.radioTargets.find(radio => radio.checked)
    if (checkedRadio) {
      const card = checkedRadio.closest('[data-split-selector-target="card"]')
      if (card) {
        card.classList.add("border-primary", "bg-light")
      }
    }
  }
}
