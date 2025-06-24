// app/javascript/controllers/impersonation_controller.js

import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="impersonation"
export default class extends Controller {
  static targets = ["switchLink"]

  connect() {
    console.log("🔄 Impersonation controller connected")

    // Add click handlers to all switch links
    this.switchLinkTargets.forEach(link => {
      link.addEventListener('click', this.handleSwitch.bind(this))
    })
  }

  disconnect() {
    console.log("🔄 Impersonation controller disconnected")
  }

  handleSwitch(event) {
    event.preventDefault()
    const link = event.currentTarget
    const url = link.href
    const method = link.dataset.turboMethod || 'POST'

    console.log(`Switching impersonation: ${method} ${url}`)

    // Show loading state
    this.showLoadingState(link)

    // Make the request
    fetch(url, {
      method: method,
      headers: {
        'X-CSRF-Token': this.getCSRFToken(),
        'Accept': 'text/html',
        'X-Requested-With': 'XMLHttpRequest'
      },
      credentials: 'same-origin'
    })
    .then(response => {
      if (response.ok) {
        // Success - redirect to dashboard
        console.log('Impersonation switch successful')
        this.showSuccessState(link)

        // Small delay for visual feedback, then redirect
        setTimeout(() => {
          window.location.href = '/dashboard'
        }, 300)
      } else {
        throw new Error(`HTTP ${response.status}`)
      }
    })
    .catch(error => {
      console.error('Impersonation switch failed:', error)
      this.showErrorState(link)

      // Reset after showing error
      setTimeout(() => {
        this.resetLinkState(link)
      }, 2000)
    })
  }

  showLoadingState(link) {
    const icon = link.querySelector('i:first-child')
    const text = link.querySelector('span') || link

    // Store original state
    link.dataset.originalIcon = icon?.className || ''
    link.dataset.originalText = text.textContent

    // Show loading state
    if (icon) {
      icon.className = 'bi bi-arrow-repeat me-2 spin'
    }
    link.classList.add('loading')
    link.style.pointerEvents = 'none'

    // Add CSS for spinning animation if not already present
    if (!document.querySelector('#impersonation-loading-styles')) {
      const style = document.createElement('style')
      style.id = 'impersonation-loading-styles'
      style.textContent = `
        .spin {
          animation: spin 1s linear infinite;
        }
        @keyframes spin {
          from { transform: rotate(0deg); }
          to { transform: rotate(360deg); }
        }
        .loading {
          opacity: 0.7;
        }
      `
      document.head.appendChild(style)
    }
  }

  showSuccessState(link) {
    const icon = link.querySelector('i:first-child')

    if (icon) {
      icon.className = 'bi bi-check-circle-fill me-2 text-success'
    }
    link.classList.remove('loading')
    link.classList.add('success')
  }

  showErrorState(link) {
    const icon = link.querySelector('i:first-child')

    if (icon) {
      icon.className = 'bi bi-exclamation-triangle-fill me-2 text-danger'
    }
    link.classList.remove('loading')
    link.classList.add('error')

    // Show error message
    this.showNotification('Failed to switch client. Please try again.', 'error')
  }

  resetLinkState(link) {
    const icon = link.querySelector('i:first-child')

    // Restore original state
    if (icon && link.dataset.originalIcon) {
      icon.className = link.dataset.originalIcon
    }

    link.classList.remove('loading', 'success', 'error')
    link.style.pointerEvents = ''

    // Clean up data attributes
    delete link.dataset.originalIcon
    delete link.dataset.originalText
  }

  showNotification(message, type = 'info') {
    // Create notification element
    const notification = document.createElement('div')
    notification.className = `alert alert-${type === 'error' ? 'danger' : 'info'} alert-dismissible fade show position-fixed`
    notification.style.cssText = `
      top: 20px;
      right: 20px;
      z-index: 9999;
      min-width: 300px;
      animation: slideInRight 0.3s ease-out;
    `

    notification.innerHTML = `
      ${message}
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `

    // Add to page
    document.body.appendChild(notification)

    // Auto-remove after 4 seconds
    setTimeout(() => {
      if (notification.parentNode) {
        notification.classList.add('fade')
        setTimeout(() => {
          notification.remove()
        }, 150)
      }
    }, 4000)

    // Add CSS for slide animation if not present
    if (!document.querySelector('#notification-styles')) {
      const style = document.createElement('style')
      style.id = 'notification-styles'
      style.textContent = `
        @keyframes slideInRight {
          from {
            transform: translateX(100%);
            opacity: 0;
          }
          to {
            transform: translateX(0);
            opacity: 1;
          }
        }
      `
      document.head.appendChild(style)
    }
  }

  getCSRFToken() {
    const meta = document.querySelector('meta[name="csrf-token"]')
    return meta ? meta.getAttribute('content') : ''
  }

  // Helper method for debugging
  logUserContext() {
    console.log('Current impersonation state:', {
      currentUser: this.element.dataset.currentUser,
      actingUser: this.element.dataset.actingUser,
      impersonationMode: this.element.dataset.impersonationMode
    })
  }
}
