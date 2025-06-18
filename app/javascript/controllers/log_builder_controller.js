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

    // Initialize the badge interface
    this.initializeBadgeInterface()

    // Listen for badge change events
    this.element.addEventListener('badge-editor:badge-changed', this.handleBadgeChange.bind(this))
    this.element.addEventListener('badge-editor:add-badge', this.handleAddBadge.bind(this))

    // Listen for form submission to capture current badge state
    if (this.hasFormTarget) {
      this.formTarget.addEventListener('submit', this.handleFormSubmit.bind(this))
    }

    this.updateHiddenField()
  }

  // Initialize the badge interface from benchmark data
  initializeBadgeInterface() {
    if (Object.keys(this.benchmarkData).length === 0) {
      // No benchmark data - show empty state
      this.showEmptyState()
    } else {
      // Has benchmark data - render as badges
      this.renderWorkoutBadges()
      this.hideEmptyState()
    }
  }

  // Show empty state with helpful message
  showEmptyState() {
    this.emptyStateTarget.style.display = 'block'
    this.exerciseListTarget.innerHTML = ''
  }

  // Hide empty state
  hideEmptyState() {
    this.emptyStateTarget.style.display = 'none'
  }

  // Render workout data as interactive badges
  renderWorkoutBadges() {
    let html = ''

    Object.entries(this.benchmarkData).forEach(([exerciseName, sets], exerciseIndex) => {
      html += this.renderExerciseBlock(exerciseName, sets, exerciseIndex)
    })

    // Add "Add Exercise" button
    html += this.renderAddExerciseButton()

    this.exerciseListTarget.innerHTML = html
  }

  // Render a single exercise block with badge sets
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

  // Render a single set line with badges
  renderSetLine(setDescription, exerciseIndex, setIndex) {
    const badges = this.parseSetIntoBadges(setDescription)
    const badgesHtml = badges.map((badge, badgeIndex) => {
      return this.renderBadge(badge, exerciseIndex, setIndex, badgeIndex)
    }).join('')

    return `
      <div class="set-line" data-set-index="${setIndex}">
        <span class="set-number">${setIndex + 1}️⃣</span>
        ${badgesHtml}
      </div>
    `
  }

  // Render a single badge with animation support
  renderBadge(badge, exerciseIndex, setIndex, badgeIndex) {
    console.log(`Rendering badge: ${badge.type} - ${badge.content}`)

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

  // Render add exercise button
  renderAddExerciseButton() {
    return `
      <div class="text-center mt-4">
        <button class="btn btn-outline-success"
                data-action="click->log-builder#addExercise">
          <i class="bi bi-plus-lg"></i> Add Exercise
        </button>
      </div>
    `
  }

  // FIX 1: Parse set description into badge objects - ALWAYS 4 BADGES
  parseSetIntoBadges(setDescription) {
    // Split by comma and trim whitespace
    const parts = setDescription.split(',').map(part => part.trim())

    // Ensure exactly 4 parts (pad with defaults if needed)
    while (parts.length < 4) {
      if (parts.length === 1) parts.push('10')        // Default reps
      else if (parts.length === 2) parts.push('70')   // Default weight
      else if (parts.length === 3) parts.push('felt good') // Default reflection
    }

    // Truncate if more than 4 parts
    const [status, reps, weight, reflection] = parts.slice(0, 4)

    return [
      { type: 'status', content: status || 'Working set' },
      { type: 'reps', content: reps || '10' },
      { type: 'weight', content: weight || '70' },
      { type: 'reflection', content: reflection || 'felt good' }
    ]
  }

  // Handle clicking in empty area to add exercise
  addExercise(event) {
    event.preventDefault()
    console.log("Adding new exercise...")

    // Show exercise selection dropdown
    this.showExerciseSelector(event.target)
  }

  // Show exercise selection dropdown
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

    // Position dropdown
    const rect = triggerElement.getBoundingClientRect()
    dropdown.style.top = `${rect.bottom + window.scrollY}px`
    dropdown.style.left = `${rect.left + window.scrollX}px`

    document.body.appendChild(dropdown)

    // Add click handlers
    dropdown.querySelectorAll('.exercise-option').forEach(option => {
      option.addEventListener('click', (e) => {
        this.selectExercise(e.target.dataset.exercise)
        dropdown.remove()
      })
    })

    // Hide on outside click
    setTimeout(() => {
      document.addEventListener('click', function hideDropdown(e) {
        if (!dropdown.contains(e.target)) {
          dropdown.remove()
          document.removeEventListener('click', hideDropdown)
        }
      })
    }, 100)
  }

  // FIX 2: Add selected exercise with EXACTLY 1 SET
  selectExercise(exerciseName) {
    console.log(`Adding exercise: ${exerciseName}`)

    // Add to benchmark data with EXACTLY ONE SET (4 comma-separated values)
    if (!this.benchmarkData[exerciseName]) {
      this.benchmarkData[exerciseName] = [
        "Working set, 10, 70, felt good"  // Single set with 4 badges
      ]
    }

    // Re-render the interface
    this.hideEmptyState()
    this.renderWorkoutBadges()
    this.updateHiddenField()

    // Add success animation to the new exercise
    setTimeout(() => {
      const exerciseBlocks = this.exerciseListTarget.querySelectorAll('.exercise-block')
      const newExercise = exerciseBlocks[exerciseBlocks.length - 2] // -2 because last is add button
      if (newExercise) {
        newExercise.style.animation = 'badge-spawn 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275)'
      }
    }, 50)
  }

  // FIX 3: Add a new set to an exercise - EXACTLY 1 SET with 4 badges
  addSet(event) {
    const exerciseId = event.target.dataset.exerciseId
    console.log(`Adding set to exercise ${exerciseId}`)

    // First update our data from current badge state
    this.updateWorkoutData()

    // Find exercise in benchmark data and add ONE set with 4 comma-separated badges
    const exercises = Object.keys(this.benchmarkData)
    const exerciseName = exercises[exerciseId]

    if (exerciseName) {
      // Add exactly 1 set with 4 comma-separated badges (status, reps, weight, reflection)
      this.benchmarkData[exerciseName].push("Working set, 10, 70, solid effort")
      this.renderWorkoutBadges()
      this.updateHiddenField()

      // Add animation to new set
      setTimeout(() => {
        const exerciseBlock = this.exerciseListTarget.querySelector(`[data-exercise-id="${exerciseId}"]`)
        if (exerciseBlock) {
          const setLines = exerciseBlock.querySelectorAll('.set-line[data-set-index]')
          const newSetLine = setLines[setLines.length - 1]
          if (newSetLine) {
            newSetLine.style.animation = 'badge-spawn 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275)'

            // Animate each badge in the new set
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

  // Delete an exercise
  deleteExercise(event) {
    const exerciseId = event.target.dataset.exerciseId
    console.log(`Deleting exercise ${exerciseId}`)

    // First update our data from current badge state
    this.updateWorkoutData()

    const exercises = Object.keys(this.benchmarkData)
    const exerciseName = exercises[exerciseId]

    if (exerciseName && confirm(`Delete ${exerciseName}?`)) {
      delete this.benchmarkData[exerciseName]
      this.renderWorkoutBadges()
      this.updateHiddenField()

      // Show empty state if no exercises left
      if (Object.keys(this.benchmarkData).length === 0) {
        this.showEmptyState()
      }
    }
  }

  // Handle form submission with animations
  handleFormSubmit(event) {
    console.log("Form submitting - capturing current badge state...")
    this.updateWorkoutData()

    // Add loading state to all badges
    const allBadges = this.exerciseListTarget.querySelectorAll('.workout-badge')
    allBadges.forEach(badge => {
      badge.classList.add('badge-loading')
    })

    // Show submission feedback
    this.showSuccessFeedback('Saving workout...')
  }

  // Handle badge changes with success feedback
  handleBadgeChange(event) {
    console.log('Badge changed:', event.detail)
    // Update data but DON'T re-render to preserve other badge states
    this.updateWorkoutData()

    // Show brief success feedback
    this.showSuccessFeedback('Badge updated!')
  }

  // Add new badge
  handleAddBadge(event) {
    console.log('Add badge:', event.detail)
    // For now, just log - could show badge type selector
  }

  // Add success feedback method
  showSuccessFeedback(message) {
    // Create temporary success message
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
      backdrop-filter: blur(10px);
    `

    document.body.appendChild(feedback)

    // Remove after animation
    setTimeout(() => {
      feedback.style.animation = 'slideOutRight 0.3s ease-in forwards'
      setTimeout(() => feedback.remove(), 300)
    }, 2000)
  }

  // Update internal workout data from current badge state (FIXED!)
  updateWorkoutData() {
    // Rebuild benchmarkData by reading current badge states from DOM
    const newBenchmarkData = {}

    // Get all exercise blocks
    const exerciseBlocks = this.exerciseListTarget.querySelectorAll('.exercise-block')

    exerciseBlocks.forEach((block, exerciseIndex) => {
      // Get exercise name from header
      const exerciseHeader = block.querySelector('.exercise-header span')
      if (!exerciseHeader) return

      const exerciseName = exerciseHeader.textContent.replace('🏋️ ', '').trim()
      newBenchmarkData[exerciseName] = []

      // Get all set lines for this exercise (exclude add set button line)
      const setLines = block.querySelectorAll('.set-line[data-set-index]')

      setLines.forEach((setLine) => {
        // Get all badges in this set
        const badges = setLine.querySelectorAll('[data-controller="badge-editor"]')
        const badgeTexts = []

        badges.forEach(badge => {
          const content = badge.getAttribute('data-badge-editor-content-value')
          if (content) {
            badgeTexts.push(content)
          }
        })

        // Reconstruct set description from badges
        if (badgeTexts.length > 0) {
          const setDescription = badgeTexts.join(', ')
          newBenchmarkData[exerciseName].push(setDescription)
        }
      })
    })

    // Update our internal state
    this.benchmarkData = newBenchmarkData
    this.updateHiddenField()

    console.log("Rebuilt workout data from current badge state:", this.benchmarkData)
  }

  // Update hidden field for form submission
  updateHiddenField() {
    this.hiddenDetailsTarget.value = JSON.stringify(this.benchmarkData)

    // Enable/disable submit button
    const hasContent = Object.keys(this.benchmarkData).length > 0
    this.submitButtonTarget.disabled = !hasContent

    console.log("Updated workout data:", this.benchmarkData)
  }
}
