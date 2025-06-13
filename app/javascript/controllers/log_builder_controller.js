import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="log-builder"
export default class extends Controller {
  static targets = [
    "exerciseGrid",
    "workoutCards",
    "emptyState",
    "finishSection",
    "form",
    "hiddenDetails",
    "submitButton",
    "exerciseCardTemplate",
    "setTemplate"
  ]

  connect() {
    console.log("Single-page log builder controller connected")
    console.log("Available targets:", this.targets)
    console.log("Template target available:", this.hasExerciseCardTemplateTarget)
    console.log("Set template available:", this.hasSetTemplateTarget)

    this.exerciseData = new Map() // Store data for each exercise
    this.setCounters = new Map() // Track set numbers per exercise
    this.updateUI()
  }

  addExercise(event) {
    const card = event.currentTarget
    const exerciseName = card.dataset.exercise

    // Don't add if already exists
    if (this.exerciseData.has(exerciseName)) {
      this.showMessage("Exercise already added!", "warning")
      return
    }

    // Initialize exercise data
    this.exerciseData.set(exerciseName, [])
    this.setCounters.set(exerciseName, 0)

    // Create exercise card
    this.createExerciseCard(exerciseName)

    // Update UI
    this.updateUI()

    // Collapse the selector
    const collapse = new bootstrap.Collapse(document.getElementById('exercise-selector'), {
      toggle: true
    })

    this.showMessage(`Added ${exerciseName}`, "success")
  }

  createExerciseCard(exerciseName) {
    // Clone the template
    const template = this.exerciseCardTemplateTarget.content.cloneNode(true)
    const card = template.querySelector('.exercise-workout-card')

    // Set exercise name and data
    card.dataset.exercise = exerciseName
    card.querySelector('.exercise-name').textContent = exerciseName

    // Add to DOM first
    this.workoutCardsTarget.appendChild(card)

    // Now add event listeners (elements are in DOM)
    const actualCard = this.workoutCardsTarget.querySelector(`[data-exercise="${exerciseName}"]`)

    const removeButton = actualCard.querySelector('.remove-exercise')
    if (removeButton) {
      removeButton.addEventListener('click', () => {
        this.removeExercise(exerciseName)
      })
    }

    // Add first set automatically
    this.addSet(exerciseName)
  }

  addSet(exerciseName) {
    const exerciseCard = this.workoutCardsTarget.querySelector(`[data-exercise="${exerciseName}"]`)
    const setsContainer = exerciseCard.querySelector('.sets-container')

    // Increment set counter
    const currentCount = this.setCounters.get(exerciseName) + 1
    this.setCounters.set(exerciseName, currentCount)

    // Clone set template
    const template = this.setTemplateTarget.content.cloneNode(true)
    const setRow = template.querySelector('.set-row')

    // Set the set number
    setRow.querySelector('.set-number').textContent = currentCount

    // Add to DOM first
    setsContainer.appendChild(setRow)

    // Now add event listeners (elements are in DOM)
    const textarea = setsContainer.lastElementChild.querySelector('.set-description')
    const voiceBtn = setsContainer.lastElementChild.querySelector('.voice-btn')

    if (textarea) {
      textarea.addEventListener('input', () => {
        this.updateExerciseData(exerciseName)
      })
    }

    if (voiceBtn) {
      voiceBtn.addEventListener('click', () => {
        this.startVoiceRecognition(textarea, voiceBtn)
      })
    }

    // Update data
    this.updateExerciseData(exerciseName)
  }

  startVoiceRecognition(textarea, button) {
    // Check if browser supports speech recognition
    if (!('webkitSpeechRecognition' in window) && !('SpeechRecognition' in window)) {
      this.showMessage("Voice recognition not supported in this browser", "warning")
      return
    }

    const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition
    const recognition = new SpeechRecognition()

    recognition.continuous = true
    recognition.interimResults = true
    recognition.lang = 'en-US'

    // Visual feedback
    button.classList.add('btn-danger')
    button.innerHTML = '<i class="bi bi-record-circle"></i>'
    button.disabled = true

    recognition.onstart = () => {
      console.log('Voice recognition started')
    }

    recognition.onresult = (event) => {
      const transcript = event.results[0][0].transcript
      textarea.value = transcript
      textarea.dispatchEvent(new Event('input')) // Trigger the input event
      this.showMessage(`Voice captured: "${transcript}"`, "success")
    }

    recognition.onerror = (event) => {
      console.error('Speech recognition error:', event.error)
      this.showMessage(`Voice recognition error: ${event.error}`, "danger")
    }

    recognition.onend = () => {
      // Reset button
      button.classList.remove('btn-danger')
      button.innerHTML = '<i class="bi bi-mic"></i>'
      button.disabled = false
    }

    recognition.start()
  }

  removeSet(exerciseName, setRow) {
    setRow.remove()
    this.updateExerciseData(exerciseName)
    this.updateUI()
  }

  removeExercise(exerciseName) {
    // Remove from data
    this.exerciseData.delete(exerciseName)
    this.setCounters.delete(exerciseName)

    // Remove from DOM
    const card = this.workoutCardsTarget.querySelector(`[data-exercise="${exerciseName}"]`)
    if (card) card.remove()

    this.updateUI()
    this.showMessage(`Removed ${exerciseName}`, "info")
  }

  updateExerciseData(exerciseName) {
    const exerciseCard = this.workoutCardsTarget.querySelector(`[data-exercise="${exerciseName}"]`)
    const setRows = exerciseCard.querySelectorAll('.set-row')

    const sets = []
    let shouldAddNewSet = false

    setRows.forEach((row, index) => {
      const description = row.querySelector('.set-description').value.trim()

      if (description) {
        sets.push(description)
        // If this is the last row and it has content, we should add a new set
        if (index === setRows.length - 1) {
          shouldAddNewSet = true
        }
      }
    })

    this.exerciseData.set(exerciseName, sets)

    // Add new set if the last one was filled
    if (shouldAddNewSet) {
      this.addSet(exerciseName)
    }

    this.updateUI()
  }

  updateUI() {
    const hasExercises = this.exerciseData.size > 0
    const hasSets = Array.from(this.exerciseData.values()).some(sets => sets.length > 0)

    // Show/hide empty state
    this.emptyStateTarget.style.display = hasExercises ? 'none' : 'block'

    // Show/hide finish section
    this.finishSectionTarget.style.display = hasSets ? 'block' : 'none'

    // Enable/disable submit button
    this.submitButtonTarget.disabled = !hasSets

    // Update hidden field with JSON data
    this.updateHiddenField()
  }

  updateHiddenField() {
    const workoutData = {}

    this.exerciseData.forEach((sets, exercise) => {
      if (sets.length > 0) {
        workoutData[exercise] = sets // Just store the array of description strings
      }
    })

    this.hiddenDetailsTarget.value = JSON.stringify(workoutData)
    console.log("Workout data prepared:", workoutData) // Debug logging
  }

  showMessage(text, type = "info") {
    // Create a temporary toast/alert
    const alertDiv = document.createElement('div')
    alertDiv.className = `alert alert-${type} alert-dismissible fade show position-fixed`
    alertDiv.style.cssText = 'top: 100px; right: 20px; z-index: 1050; max-width: 300px;'
    alertDiv.innerHTML = `
      ${text}
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `

    document.body.appendChild(alertDiv)

    // Auto-remove after 3 seconds
    setTimeout(() => {
      if (alertDiv.parentNode) {
        alertDiv.remove()
      }
    }, 3000)
  }
}
