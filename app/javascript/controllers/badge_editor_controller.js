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
    this.initializeAnimations()
  }

  disconnect() {
    if (this.dropdown) {
      this.dropdown.remove()
    }
    // Clean up event listeners
    if (this.boundHideDropdown) {
      document.removeEventListener('click', this.boundHideDropdown)
    }
    // Clean up animation listeners
    this.element.removeEventListener('animationend', this.boundAnimationEnd)
  }

  // Initialize animation system
  initializeAnimations() {
    // Add ripple effect on click
    this.element.addEventListener('click', this.addRippleEffect.bind(this))

    // Bind animation end handler
    this.boundAnimationEnd = this.handleAnimationEnd.bind(this)
    this.element.addEventListener('animationend', this.boundAnimationEnd)

    // Add creating animation if this is a new badge
    if (this.element.dataset.newBadge === 'true') {
      this.element.classList.add('badge-creating')
      this.element.removeAttribute('data-new-badge')
    }
  }

  // Add ripple effect on click
  addRippleEffect(event) {
    // Don't add ripple if dropdown is already open
    if (this.dropdown && this.dropdown.style.display === 'block') {
      return
    }

    this.element.classList.add('badge-ripple')

    // Remove ripple class after animation
    setTimeout(() => {
      this.element.classList.remove('badge-ripple')
    }, 600)
  }

  // Handle animation end events
  handleAnimationEnd(event) {
    if (event.target === this.element) {
      // Remove animation classes after they complete
      this.element.classList.remove('badge-creating', 'badge-updating', 'badge-success', 'badge-loading')
    }
  }

  // Handle badge click - show dropdown with animations
  edit(event) {
    event.stopPropagation()
    console.log(`Editing ${this.typeValue} badge: "${this.contentValue}"`)

    // Add bounce animation
    this.element.classList.add('badge-updating')

    this.hideAllDropdowns()
    this.showDropdown()
  }

  // Create dropdown element
  createDropdown() {
    this.dropdown = document.createElement('div')
    this.dropdown.className = 'badge-dropdown position-absolute'
    this.dropdown.style.cssText = `
      display: none;
      max-height: 250px;
      overflow-y: auto;
      z-index: 1000;
      min-width: 180px;
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

  // Show dropdown with enhanced animations
  showDropdown() {
    const alternatives = this.getAlternatives()

    this.dropdown.innerHTML = alternatives.map((option, index) => `
      <div class="badge-option"
           style="animation-delay: ${index * 0.02}s;"
           data-value="${option}">
        ${option}
      </div>
    `).join('')

    // Position dropdown intelligently
    this.positionDropdown()

    // Show with animation
    this.dropdown.style.display = 'block'
    this.dropdown.classList.remove('closing')

    // Add enhanced click handlers
    this.dropdown.querySelectorAll('.badge-option').forEach((option, index) => {
      option.addEventListener('click', (e) => {
        e.stopPropagation()
        this.selectOptionWithAnimation(e.target.dataset.value, e.target)
      })
    })

    // Add document click listener
    document.addEventListener('click', this.boundHideDropdown)
  }

  // Intelligent dropdown positioning
  positionDropdown() {
    const rect = this.element.getBoundingClientRect()
    const viewportHeight = window.innerHeight
    const dropdownHeight = 250 // max-height

    // Check if there's space below
    if (rect.bottom + dropdownHeight > viewportHeight) {
      // Position above if not enough space below
      this.dropdown.style.bottom = '100%'
      this.dropdown.style.top = 'auto'
    } else {
      // Position below
      this.dropdown.style.top = '100%'
      this.dropdown.style.bottom = 'auto'
    }

    this.dropdown.style.left = '0'
  }

  // Hide dropdown with animation
  hideDropdown() {
    if (this.dropdown && this.dropdown.style.display === 'block') {
      this.dropdown.classList.add('closing')

      // Hide after animation completes
      setTimeout(() => {
        this.dropdown.style.display = 'none'
        this.dropdown.classList.remove('closing')
      }, 150)
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

  // Handle option selection with animations
  selectOptionWithAnimation(newValue, optionElement) {
    console.log(`Changing ${this.typeValue} from "${this.contentValue}" to "${newValue}"`)

    // Add selection animation to the clicked option
    optionElement.style.background = '#e3f2fd'
    optionElement.style.transform = 'scale(0.95)'

    setTimeout(() => {
      // Update badge content
      const oldValue = this.contentValue
      this.contentValue = newValue

      // Update the badge text with animation
      if (this.hasBadgeTarget) {
        const textSpan = this.badgeTarget.querySelector('.badge-text')
        if (textSpan) {
          // Fade out, change text, fade in
          textSpan.style.opacity = '0.5'
          setTimeout(() => {
            textSpan.textContent = newValue
            textSpan.style.opacity = '1'
          }, 100)
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

      // Add success animation
      this.element.classList.add('badge-success')

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
    }, 100)
  }

  // Original selectOption method for compatibility
  selectOption(newValue) {
    this.selectOptionWithAnimation(newValue, null)
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
