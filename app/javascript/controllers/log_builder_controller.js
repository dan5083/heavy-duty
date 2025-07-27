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
    "benchmarkChoice",
    "contextSection",
    "contextToggleButton",
    "contextBody",
    "contextTextarea",
    "contextSubmitButton",
    "hiddenContext",
    "customTimingSection",
    "customDate",
    "customTime",
    "hiddenDatetime",
    "hiddenVariation"
  ]

  connect() {
    console.log("🏷️ Badge-based workout editor connected!")

    // Get benchmark data from ExerciseSet structure
    this.benchmarkData = window.benchmarkData || {}
    this.benchmarkContext = window.benchmarkContext || null
    this.availableExercises = window.availableExercises || []
    this.cardioExercises = window.cardioExercises || []

    console.log("Benchmark data:", this.benchmarkData)
    console.log("Benchmark context:", this.benchmarkContext)
    console.log("Available exercises:", this.availableExercises)
    console.log("Cardio exercises:", this.cardioExercises)

    this.initializeBadgeInterface()
    this.element.addEventListener('badge-editor:badge-changed', this.handleBadgeChange.bind(this))
    this.element.addEventListener('badge-editor:add-badge', this.handleAddBadge.bind(this))

    // 🆕 NEW: Initialize context functionality
    this.initializeContextSection()

    // 🆕 NEW: Initialize timing functionality
    this.initializeTimingSection()

    this.updateHiddenField()

    // 🆕 NEW: Dispatch initial workout state for current-exercise-set controller
    this.dispatchWorkoutStateUpdate('workout-initialized')

    // 🆕 NEW: Listen for variation controller events
    this.element.addEventListener('benchmark-variations:variation-changed', this.handleVariationChange.bind(this))
    this.element.addEventListener('benchmark-variations:submit-with-variation', this.handleVariationSubmission.bind(this))
  }

  // 🆕 NEW: Dispatch events for current-exercise-set controller
  dispatchWorkoutStateUpdate(action, details = {}) {
    const eventDetail = {
      action: action,
      totalExercises: this.getTotalExerciseCount(),
      totalSets: this.getTotalSetCount(),
      exerciseData: this.getExerciseStructure(),
      ...details
    }

    console.log(`🔄 Dispatching ${action}:`, eventDetail)

    // Dispatch to current-exercise-set controller
    this.element.dispatchEvent(new CustomEvent('log-builder:workout-updated', {
      detail: eventDetail,
      bubbles: true
    }))
  }

  // 🆕 NEW: Get total exercise count
  getTotalExerciseCount() {
    return this.exerciseListTarget.querySelectorAll('.exercise-block[data-exercise-id]').length
  }

  // 🆕 NEW: Get total set count across all exercises
  getTotalSetCount() {
    let totalSets = 0
    const exerciseBlocks = this.exerciseListTarget.querySelectorAll('.exercise-block[data-exercise-id]')

    exerciseBlocks.forEach(block => {
      const setLines = block.querySelectorAll('.set-line[data-set-index]')
      totalSets += setLines.length
    })

    return totalSets
  }

  // 🆕 NEW: Get structured exercise data for current-exercise-set controller
  getExerciseStructure() {
    const structure = []
    const exerciseBlocks = this.exerciseListTarget.querySelectorAll('.exercise-block[data-exercise-id]')

    exerciseBlocks.forEach((block, exerciseIndex) => {
      const exerciseName = block.dataset.exerciseName || `Exercise ${exerciseIndex + 1}`
      const setLines = block.querySelectorAll('.set-line[data-set-index]')

      structure.push({
        exerciseIndex: exerciseIndex,
        exerciseName: exerciseName,
        setCount: setLines.length,
        element: block
      })
    })

    return structure
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

  // 🆕 NEW: Initialize context section functionality
  initializeContextSection() {
    if (this.hasContextTextareaTarget) {
      // Add input event listener for character counting and real-time updates
      this.contextTextareaTarget.addEventListener('input', () => {
        this.updateContextData()
      })

      // 🆕 NEW: Load benchmark context if available
      if (this.benchmarkContext) {
        console.log("Loading benchmark context:", this.benchmarkContext)
        this.contextTextareaTarget.value = this.benchmarkContext

        // Show as badge instead of open textarea
        this.showContextBadge(this.benchmarkContext)

        // Update hidden field with loaded context
        this.updateContextData()
      }
    }
  }

  // 🆕 NEW: Initialize timing section functionality
  initializeTimingSection() {
    if (this.hasCustomDateTarget) {
      this.customDateTarget.addEventListener('change', this.updateCustomDatetime.bind(this))
    }
    if (this.hasCustomTimeTarget) {
      this.customTimeTarget.addEventListener('change', this.updateCustomDatetime.bind(this))
    }
  }

  // 🆕 NEW: Toggle timing section visibility
  toggleTimingSection(event) {
    const isCurrentTime = event.target.checked

    if (isCurrentTime) {
      this.customTimingSectionTarget.style.display = 'none'
      this.hiddenDatetimeTarget.value = '' // Empty means use current time
      console.log("Using current time for workout")
    } else {
      this.customTimingSectionTarget.style.display = 'block'
      this.updateCustomDatetime()
      console.log("Using custom time for workout")
    }
  }

  // 🆕 NEW: Set time ago using quick buttons
  setTimeAgo(event) {
    event.preventDefault()
    const hours = parseInt(event.target.dataset.hours)
    const targetTime = new Date(Date.now() - (hours * 60 * 60 * 1000))

    // Update the date and time fields
    this.customDateTarget.value = targetTime.toISOString().split('T')[0]
    this.customTimeTarget.value = targetTime.toTimeString().slice(0, 5)

    // Update the hidden field
    this.updateCustomDatetime()

    console.log(`Set workout time to ${hours} hours ago:`, targetTime)
  }

  // 🆕 NEW: Update custom datetime when fields change
  updateCustomDatetime() {
    if (this.hasCustomDateTarget && this.hasCustomTimeTarget) {
      const date = this.customDateTarget.value
      const time = this.customTimeTarget.value

      if (date && time) {
        const datetime = `${date}T${time}`
        this.hiddenDatetimeTarget.value = datetime
        console.log("Updated custom workout datetime:", datetime)
      }
    }
  }

  // 🆕 NEW: Toggle context section visibility
  toggleContextSection(event) {
    event.preventDefault()

    if (this.contextBodyTarget.style.display === 'none') {
      // Show context section
      this.contextBodyTarget.style.display = 'block'
      this.contextToggleButtonTarget.innerHTML = '<i class="bi bi-x me-2"></i>Cancel'
      this.contextToggleButtonTarget.classList.remove('btn-outline-secondary')
      this.contextToggleButtonTarget.classList.add('btn-outline-danger')

      // Focus the textarea
      setTimeout(() => {
        this.contextTextareaTarget.focus()
      }, 100)
    } else {
      // Hide context section
      this.hideContextSection()
    }
  }

  // 🆕 NEW: Submit context (like IG comment)
  submitContext(event) {
    event.preventDefault()

    const contextValue = this.contextTextareaTarget.value.trim()

    if (contextValue) {
      // Save context and transform to badge-like display
      this.updateContextData()
      this.showContextBadge(contextValue)
      this.hideContextInput()
    } else {
      // Just close if empty
      this.hideContextSection()
    }
  }

  // 🆕 NEW: Show context as a badge-like element
  showContextBadge(contextText) {
    const badgeHtml = `
      <div class="context-badge-display" data-log-builder-target="contextBadge">
        <div class="context-badge">
          <i class="bi bi-chat-square-text"></i>
          <span class="context-preview">${contextText}</span>
          <button class="context-edit-btn"
                  data-action="click->log-builder#editContext"
                  title="Edit context">
            <i class="bi bi-pencil"></i>
          </button>
        </div>
      </div>
    `

    // Hide the toggle button and show the badge
    this.contextToggleButtonTarget.style.display = 'none'
    this.contextToggleButtonTarget.insertAdjacentHTML('afterend', badgeHtml)
  }

  // 🆕 NEW: Edit existing context
  editContext(event) {
    event.preventDefault()

    // Remove the badge and show the input again
    const badge = this.element.querySelector('[data-log-builder-target="contextBadge"]')
    if (badge) {
      badge.remove()
    }

    // Show the toggle button and open the context section
    this.contextToggleButtonTarget.style.display = 'inline-block'
    this.contextBodyTarget.style.display = 'block'
    this.contextToggleButtonTarget.innerHTML = '<i class="bi bi-x me-2"></i>Cancel'
    this.contextToggleButtonTarget.classList.remove('btn-outline-secondary')
    this.contextToggleButtonTarget.classList.add('btn-outline-danger')

    // Focus the textarea
    setTimeout(() => {
      this.contextTextareaTarget.focus()
    }, 100)
  }

  // 🆕 NEW: Hide just the input section (keep badge if exists)
  hideContextInput() {
    this.contextBodyTarget.style.display = 'none'
    this.contextToggleButtonTarget.style.display = 'none'
  }

  // 🆕 NEW: Utility to truncate text
  truncateText(text, limit) {
    if (text.length <= limit) return text
    return text.substring(0, limit) + '...'
  }

  // 🆕 NEW: Hide context section helper
  hideContextSection() {
    this.contextBodyTarget.style.display = 'none'
    this.contextToggleButtonTarget.innerHTML = '<i class="bi bi-chat-square-text me-2"></i>Add Context'
    this.contextToggleButtonTarget.classList.remove('btn-outline-danger')
    this.contextToggleButtonTarget.classList.add('btn-outline-secondary')

    // Update the hidden field when hiding
    this.updateContextData()
  }

  // 🆕 NEW: Update context data in hidden field
  updateContextData() {
    if (this.hasHiddenContextTarget && this.hasContextTextareaTarget) {
      const contextValue = this.contextTextareaTarget.value.trim()
      this.hiddenContextTarget.value = contextValue
      console.log("Updated exercise context:", contextValue)
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

    html += this.renderAddExerciseButtons()
    this.exerciseListTarget.innerHTML = html

    // 🆕 NEW: Dispatch exercise structure update
    this.dispatchWorkoutStateUpdate('exercises-rendered')
  }

  renderExerciseBlock(exerciseName, sets, exerciseIndex) {
    const setsHtml = sets.map((setData, setIndex) => {
      return this.renderSetLine(setData, exerciseIndex, setIndex, exerciseName)
    }).join('')

    return `
      <div class="exercise-block" data-exercise-id="${exerciseIndex}" data-exercise-name="${exerciseName}">
        <div class="exercise-header d-flex justify-content-between align-items-center">
          <span>${exerciseName}</span>
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

  renderSetLine(setData, exerciseIndex, setIndex, exerciseName) {
    const badges = this.exerciseSetToBadges(setData, exerciseName)
    const badgesHtml = badges.map((badge, badgeIndex) => {
      return this.renderBadge(badge, exerciseIndex, setIndex, badgeIndex)
    }).join('')

    return `
      <div class="set-line" data-set-index="${setIndex}" data-exercise-id="${exerciseIndex}" data-set-number="${setIndex + 1}">
        <span class="set-number">${setIndex + 1}:</span>
        ${badgesHtml}
        <button class="btn btn-xs btn-outline-danger ms-2"
                data-action="click->log-builder#removeSet"
                data-exercise-id="${exerciseIndex}"
                data-set-index="${setIndex}"
                title="Remove set"
                type="button">
          <i class="bi bi-x"></i>
        </button>
      </div>
    `
  }

  removeSet(event) {
    event.preventDefault()
    event.stopPropagation()

    const setLine = event.target.closest('.set-line[data-set-index]')
    const exerciseBlock = setLine.closest('.exercise-block')
    const exerciseId = exerciseBlock.dataset.exerciseId
    const setIndex = parseInt(setLine.dataset.setIndex)

    if (confirm('Remove this set?')) {
      this.updateWorkoutData()

      const exercises = Object.keys(this.benchmarkData)
      const exerciseName = exercises[exerciseId]

      if (exerciseName && this.benchmarkData[exerciseName]) {
        this.benchmarkData[exerciseName].splice(setIndex, 1)

        this.benchmarkData[exerciseName].forEach((set, index) => {
          set.set_number = index + 1
        })

        if (this.benchmarkData[exerciseName].length === 0) {
          delete this.benchmarkData[exerciseName]
        }
      }

      this.renderWorkoutBadges()
      this.updateHiddenField()

      // 🆕 NEW: Dispatch set removal event
      this.dispatchWorkoutStateUpdate('set-removed', {
        exerciseId: exerciseId,
        setIndex: setIndex,
        exerciseName: exerciseName
      })

      if (Object.keys(this.benchmarkData).length === 0) {
        this.showEmptyState()
      }
    }
  }

  renderBadge(badge, exerciseIndex, setIndex, badgeIndex) {
    return `
      <span class="workout-badge badge-${badge.type}"
            data-controller="badge-editor"
            data-badge-editor-target="badge"
            data-badge-editor-type-value="${badge.type}"
            data-badge-editor-content-value="${badge.content}"
            data-badge-editor-exercise-id-value="${exerciseIndex}"
            data-badge-index="${badgeIndex}"
            data-new-badge="true"
            data-action="click->badge-editor#edit">
        <span class="badge-text">${badge.content}</span>
      </span>
    `
  }

  renderAddExerciseButtons() {
    return `
      <div class="text-center mt-4 mb-4">
        <button class="btn btn-outline-success"
                data-action="click->log-builder#addExercise">
          <i class="bi bi-plus-lg"></i> Add Exercise
        </button>
      </div>
    `
  }

  // 🆕 NEW: Check if an exercise is cardio
  isCardioExercise(exerciseName) {
    return this.cardioExercises.includes(exerciseName)
  }

  // Updated: Convert ExerciseSet data to badge format (now handles cardio)
  exerciseSetToBadges(setData, exerciseName) {
    if (this.isCardioExercise(exerciseName)) {
      // Cardio badges - just time and energy
      return [
        { type: 'time', content: setData.duration_seconds ? `${Math.round(setData.duration_seconds / 60)} minutes` : '30 minutes' },
        { type: 'energy', content: setData.energy_calories ? `${setData.energy_calories} calories` : '100 calories' }
      ]
    } else {
      // Strength badges
      return [
        { type: 'status', content: `${setData.set_type || 'Working'} set` },
        { type: 'reps', content: setData.reps ? `${setData.reps} reps` : 'to failure' },
        { type: 'weight', content: setData.weight_kg ? `at ${setData.weight_kg} ${setData.weight_unit || 'kg'}` : 'bodyweight' },
        { type: 'reflection', content: setData.notes || 'solid effort' }
      ]
    }
  }

  // Updated: Convert badges back to ExerciseSet format (now handles cardio)
  badgesToExerciseSet(badges, exerciseName, setNumber) {
    const statusBadge = badges.find(b => b.type === 'status')
    const reflectionBadge = badges.find(b => b.type === 'reflection')

    let exerciseSetData = {
      exercise_name: exerciseName,
      set_number: setNumber,
      set_type: this.extractSetType(statusBadge?.content) || 'working',
      notes: reflectionBadge?.content || 'solid effort'
    }

    if (this.isCardioExercise(exerciseName)) {
      // Cardio fields - just time and energy
      const timeBadge = badges.find(b => b.type === 'time')
      const energyBadge = badges.find(b => b.type === 'energy')

      exerciseSetData.duration_seconds = this.extractDuration(timeBadge?.content)
      exerciseSetData.energy_calories = this.extractCalories(energyBadge?.content)
    } else {
      // Strength fields
      const repsBadge = badges.find(b => b.type === 'reps')
      const weightBadge = badges.find(b => b.type === 'weight')

      exerciseSetData.reps = this.extractReps(repsBadge?.content)
      const weightData = this.extractWeight(weightBadge?.content)
      exerciseSetData.weight_kg = weightData?.weight
      exerciseSetData.weight_unit = weightData?.unit || 'kg'
    }

    return exerciseSetData
  }

  // 🆕 NEW: Extract duration from time badge (converts minutes to seconds)
  extractDuration(timeContent) {
    if (!timeContent) return null

    // Extract from "30 minutes", "1 minute"
    const match = timeContent.match(/(\d+)\s*minute/)
    if (match) {
      return parseInt(match[1]) * 60 // Convert to seconds
    }
    return null
  }

  // 🆕 NEW: Extract calories from energy badge
  extractCalories(energyContent) {
    if (!energyContent) return null

    // Extract from "100 calories"
    const match = energyContent.match(/(\d+)\s*calorie/)
    if (match) {
      return parseInt(match[1])
    }
    return null
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

  // Add exercise (detects context automatically)
  addExercise(event) {
    event.preventDefault()
    console.log("Adding new exercise...")

    // Auto-detect if this is a cardio workout by checking existing exercises
    const isCardioWorkout = this.isCurrentWorkoutCardio()
    this.showExerciseSelector(event.target, isCardioWorkout)
  }

  // Detect if current workout is cardio-focused
  isCurrentWorkoutCardio() {
    const exerciseBlocks = this.exerciseListTarget.querySelectorAll('.exercise-block')

    // If no exercises yet, check the page URL or muscle group context
    if (exerciseBlocks.length === 0) {
      // Check if we're in a cardio workout (muscle_group=cardio in URL)
      return window.location.href.includes('cardio') ||
             document.querySelector('h2')?.textContent?.toLowerCase().includes('cardio')
    }

    // If exercises exist, check if any are cardio
    for (let block of exerciseBlocks) {
      const exerciseName = block.dataset.exerciseName
      if (exerciseName && this.isCardioExercise(exerciseName)) {
        return true
      }
    }

    return false
  }

  showExerciseSelector(triggerElement, isCardio = false) {
    const exercises = isCardio ? this.cardioExercises : this.availableExercises
    const exerciseType = isCardio ? 'cardio' : 'lifting'

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

    const exercisesHtml = exercises.map(exercise => `
      <div class="exercise-option px-3 py-2 cursor-pointer"
           style="cursor: pointer;"
           onmouseover="this.style.backgroundColor='#f8f9fa'"
           onmouseout="this.style.backgroundColor=''"
           data-exercise="${exercise}">
        ${exercise}
      </div>
    `).join('')

    dropdown.innerHTML = `
      <div class="p-3 border-bottom">
        <strong>Choose a ${exerciseType} exercise:</strong>
      </div>
      ${exercisesHtml}
    `

    const rect = triggerElement.getBoundingClientRect()
    dropdown.style.top = `${rect.bottom + window.scrollY}px`
    dropdown.style.left = `${rect.left + window.scrollX}px`

    document.body.appendChild(dropdown)

    dropdown.querySelectorAll('.exercise-option').forEach(option => {
      option.addEventListener('click', (e) => {
        this.selectExercise(e.target.dataset.exercise, isCardio)
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

  selectExercise(exerciseName, isCardio = false) {
    console.log(`Adding ${isCardio ? 'cardio' : 'lifting'} exercise: ${exerciseName}`)

    this.updateWorkoutData()

    if (!this.benchmarkData[exerciseName]) {
      if (isCardio) {
        // Default cardio set - just time and energy
        this.benchmarkData[exerciseName] = [{
          set_number: 1,
          set_type: 'working',
          duration_seconds: 1800, // 30 minutes
          energy_calories: 100,
          notes: 'solid effort'
        }]
      } else {
        // Default lifting set
        this.benchmarkData[exerciseName] = [{
          set_number: 1,
          set_type: 'working',
          reps: 1,
          weight_kg: 1,
          weight_unit: 'kg',
          notes: 'solid effort'
        }]
      }
    }

    this.hideEmptyState()
    this.renderWorkoutBadges()
    this.updateHiddenField()

    // 🆕 NEW: Dispatch exercise addition event
    this.dispatchWorkoutStateUpdate('exercise-added', {
      exerciseName: exerciseName,
      isCardio: isCardio
    })

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
      const isCardio = this.isCardioExercise(exerciseName)

      if (isCardio) {
        // Default cardio set - just time and energy
        this.benchmarkData[exerciseName].push({
          set_number: newSetNumber,
          set_type: 'working',
          duration_seconds: 1800, // 30 minutes
          energy_calories: 100,
          notes: 'solid effort'
        })
      } else {
        // Default lifting set
        this.benchmarkData[exerciseName].push({
          set_number: newSetNumber,
          set_type: 'working',
          reps: 1,
          weight_kg: 1,
          weight_unit: 'kg',
          notes: 'solid effort'
        })
      }

      this.renderWorkoutBadges()
      this.updateHiddenField()

      // 🆕 NEW: Dispatch set addition event
      this.dispatchWorkoutStateUpdate('set-added', {
        exerciseId: exerciseId,
        exerciseName: exerciseName,
        setNumber: newSetNumber
      })

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

      // 🆕 NEW: Dispatch exercise removal event
      this.dispatchWorkoutStateUpdate('exercise-removed', {
        exerciseId: exerciseId,
        exerciseName: exerciseName
      })

      if (Object.keys(this.benchmarkData).length === 0) {
        this.showEmptyState()
      }
    }
  }

  showBenchmarkModal(event) {
    event.preventDefault()
    console.log("Showing benchmark choice modal...")

    this.updateWorkoutData()
    // 🆕 NEW: Also update context data before showing modal
    this.updateContextData()

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
    event.preventDefault()

    const button = event.target.closest('button')
    const choice = button ? button.dataset.choice : event.target.dataset.choice

    console.log(`User chose: ${choice}`)

    const benchmarkField = document.querySelector('[data-log-builder-target="benchmarkChoice"]')

    if (benchmarkField) {
      // 🆕 UPDATED: Handle all choice types including just_save
      benchmarkField.value = choice
      console.log(`Hidden field set to: ${benchmarkField.value}`)
    } else {
      console.error('Could not find benchmark choice field')
    }

    // 🆕 NEW: Handle just_save workflow - clear exercise data
    if (choice === 'just_save') {
      this.hiddenDetailsTarget.value = '[]'
      console.log("Cleared exercise data for just_save workflow")
    }

    this.closeBenchmarkModal()
    this.submitFormWithChoice()
  }

  closeBenchmarkModal() {
    this.benchmarkModalTarget.style.display = 'none'
    document.body.style.overflow = ''
  }

  submitFormWithChoice() {
    const benchmarkField = document.querySelector('[data-log-builder-target="benchmarkChoice"]')
    console.log("Submitting form with benchmark choice:", benchmarkField?.value)

    // 🆕 NEW: Ensure context and timing are updated before submission
    this.updateContextData()

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

    // 🆕 NEW: Dispatch badge change event for current-exercise-set controller
    this.dispatchWorkoutStateUpdate('badge-changed', {
      badgeType: event.detail.type,
      newValue: event.detail.newValue,
      oldValue: event.detail.oldValue
    })
  }

  handleAddBadge(event) {
    console.log('Add badge:', event.detail)

    // 🆕 NEW: Dispatch badge addition event
    this.dispatchWorkoutStateUpdate('badge-added', {
      badgeType: event.detail.type,
      exerciseId: event.detail.exerciseId,
      setIndex: event.detail.setIndex
    })
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

      const exerciseName = exerciseHeader.textContent.trim()
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

    // 🆕 NEW: Dispatch workout data update
    this.dispatchWorkoutStateUpdate('workout-data-updated')
  }

  updateHiddenField(exerciseSetsArray = null) {
    if (!exerciseSetsArray) {
      exerciseSetsArray = []
      Object.entries(this.benchmarkData).forEach(([exerciseName, sets]) => {
        sets.forEach(setData => {
          let exerciseSetData = {
            exercise_name: exerciseName,
            set_number: setData.set_number || 1,
            set_type: setData.set_type || 'working',
            notes: setData.notes || 'solid effort'
          }

          if (this.isCardioExercise(exerciseName)) {
            // Cardio fields - just time and energy
            exerciseSetData.duration_seconds = setData.duration_seconds
            exerciseSetData.energy_calories = setData.energy_calories
          } else {
            // Strength fields
            exerciseSetData.reps = setData.reps
            exerciseSetData.weight_kg = setData.weight_kg
            exerciseSetData.weight_unit = setData.weight_unit || 'kg'
          }

          exerciseSetsArray.push(exerciseSetData)
        })
      })
    }

    this.hiddenDetailsTarget.value = JSON.stringify(exerciseSetsArray)

    const hasContent = exerciseSetsArray.length > 0
    this.submitButtonTarget.disabled = !hasContent

    console.log("Updated exercise sets data:", exerciseSetsArray)
  }

  // 🆕 NEW: Handle variation change from benchmark-variations controller
  handleVariationChange(event) {
    console.log("🔄 Received variation change:", event.detail.variation)

    // Update benchmark data and context
    this.benchmarkData = event.detail.benchmarkData || {}
    this.benchmarkContext = event.detail.benchmarkContext || null

    // Update context section if context exists
    if (this.benchmarkContext && this.hasContextTextareaTarget) {
      this.contextTextareaTarget.value = this.benchmarkContext
      this.showContextBadge(this.benchmarkContext)
      this.updateContextData()
    } else if (this.hasContextTextareaTarget) {
      // Clear context if no context for this variation
      this.contextTextareaTarget.value = ''
      this.hideContextSection()
      // Remove existing context badge if present
      const existingBadge = this.element.querySelector('[data-log-builder-target="contextBadge"]')
      if (existingBadge) {
        existingBadge.remove()
        this.contextToggleButtonTarget.style.display = 'inline-block'
      }
    }

    // Re-initialize the interface with new data
    this.initializeBadgeInterface()
  }

  // 🆕 NEW: Handle variation submission from benchmark-variations controller
  handleVariationSubmission(event) {
    console.log("📝 Handling variation submission:", event.detail)

    // Close the benchmark modal
    this.closeBenchmarkModal()

    // Submit the form
    this.submitFormWithChoice()
  }

  // 🆕 NEW: Show variation selector (delegates to variations controller)
  showVariationSelector() {
    const variationEvent = new CustomEvent('log-builder:show-variation-selector', {
      bubbles: true
    })
    this.element.dispatchEvent(variationEvent)
  }
}
