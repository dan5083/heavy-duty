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

  // Render a single badge
  renderBadge(badge, exerciseIndex, setIndex, badgeIndex) {
    console.log(`Rendering badge: ${badge.type} - ${badge.content}`) // Debug log

    return `
      <span class="workout-badge badge-${badge.type}"
            data-controller="badge-editor"
            data-badge-editor-target="badge"
            data-badge-editor-type-value="${badge.type}"
            data-badge-editor-content-value="${badge.content}"
            data-badge-editor-exercise-id-value="${exerciseIndex}"
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

  // Parse set description into badge objects (simplified JS version)
  parseSetIntoBadges(setDescription) {
    const badges = []
    const text = setDescription.toLowerCase()

    // Extract status badges (Working set, Drop set, etc.)
    if (text.includes('working set') || text.includes('working')) {
      badges.push({ type: 'status', content: 'Working set' })
    } else if (text.includes('warmup') || text.includes('warm up')) {
      badges.push({ type: 'status', content: 'Warmup set' })
    } else if (text.includes('drop set') || text.includes('drop')) {
      badges.push({ type: 'status', content: 'Drop set' })
    } else if (text.includes('super set') || text.includes('super')) {
      badges.push({ type: 'status', content: 'Super set' })
    } else if (text.includes('heavy set') || text.includes('heavy set')) {
      badges.push({ type: 'status', content: 'Heavy set' })
    } else if (text.includes('light set') || text.includes('light set')) {
      badges.push({ type: 'status', content: 'Light set' })
    }

    // Extract reps badges
    const repsMatch = text.match(/(\d+)\s*reps?/)
    if (repsMatch) {
      badges.push({ type: 'reps', content: `${repsMatch[1]} reps` })
    } else if (text.includes('to failure') || text.includes('failure')) {
      badges.push({ type: 'reps', content: 'to failure' })
    } else if (text.includes('amrap')) {
      badges.push({ type: 'reps', content: 'AMRAP' })
    }

    // Extract weight badges
    const weightMatch = text.match(/(?:at|with)\s*(\d+(?:\.\d+)?)\s*(kilos?|kgs?|lbs?|pounds?)/)
    if (weightMatch) {
      const unit = weightMatch[2].includes('lb') || weightMatch[2].includes('pound') ? 'lbs' : 'kilos'
      badges.push({ type: 'weight', content: `at ${weightMatch[1]} ${unit}` })
    } else if (text.includes('bodyweight') || text.includes('body weight')) {
      badges.push({ type: 'weight', content: 'with bodyweight' })
    } else if (text.match(/(\d+)%\s*1rm/)) {
      const percentMatch = text.match(/(\d+)%\s*1rm/)
      badges.push({ type: 'weight', content: `at ${percentMatch[1]}% 1RM` })
    }

    // Extract reflection badges - IMPROVED DETECTION
    if (text.includes('felt heavy') || text.includes('heavy')) {
      badges.push({ type: 'reflection', content: 'felt heavy' })
    } else if (text.includes('felt light') || text.includes('light')) {
      badges.push({ type: 'reflection', content: 'felt light' })
    } else if (text.includes('kept it smooth') || text.includes('smooth')) {
      badges.push({ type: 'reflection', content: 'kept it smooth' })
    } else if (text.includes('perfect form') || text.includes('perfect')) {
      badges.push({ type: 'reflection', content: 'perfect form' })
    } else if (text.includes('good form') || text.includes('clean form')) {
      badges.push({ type: 'reflection', content: 'good form' })
    } else if (text.includes('form broke down') || text.includes('sloppy')) {
      badges.push({ type: 'reflection', content: 'form broke down' })
    } else if (text.includes('could go heavier') || text.includes('too easy')) {
      badges.push({ type: 'reflection', content: 'could go heavier' })
    } else if (text.includes('solid effort') || text.includes('solid')) {
      badges.push({ type: 'reflection', content: 'solid effort' })
    } else if (text.includes('great pump') || text.includes('pump')) {
      badges.push({ type: 'reflection', content: 'great pump' })
    } else if (text.includes('felt good') || text.includes('felt great') || text.includes('good')) {
      // FIX 2: Add this common reflection pattern that was missing
      badges.push({ type: 'reflection', content: 'felt good' })
    }

    // If no badges found, try to intelligently categorize the whole text
    if (badges.length === 0) {
      // Check if it's mostly numbers (likely reps/weight)
      if (text.match(/\d+/)) {
        badges.push({ type: 'reps', content: setDescription.trim() })
      } else {
        // Default to reflection
        badges.push({ type: 'reflection', content: setDescription.trim() })
      }
    }

    // Ensure we have at least a status if none was detected
    if (!badges.find(b => b.type === 'status')) {
      badges.unshift({ type: 'status', content: 'Working set' })
    }

    // FIX 2: Ensure we always have a reflection badge if none was found
    if (!badges.find(b => b.type === 'reflection')) {
      badges.push({ type: 'reflection', content: 'felt good' })
    }

    return badges
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

  // Add selected exercise with sample sets - FIX 1: Only one set
  selectExercise(exerciseName) {
    console.log(`Adding exercise: ${exerciseName}`)

    // Add to benchmark data
    if (!this.benchmarkData[exerciseName]) {
      // FIX 1: Only add ONE set instead of two
      // FIX 2: Ensure the reflection badge is included by using "felt good"
      this.benchmarkData[exerciseName] = [
        "Working set was 10 reps at 70 kilos, felt good"
      ]
    }

    // Re-render the interface
    this.hideEmptyState()
    this.renderWorkoutBadges()
    this.updateHiddenField()
  }

  // Add a new set to an exercise
  addSet(event) {
    const exerciseId = event.target.dataset.exerciseId
    console.log(`Adding set to exercise ${exerciseId}`)

    // First update our data from current badge state
    this.updateWorkoutData()

    // Find exercise in benchmark data and add a sample set
    const exercises = Object.keys(this.benchmarkData)
    const exerciseName = exercises[exerciseId]

    if (exerciseName) {
      this.benchmarkData[exerciseName].push("Working set was 10 reps at 70 kilos, solid effort")
      this.renderWorkoutBadges()
      this.updateHiddenField()
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

  // Handle form submission - ensure we capture current badge state
  handleFormSubmit(event) {
    console.log("Form submitting - capturing current badge state...")
    this.updateWorkoutData()
  }

  // Handle badge changes from badge-editor (FIXED - no re-rendering!)
  handleBadgeChange(event) {
    console.log('Badge changed:', event.detail)
    // Update data but DON'T re-render to preserve other badge states
    this.updateWorkoutData()
  }

  // Add new badge
  handleAddBadge(event) {
    console.log('Add badge:', event.detail)
    // For now, just log - could show badge type selector
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
