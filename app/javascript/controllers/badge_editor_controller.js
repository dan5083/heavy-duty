import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="badge-editor"
export default class extends Controller {
  static targets = ["badge"]
  static values = {
    type: String,
    content: String,
    exerciseId: String
  }

  connect() {
    console.log(`🏷️ Badge editor connected: ${this.typeValue} - "${this.contentValue}"`)

    if (!document.querySelector('.badge-modal')) {
      this.createSharedModal()
    }
  }

  disconnect() {
    // Don't remove modal - it's shared across all badges
  }

  edit(event) {
    event.stopPropagation()
    console.log(`Editing ${this.typeValue} badge: "${this.contentValue}"`)

    this.showModal()
  }

  createSharedModal() {
    const modal = document.createElement('div')
    modal.className = 'badge-modal'
    modal.innerHTML = `
      <div class="badge-modal-content">
        <div class="badge-modal-header">
          <h3 class="badge-modal-title">Choose Value</h3>
          <button class="badge-modal-close" type="button">&times;</button>
        </div>
        <div class="badge-options-grid">
          <!-- Options populated by JS -->
        </div>
      </div>
    `

    document.body.appendChild(modal)

    modal.querySelector('.badge-modal-close').addEventListener('click', () => {
      this.hideModal()
    })

    modal.addEventListener('click', (e) => {
      if (e.target === modal) {
        this.hideModal()
      }
    })

    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape' && modal.classList.contains('show')) {
        this.hideModal()
      }
    })

    this.modal = modal
  }

  showModal() {
    const modal = document.querySelector('.badge-modal')
    if (!modal) return

    const title = modal.querySelector('.badge-modal-title')
    const optionsGrid = modal.querySelector('.badge-options-grid')

    title.textContent = `Choose ${this.typeValue.charAt(0).toUpperCase() + this.typeValue.slice(1)}`

    const alternatives = this.getAlternatives()

    optionsGrid.innerHTML = alternatives.map((option) => `
      <div class="badge-option" data-value="${option}">
        ${option}
      </div>
    `).join('')

    optionsGrid.querySelectorAll('.badge-option').forEach((option) => {
      option.addEventListener('click', (e) => {
        this.selectOption(e.target.dataset.value)
      })
    })

    modal.classList.add('show')
    document.body.style.overflow = 'hidden'
  }

  hideModal() {
    const modal = document.querySelector('.badge-modal')
    if (!modal) return

    modal.classList.remove('show')
    document.body.style.overflow = ''
  }

  selectOption(newValue) {
    console.log(`Changing ${this.typeValue} from "${this.contentValue}" to "${newValue}"`)

    const oldValue = this.contentValue
    this.contentValue = newValue

    this.element.textContent = newValue

    this.updateBadgeClass()

    this.hideModal()

    this.dispatch('badgeChanged', {
      detail: {
        type: this.typeValue,
        oldValue: oldValue,
        newValue: newValue,
        exerciseId: this.exerciseIdValue
      }
    })
  }

  getAlternatives() {
    const clauseLibrary = window.clauseLibrary || {}

    switch(this.typeValue) {
      case 'status':
        return clauseLibrary.status?.options || ["Working set", "Warmup set", "Drop set", "Super set", "Heavy set", "Light set"]

      case 'reps':
        if (clauseLibrary.reps?.options) {
          return clauseLibrary.reps.options.map(num => num === 1 ? "1 rep" : `${num} reps`)
                  .concat(["to failure", "AMRAP"])
        }
        const repsOptions = []
        for (let i = 1; i <= 35; i++) {
          repsOptions.push(i === 1 ? "1 rep" : `${i} reps`)
        }
        return [...repsOptions, "to failure", "AMRAP"]

      case 'weight':
        if (clauseLibrary.weight?.options) {
          // Weight options already include "kg" suffix and "Unknown"/"bodyweight"
          return clauseLibrary.weight.options
        }
        // Fallback - kg only, no lbs
        const fallbackWeights = ["Unknown", "bodyweight"]
        for (let i = 1; i <= 700; i++) {
          fallbackWeights.push(`${i} kg`)
        }
        return fallbackWeights

      case 'time':
        if (clauseLibrary.time?.options) {
          // Time options already include "Unknown" and proper formatting
          return clauseLibrary.time.options
        }
        // Fallback
        const timeOptions = ["Unknown"]
        for (let i = 1; i <= 120; i++) {
          timeOptions.push(i === 1 ? "1 minute" : `${i} minutes`)
        }
        return timeOptions

      case 'energy':
        if (clauseLibrary.energy?.options) {
          // Energy options already include "Unknown" and "calories" suffix
          return clauseLibrary.energy.options
        }
        // Fallback
        const energyOptions = ["Unknown"]
        for (let i = 10; i <= 750; i += 10) {
          energyOptions.push(`${i} calories`)
        }
        return energyOptions

      case 'distance':
        if (clauseLibrary.distance?.options) {
          // Distance options already include "Unknown" and "m" suffix - METERS ONLY
          return clauseLibrary.distance.options
        }
        // Fallback - meters only, 5m increments
        const distanceOptions = ["Unknown"]
        for (let i = 5; i <= 1000; i += 5) {
          distanceOptions.push(`${i} m`)
        }
        return distanceOptions

      case 'reflection':
        return clauseLibrary.reflection?.options || ["solid effort", "perfect form", "good pump", "felt heavy", "personal best"]

      default:
        return []
    }
  }

  updateBadgeClass() {
    const typeClasses = {
      status: 'badge-status',
      reps: 'badge-reps',
      weight: 'badge-weight',
      time: 'badge-time',
      energy: 'badge-energy',
      distance: 'badge-distance',
      reflection: 'badge-reflection'
    }

    Object.values(typeClasses).forEach(cls => {
      this.element.classList.remove(cls)
    })

    const newClass = typeClasses[this.typeValue]
    if (newClass) {
      this.element.classList.add(newClass)
    }
  }
}
