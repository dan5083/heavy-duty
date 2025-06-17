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
    this.createDropdown()
  }

  disconnect() {
    if (this.dropdown) {
      this.dropdown.remove()
    }
    if (this.boundHideDropdown) {
      document.removeEventListener('click', this.boundHideDropdown)
    }
  }

  // Handle badge click - show dropdown
  edit(event) {
    event.stopPropagation()
    console.log(`Editing ${this.typeValue} badge: "${this.contentValue}"`)

    this.hideAllDropdowns()
    this.showDropdown()
  }

  // Create dropdown element
  createDropdown() {
    this.dropdown = document.createElement('div')
    this.dropdown.className = 'badge-dropdown'
    this.dropdown.style.display = 'none'

    this.element.appendChild(this.dropdown)

    this.boundHideDropdown = (e) => {
      if (!this.element.contains(e.target)) {
        this.hideDropdown()
      }
    }
  }

  // Show dropdown
  showDropdown() {
    console.log('🚀 SHOW DROPDOWN CALLED!')

    const alternatives = this.getAlternatives()

    this.dropdown.innerHTML = alternatives.map((option) => `
      <div class="badge-option" data-value="${option}">
        ${option}
      </div>
    `).join('')

    // Show and position dropdown
    this.dropdown.style.display = 'block'

    // Add click handlers
    this.dropdown.querySelectorAll('.badge-option').forEach((option) => {
      option.addEventListener('click', (e) => {
        e.stopPropagation()
        this.selectOption(e.target.dataset.value)
      })
    })

    document.addEventListener('click', this.boundHideDropdown)
  }

  // Hide dropdown
  hideDropdown() {
    if (this.dropdown) {
      this.dropdown.style.display = 'none'
    }
    if (this.boundHideDropdown) {
      document.removeEventListener('click', this.boundHideDropdown)
    }
  }

  // Hide all badge dropdowns on page
  hideAllDropdowns() {
    document.querySelectorAll('.badge-dropdown').forEach(dropdown => {
      dropdown.style.display = 'none'
    })
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

    // Hide dropdown
    this.hideDropdown()

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

  // Get alternatives based on badge type
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

  // Update badge visual class based on content
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
