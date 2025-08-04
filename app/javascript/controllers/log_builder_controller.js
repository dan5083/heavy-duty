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
    "hiddenVariation",
    "exerciseInput",
    "autocompleteDropdown",
    "fallbackButtons"
  ]

  connect() {
    console.log("🏷️ Badge-based workout editor connected!")

    // Get benchmark data from ExerciseSet structure
    this.benchmarkData = window.benchmarkData || {}
    this.benchmarkContext = window.benchmarkContext || null

    // 🆕 NEW: Use all exercises and cardio context instead of separate lists
    this.allExercises = window.allExercises || []
    this.isCardioWorkout = window.isCardioWorkout || false

    console.log("Benchmark data:", this.benchmarkData)
    console.log("Benchmark context:", this.benchmarkContext)
    console.log("All exercises:", this.allExercises)
    console.log("Is cardio workout:", this.isCardioWorkout)

    this.initializeBadgeInterface()
    this.element.addEventListener('badge-editor:badge-changed', this.handleBadgeChange.bind(this))
    this.element.addEventListener('badge-editor:add-badge', this.handleAddBadge.bind(this))

    // 🆕 NEW: Initialize autocomplete functionality
    this.initializeAutocomplete()

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

  // 🆕 NEW: Initialize autocomplete functionality
  initializeAutocomplete() {
    if (this.hasExerciseInputTarget) {
      // Track autocomplete state
      this.autocompleteVisible = false
      this.selectedIndex = -1
      this.filteredExercises = []

      // Add click outside listener to close autocomplete
      document.addEventListener('click', (e) => {
        if (!this.element.contains(e.target)) {
          this.hideAutocomplete()
        }
      })
    }
  }

  // 🆕 NEW: Handle exercise input for autocomplete
  handleExerciseInput(event) {
    const query = event.target.value.trim()

    if (query.length === 0) {
      this.hideAutocomplete()
      return
    }

    // Show dropdown after first character
    if (query.length >= 1) {
      this.filterAndShowExercises(query)
    }
  }

  // 🆕 NEW: Handle keyboard navigation in autocomplete
  handleExerciseKeydown(event) {
    if (!this.autocompleteVisible) {
      // If autocomplete not visible, handle Enter to add exercise directly
      if (event.key === 'Enter') {
        event.preventDefault()
        const exerciseName = this.exerciseInputTarget.value.trim()
        if (exerciseName) {
          this.selectExercise(exerciseName)
        }
      }
      return
    }

    // Handle keyboard navigation when autocomplete is visible
    switch(event.key) {
      case 'ArrowDown':
        event.preventDefault()
        this.selectedIndex = Math.min(this.selectedIndex + 1, this.filteredExercises.length - 1)
        this.updateAutocompleteSelection()
        break

      case 'ArrowUp':
        event.preventDefault()
        this.selectedIndex = Math.max(this.selectedIndex - 1, -1)
        this.updateAutocompleteSelection()
        break

      case 'Enter':
        event.preventDefault()
        if (this.selectedIndex >= 0 && this.selectedIndex < this.filteredExercises.length) {
          this.selectExercise(this.filteredExercises[this.selectedIndex])
        } else {
          // No selection, use typed text
          const exerciseName = this.exerciseInputTarget.value.trim()
          if (exerciseName) {
            this.selectExercise(exerciseName)
          }
        }
        break

      case 'Escape':
        event.preventDefault()
        this.hideAutocomplete()
        break
    }
  }

  // 🆕 NEW: Filter exercises and show autocomplete dropdown
  filterAndShowExercises(query) {
    const lowerQuery = query.toLowerCase()

    // Filter exercises that contain the query
    this.filteredExercises = this.allExercises.filter(exercise =>
      exercise.toLowerCase().includes(lowerQuery)
    ).slice(0, 10) // Limit to 10 results

    if (this.filteredExercises.length === 0) {
      this.hideAutocomplete()
      return
    }

    // Build dropdown HTML
    const dropdownHtml = this.filteredExercises.map((exercise, index) => `
      <div class="autocomplete-item ${index === this.selectedIndex ? 'selected' : ''}"
           data-exercise="${exercise}"
           data-index="${index}">
        ${this.highlightMatch(exercise, query)}
      </div>
    `).join('')

    this.autocompleteDropdownTarget.innerHTML = dropdownHtml
    this.showAutocomplete()

    // Add click listeners to dropdown items
    this.autocompleteDropdownTarget.querySelectorAll('.autocomplete-item').forEach(item => {
      item.addEventListener('click', (e) => {
        const exerciseName = e.target.closest('.autocomplete-item').dataset.exercise
        this.selectExercise(exerciseName)
      })
    })
  }

  // 🆕 NEW: Highlight matching text in exercise names
  highlightMatch(exerciseName, query) {
    const regex = new RegExp(`(${query})`, 'gi')
    return exerciseName.replace(regex, '<strong>$1</strong>')
  }

  // 🆕 NEW: Show autocomplete dropdown
  showAutocomplete() {
    this.autocompleteDropdownTarget.style.display = 'block'
    this.autocompleteVisible = true
    this.selectedIndex = -1
  }

  // 🆕 NEW: Hide autocomplete dropdown
  hideAutocomplete() {
    if (this.hasAutocompleteDropdownTarget) {
      this.autocompleteDropdownTarget.style.display = 'none'
      this.autocompleteVisible = false
      this.selectedIndex = -1
    }
  }

  // 🆕 NEW: Update visual selection in autocomplete
  updateAutocompleteSelection() {
    this.autocompleteDropdownTarget.querySelectorAll('.autocomplete-item').forEach((item, index) => {
      if (index === this.selectedIndex) {
        item.classList.add('selected')
      } else {
        item.classList.remove('selected')
      }
    })
  }

  // 🆕 NEW: Focus exercise input (called from fallback button)
  focusExerciseInput() {
    if (this.hasExerciseInputTarget) {
      this.exerciseInputTarget.focus()

      // 🆕 FIXED: If there's text in the input, try to add it as an exercise
      const exerciseName = this.exerciseInputTarget.value.trim()
      if (exerciseName) {
        this.selectExercise(exerciseName)
      }
    }
  }

  // 🆕 NEW: Select exercise from autocomplete or direct input
  selectExercise(exerciseName) {
    console.log(`Adding exercise: ${exerciseName}`)

    this.updateWorkoutData()

    if (!this.benchmarkData[exerciseName]) {
      if (this.isCardioWorkout) {
        // Default cardio set - time, distance, weight (resistance), energy
        this.benchmarkData[exerciseName] = [{
          set_number: 1,
          set_type: 'working',
          duration_seconds: 1800, // 30 minutes
          distance_value: 100, // 100 meters
          weight_kg: 1, // 1kg resistance
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
          notes: 'solid effort'
        }]
      }
    }

    this.hideEmptyState()
    this.renderWorkoutBadges()
    this.updateHiddenField()

    // Clear the input and hide autocomplete
    this.exerciseInputTarget.value = ''
    this.hideAutocomplete()

    // 🆕 NEW: Dispatch exercise addition event
    this.dispatchWorkoutStateUpdate('exercise-added', {
      exerciseName: exerciseName,
      isCardio: this.isCardioWorkout
    })

    setTimeout(() => {
      const exerciseBlocks = this.exerciseListTarget.querySelectorAll('.exercise-block')
      const newExercise = exerciseBlocks[exerciseBlocks.length - 1]
      if (newExercise) {
        newExercise.style.animation = 'badge-spawn 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275)'
        newExercise.scrollIntoView({ behavior: 'smooth', block: 'nearest' })
      }
    }, 50)
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

    // Show the input field and fallback buttons
    if (this.hasFallbackButtonsTarget) {
      this.fallbackButtonsTarget.style.display = 'flex'
    }
  }

  hideEmptyState() {
    // 🆕 FIXED: Don't hide the entire empty state, just hide fallback buttons
    // Keep the autocomplete input visible so users can add more exercises
    if (this.hasFallbackButtonsTarget) {
      this.fallbackButtonsTarget.style.display = 'none'
    }

    // Don't hide the entire emptyStateTarget - keep the autocomplete input visible
    // this.emptyStateTarget.style.display = 'none'  // REMOVED
  }

  renderWorkoutBadges() {
    let html = ''

    Object.entries(this.benchmarkData).forEach(([exerciseName, sets], exerciseIndex) => {
      html += this.renderExerciseBlock(exerciseName, sets, exerciseIndex)
    })

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

  // 🆕 UPDATED: Convert ExerciseSet data to badge format - Uses cardio workout context
  exerciseSetToBadges(setData, exerciseName) {
    if (this.isCardioWorkout) {
      // Cardio badges - time, distance, weight (as resistance), energy
      return [
        { type: 'time', content: setData.duration_seconds ? `${Math.round(setData.duration_seconds / 60)} minutes` : '30 minutes' },
        { type: 'distance', content: setData.distance_value ? `${setData.distance_value} m` : '100 m' },
        { type: 'weight', content: setData.weight_kg ? `${setData.weight_kg} kg` : 'no resistance' },
        { type: 'energy', content: setData.energy_calories ? `${setData.energy_calories} calories` : '100 calories' }
      ]
    } else {
      // Strength badges
      return [
        { type: 'status', content: `${setData.set_type || 'Working'} set` },
        { type: 'reps', content: setData.reps ? `${setData.reps} reps` : 'to failure' },
        { type: 'weight', content: setData.weight_kg ? `${setData.weight_kg} kg` : 'bodyweight' },
        { type: 'reflection', content: setData.notes || 'solid effort' }
      ]
    }
  }

  // 🆕 UPDATED: Convert badges back to ExerciseSet format - Uses cardio workout context
  badgesToExerciseSet(badges, exerciseName, setNumber) {
    const statusBadge = badges.find(b => b.type === 'status')
    const reflectionBadge = badges.find(b => b.type === 'reflection')

    let exerciseSetData = {
      exercise_name: exerciseName,
      set_number: setNumber,
      set_type: this.extractSetType(statusBadge?.content) || 'working',
      notes: reflectionBadge?.content || 'solid effort'
    }

    if (this.isCardioWorkout) {
      // Cardio fields - time, distance, weight (resistance), energy
      const timeBadge = badges.find(b => b.type === 'time')
      const distanceBadge = badges.find(b => b.type === 'distance')
      const weightBadge = badges.find(b => b.type === 'weight')
      const energyBadge = badges.find(b => b.type === 'energy')

      exerciseSetData.duration_seconds = this.extractDuration(timeBadge?.content)
      exerciseSetData.distance_value = this.extractDistance(distanceBadge?.content)
      exerciseSetData.weight_kg = this.extractWeight(weightBadge?.content)?.weight
      exerciseSetData.energy_calories = this.extractCalories(energyBadge?.content)
    } else {
      // Strength fields
      const repsBadge = badges.find(b => b.type === 'reps')
      const weightBadge = badges.find(b => b.type === 'weight')

      exerciseSetData.reps = this.extractReps(repsBadge?.content)
      const weightData = this.extractWeight(weightBadge?.content)
      exerciseSetData.weight_kg = weightData?.weight
    }

    return exerciseSetData
  }

  // 🆕 NEW: Extract duration from time badge (converts minutes to seconds)
  extractDuration(timeContent) {
    if (!timeContent || timeContent === 'Unknown') return null

    // Extract from "30 minutes", "1 minute"
    const match = timeContent.match(/(\d+)\s*minute/)
    if (match) {
      return parseInt(match[1]) * 60 // Convert to seconds
    }
    return null
  }

  // 🆕 NEW: Extract distance from distance badge - METERS ONLY
  extractDistance(distanceContent) {
    if (!distanceContent || distanceContent === 'Unknown') return null

    // Extract from "100 m", "50 m" etc.
    const match = distanceContent.match(/(\d+)\s*m/)
    if (match) {
      return parseInt(match[1])
    }
    return null
  }

  // 🆕 NEW: Extract calories from energy badge
  extractCalories(energyContent) {
    if (!energyContent || energyContent === 'Unknown') return null

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

  // UPDATED: Remove lbs handling - KG ONLY
  extractWeight(weightContent) {
    if (!weightContent || weightContent === 'Unknown' || weightContent.toLowerCase().includes('bodyweight') || weightContent.toLowerCase().includes('no resistance')) {
      return { weight: null }
    }

    // Extract from "75 kg" or just "75"
    const match = weightContent.match(/(\d+(?:\.\d+)?)\s*kg?/i)
    if (match) {
      const weight = parseFloat(match[1])
      return { weight: weight }
    }
    return { weight: null }
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

      if (this.isCardioWorkout) {
        // Default cardio set - time, distance, weight (resistance), energy
        this.benchmarkData[exerciseName].push({
          set_number: newSetNumber,
          set_type: 'working',
          duration_seconds: 1800, // 30 minutes
          distance_value: 100, // 100 meters
          weight_kg: 1, // 1kg resistance
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

          if (this.isCardioWorkout) {
            // Cardio fields - time, distance, weight (resistance), energy
            exerciseSetData.duration_seconds = setData.duration_seconds
            exerciseSetData.distance_value = setData.distance_value
            exerciseSetData.weight_kg = setData.weight_kg
            exerciseSetData.energy_calories = setData.energy_calories
          } else {
            // Strength fields
            exerciseSetData.reps = setData.reps
            exerciseSetData.weight_kg = setData.weight_kg
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
}
