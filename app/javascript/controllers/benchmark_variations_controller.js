import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="benchmark-variations"
export default class extends Controller {
  static targets = [
    "variationButton",
    "variationIndicator",
    "hiddenVariation"
  ]

  static values = {
    currentVariation: { type: String, default: "A" },
    workoutId: Number,
    availableVariations: { type: Array, default: [] },
    benchmarkData: Object,
    contextData: Object
  }

  connect() {
    console.log("🔄 Benchmark variations controller connected!")
    console.log("Available variations:", this.availableVariationsValue)
    console.log("Current variation:", this.currentVariationValue)
    console.log("Benchmark data:", this.benchmarkDataValue)
    console.log("Context data:", this.contextDataValue)

    // Initialize the UI state
    this.updateVariationButtons()
    this.updateHiddenField()

    // Listen for log-builder requests to show variation selector
    this.element.addEventListener('log-builder:show-variation-selector', this.showVariationSelector.bind(this))
  }

  // Switch to a different variation
  selectVariation(event) {
    event.preventDefault()

    const button = event.currentTarget
    const newVariation = button.dataset.variation

    console.log(`🔄 Switching from ${this.currentVariationValue} to ${newVariation}`)

    // Don't do anything if already selected
    if (newVariation === this.currentVariationValue) {
      console.log("Already on this variation, ignoring")
      return
    }

    // Update the current variation
    this.currentVariationValue = newVariation

    // Update UI immediately
    this.updateVariationButtons()
    this.updateHiddenField()

    // Load data for this variation
    this.loadVariationData(newVariation)
  }

  // Load benchmark data and context for the selected variation
  loadVariationData(variation) {
    console.log(`📥 Loading data for variation ${variation}`)

    // Get the data for this specific variation from the global data
    const variationBenchmarkData = this.getVariationBenchmarkData(variation)
    const variationContext = this.getVariationContext(variation)

    console.log(`Variation ${variation} benchmark data:`, variationBenchmarkData)
    console.log(`Variation ${variation} context:`, variationContext)

    // Show loading state
    this.showLoadingState()

    // Simulate brief loading delay for better UX
    setTimeout(() => {
      // Dispatch event to log-builder with the new data
      this.dispatchVariationChange(variation, variationBenchmarkData, variationContext)

      // Hide loading state
      this.hideLoadingState()

      console.log(`✅ Loaded variation ${variation}`)
    }, 150)
  }

  // Get benchmark data for a specific variation from global data
  getVariationBenchmarkData(variation) {
    // Use the global window.allVariationData that's set by the view
    const allData = window.allVariationData || {}

    // Look for data specific to this variation
    const variationData = allData[variation] || {}

    console.log(`Raw variation data for ${variation}:`, variationData)

    // Return the exercises object from the variation data
    const exercisesData = variationData.exercises || {}

    if (Object.keys(exercisesData).length === 0) {
      console.log(`No benchmark data found for variation ${variation}`)
      return {}
    }

    return exercisesData
  }

  // Get context data for a specific variation
  getVariationContext(variation) {
    // Use the global window.allVariationData that's set by the view
    const allData = window.allVariationData || {}

    // Context is stored in the variation data structure
    const variationData = allData[variation] || {}
    const variationContext = variationData.context

    console.log(`Context for variation ${variation}:`, variationContext)

    return variationContext || null
  }

  // Dispatch event to log-builder controller with variation data
  dispatchVariationChange(variation, benchmarkData, contextData) {
    const eventDetail = {
      variation: variation,
      benchmarkData: benchmarkData,
      benchmarkContext: contextData,
      isEmpty: Object.keys(benchmarkData).length === 0
    }

    console.log("🔄 Dispatching variation change:", eventDetail)

    const event = new CustomEvent('benchmark-variations:variation-changed', {
      detail: eventDetail,
      bubbles: true
    })

    this.element.dispatchEvent(event)
  }

  // Update the visual state of variation buttons
  updateVariationButtons() {
    this.variationButtonTargets.forEach(button => {
      const buttonVariation = button.dataset.variation
      const isSelected = buttonVariation === this.currentVariationValue
      const hasData = this.variationHasData(buttonVariation)

      // Remove all state classes
      button.classList.remove('btn-primary', 'btn-outline-primary', 'btn-outline-secondary', 'active')

      if (isSelected) {
        // Selected variation
        button.classList.add('btn-primary', 'active')
        button.setAttribute('aria-pressed', 'true')
      } else if (hasData) {
        // Has data but not selected
        button.classList.add('btn-outline-primary')
        button.setAttribute('aria-pressed', 'false')
      } else {
        // No data and not selected
        button.classList.add('btn-outline-secondary')
        button.setAttribute('aria-pressed', 'false')
      }

      // Update button content to show data status
      this.updateButtonContent(button, buttonVariation, hasData, isSelected)
    })

    // Update any variation indicators
    this.updateVariationIndicators()
  }

  // Update button content to show whether variation has data
  updateButtonContent(button, variation, hasData, isSelected) {
    const baseText = `Variation ${variation}`

    // Find or create the text content
    let textSpan = button.querySelector('.variation-text')
    if (!textSpan) {
      textSpan = document.createElement('span')
      textSpan.className = 'variation-text'
      button.appendChild(textSpan)
    }

    // Find or create the indicator
    let indicator = button.querySelector('.variation-indicator')
    if (!indicator) {
      indicator = document.createElement('small')
      indicator.className = 'variation-indicator d-block'
      button.appendChild(indicator)
    }

    textSpan.textContent = baseText

    if (isSelected) {
      indicator.innerHTML = '<i class="bi bi-check-circle-fill"></i> Current'
      indicator.className = 'variation-indicator d-block text-success'
    } else if (hasData) {
      indicator.innerHTML = '<i class="bi bi-bookmark-fill"></i> Saved'
      indicator.className = 'variation-indicator d-block text-info'
    } else {
      indicator.innerHTML = '<i class="bi bi-plus-circle"></i> Empty'
      indicator.className = 'variation-indicator d-block text-muted'
    }
  }

  // Check if a variation has data
  variationHasData(variation) {
    const variationData = this.getVariationBenchmarkData(variation)
    return Object.keys(variationData).length > 0
  }

  // Update variation indicators (if any)
  updateVariationIndicators() {
    this.variationIndicatorTargets.forEach(indicator => {
      indicator.textContent = `Variation ${this.currentVariationValue}`
    })

    // 🆕 NEW: Update current variation label in modal
    const currentVariationLabels = document.querySelectorAll('[data-benchmark-variations-target="currentVariationLabel"]')
    currentVariationLabels.forEach(label => {
      label.textContent = `Variation ${this.currentVariationValue}`
    })
  }

  // Update the hidden field that gets submitted with the form
  updateHiddenField() {
    if (this.hasHiddenVariationTarget) {
      this.hiddenVariationTarget.value = this.currentVariationValue
      console.log(`🔄 Updated hidden variation field to: ${this.currentVariationValue}`)
    }
  }

  // Show loading state during variation switch
  showLoadingState() {
    this.variationButtonTargets.forEach(button => {
      if (button.dataset.variation === this.currentVariationValue) {
        button.disabled = true
        const originalContent = button.innerHTML
        button.dataset.originalContent = originalContent
        button.innerHTML = '<i class="bi bi-arrow-repeat spin me-2"></i>Loading...'
      }
    })
  }

  // Hide loading state
  hideLoadingState() {
    this.variationButtonTargets.forEach(button => {
      if (button.dataset.variation === this.currentVariationValue) {
        button.disabled = false
        if (button.dataset.originalContent) {
          button.innerHTML = button.dataset.originalContent
          delete button.dataset.originalContent
        }
      }
    })
  }

  // Handle submission with variation (called from log-builder)
  submitWithVariation(variation) {
    console.log(`📝 Submitting with variation: ${variation}`)

    // Update current variation
    this.currentVariationValue = variation
    this.updateHiddenField()

    // Dispatch event back to log-builder
    const event = new CustomEvent('benchmark-variations:submit-with-variation', {
      detail: { variation: variation },
      bubbles: true
    })

    this.element.dispatchEvent(event)
  }

  // 🆕 NEW: Handle modal interactions
  updateCurrentVariation(event) {
    event.preventDefault()
    console.log(`📝 Updating current variation ${this.currentVariationValue} as benchmark`)

    // Set benchmark choice to 'yes' and submit with current variation
    const benchmarkField = document.querySelector('[data-log-builder-target="benchmarkChoice"]')
    if (benchmarkField) {
      benchmarkField.value = 'yes'
    }

    // Close modal and submit
    this.closeBenchmarkModal()
    this.submitForm()
  }

  chooseJustSave(event) {
    event.preventDefault()
    console.log(`📝 Choosing just save (recovery tracking only)`)

    // Set benchmark choice to just_save and submit
    const benchmarkField = document.querySelector('[data-log-builder-target="benchmarkChoice"]')
    if (benchmarkField) {
      benchmarkField.value = 'just_save'
    }

    // Close modal and submit
    this.closeBenchmarkModal()
    this.submitForm()
  }

  closeBenchmarkModal() {
    const modal = document.querySelector('[data-log-builder-target="benchmarkModal"]')
    if (modal) {
      modal.style.display = 'none'
      document.body.style.overflow = ''
    }
  }

  submitForm() {
    const form = document.querySelector('#workout-form')
    if (form) {
      console.log(`📝 Submitting form with variation: ${this.currentVariationValue}`)
      form.submit()
    }
  }

  // Show variation selector modal (if needed)
  showVariationSelector() {
    console.log("📋 Showing variation selector")

    // Create a simple modal for variation selection during submission
    const modal = document.createElement('div')
    modal.className = 'variation-selector-modal'
    modal.style.cssText = `
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: rgba(0, 0, 0, 0.5);
      display: flex;
      align-items: center;
      justify-content: center;
      z-index: 10000;
    `

    modal.innerHTML = `
      <div class="bg-white rounded p-4" style="min-width: 400px;">
        <h5 class="mb-3">Choose Benchmark Variation</h5>
        <p class="text-muted mb-4">Which variation should this workout be saved as?</p>

        <div class="d-grid gap-2">
          ${['A', 'B', 'C'].map(variation => {
            const hasData = this.variationHasData(variation)
            const isCurrent = variation === this.currentVariationValue

            return `
              <button class="btn ${isCurrent ? 'btn-primary' : hasData ? 'btn-outline-warning' : 'btn-outline-success'} text-start"
                      data-variation="${variation}"
                      onclick="this.closest('.variation-selector-modal').dispatchEvent(new CustomEvent('variation-selected', { detail: { variation: '${variation}' } }))">
                <div class="d-flex justify-content-between align-items-center">
                  <div>
                    <strong>Variation ${variation}</strong>
                    <br>
                    <small class="text-muted">
                      ${isCurrent ? 'Currently editing' : hasData ? 'Will overwrite existing' : 'New variation'}
                    </small>
                  </div>
                  <i class="bi bi-${isCurrent ? 'check-circle-fill' : hasData ? 'exclamation-triangle' : 'plus-circle'}"></i>
                </div>
              </button>
            `
          }).join('')}
        </div>

        <div class="mt-3 text-end">
          <button class="btn btn-outline-secondary"
                  onclick="this.closest('.variation-selector-modal').remove(); document.body.style.overflow = ''">
            Cancel
          </button>
        </div>
      </div>
    `

    // Add event listener for variation selection
    modal.addEventListener('variation-selected', (event) => {
      const selectedVariation = event.detail.variation
      modal.remove()
      document.body.style.overflow = ''
      this.submitWithVariation(selectedVariation)
    })

    document.body.appendChild(modal)
    document.body.style.overflow = 'hidden'
  }

  // Utility function to escape HTML
  escapeHtml(text) {
    const div = document.createElement('div')
    div.textContent = text
    return div.innerHTML
  }

  // Handle keyboard shortcuts for variation switching
  handleKeydown(event) {
    // Alt + 1/2/3 to switch variations
    if (event.altKey && ['1', '2', '3'].includes(event.key)) {
      event.preventDefault()
      const variation = { '1': 'A', '2': 'B', '3': 'C' }[event.key]

      const button = this.variationButtonTargets.find(btn => btn.dataset.variation === variation)
      if (button) {
        button.click()
      }
    }
  }

  // Debug method to log current state
  logState() {
    console.log("🔄 Current variation state:", {
      currentVariation: this.currentVariationValue,
      availableVariations: this.availableVariationsValue,
      benchmarkData: this.benchmarkDataValue,
      contextData: this.contextDataValue,
      hasDataForCurrent: this.variationHasData(this.currentVariationValue)
    })
  }
}
