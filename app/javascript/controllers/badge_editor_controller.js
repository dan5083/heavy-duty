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
    switch(this.typeValue) {
      case 'status':
        return ["Working set", "Warmup set", "Drop set", "Super set", "Heavy set", "Light set"]

      case 'reps':
        const repsOptions = []
        for (let i = 1; i <= 35; i++) {
          repsOptions.push(i === 1 ? "1 rep" : `${i} reps`)
        }
        return [...repsOptions, "to failure", "AMRAP"]

      case 'weight':
        const weightOptions = []
        for (let i = 1; i <= 300; i++) {
          weightOptions.push(`at ${i} kilos`)
        }
        return ["with bodyweight", ...weightOptions]

      case 'reflection':
        return ["kept it smooth", "felt heavy", "perfect form", "could go heavier",
                "solid effort", "form broke down", "great pump", "good mind-muscle connection"]

      default:
        return []
    }
  }

  updateBadgeClass() {
    const typeClasses = {
      status: 'badge-status',
      reps: 'badge-reps',
      weight: 'badge-weight',
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
