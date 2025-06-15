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
    // Clean up event listeners
    if (this.boundHideDropdown) {
      document.removeEventListener('click', this.boundHideDropdown)
    }
  }

  // Handle badge click - show dropdown with alternatives
  edit(event) {
    event.stopPropagation()
    console.log(`Editing ${this.typeValue} badge: "${this.contentValue}"`)

    this.hideAllDropdowns()
    this.showDropdown()
  }

  // Create dropdown element
  createDropdown() {
    this.dropdown = document.createElement('div')
    this.dropdown.className = 'badge-dropdown position-absolute bg-white border rounded shadow-lg'
    this.dropdown.style.cssText = `
      display: none;
      max-height: 250px;
      overflow-y: auto;
      z-index: 1000;
      min-width: 180px;
      border-color: #dee2e6;
    `

    this.element.style.position = 'relative'
    this.element.appendChild(this.dropdown)

    // Bind the hide function to preserve 'this' context
    this.boundHideDropdown = (e) => {
      if (!this.element.contains(e.target)) {
        this.hideDropdown()
      }
    }
  }

  // Show dropdown with clause alternatives
  showDropdown() {
    const alternatives = this.getAlternatives()

    this.dropdown.innerHTML = alternatives.map(option => `
      <div class="badge-option px-3 py-2 cursor-pointer"
           style="cursor: pointer;"
           onmouseover="this.style.backgroundColor='#f8f9fa'"
           onmouseout="this.style.backgroundColor=''"
           data-value="${option}">
        ${option}
      </div>
    `).join('')

    // Position dropdown
    this.dropdown.style.top = '100%'
    this.dropdown.style.left = '0'
    this.dropdown.style.display = 'block'

    // Add click handlers
    this.dropdown.querySelectorAll('.badge-option').forEach(option => {
      option.addEventListener('click', (e) => {
        e.stopPropagation()
        this.selectOption(e.target.dataset.value)
      })
    })

    // Add document click listener
    document.addEventListener('click', this.boundHideDropdown)
  }

  // Hide this dropdown
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

    // Update badge content
    const oldValue = this.contentValue
    this.contentValue = newValue

    // Update the badge text
    if (this.hasBadgeTarget) {
      const textSpan = this.badgeTarget.querySelector('.badge-text')
      if (textSpan) {
        textSpan.textContent = newValue
      } else {
        // Fallback: update first text node
        const textNode = Array.from(this.badgeTarget.childNodes).find(node => node.nodeType === Node.TEXT_NODE)
        if (textNode) {
          textNode.textContent = newValue
        }
      }
    }

    // Update badge class if needed
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
        // Generate 1-35 reps + special options, optimized for mobile scrolling
        const repsOptions = []
        for (let i = 1; i <= 35; i++) {
          repsOptions.push(i === 1 ? "1 rep" : `${i} reps`)
        }
        return [...repsOptions, "to failure", "AMRAP"]

      case 'weight':
        // Generate 1-300 kilos, optimized for mobile
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
      this.badgeTarget.classList.remove(cls)
    })

    // Add current type class
    const newClass = typeClasses[this.typeValue]
    if (newClass) {
      this.badgeTarget.classList.add(newClass)
    }
  }

  // Delete this badge
  delete(event) {
    event.stopPropagation()

    this.dispatch('badgeDeleted', {
      detail: {
        type: this.typeValue,
        content: this.contentValue,
        exerciseId: this.exerciseIdValue
      }
    })

    this.element.remove()
  }

  // Add new badge after this one
  addAfter(event) {
    event.stopPropagation()

    this.dispatch('addBadge', {
      detail: {
        afterElement: this.element,
        exerciseId: this.exerciseIdValue
      }
    })
  }
}
