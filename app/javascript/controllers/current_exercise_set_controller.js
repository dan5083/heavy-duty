// app/javascript/controllers/current_exercise_set_controller.js

import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="current-exercise-set"
export default class extends Controller {
  static targets = [
    "progressBar",
    "positionIndicator",
    "exerciseList",
    "exerciseName",
    "setInfo",
    "previousButton",
    "nextButton"
  ]

  static values = {
    currentExerciseIndex: { type: Number, default: 0 },
    currentSetIndex: { type: Number, default: 0 },
    totalExercises: { type: Number, default: 0 },
    totalSets: { type: Number, default: 0 }
  }

  connect() {
    console.log("🎯 Current Exercise Set controller connected!")

    // Initialize the current position tracking
    this.initializeWorkoutState()
    this.updateCurrentPosition()
    this.updateProgressBar()
    this.updatePositionIndicator()

    // Listen for exercise/set changes from log_builder
    this.element.addEventListener('log-builder:exercise-added', this.handleExerciseAdded.bind(this))
    this.element.addEventListener('log-builder:exercise-removed', this.handleExerciseRemoved.bind(this))
    this.element.addEventListener('log-builder:set-added', this.handleSetAdded.bind(this))
    this.element.addEventListener('log-builder:set-removed', this.handleSetRemoved.bind(this))
    this.element.addEventListener('log-builder:workout-updated', this.handleWorkoutUpdated.bind(this))
  }

  disconnect() {
    console.log("🎯 Current Exercise Set controller disconnected")
  }

  // Initialize workout state by scanning existing exercises/sets
  initializeWorkoutState() {
    const exerciseBlocks = this.getAllExerciseBlocks()

    this.totalExercisesValue = exerciseBlocks.length
    this.totalSetsValue = this.getTotalSetsCount()

    // If we have exercises, ensure we start at a valid position
    if (this.totalExercisesValue > 0) {
      // Make sure we're not beyond available exercises
      if (this.currentExerciseIndexValue >= this.totalExercisesValue) {
        this.currentExerciseIndexValue = 0
      }

      // Make sure we're not beyond available sets in current exercise
      const currentSetLines = this.getSetLinesForExercise(this.currentExerciseIndexValue)
      if (this.currentSetIndexValue >= currentSetLines.length) {
        this.currentSetIndexValue = 0
      }
    } else {
      // No exercises, reset to 0
      this.currentExerciseIndexValue = 0
      this.currentSetIndexValue = 0
    }

    console.log(`🎯 Initialized: ${this.totalExercisesValue} exercises, ${this.totalSetsValue} total sets`)
    console.log(`🎯 Current position: Exercise ${this.currentExerciseIndexValue + 1}, Set ${this.currentSetIndexValue + 1}`)
  }

  // Get all exercise blocks in the workout
  getAllExerciseBlocks() {
    if (this.hasExerciseListTarget) {
      return this.exerciseListTarget.querySelectorAll('.exercise-block[data-exercise-id]')
    }
    return this.element.querySelectorAll('.exercise-block[data-exercise-id]')
  }

  // Get all set lines for a specific exercise
  getSetLinesForExercise(exerciseIndex) {
    const exerciseBlocks = this.getAllExerciseBlocks()
    if (exerciseIndex >= 0 && exerciseIndex < exerciseBlocks.length) {
      return exerciseBlocks[exerciseIndex].querySelectorAll('.set-line[data-set-index]')
    }
    return []
  }

  // Get total count of all sets across all exercises
  getTotalSetsCount() {
    let totalSets = 0
    const exerciseBlocks = this.getAllExerciseBlocks()

    exerciseBlocks.forEach(block => {
      const setLines = block.querySelectorAll('.set-line[data-set-index]')
      totalSets += setLines.length
    })

    return totalSets
  }

  // Get current exercise name
  getCurrentExerciseName() {
    const exerciseBlocks = this.getAllExerciseBlocks()
    if (this.currentExerciseIndexValue < exerciseBlocks.length) {
      const exerciseHeader = exerciseBlocks[this.currentExerciseIndexValue].querySelector('.exercise-header span')
      return exerciseHeader ? exerciseHeader.textContent.trim() : `Exercise ${this.currentExerciseIndexValue + 1}`
    }
    return "No Exercise"
  }

  // Update visual indicators for current position
  updateCurrentPosition() {
    this.clearAllHighlights()
    this.highlightCurrentExercise()
    this.highlightCurrentSet()
  }

  // Clear all existing highlights
  clearAllHighlights() {
    const exerciseBlocks = this.getAllExerciseBlocks()

    exerciseBlocks.forEach((block, exerciseIndex) => {
      // Remove all exercise state classes
      block.classList.remove('current-exercise', 'completed-exercise', 'upcoming-exercise')

      // Remove progress attribute
      block.removeAttribute('data-progress')

      // Remove all set state classes
      const setLines = block.querySelectorAll('.set-line[data-set-index]')
      setLines.forEach(setLine => {
        setLine.classList.remove('current-set', 'completed-set', 'upcoming-set')
      })
    })
  }

  // Highlight current exercise and set states
  highlightCurrentExercise() {
    const exerciseBlocks = this.getAllExerciseBlocks()

    exerciseBlocks.forEach((block, exerciseIndex) => {
      const setLines = block.querySelectorAll('.set-line[data-set-index]')

      if (exerciseIndex < this.currentExerciseIndexValue) {
        // Completed exercise
        block.classList.add('completed-exercise')
        setLines.forEach(setLine => setLine.classList.add('completed-set'))

      } else if (exerciseIndex === this.currentExerciseIndexValue) {
        // Current exercise
        block.classList.add('current-exercise')

        // Add progress indicator (current set number / total sets in this exercise)
        const currentSetNumber = this.currentSetIndexValue + 1
        const totalSetsInExercise = setLines.length
        const progress = totalSetsInExercise > 0 ? `${currentSetNumber}/${totalSetsInExercise}` : '0/0'
        block.setAttribute('data-progress', progress)

        // Set states within current exercise
        setLines.forEach((setLine, setIndex) => {
          if (setIndex < this.currentSetIndexValue) {
            setLine.classList.add('completed-set')
          } else if (setIndex === this.currentSetIndexValue) {
            setLine.classList.add('current-set')
          } else {
            setLine.classList.add('upcoming-set')
          }
        })

      } else {
        // Upcoming exercise
        block.classList.add('upcoming-exercise')
        setLines.forEach(setLine => setLine.classList.add('upcoming-set'))
      }
    })
  }

  // Highlight current set specifically
  highlightCurrentSet() {
    const currentSetLines = this.getSetLinesForExercise(this.currentExerciseIndexValue)

    if (this.currentSetIndexValue < currentSetLines.length) {
      const currentSetLine = currentSetLines[this.currentSetIndexValue]
      currentSetLine.classList.add('current-set')
    }
  }

  // Update progress bar
  updateProgressBar() {
    if (!this.hasProgressBarTarget) return

    let completedSets = 0

    // Count all completed sets (all sets in completed exercises + completed sets in current exercise)
    const exerciseBlocks = this.getAllExerciseBlocks()

    exerciseBlocks.forEach((block, exerciseIndex) => {
      const setLines = block.querySelectorAll('.set-line[data-set-index]')

      if (exerciseIndex < this.currentExerciseIndexValue) {
        // All sets in completed exercises
        completedSets += setLines.length
      } else if (exerciseIndex === this.currentExerciseIndexValue) {
        // Completed sets in current exercise
        completedSets += this.currentSetIndexValue
      }
      // Don't count upcoming exercises
    })

    const progressPercentage = this.totalSetsValue > 0 ? (completedSets / this.totalSetsValue) * 100 : 0

    this.progressBarTarget.style.setProperty('--progress-width', `${progressPercentage}%`)

    console.log(`🎯 Progress: ${completedSets}/${this.totalSetsValue} sets (${progressPercentage.toFixed(1)}%)`)
  }

  // Update position indicator
  updatePositionIndicator() {
    if (this.hasExerciseNameTarget) {
      this.exerciseNameTarget.textContent = this.getCurrentExerciseName()
    }

    if (this.hasSetInfoTarget) {
      const currentSetLines = this.getSetLinesForExercise(this.currentExerciseIndexValue)
      const setNumber = this.currentSetIndexValue + 1
      const totalSetsInExercise = currentSetLines.length

      this.setInfoTarget.textContent = `Set ${setNumber}/${totalSetsInExercise}`
    }

    // Update navigation button states
    this.updateNavigationButtons()
  }

  // Update navigation button states
  updateNavigationButtons() {
    if (this.hasPreviousButtonTarget && this.hasNextButtonTarget) {
      const isFirstSet = this.currentExerciseIndexValue === 0 && this.currentSetIndexValue === 0
      const currentSetLines = this.getSetLinesForExercise(this.currentExerciseIndexValue)
      const isLastExercise = this.currentExerciseIndexValue === this.totalExercisesValue - 1
      const isLastSet = this.currentSetIndexValue === currentSetLines.length - 1
      const isLastSetOfWorkout = isLastExercise && isLastSet

      // Disable previous button if at first set
      this.previousButtonTarget.disabled = isFirstSet
      if (isFirstSet) {
        this.previousButtonTarget.classList.add('disabled')
      } else {
        this.previousButtonTarget.classList.remove('disabled')
      }

      // Disable next button if at last set of last exercise
      this.nextButtonTarget.disabled = isLastSetOfWorkout
      if (isLastSetOfWorkout) {
        this.nextButtonTarget.classList.add('disabled')
      } else {
        this.nextButtonTarget.classList.remove('disabled')
      }
    }
  }

  // Navigation methods
  nextSet() {
    const currentSetLines = this.getSetLinesForExercise(this.currentExerciseIndexValue)

    if (this.currentSetIndexValue < currentSetLines.length - 1) {
      // Move to next set in current exercise
      this.currentSetIndexValue++
    } else {
      // Move to first set of next exercise
      this.nextExercise()
    }

    this.updateCurrentPosition()
    this.updateProgressBar()
    this.updatePositionIndicator()

    console.log(`🎯 Advanced to Exercise ${this.currentExerciseIndexValue + 1}, Set ${this.currentSetIndexValue + 1}`)
  }

  previousSet() {
    if (this.currentSetIndexValue > 0) {
      // Move to previous set in current exercise
      this.currentSetIndexValue--
    } else if (this.currentExerciseIndexValue > 0) {
      // Move to last set of previous exercise
      this.previousExercise()
      const prevSetLines = this.getSetLinesForExercise(this.currentExerciseIndexValue)
      this.currentSetIndexValue = Math.max(0, prevSetLines.length - 1)
    }

    this.updateCurrentPosition()
    this.updateProgressBar()
    this.updatePositionIndicator()

    console.log(`🎯 Moved back to Exercise ${this.currentExerciseIndexValue + 1}, Set ${this.currentSetIndexValue + 1}`)
  }

  nextExercise() {
    if (this.currentExerciseIndexValue < this.totalExercisesValue - 1) {
      this.currentExerciseIndexValue++
      this.currentSetIndexValue = 0 // Reset to first set of new exercise
    }
  }

  previousExercise() {
    if (this.currentExerciseIndexValue > 0) {
      this.currentExerciseIndexValue--
      this.currentSetIndexValue = 0 // Reset to first set
    }
  }

  // Jump to specific exercise/set
  jumpToExercise(exerciseIndex) {
    if (exerciseIndex >= 0 && exerciseIndex < this.totalExercisesValue) {
      this.currentExerciseIndexValue = exerciseIndex
      this.currentSetIndexValue = 0

      this.updateCurrentPosition()
      this.updateProgressBar()
      this.updatePositionIndicator()

      console.log(`🎯 Jumped to Exercise ${exerciseIndex + 1}`)
    }
  }

  jumpToSet(exerciseIndex, setIndex) {
    const setLines = this.getSetLinesForExercise(exerciseIndex)

    if (exerciseIndex >= 0 && exerciseIndex < this.totalExercisesValue &&
        setIndex >= 0 && setIndex < setLines.length) {

      this.currentExerciseIndexValue = exerciseIndex
      this.currentSetIndexValue = setIndex

      this.updateCurrentPosition()
      this.updateProgressBar()
      this.updatePositionIndicator()

      console.log(`🎯 Jumped to Exercise ${exerciseIndex + 1}, Set ${setIndex + 1}`)
    }
  }

  // Mark current set as completed and advance
  completeCurrentSet() {
    console.log(`🎯 Completed Exercise ${this.currentExerciseIndexValue + 1}, Set ${this.currentSetIndexValue + 1}`)
    this.nextSet()
  }

  // Event handlers for log_builder integration
  handleExerciseAdded(event) {
    console.log("🎯 Exercise added:", event.detail)
    this.initializeWorkoutState()
    this.updateCurrentPosition()
    this.updateProgressBar()
    this.updatePositionIndicator()
  }

  handleExerciseRemoved(event) {
    console.log("🎯 Exercise removed:", event.detail)

    // Adjust current position if needed
    if (this.currentExerciseIndexValue >= this.totalExercisesValue) {
      this.currentExerciseIndexValue = Math.max(0, this.totalExercisesValue - 1)
      this.currentSetIndexValue = 0
    }

    this.initializeWorkoutState()
    this.updateCurrentPosition()
    this.updateProgressBar()
    this.updatePositionIndicator()
  }

  handleSetAdded(event) {
    console.log("🎯 Set added:", event.detail)
    this.initializeWorkoutState()
    this.updateCurrentPosition()
    this.updateProgressBar()
    this.updatePositionIndicator()
  }

  handleSetRemoved(event) {
    console.log("🎯 Set removed:", event.detail)

    // Adjust current set index if we're beyond the available sets
    const currentSetLines = this.getSetLinesForExercise(this.currentExerciseIndexValue)
    if (this.currentSetIndexValue >= currentSetLines.length) {
      this.currentSetIndexValue = Math.max(0, currentSetLines.length - 1)
    }

    this.initializeWorkoutState()
    this.updateCurrentPosition()
    this.updateProgressBar()
    this.updatePositionIndicator()
  }

  handleWorkoutUpdated(event) {
    console.log("🎯 Workout updated:", event.detail)
    this.initializeWorkoutState()
    this.updateCurrentPosition()
    this.updateProgressBar()
    this.updatePositionIndicator()
  }

  // Public API methods for external controllers (e.g., system notifications)
  getCurrentState() {
    return {
      exerciseIndex: this.currentExerciseIndexValue,
      setIndex: this.currentSetIndexValue,
      exerciseName: this.getCurrentExerciseName(),
      totalExercises: this.totalExercisesValue,
      totalSets: this.totalSetsValue,
      currentSetLine: this.getSetLinesForExercise(this.currentExerciseIndexValue)[this.currentSetIndexValue],
      progressPercentage: this.totalSetsValue > 0 ? ((this.getCurrentCompletedSets() / this.totalSetsValue) * 100) : 0
    }
  }

  getCurrentCompletedSets() {
    let completedSets = 0
    const exerciseBlocks = this.getAllExerciseBlocks()

    exerciseBlocks.forEach((block, exerciseIndex) => {
      const setLines = block.querySelectorAll('.set-line[data-set-index]')

      if (exerciseIndex < this.currentExerciseIndexValue) {
        completedSets += setLines.length
      } else if (exerciseIndex === this.currentExerciseIndexValue) {
        completedSets += this.currentSetIndexValue
      }
    })

    return completedSets
  }

  getCurrentSetData() {
    const currentSetLines = this.getSetLinesForExercise(this.currentExerciseIndexValue)
    const currentSetLine = currentSetLines[this.currentSetIndexValue]

    if (!currentSetLine) return null

    // Extract badge data from current set
    const badges = currentSetLine.querySelectorAll('.workout-badge[data-badge-editor-type-value]')
    const setData = {}

    badges.forEach(badge => {
      const type = badge.getAttribute('data-badge-editor-type-value')
      const content = badge.getAttribute('data-badge-editor-content-value')
      setData[type] = content
    })

    return {
      exerciseName: this.getCurrentExerciseName(),
      setNumber: this.currentSetIndexValue + 1,
      badges: setData,
      element: currentSetLine
    }
  }

  // Keyboard navigation
  handleKeydown(event) {
    switch(event.key) {
      case 'ArrowRight':
      case ' ':
        event.preventDefault()
        this.nextSet()
        break
      case 'ArrowLeft':
        event.preventDefault()
        this.previousSet()
        break
      case 'ArrowDown':
        event.preventDefault()
        this.nextExercise()
        break
      case 'ArrowUp':
        event.preventDefault()
        this.previousExercise()
        break
      case 'Enter':
        event.preventDefault()
        this.completeCurrentSet()
        break
    }
  }
}
