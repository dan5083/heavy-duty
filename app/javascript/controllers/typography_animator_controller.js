// app/javascript/controllers/typography_animator_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["typewriter", "fadeIn", "slideUp", "charAnimate", "splitText", "highlight", "reveal"]
  static values = {
    delay: { type: Number, default: 0 },
    stagger: { type: Number, default: 100 }
  }

  connect() {
    console.log("🎬 Typography animator connected")

    setTimeout(() => {
      this.animateAll()
    }, this.delayValue)
  }

  animateAll() {
    // Simple typewriter - just add CSS class
    this.typewriterTargets.forEach((element, index) => {
      setTimeout(() => {
        element.classList.add('typewriter-text')
      }, index * this.staggerValue)
    })

    // Fade in elements
    this.fadeInTargets.forEach((element, index) => {
      setTimeout(() => {
        element.classList.add('fade-in')
      }, index * this.staggerValue)
    })

    // Slide up elements
    this.slideUpTargets.forEach((element, index) => {
      setTimeout(() => {
        element.classList.add('slide-up')
      }, index * this.staggerValue)
    })

    // Highlight elements
    this.highlightTargets.forEach((element, index) => {
      setTimeout(() => {
        element.classList.add('animate')
      }, index * this.staggerValue + 1000)
    })
  }

  disconnect() {
    console.log("🎬 Typography animator disconnected")
  }
}
