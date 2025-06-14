import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="log-builder"
export default class extends Controller {
  static targets = [
    "workoutEditor",
    "form",
    "hiddenDetails",
    "submitButton"
  ]

  connect() {
    console.log("🚀 Unified workout editor connected!")

    this.benchmarkData = window.benchmarkData || {}
    console.log("Benchmark data:", this.benchmarkData)

    // Pre-populate editor with formatted benchmark text
    this.loadBenchmarkText()

    // Add event listener for text changes
    this.workoutEditorTarget.addEventListener('input', () => {
      this.updateHiddenField()
    })

    this.updateHiddenField()
  }

  loadBenchmarkText() {
    const formattedText = this.formatWorkoutData(this.benchmarkData)
    this.workoutEditorTarget.value = formattedText
  }

  formatWorkoutData(data) {
    // Convert JSON benchmark data to markdown-style text
    if (!data || Object.keys(data).length === 0) {
      return "# Exercise Name\nDescribe your first set...\nDescribe your second set...\n\n# Another Exercise\nDescribe your first set...\nDescribe your second set..."
    }

    let text = ""
    Object.entries(data).forEach(([exerciseName, sets], index) => {
      if (index > 0) text += "\n\n"
      text += `# ${exerciseName}\n`
      sets.forEach(set => {
        text += `${set}\n`
      })
    })

    // Add template for new exercise at the end
    text += "\n\n# \n"

    return text
  }

  parseWorkoutText(text) {
    // Convert markdown-style text back to JSON
    const workoutData = {}
    const lines = text.split('\n')
    let currentExercise = null

    lines.forEach(line => {
      line = line.trim()

      if (line.startsWith('# ')) {
        // This is an exercise header
        currentExercise = line.substring(2).trim()
        if (currentExercise) {
          workoutData[currentExercise] = []
        }
      } else if (line && currentExercise) {
        // This is a set description
        workoutData[currentExercise].push(line)
      }
    })

    // Remove any exercises with no sets
    Object.keys(workoutData).forEach(exercise => {
      if (workoutData[exercise].length === 0) {
        delete workoutData[exercise]
      }
    })

    return workoutData
  }

  updateHiddenField() {
    const text = this.workoutEditorTarget.value
    const workoutData = this.parseWorkoutText(text)

    this.hiddenDetailsTarget.value = JSON.stringify(workoutData)

    // Enable/disable submit button based on content
    const hasContent = Object.keys(workoutData).length > 0
    this.submitButtonTarget.disabled = !hasContent

    console.log("Parsed workout data:", workoutData)
  }
}
