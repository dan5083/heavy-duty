import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="log-builder"
export default class extends Controller {
  static targets = [
    "badgeContainer",
    "exerciseList",
    "emptyState",
    "form",
    "hiddenDetails",
    "submitButton"
  ]

  connect() {
    console.log("🏷️ Badge-based workout editor connected!")

    this.benchmarkData = window.benchmarkData || {}
    this.availableExercises = window.availableExercises || []

    this.initializeBadgeInterface()
    this.element.addEventListener('badge-editor:badge-changed', this.handleBadgeChange.bind(this))
    this.element.addEventListener('badge-editor:add-badge', this.handleAddBadge.bind(this))

    if (this.hasFormTarget) {
      this.formTarget.addEventListener('submit', this.handleFormSubmit.bind(this))
    }

    this.updateHiddenField()
  }

  initializeBadgeInterface() {
    if (Object.keys(this.benchmarkData).length === 0) {
      this.showEmptyState()
    } else {
      this.renderWorkoutBadges()
      this.hideEmptyState()
    }
  }

  showEmptyState() {
    this.emptyStateTarget.style.display = 'block'
    this.exerciseListTarget.innerHTML = ''
  }

  hideEmptyState() {
    this.emptyStateTarget.style.display = 'none'
  }

  renderWorkoutBadges() {
    let html = ''

    Object.entries(this.benchmarkData).forEach(([exerciseName, sets], exerciseIndex) => {
      html += this.renderExerciseBlock(exerciseName, sets, exerciseIndex)
    })

    html += this.renderAddExerciseButton()
    this.exerciseListTarget.innerHTML = html
  }

  renderExerciseBlock(exerciseName, sets, exerciseIndex) {
    const setsHtml = sets.map((setDescription, setIndex) => {
      return this.renderSetLine(setDescription, exerciseIndex, setIndex)
    }).join('')

    return `
      <div class="exercise-block" data-exercise-id="${exerciseIndex}">
        <div class="exercise-header d-flex justify-content-between align-items-center">
          <span>🏋️ ${exerciseName}</span>
          <button class="btn btn-sm btn-outline-danger"
                  data-action="click->log-builder#deleteExercise"
                  data-exercise-id="${exerciseIndex}"
                  onclick="event.stopPropagation()">
            <i class="bi bi-trash"></i>
          </button>
        </div>
        ${setsHtml}
        <div class="set-line">
          <button class="btn btn-sm btn-outline-primary"
                  data-action="click->log-builder#addSet"
                  data-exercise-id="${exerciseIndex}">
            + Add Set
          </button>
        </div>
      </div>
    `
  }

  renderSetLine(setDescription, exerciseIndex, setIndex) {
    const badges = this.parseSetIntoBadges(setDescription)
    const badgesHtml = badges.map((badge, badgeIndex) => {
      return this.renderBadge(badge, exerciseIndex, setIndex, badgeIndex)
    }).join('')

    return `
      <div class="set-line" data-set-index="${setIndex}">
        <span class="set-number">${setIndex + 1}:</span>
        ${badgesHtml}
      </div>
    `
  }

  renderBadge(badge, exerciseIndex, setIndex, badgeIndex) {
    return `
      <span class="workout-badge badge-${badge.type}"
            data-controller="badge-editor"
            data-badge-editor-target="badge"
            data-badge-editor-type-value="${badge.type}"
            data-badge-editor-content-value="${badge.content}"
            data-badge-editor-exercise-id-value="${exerciseIndex}"
            data-new-badge="true"
            data-action="click->badge-editor#edit">
        <span class="badge-text">${badge.content}</span>
      </span>
    `
  }

  renderAddExerciseButton() {
    return `
      <div class="text-center mt-4 mb-4">
        <button class="btn btn-outline-success"
                data-action="click->log-builder#addExercise">
          <i class="bi bi-plus-lg"></i> Add Exercise
        </button>
      </div>
    `
  }

  parseSetIntoBadges(setDescription) {
    const parts = setDescription.split(',').map(part => part.trim())

    while (parts.length < 4) {
      if (parts.length === 1) parts.push('10')
      else if (parts.length === 2) parts.push('70')
      else if (parts.length === 3) parts.push('good')
    }

    const [status, reps, weight, reflection] = parts.slice(0, 4)

    return [
      { type: 'status', content: status || 'Work' },
      { type: 'reps', content: reps || '10' },
      { type: 'weight', content: weight || '70' },
      { type: 'reflection', content: reflection || 'good' }
    ]
  }

  addExercise(event) {
    event.preventDefault()
    console.log("Adding new exercise...")
    this.showExerciseSelector(event.target)
  }

  showExerciseSelector(triggerElement) {
    const dropdown = document.createElement('div')
    dropdown.className = 'exercise-selector-dropdown position-absolute bg-white border rounded shadow-lg'
    dropdown.style.cssText = `
      display: block;
      max-height: 300px;
      overflow-y: auto;
      z-index: 1000;
      min-width: 300px;
      border-color: #dee2e6;
    `

    const exercisesHtml = this.availableExercises.map(exercise => `
      <div class="exercise-option px-3 py-2 cursor-pointer"
           style="cursor: pointer;"
           onmouseover="this.style.backgroundColor='#f8f9fa'"
           onmouseout="this.style.backgroundColor=''"
           data-exercise="${exercise}">
        🏋️ ${exercise}
      </div>
    `).join('')

    dropdown.innerHTML = `
      <div class="p-3 border-bottom">
        <strong>Choose an exercise:</strong>
      </div>
      ${exercisesHtml}
    `

    const rect = triggerElement.getBoundingClientRect()
    dropdown.style.top = `${rect.bottom + window.scrollY}px`
    dropdown.style.left = `${rect.left + window.scrollX}px`

    document.body.appendChild(dropdown)

    dropdown.querySelectorAll('.exercise-option').forEach(option => {
      option.addEventListener('click', (e) => {
        this.selectExercise(e.target.dataset.exercise)
        dropdown.remove()
      })
    })

    setTimeout(() => {
      document.addEventListener('click', function hideDropdown(e) {
        if (!dropdown.contains(e.target)) {
          dropdown.remove()
          document.removeEventListener('click', hideDropdown)
        }
      })
    }, 100)
  }

  selectExercise(exerciseName) {
    console.log(`Adding exercise: ${exerciseName}`)

    if (!this.benchmarkData[exerciseName]) {
      this.benchmarkData[exerciseName] = [
        "Work, 10, 70, good"
      ]
    }

    this.hideEmptyState()
    this.renderWorkoutBadges()
    this.updateHiddenField()

    setTimeout(() => {
      const exerciseBlocks = this.exerciseListTarget.querySelectorAll('.exercise-block')
      const newExercise = exerciseBlocks[exerciseBlocks.length - 2]
      if (newExercise) {
        newExercise.style.animation = 'badge-spawn 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275)'
      }
    }, 50)
  }

addSet(event) {
  event.preventDefault()
  event.stopPropagation()
  const exerciseId = event.target.dataset.exerciseId
  console.log(`Adding set to exercise ${exerciseId}`)

  this.updateWorkoutData()

  const exercises = Object.keys(this.benchmarkData)
  const exerciseName = exercises[exerciseId]

  if (exerciseName) {
    this.benchmarkData[exerciseName].push("Work, 10, 70, good")
    this.renderWorkoutBadges()
    this.updateHiddenField()

    setTimeout(() => {
      const exerciseBlock = this.exerciseListTarget.querySelector(`[data-exercise-id="${exerciseId}"]`)
      if (exerciseBlock) {
        const setLines = exerciseBlock.querySelectorAll('.set-line[data-set-index]')
        const newSetLine = setLines[setLines.length - 1]
        if (newSetLine) {
          newSetLine.style.animation = 'badge-spawn 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275)'

          const badges = newSetLine.querySelectorAll('.workout-badge')
          badges.forEach((badge, index) => {
            badge.style.animationDelay = `${index * 0.1}s`
            badge.classList.add('badge-creating')
          })
        }
      }
    }, 50)
  }
}

  deleteExercise(event) {
    const exerciseId = event.target.dataset.exerciseId
    console.log(`Deleting exercise ${exerciseId}`)

    this.updateWorkoutData()

    const exercises = Object.keys(this.benchmarkData)
    const exerciseName = exercises[exerciseId]

    if (exerciseName && confirm(`Delete ${exerciseName}?`)) {
      delete this.benchmarkData[exerciseName]
      this.renderWorkoutBadges()
      this.updateHiddenField()

      if (Object.keys(this.benchmarkData).length === 0) {
        this.showEmptyState()
      }
    }
  }

  handleFormSubmit(event) {
    console.log("Form submitting - capturing current badge state...")
    this.updateWorkoutData()

    const allBadges = this.exerciseListTarget.querySelectorAll('.workout-badge')
    allBadges.forEach(badge => {
      badge.classList.add('badge-loading')
    })

    this.showSuccessFeedback('Saving workout...')
  }

  handleBadgeChange(event) {
    console.log('Badge changed:', event.detail)
    this.updateWorkoutData()
    this.showSuccessFeedback('Updated!')
  }

  handleAddBadge(event) {
    console.log('Add badge:', event.detail)
  }

  showSuccessFeedback(message) {
    const feedback = document.createElement('div')
    feedback.className = 'badge-success-feedback'
    feedback.textContent = message
    feedback.style.cssText = `
      position: fixed;
      top: 20px;
      right: 20px;
      background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
      color: #155724;
      padding: 0.75rem 1rem;
      border-radius: 0.5rem;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
      z-index: 9999;
      animation: slideInRight 0.3s ease-out;
    `

    document.body.appendChild(feedback)

    setTimeout(() => {
      feedback.style.animation = 'slideOutRight 0.3s ease-in forwards'
      setTimeout(() => feedback.remove(), 300)
    }, 2000)
  }

  updateWorkoutData() {
    const newBenchmarkData = {}

    const exerciseBlocks = this.exerciseListTarget.querySelectorAll('.exercise-block')

    exerciseBlocks.forEach((block, exerciseIndex) => {
      const exerciseHeader = block.querySelector('.exercise-header span')
      if (!exerciseHeader) return

      const exerciseName = exerciseHeader.textContent.replace('🏋️ ', '').trim()
      newBenchmarkData[exerciseName] = []

      const setLines = block.querySelectorAll('.set-line[data-set-index]')

      setLines.forEach((setLine) => {
        const badges = setLine.querySelectorAll('[data-controller="badge-editor"]')
        const badgeTexts = []

        badges.forEach(badge => {
          const content = badge.getAttribute('data-badge-editor-content-value')
          if (content) {
            badgeTexts.push(content)
          }
        })

        if (badgeTexts.length > 0) {
          const setDescription = badgeTexts.join(', ')
          newBenchmarkData[exerciseName].push(setDescription)
        }
      })
    })

    this.benchmarkData = newBenchmarkData
    this.updateHiddenField()

    console.log("Rebuilt workout data from current badge state:", this.benchmarkData)
  }

  updateHiddenField() {
    this.hiddenDetailsTarget.value = JSON.stringify(this.benchmarkData)

    const hasContent = Object.keys(this.benchmarkData).length > 0
    this.submitButtonTarget.disabled = !hasContent

    console.log("Updated workout data:", this.benchmarkData)
  }
}
