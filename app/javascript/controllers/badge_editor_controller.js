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

    // Create the shared modal on first badge connect (only once)
    if (!document.querySelector('.badge-modal')) {
      this.createSharedModal()
    }
  }

  disconnect() {
    // Don't remove modal - it's shared across all badges
  }

  // Handle badge click - show modal
  edit(event) {
    event.stopPropagation()
    console.log(`Editing ${this.typeValue} badge: "${this.contentValue}"`)

    this.showModal()
  }

  // Create the shared modal (called once)
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

    // Add close handlers
    modal.querySelector('.badge-modal-close').addEventListener('click', () => {
      this.hideModal()
    })

    // Close on backdrop click
    modal.addEventListener('click', (e) => {
      if (e.target === modal) {
        this.hideModal()
      }
    })

    // Close on escape key
    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape' && modal.classList.contains('show')) {
        this.hideModal()
      }
    })

    this.modal = modal
  }

  // Show modal with options for current badge
  showModal() {
    const modal = document.querySelector('.badge-modal')
    if (!modal) return

    const title = modal.querySelector('.badge-modal-title')
    const optionsGrid = modal.querySelector('.badge-options-grid')

    // Update title
    title.textContent = `Choose ${this.typeValue.charAt(0).toUpperCase() + this.typeValue.slice(1)}`

    // Get alternatives for this badge type
    const alternatives = this.getAlternatives()

    // Populate options
    optionsGrid.innerHTML = alternatives.map((option) => `
      <div class="badge-option" data-value="${option}">
        ${option}
      </div>
    `).join('')

    // Add click handlers to options
    optionsGrid.querySelectorAll('.badge-option').forEach((option) => {
      option.addEventListener('click', (e) => {
        this.selectOption(e.target.dataset.value)
      })
    })

    // Show modal
    modal.classList.add('show')

    // Prevent body scroll
    document.body.style.overflow = 'hidden'
  }

  // Hide modal
  hideModal() {
    const modal = document.querySelector('.badge-modal')
    if (!modal) return

    modal.classList.remove('show')
    document.body.style.overflow = ''
  }

  // Handle option selection
  selectOption(newValue) {
    console.log(`Changing ${this.typeValue} from "${this.contentValue}" to "${newValue}"`)

    const oldValue = this.contentValue
    this.contentValue = newValue

    // Update badge text
    this.element.textContent = newValue

    // Update badge class
    this.updateBadgeClass()

    // Hide modal
    this.hideModal()

    // Dispatch change event for parent controller
    this.dispatch('badgeChanged', {
      detail: {
        type: this.typeValue,
        oldValue: oldValue,
        newValue: newValue,
        exerciseId: this.exerciseIdValue
      }
    })
  }

  // Get alternatives based on badge type - SAME AS BEFORE
  getAlternatives() {
    switch(this.typeValue) {
      case 'status':
        return ["Working set", "Warmup set", "Drop set", "Super set", "Heavy set", "Light set"]

      case 'reps':
        // Generate 1-35 reps + special options
        const repsOptions = []
        for (let i = 1; i <= 35; i++) {
          repsOptions.push(i === 1 ? "1 rep" : `${i} reps`)
        }
        return [...repsOptions, "to failure", "AMRAP"]

      case 'weight':
        // Generate 1-300 kilos
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

  // Update badge visual class based on content - SAME AS BEFORE
  updateBadgeClass() {
    const typeClasses = {
      status: 'badge-status',
      reps: 'badge-reps',
      weight: 'badge-weight',
      reflection: 'badge-reflection'
    }

    // Remove all type classes
    Object.values(typeClasses).forEach(cls => {
      this.element.classList.remove(cls)
    })

    // Add current type class
    const newClass = typeClasses[this.typeValue]
    if (newClass) {
      this.element.classList.add(newClass)
    }
  }
}
