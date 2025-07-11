// app/javascript/controllers/typography_animator_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
 static targets = ["typewriter", "fadeIn", "slideUp", "highlight"]
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

   // Highlight elements (delayed)
   this.highlightTargets.forEach((element, index) => {
     setTimeout(() => {
       element.classList.add('animate')
     }, index * this.staggerValue + 1000)
   })
 }

 // Add pulse animation to priority alerts
 animatePriorityAlert() {
   const priorityAlert = document.querySelector('.alert-next-up')
   if (priorityAlert) {
     priorityAlert.classList.add('priority-pulse')

     setTimeout(() => {
       priorityAlert.classList.remove('priority-pulse')
     }, 2000)
   }
 }

 // Add ripple effect to buttons
 addRippleEffect(button, event) {
   const ripple = document.createElement('span')
   ripple.classList.add('ripple')

   const rect = button.getBoundingClientRect()
   const size = Math.max(rect.width, rect.height)
   const x = event.clientX - rect.left - size / 2
   const y = event.clientY - rect.top - size / 2

   ripple.style.width = ripple.style.height = size + 'px'
   ripple.style.left = x + 'px'
   ripple.style.top = y + 'px'

   button.appendChild(ripple)

   setTimeout(() => {
     ripple.remove()
   }, 600)
 }

 disconnect() {
   console.log("🎬 Typography animator disconnected")
 }
}
