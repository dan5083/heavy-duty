import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="custom-split-builder"
export default class extends Controller {
  static targets = [
    "form",
    "muscleCard",
    "muscleCheckbox",
    "recoverySelector",
    "recoverySelect",
    "preview",
    "previewStats",
    "muscleCount",
    "avgRecovery",
    "submitButton"
  ]

  connect() {
    console.log("🏗️ Custom split builder connected!")
    this.updatePreview()
  }

  toggleMuscle(event) {
    const checkbox = event.target
    const muscleCard = checkbox.closest('[data-custom-split-builder-target="muscleCard"]')
    const recoverySelector = muscleCard.querySelector('[data-custom-split-builder-target="recoverySelector"]')

    if (checkbox.checked) {
      // Show recovery selector
      recoverySelector.style.display = 'block'
      muscleCard.classList.add('selected')

      // Add animation
      recoverySelector.style.animation = 'slideDown 0.3s ease-out'
    } else {
      // Hide recovery selector
      recoverySelector.style.display = 'none'
      muscleCard.classList.remove('selected')
    }

    this.updatePreview()
  }

  updatePreview() {
    const selectedMuscles = this.getSelectedMuscles()

    if (selectedMuscles.length === 0) {
      this.showEmptyPreview()
      this.submitButtonTarget.disabled = true
    } else {
      this.showSplitPreview(selectedMuscles)
      this.submitButtonTarget.disabled = false
    }
  }

  getSelectedMuscles() {
    const selected = []

    this.muscleCheckboxTargets.forEach(checkbox => {
      if (checkbox.checked) {
        const muscleCard = checkbox.closest('[data-custom-split-builder-target="muscleCard"]')
        const muscle = muscleCard.dataset.muscle
        const recoverySelect = muscleCard.querySelector('[data-custom-split-builder-target="recoverySelect"]')
        const recoveryDays = recoverySelect ? parseInt(recoverySelect.value) : 5

        selected.push({
          muscle: muscle,
          recoveryDays: recoveryDays,
          label: checkbox.nextElementSibling.querySelector('strong').textContent
        })
      }
    })

    return selected
  }

  showEmptyPreview() {
    this.previewTarget.innerHTML = `
      <div class="text-center text-muted py-4">
        <i class="bi bi-arrow-left display-6"></i>
        <p class="mt-2 mb-0">Select muscles to see your split</p>
      </div>
    `
    this.previewStatsTarget.style.display = 'none'
  }

  showSplitPreview(selectedMuscles) {
    // Build preview HTML
    let previewHtml = '<div class="selected-muscles">'

    selectedMuscles.forEach((muscle, index) => {
      previewHtml += `
        <div class="muscle-preview-item d-flex justify-content-between align-items-center mb-2 p-2 rounded bg-light">
          <div>
            <strong class="text-primary">${muscle.label}</strong>
            <br>
            <small class="text-muted">${muscle.recoveryDays} day${muscle.recoveryDays !== 1 ? 's' : ''} recovery</small>
          </div>
          <span class="badge bg-primary">${index + 1}</span>
        </div>
      `
    })

    previewHtml += '</div>'

    if (selectedMuscles.length > 0) {
      previewHtml += `
        <div class="mt-3 pt-3 border-top">
          <h6 class="text-muted mb-2">Your Split Rotation:</h6>
          <div class="split-rotation">
            ${this.generateRotationPreview(selectedMuscles)}
          </div>
        </div>
      `
    }

    this.previewTarget.innerHTML = previewHtml

    // Update stats
    this.updateStats(selectedMuscles)
  }

  generateRotationPreview(selectedMuscles) {
    if (selectedMuscles.length === 0) return ''

    // Simple rotation - just show the order
    const rotation = selectedMuscles.map((muscle, index) => {
      return `<span class="badge bg-outline-primary me-1 mb-1">Day ${index + 1}: ${muscle.label}</span>`
    }).join('')

    return `<div class="rotation-preview">${rotation}</div>`
  }

  updateStats(selectedMuscles) {
    const muscleCount = selectedMuscles.length
    const avgRecovery = muscleCount > 0
      ? Math.round(selectedMuscles.reduce((sum, m) => sum + m.recoveryDays, 0) / muscleCount)
      : 0

    this.muscleCountTarget.textContent = muscleCount
    this.avgRecoveryTarget.textContent = `${avgRecovery}d`

    this.previewStatsTarget.style.display = muscleCount > 0 ? 'block' : 'none'

    // Add animation to stats
    if (muscleCount > 0) {
      this.previewStatsTarget.style.animation = 'fadeIn 0.3s ease-out'
    }
  }
}
