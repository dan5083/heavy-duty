import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="safety"
export default class extends Controller {
  static targets = ["form", "confirmButton"]
  static values = {
    impersonationMode: Boolean,
    destructiveAction: Boolean,
    actionType: String,
    confirmMessage: String
  }

  connect() {
    console.log("🛡️ Safety controller connected")
    console.log("Impersonation mode:", this.impersonationModeValue)
    console.log("Destructive action:", this.destructiveActionValue)

    if (this.impersonationModeValue || this.destructiveActionValue) {
      this.setupSafetyChecks()
    }
  }

  setupSafetyChecks() {
    // FIXED: Only target specific dangerous elements, not form inputs
    const dangerousActions = this.element.querySelectorAll([
      'button[data-turbo-method="delete"]',
      'a[data-turbo-method="delete"]',
      '.btn-danger',
      '.btn-warning',
      '[data-safety-confirm]',
      'input[type="submit"]'  // Only submit buttons, not text inputs
    ].join(','))

    dangerousActions.forEach(element => {
      element.addEventListener('click', this.handleDangerousAction.bind(this))
    })

    // FIXED: Handle form submissions separately, not clicks on form elements
    const forms = this.element.querySelectorAll('form[method="delete"], form[data-safety-confirm]')
    forms.forEach(form => {
      form.addEventListener('submit', this.handleDangerousAction.bind(this))
    })

    // Add visual warnings for impersonation mode
    if (this.impersonationModeValue) {
      this.addImpersonationWarnings()
    }
  }

  handleDangerousAction(event) {
    // FIXED: Don't interfere with normal form input interactions
    const element = event.target

    // Allow normal input field interactions
    if (element.matches('input[type="text"], input[type="email"], textarea, select')) {
      return // Let the event proceed normally
    }

    // Only intercept dangerous actions
    const actionElement = event.target.closest('form, button, a, input[type="submit"]')
    const actionType = this.getActionType(actionElement)
    const confirmMessage = this.getConfirmMessage(actionElement, actionType)

    // Only show confirmation for truly dangerous actions
    if (this.isDangerousAction(actionElement)) {
      event.preventDefault()
      event.stopPropagation()

      if (this.impersonationModeValue) {
        this.showImpersonationModal(actionElement, actionType, confirmMessage)
      } else if (this.destructiveActionValue) {
        this.showStandardConfirmation(actionElement, confirmMessage)
      }
    }
  }

  // FIXED: Better logic to determine what's actually dangerous
  isDangerousAction(element) {
    if (!element) return false

    const isDangerousButton = element.matches('.btn-danger, .btn-warning, [data-safety-confirm]')
    const isDangerousMethod = element.dataset.turboMethod === 'delete'
    const isSubmitButton = element.matches('input[type="submit"], button[type="submit"]')
    const isDangerousForm = element.matches('form[method="delete"], form[data-safety-confirm]')

    return isDangerousButton || isDangerousMethod || (isSubmitButton && this.impersonationModeValue) || isDangerousForm
  }

  showImpersonationModal(element, actionType, confirmMessage) {
    const modal = document.getElementById('impersonationSafetyModal')
    if (!modal) {
      console.error('Impersonation safety modal not found')
      return this.fallbackToStandardConfirm(element, confirmMessage)
    }

    // Update modal content
    const detailsContainer = document.getElementById('safetyModalDetails')
    if (detailsContainer) {
      detailsContainer.innerHTML = `
        <div class="bg-light p-3 rounded">
          <strong>Action:</strong> ${actionType}<br>
          <strong>Target:</strong> ${confirmMessage}
        </div>
      `
    }

    // Store the element for later execution
    this.pendingAction = element

    // Show modal
    const bootstrapModal = new bootstrap.Modal(modal)
    bootstrapModal.show()

    // Setup confirm button
    const confirmButton = document.getElementById('confirmSafetyAction')
    if (confirmButton) {
      confirmButton.onclick = () => {
        bootstrapModal.hide()
        this.executePendingAction()
      }
    }
  }

  showStandardConfirmation(element, confirmMessage) {
    if (confirm(confirmMessage)) {
      this.executeAction(element)
    }
  }

  fallbackToStandardConfirm(element, confirmMessage) {
    const enhancedMessage = this.impersonationModeValue
      ? `⚠️ IMPERSONATION MODE ACTIVE ⚠️\n\n${confirmMessage}\n\nThis action will be performed as the client, not you.`
      : confirmMessage

    if (confirm(enhancedMessage)) {
      this.executeAction(element)
    }
  }

  executePendingAction() {
    if (this.pendingAction) {
      this.executeAction(this.pendingAction)
      this.pendingAction = null
    }
  }

  executeAction(element) {
    if (element.tagName === 'FORM') {
      element.submit()
    } else if (element.tagName === 'A') {
      window.location.href = element.href
    } else if (element.matches('button, input[type="submit"]')) {
      // Handle button actions
      const form = element.closest('form')
      if (form) {
        form.submit()
      } else if (element.onclick) {
        element.onclick()
      }
    }
  }

  getActionType(element) {
    // Determine action type from element
    const method = element?.dataset?.turboMethod || element?.method || 'GET'
    const className = element?.className || ''

    if (method.toUpperCase() === 'DELETE' || className.includes('btn-danger')) {
      return 'Delete/Remove'
    } else if (className.includes('btn-warning')) {
      return 'Modify'
    } else if (element?.dataset?.safetyConfirm) {
      return element.dataset.safetyConfirm
    } else {
      return 'Action'
    }
  }

  getConfirmMessage(element, actionType) {
    // Check for custom confirm message
    if (element?.dataset?.confirm) {
      return element.dataset.confirm
    }

    // Generate message based on element
    const text = element?.textContent?.trim() || element?.value || actionType

    if (this.impersonationModeValue) {
      return `${text}\n\nThis will be performed as the client, not you.`
    } else {
      return `Are you sure you want to: ${text}?`
    }
  }

  addImpersonationWarnings() {
    // FIXED: Only add warnings to actually dangerous elements
    const destructiveElements = this.element.querySelectorAll([
      '.btn-danger',
      '.btn-warning',
      'button[data-turbo-method="delete"]',
      'a[data-turbo-method="delete"]'
    ].join(','))

    destructiveElements.forEach(element => {
      if (!element.querySelector('.impersonation-warning')) {
        const warning = document.createElement('span')
        warning.className = 'impersonation-warning badge bg-warning text-dark ms-1'
        warning.innerHTML = '<i class="bi bi-exclamation-triangle"></i>'
        warning.title = 'Impersonation mode active - action will affect client'

        element.appendChild(warning)
      }
    })
  }

  disconnect() {
    console.log("🛡️ Safety controller disconnected")
  }
}
