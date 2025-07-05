// Notification Management JavaScript

document.addEventListener("DOMContentLoaded", () => {

  // Auto-dismiss alerts after 5 seconds

  const alerts = document.querySelectorAll(".alert")

  const bootstrap = window.bootstrap // Declare the bootstrap variable

  alerts.forEach((alert) => {

    setTimeout(() => {

      const bsAlert = new bootstrap.Alert(alert)

      bsAlert.close()

    }, 5000)

  })

  // Form validation

  const forms = document.querySelectorAll("form")

  forms.forEach((form) => {

    form.addEventListener("submit", (e) => {

      const requiredFields = form.querySelectorAll("[required]")

      let isValid = true

      requiredFields.forEach((field) => {

        if (!field.value.trim()) {

          field.classList.add("is-invalid")

          isValid = false

        } else {

          field.classList.remove("is-invalid")

        }

      })

      if (!isValid) {

        e.preventDefault()

        alert("Vui lòng điền đầy đủ thông tin bắt buộc")

      }

    })

  })

  // Character count for content textarea

  const contentTextareas = document.querySelectorAll('textarea[name="content"]')

  contentTextareas.forEach((textarea) => {

    const maxLength = 1000

    // Create character counter

    const counter = document.createElement("small")

    counter.className = "text-muted"

    counter.style.float = "right"

    textarea.parentNode.appendChild(counter)

    function updateCounter() {

      const remaining = maxLength - textarea.value.length

      counter.textContent = `${textarea.value.length}/${maxLength} ký tự`

      if (remaining < 50) {

        counter.className = "text-warning"

      } else if (remaining < 0) {

        counter.className = "text-danger"

      } else {

        counter.className = "text-muted"

      }

    }

    textarea.addEventListener("input", updateCounter)

    updateCounter() // Initial count

  })

  // Date validation for send date

  const sendDateInputs = document.querySelectorAll('input[name="sendDate"]')

  sendDateInputs.forEach((input) => {

    // Set minimum date to today

    const today = new Date().toISOString().split("T")[0]

    input.min = today

    input.addEventListener("change", function () {

      if (this.value && this.value < today) {

        alert("Ngày gửi không thể là ngày trong quá khứ")

        this.value = today

      }

    })

  })

  // Auto-resize textareas

  const textareas = document.querySelectorAll("textarea")

  textareas.forEach((textarea) => {

    textarea.addEventListener("input", function () {

      this.style.height = "auto"

      this.style.height = this.scrollHeight + "px"

    })

  })

})

// Modal event handlers to ensure proper cleanup

document.addEventListener("hidden.bs.modal", (event) => {

  // Remove any backdrop that might be stuck

  const backdrops = document.querySelectorAll(".modal-backdrop")

  backdrops.forEach((backdrop) => backdrop.remove())

  // Reset body classes

  document.body.classList.remove("modal-open")

  document.body.style.paddingRight = ""

  document.body.style.overflow = ""

})

// Ensure modals are properly initialized

document.addEventListener("shown.bs.modal", (event) => {

  // Focus on first input in modal

  const modal = event.target

  const firstInput = modal.querySelector('input:not([type="hidden"]), textarea, select')

  if (firstInput) {

    setTimeout(() => firstInput.focus(), 100)

  }

})

// Utility function to format date

function formatDate(dateString) {

  const date = new Date(dateString)

  return date.toLocaleDateString("vi-VN", {

    year: "numeric",

    month: "2-digit",

    day: "2-digit",

  })

}

// Utility function to truncate text

function truncateText(text, maxLength) {

  if (text.length <= maxLength) return text

  return text.substring(0, maxLength) + "..."

}

