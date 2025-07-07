// app/javascript/controllers/typography_animator_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["typewriter", "fadeIn", "slideUp", "charAnimate", "splitText", "highlight", "reveal"]
  static values = {
    delay: { type: Number, default: 0 },
    stagger: { type: Number, default: 100 },
    viewMode: { type: String, default: "recovery" }
  }

  connect() {
    console.log("🎬 Typography animator connected")
    console.log(`View mode: ${this.viewModeValue}`)

    // NEW: Listen for view mode changes
    this.element.addEventListener('dashboard:viewChanged', this.handleViewChange.bind(this))

    setTimeout(() => {
      this.animateAll()
    }, this.delayValue)
  }

  animateAll() {
    // Simple typewriter - just add CSS class
    this.typewriterTargets.forEach((element, index) => {
      setTimeout(() => {
        element.classList.add('typewriter-text')
        // NEW: Add view-specific animation class
        if (this.viewModeValue === 'benchmark') {
          element.classList.add('benchmark-mode')
        }
      }, index * this.staggerValue)
    })

    // Fade in elements
    this.fadeInTargets.forEach((element, index) => {
      setTimeout(() => {
        element.classList.add('fade-in')
      }, index * this.staggerValue)
    })

    // Slide up elements with view-aware staggering
    this.slideUpTargets.forEach((element, index) => {
      const staggerDelay = this.viewModeValue === 'benchmark'
        ? index * (this.staggerValue * 0.8) // Slightly faster for benchmark view
        : index * this.staggerValue

      setTimeout(() => {
        element.classList.add('slide-up')

        // NEW: Add special effects for benchmark cards
        if (this.viewModeValue === 'benchmark') {
          this.addBenchmarkCardEffects(element)
        }
      }, staggerDelay)
    })

    // Highlight elements
    this.highlightTargets.forEach((element, index) => {
      setTimeout(() => {
        element.classList.add('animate')
      }, index * this.staggerValue + 1000)
    })
  }

  // NEW: Handle view mode changes with smooth transitions
  handleViewChange(event) {
    const newViewMode = event.detail.viewMode
    console.log(`View mode changed to: ${newViewMode}`)

    this.viewModeValue = newViewMode
    this.animateViewTransition(newViewMode)
  }

  // NEW: Animate transition between views
  animateViewTransition(viewMode) {
    // Add transition class to all animated elements
    const allAnimatedElements = [
      ...this.typewriterTargets,
      ...this.fadeInTargets,
      ...this.slideUpTargets
    ]

    // Fade out current content
    allAnimatedElements.forEach((element, index) => {
      setTimeout(() => {
        element.classList.add('view-transition-out')
      }, index * 50)
    })

    // Wait for fade out, then fade in with new content
    setTimeout(() => {
      allAnimatedElements.forEach((element, index) => {
        setTimeout(() => {
          element.classList.remove('view-transition-out')
          element.classList.add('view-transition-in')

          // Apply view-specific styling
          if (viewMode === 'benchmark') {
            element.classList.add('benchmark-mode')
          } else {
            element.classList.remove('benchmark-mode')
          }
        }, index * 75)
      })
    }, 300)

    // Clean up transition classes
    setTimeout(() => {
      allAnimatedElements.forEach(element => {
        element.classList.remove('view-transition-in')
      })
    }, 1000)
  }

  // NEW: Add special effects for benchmark view cards
  addBenchmarkCardEffects(element) {
    // Check if this is a muscle card
    const card = element.querySelector('.card')
    if (!card) return

    // Add benchmark-specific hover effects
    card.addEventListener('mouseenter', () => {
      if (this.viewModeValue === 'benchmark') {
        card.classList.add('benchmark-card-hover')
      }
    })

    card.addEventListener('mouseleave', () => {
      card.classList.remove('benchmark-card-hover')
    })

    // Add progress bar animation for benchmark cards
    const progressBar = card.querySelector('.progress-bar')
    if (progressBar && this.viewModeValue === 'benchmark') {
      setTimeout(() => {
        progressBar.classList.add('benchmark-progress-animate')
      }, 200)
    }
  }

  // NEW: Trigger view change from external sources
  changeView(viewMode) {
    const event = new CustomEvent('dashboard:viewChanged', {
      detail: { viewMode: viewMode }
    })
    this.element.dispatchEvent(event)
  }

  // NEW: Add pulse animation to priority alerts
  animatePriorityAlert() {
    const priorityAlert = document.querySelector('.alert-benchmark-priority, .alert-next-up')
    if (priorityAlert) {
      priorityAlert.classList.add('priority-pulse')

      setTimeout(() => {
        priorityAlert.classList.remove('priority-pulse')
      }, 2000)
    }
  }

  // NEW: Smooth toggle button transitions
  animateToggleButtons() {
    const toggleButtons = document.querySelectorAll('.btn-group .btn')
    toggleButtons.forEach((button, index) => {
      button.addEventListener('click', (e) => {
        // Add click ripple effect
        this.addRippleEffect(button, e)

        // Animate other buttons
        toggleButtons.forEach((otherButton, otherIndex) => {
          if (otherIndex !== index) {
            otherButton.classList.add('toggle-animate-out')
            setTimeout(() => {
              otherButton.classList.remove('toggle-animate-out')
            }, 300)
          }
        })
      })
    })
  }

  // NEW: Add ripple effect to buttons
  addRippleEffect(button, event) {
    const ripple = document.createElement('span')
    ripple.classList.add('ripple')

    const rect = button.getBoundingClientRect()
    const size = Math.max(rect.width, rect.height)
    const x = event.clientX - rect.left - size / 2
    const y = event.clientY - rect.top - size / 2

    ripple.style.width = ripple.style.height = size + 'px'
    ripple.style.left = x + 'px'
    ripple.style.top = y + 'px'

    button.appendChild(ripple)

    setTimeout(() => {
      ripple.remove()
    }, 600)
  }

  disconnect() {
    console.log("🎬 Typography animator disconnected")

    // Clean up event listeners
    this.element.removeEventListener('dashboard:viewChanged', this.handleViewChange.bind(this))
  }
}
