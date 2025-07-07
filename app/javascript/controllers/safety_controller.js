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
    // FIXED: Only target ACTUALLY dangerous elements - very specific selectors
    const dangerousActions = this.element.querySelectorAll([
      'button[data-turbo-method="delete"]',
      'a[data-turbo-method="delete"]',
      'form[method="delete"]',
      '[data-safety-confirm]',
      '.btn-danger[data-confirm]',  // Only danger buttons WITH confirm attribute
      'input[type="submit"][data-confirm]'  // Only submit buttons WITH confirm attribute
    ].join(','))

    dangerousActions.forEach(element => {
      element.addEventListener('click', this.handleDangerousAction.bind(this))
    })

    // Handle form submissions for delete forms only
    const deleteForms = this.element.querySelectorAll('form[method="delete"]')
    deleteForms.forEach(form => {
      form.addEventListener('submit', this.handleDangerousAction.bind(this))
    })

    // Add visual warnings for impersonation mode
    if (this.impersonationModeValue) {
      this.addImpersonationWarnings()
    }
  }

  handleDangerousAction(event) {
    const element = event.target

    // FIXED: NEVER interfere with normal form inputs
    if (element.matches('input[type="text"], input[type="email"], input[type="password"], textarea, select')) {
      return // Always allow normal form interactions
    }

    // FIXED: Don't interfere with harmless buttons (view toggles, navigation, etc.)
    if (element.matches('.btn-primary, .btn-secondary, .btn-outline-primary, .btn-outline-secondary')) {
      // Only intercept if they have explicit safety attributes
      if (!element.dataset.safetyConfirm && !element.dataset.confirm && element.dataset.turboMethod !== 'delete') {
        return // Let harmless buttons work normally
      }
    }

    const actionElement = event.target.closest('form[method="delete"], button[data-turbo-method="delete"], a[data-turbo-method="delete"], [data-safety-confirm], [data-confirm]')

    if (!actionElement) {
      return // Not a dangerous action, let it proceed
    }

    // Only intercept truly dangerous actions
    if (this.isTrulyDangerous(actionElement)) {
      event.preventDefault()
      event.stopPropagation()

      const actionType = this.getActionType(actionElement)
      const confirmMessage = this.getConfirmMessage(actionElement, actionType)

      if (this.impersonationModeValue) {
        this.showImpersonationModal(actionElement, actionType, confirmMessage)
      } else if (this.destructiveActionValue) {
        this.showStandardConfirmation(actionElement, confirmMessage)
      }
    }
  }

  // FIXED: Much more restrictive - only truly dangerous actions
  isTrulyDangerous(element) {
    if (!element) return false

    const hasDeleteMethod = element.dataset.turboMethod === 'delete' || element.method === 'delete'
    const hasExplicitConfirm = element.dataset.confirm || element.dataset.safetyConfirm
    const isDangerButton = element.matches('.btn-danger') && hasExplicitConfirm
    const isDeleteForm = element.matches('form[method="delete"]')

    return hasDeleteMethod || isDangerButton || isDeleteForm
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
    // FIXED: Only add warnings to actually dangerous elements with explicit confirms
    const destructiveElements = this.element.querySelectorAll([
      '.btn-danger[data-confirm]',
      'button[data-turbo-method="delete"]',
      'a[data-turbo-method="delete"]',
      '[data-safety-confirm]'
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
