// Course Management JavaScript
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

  // Date validation
  const startDateInputs = document.querySelectorAll('input[name="startDate"]')
  const endDateInputs = document.querySelectorAll('input[name="endDate"]')

  startDateInputs.forEach((startInput, index) => {
    const endInput = endDateInputs[index]
    if (endInput) {
      startInput.addEventListener("change", function () {
        endInput.min = this.value
      })

      endInput.addEventListener("change", function () {
        if (this.value && startInput.value && this.value <= startInput.value) {
          alert("Ngày kết thúc phải sau ngày bắt đầu")
          this.value = ""
        }
      })
    }
  })

  // Fee validation
  const feeInputs = document.querySelectorAll('input[name="fee"]')
  feeInputs.forEach((input) => {
    input.addEventListener("input", function () {
      if (this.value < 0) {
        this.value = 0
      }
    })
  })

  // Duration validation
  const durationInputs = document.querySelectorAll('input[name="duration"]')
  durationInputs.forEach((input) => {
    input.addEventListener("input", function () {
      if (this.value < 1) {
        this.value = 1
      }
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