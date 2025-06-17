// app/javascript/controllers/typography_animator_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["typewriter", "fadeIn", "slideUp", "charAnimate", "splitText", "highlight", "reveal"]
  static values = {
    delay: { type: Number, default: 0 },
    speed: { type: Number, default: 100 },
    stagger: { type: Number, default: 100 }
  }

  connect() {
    console.log("🎬 Typography animator connected")

    // Small delay to ensure page is ready
    setTimeout(() => {
      this.animateAll()
    }, this.delayValue)
  }

  animateAll() {
    // Animate typewriter elements
    this.typewriterTargets.forEach((element, index) => {
      this.animateTypewriter(element, index * this.staggerValue)
    })

    // Animate fade-in elements
    this.fadeInTargets.forEach((element, index) => {
      setTimeout(() => {
        element.classList.add('fade-in')
      }, index * this.staggerValue)
    })

    // Animate slide-up elements
    this.slideUpTargets.forEach((element, index) => {
      setTimeout(() => {
        element.classList.add('slide-up')
      }, index * this.staggerValue)
    })

    // Animate character-by-character elements
    this.charAnimateTargets.forEach((element, index) => {
      this.animateCharacters(element, index * 500)
    })

    // Animate split text elements
    this.splitTextTargets.forEach((element, index) => {
      this.animateSplitText(element, index * 300)
    })

    // Animate highlight elements
    this.highlightTargets.forEach((element, index) => {
      setTimeout(() => {
        element.classList.add('animate')
      }, index * this.staggerValue + 1000)
    })

    // Animate reveal elements
    this.revealTargets.forEach((element, index) => {
      setTimeout(() => {
        element.classList.add('text-reveal')
      }, index * this.staggerValue)
    })
  }

  animateTypewriter(element, delay = 0) {
    const text = element.textContent
    element.textContent = ''
    element.style.borderRight = '0.15em solid #0d6efd'
    element.style.animation = 'blink-caret 0.75s step-end infinite'

    setTimeout(() => {
      let i = 0
      const typeInterval = setInterval(() => {
        if (i < text.length) {
          element.textContent += text.charAt(i)
          i++
        } else {
          clearInterval(typeInterval)
          // Remove cursor after typing is done
          setTimeout(() => {
            element.style.borderRight = 'none'
            element.style.animation = 'none'
          }, 1000)
        }
      }, this.speedValue)
    }, delay)
  }

  animateCharacters(element, delay = 0) {
    const text = element.textContent
    element.innerHTML = ''

    setTimeout(() => {
      text.split('').forEach((char, index) => {
        const span = document.createElement('span')
        span.textContent = char === ' ' ? '\u00A0' : char
        span.classList.add('char-animate', `char-${index + 1}`)
        element.appendChild(span)
      })
    }, delay)
  }

  animateSplitText(element, delay = 0) {
    const text = element.textContent
    const words = text.split(' ')
    element.innerHTML = ''

    words.forEach((word, wordIndex) => {
      const wordSpan = document.createElement('span')
      wordSpan.classList.add('word')

      word.split('').forEach((char, charIndex) => {
        const charSpan = document.createElement('span')
        charSpan.textContent = char
        charSpan.classList.add('char')
        charSpan.style.transitionDelay = `${(wordIndex * word.length + charIndex) * 0.05}s`
        wordSpan.appendChild(charSpan)
      })

      element.appendChild(wordSpan)
      if (wordIndex < words.length - 1) {
        element.appendChild(document.createTextNode(' '))
      }
    })

    setTimeout(() => {
      element.classList.add('animate')
    }, delay)
  }

  // Action methods for manual triggering
  triggerTypewriter(event) {
    const element = event.currentTarget
    this.animateTypewriter(element)
  }

  triggerFadeIn(event) {
    const element = event.currentTarget
    element.classList.add('fade-in')
  }

  triggerSlideUp(event) {
    const element = event.currentTarget
    element.classList.add('slide-up')
  }

  triggerCharAnimate(event) {
    const element = event.currentTarget
    this.animateCharacters(element)
  }

  triggerHighlight(event) {
    const element = event.currentTarget
    element.classList.add('animate')
  }

  // Reset animations (useful for page transitions)
  reset() {
    this.element.querySelectorAll('.fade-in, .slide-up, .char-animate, .animate').forEach(el => {
      el.classList.remove('fade-in', 'slide-up', 'char-animate', 'animate')
    })

    this.typewriterTargets.forEach(el => {
      el.style.borderRight = 'none'
      el.style.animation = 'none'
    })
  }

  // Utility method to add staggered animations to child elements
  staggerChildren(container, className, delay = 100) {
    const children = container.children
    Array.from(children).forEach((child, index) => {
      setTimeout(() => {
        child.classList.add(className)
      }, index * delay)
    })
  }

  disconnect() {
    console.log("🎬 Typography animator disconnected")
  }
}
