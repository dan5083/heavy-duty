import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="log-builder"
export default class extends Controller {
  static targets = [
    "badgeContainer",
    "exerciseList",
    "emptyState",
    "form",
    "hiddenDetails",
    "submitButton",
    "benchmarkModal",
    "benchmarkChoice"
  ]

  connect() {
    console.log("🏷️ Badge-based workout editor connected!")

    // Get benchmark data from ExerciseSet structure
    this.benchmarkData = window.benchmarkData || {}
    this.availableExercises = window.availableExercises || []

    console.log("Benchmark data:", this.benchmarkData)
    console.log("Available exercises:", this.availableExercises)

    this.initializeBadgeInterface()
    this.element.addEventListener('badge-editor:badge-changed', this.handleBadgeChange.bind(this))
    this.element.addEventListener('badge-editor:add-badge', this.handleAddBadge.bind(this))

    this.updateHiddenField()
  }

  initializeBadgeInterface() {
    console.log("Initializing badge interface with data:", this.benchmarkData)

    if (Object.keys(this.benchmarkData).length === 0) {
      console.log("No benchmark data - showing empty state")
      this.showEmptyState()
    } else {
      console.log("Benchmark data found - rendering workout badges")
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
    const setsHtml = sets.map((setData, setIndex) => {
      return this.renderSetLine(setData, exerciseIndex, setIndex)
    }).join('')

    return `
      <div class="exercise-block" data-exercise-id="${exerciseIndex}">
        <div class="exercise-header d-flex justify-content-between align-items-center">
          <span>🏋️ ${exerciseName}</span>
          <button class="btn btn-xs btn-danger exercise-delete-btn"
                  data-action="click->log-builder#deleteExercise"
                  data-exercise-id="${exerciseIndex}"
                  type="button">
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

  renderSetLine(setData, exerciseIndex, setIndex) {
    const badges = this.exerciseSetToBadges(setData)
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

  // Convert ExerciseSet data to badge format
  exerciseSetToBadges(setData) {
    return [
      { type: 'status', content: `${setData.set_type || 'Working'} set` },
      { type: 'reps', content: setData.reps ? `${setData.reps} reps` : 'to failure' },
      { type: 'weight', content: setData.weight_kg ? `at ${setData.weight_kg} ${setData.weight_unit || 'kg'}` : 'bodyweight' },
      { type: 'reflection', content: setData.notes || 'solid effort' }
    ]
  }

  // Convert badges back to ExerciseSet format
  badgesToExerciseSet(badges, exerciseName, setNumber) {
    const statusBadge = badges.find(b => b.type === 'status')
    const repsBadge = badges.find(b => b.type === 'reps')
    const weightBadge = badges.find(b => b.type === 'weight')
    const reflectionBadge = badges.find(b => b.type === 'reflection')

    return {
      exercise_name: exerciseName,
      set_number: setNumber,
      set_type: this.extractSetType(statusBadge?.content),
      reps: this.extractReps(repsBadge?.content),
      weight_kg: this.extractWeight(weightBadge?.content)?.weight,
      weight_unit: this.extractWeight(weightBadge?.content)?.unit || 'kg',
      notes: reflectionBadge?.content || 'solid effort'
    }
  }

  extractSetType(statusContent) {
    if (!statusContent) return 'working'
    const lower = statusContent.toLowerCase()
    if (lower.includes('warmup')) return 'warmup'
    if (lower.includes('drop')) return 'drop'
    if (lower.includes('super')) return 'super'
    if (lower.includes('heavy')) return 'heavy'
    if (lower.includes('light')) return 'light'
    return 'working'
  }

  extractReps(repsContent) {
    if (!repsContent || repsContent.toLowerCase().includes('failure')) return null
    const match = repsContent.match(/(\d+)/)
    return match ? parseInt(match[1]) : null
  }

  extractWeight(weightContent) {
    if (!weightContent || weightContent.toLowerCase().includes('bodyweight')) {
      return { weight: null, unit: 'kg' }
    }

    const match = weightContent.match(/(\d+(?:\.\d+)?)\s*(kg|kilos?|lbs?|pounds?)?/i)
    if (match) {
      const weight = parseFloat(match[1])
      const unit = match[2]?.toLowerCase().includes('lb') ? 'lbs' : 'kg'
      return { weight, unit }
    }
    return { weight: null, unit: 'kg' }
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

    this.updateWorkoutData()

    if (!this.benchmarkData[exerciseName]) {
      this.benchmarkData[exerciseName] = [{
        set_number: 1,
        set_type: 'working',
        reps: 1,
        weight_kg: 1,
        weight_unit: 'kg',
        notes: 'solid effort'
      }]
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
      const currentSets = this.benchmarkData[exerciseName]
      const newSetNumber = currentSets.length + 1

      this.benchmarkData[exerciseName].push({
        set_number: newSetNumber,
        set_type: 'working',
        reps: 1,
        weight_kg: 1,
        weight_unit: 'kg',
        notes: 'solid effort'
      })

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
    event.preventDefault()
    event.stopPropagation()

    const exerciseId = event.target.closest('button').dataset.exerciseId
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

  showBenchmarkModal(event) {
    event.preventDefault()
    console.log("Showing benchmark choice modal...")

    this.updateWorkoutData()

    this.benchmarkModalTarget.style.display = 'flex'
    this.benchmarkModalTarget.style.cssText = `
      display: flex !important;
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: rgba(0, 0, 0, 0.5);
      z-index: 9999;
      align-items: center;
      justify-content: center;
    `

    document.body.style.overflow = 'hidden'
  }

  chooseBenchmarkUpdate(event) {
    event.preventDefault()  // Prevent any default behavior

    // Find the button element (in case we clicked on a child element)
    const button = event.target.closest('button')
    const choice = button ? button.dataset.choice : event.target.dataset.choice

    console.log(`User chose: ${choice}`)
    console.log(`Event target:`, event.target)
    console.log(`Button found:`, button)

    // Find the hidden field more defensively
    const benchmarkField = document.querySelector('[data-log-builder-target="benchmarkChoice"]')

    if (benchmarkField) {
      benchmarkField.value = choice === 'yes' ? 'yes' : 'no'
      console.log(`Hidden field set to: ${benchmarkField.value}`)
    } else {
      console.error('Could not find benchmark choice field')
    }

    // Close modal
    this.closeBenchmarkModal()

    // Submit the form
    this.submitFormWithChoice()
  }

  closeBenchmarkModal() {
    this.benchmarkModalTarget.style.display = 'none'
    document.body.style.overflow = ''
  }

  submitFormWithChoice() {
    const benchmarkField = document.querySelector('[data-log-builder-target="benchmarkChoice"]')
    console.log("Submitting form with benchmark choice:", benchmarkField?.value)

    const allBadges = this.exerciseListTarget.querySelectorAll('.workout-badge')
    allBadges.forEach(badge => {
      badge.classList.add('badge-loading')
    })

    this.showSuccessFeedback('Saving workout...')

    this.formTarget.submit()
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
    const exerciseSetsArray = []

    const exerciseBlocks = this.exerciseListTarget.querySelectorAll('.exercise-block')

    exerciseBlocks.forEach((block, exerciseIndex) => {
      const exerciseHeader = block.querySelector('.exercise-header span')
      if (!exerciseHeader) return

      const exerciseName = exerciseHeader.textContent.replace('🏋️ ', '').trim()
      const setLines = block.querySelectorAll('.set-line[data-set-index]')

      setLines.forEach((setLine, setIndex) => {
        const badges = setLine.querySelectorAll('[data-controller="badge-editor"]')
        const badgeData = []

        badges.forEach(badge => {
          const type = badge.getAttribute('data-badge-editor-type-value')
          const content = badge.getAttribute('data-badge-editor-content-value')
          if (type && content) {
            badgeData.push({ type, content })
          }
        })

        if (badgeData.length > 0) {
          const exerciseSetData = this.badgesToExerciseSet(badgeData, exerciseName, setIndex + 1)
          exerciseSetsArray.push(exerciseSetData)
        }
      })
    })

    // Group back into benchmark format for rendering
    this.benchmarkData = {}
    exerciseSetsArray.forEach(setData => {
      if (!this.benchmarkData[setData.exercise_name]) {
        this.benchmarkData[setData.exercise_name] = []
      }
      this.benchmarkData[setData.exercise_name].push(setData)
    })

    this.updateHiddenField(exerciseSetsArray)

    console.log("Rebuilt workout data:", this.benchmarkData)
    console.log("Exercise sets array:", exerciseSetsArray)
  }

  updateHiddenField(exerciseSetsArray = null) {
    if (!exerciseSetsArray) {
      // Convert current benchmarkData to exercise sets array
      exerciseSetsArray = []
      Object.entries(this.benchmarkData).forEach(([exerciseName, sets]) => {
        sets.forEach(setData => {
          exerciseSetsArray.push({
            exercise_name: exerciseName,
            set_number: setData.set_number || 1,
            set_type: setData.set_type || 'working',
            reps: setData.reps,
            weight_kg: setData.weight_kg,
            weight_unit: setData.weight_unit || 'kg',
            notes: setData.notes || 'solid effort'
          })
        })
      })
    }

    this.hiddenDetailsTarget.value = JSON.stringify(exerciseSetsArray)

    const hasContent = exerciseSetsArray.length > 0
    this.submitButtonTarget.disabled = !hasContent

    console.log("Updated exercise sets data:", exerciseSetsArray)
  }
}
