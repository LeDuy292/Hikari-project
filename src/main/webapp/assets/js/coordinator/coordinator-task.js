// Coordinator Task Management JavaScript

document.addEventListener("DOMContentLoaded", () => {
  initializeTaskManagement()
})

function initializeTaskManagement() {
  // Initialize task type radio buttons
  initializeTaskTypeToggle()

  // Initialize form validation
  initializeFormValidation()

  // Initialize tooltips
  initializeTooltips()

  // Auto-hide alerts
  autoHideAlerts()
}

function initializeTaskTypeToggle() {
  var courseRadio = document.getElementById("courseTask")
  var testRadio = document.getElementById("testTask")
  var courseSelection = document.getElementById("courseSelection")
  var testSelection = document.getElementById("testSelection")
  var courseSelect = document.getElementById("courseID")
  var testSelect = document.getElementById("testID")

  function toggleTaskType() {
    if (courseRadio.checked) {
      courseSelection.style.display = "block"
      testSelection.style.display = "none"
      courseSelect.required = true
      testSelect.required = false
      testSelect.value = ""
    } else {
      courseSelection.style.display = "none"
      testSelection.style.display = "block"
      courseSelect.required = false
      testSelect.required = true
      courseSelect.value = ""
    }
  }

  courseRadio.addEventListener("change", toggleTaskType)
  testRadio.addEventListener("change", toggleTaskType)

  // Initialize on page load
  toggleTaskType()
}

function initializeFormValidation() {
  var createTaskForm = document.querySelector("#createTaskModal form")

  if (createTaskForm) {
    createTaskForm.addEventListener("submit", (e) => {
      if (!validateCreateTaskForm()) {
        e.preventDefault()
        e.stopPropagation()
      }
    })
  }
}

function validateCreateTaskForm() {
  var isValid = true
  var errors = []

  // Validate teacher selection
  var teacherID = document.getElementById("teacherID").value
  if (!teacherID) {
    errors.push("Vui lòng chọn giáo viên")
    isValid = false
  }

  // Validate task type selection
  var taskType = document.querySelector('input[name="taskType"]:checked').value
  if (taskType === "course") {
    var courseID = document.getElementById("courseID").value
    if (!courseID) {
      errors.push("Vui lòng chọn khóa học")
      isValid = false
    }
  } else {
    var testID = document.getElementById("testID").value
    if (!testID) {
      errors.push("Vui lòng chọn bài kiểm tra")
      isValid = false
    }
  }

  // Validate description
  var description = document.getElementById("description").value.trim()
  if (!description) {
    errors.push("Vui lòng nhập mô tả nhiệm vụ")
    isValid = false
  }

  // Validate deadline
  var deadline = document.getElementById("deadline").value
  if (!deadline) {
    errors.push("Vui lòng chọn thời hạn hoàn thành")
    isValid = false
  } else {
    var deadlineDate = new Date(deadline)
    var today = new Date()
    today.setHours(0, 0, 0, 0)

    if (deadlineDate <= today) {
      errors.push("Thời hạn hoàn thành phải sau ngày hôm nay")
      isValid = false
    }
  }

  // Display errors if any
  if (!isValid) {
    showAlert("danger", errors.join("<br>"))
  }

  return isValid
}

function initializeTooltips() {
  // Initialize Bootstrap tooltips if available
  var bootstrap = window.bootstrap
  if (typeof bootstrap !== "undefined" && bootstrap.Tooltip) {
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
    var tooltipList = tooltipTriggerList.map((tooltipTriggerEl) => new bootstrap.Tooltip(tooltipTriggerEl))
  }
}

function autoHideAlerts() {
  var alerts = document.querySelectorAll(".alert")
  alerts.forEach((alert) => {
    setTimeout(() => {
      if (alert && alert.parentNode) {
        alert.classList.add("fade")
        setTimeout(() => {
          alert.remove()
        }, 150)
      }
    }, 5000)
  })
}

// Task Management Functions
function viewTaskDetail(taskId) {
  // Show loading state
  var modal = new window.bootstrap.Modal(document.getElementById("taskDetailModal"))
  var content = document.getElementById("taskDetailContent")

  content.innerHTML = '<div class="text-center py-4"><div class="spinner"></div>Đang tải thông tin nhiệm vụ...</div>'

  modal.show()

  // Simulate loading task details
  setTimeout(() => {
    loadTaskDetail(taskId)
  }, 500)
}

function loadTaskDetail(taskId) {
  // In a real application, this would be an AJAX call
  // For now, we'll simulate the response
  var content = document.getElementById("taskDetailContent")

  content.innerHTML = `
        <div class="task-detail-content">
            <div class="row">
                <div class="col-md-6">
                    <h6 class="fw-bold mb-3">Thông tin nhiệm vụ</h6>
                    <div class="detail-item mb-2">
                        <i class="fas fa-user text-muted me-2"></i>
                        <strong>Giáo viên:</strong> Trần Văn Tùng
                    </div>
                    <div class="detail-item mb-2">
                        <i class="fas fa-book-open text-muted me-2"></i>
                        <strong>Khóa học:</strong> Tiếng Nhật Cơ Bản N5
                    </div>
                    <div class="detail-item mb-2">
                        <i class="fas fa-tag text-muted me-2"></i>
                        <strong>Trạng thái:</strong> 
                        <span class="badge bg-warning">Assigned</span>
                    </div>
                </div>
                <div class="col-md-6">
                    <h6 class="fw-bold mb-3">Thời gian</h6>
                    <div class="detail-item mb-2">
                        <i class="fas fa-calendar text-muted me-2"></i>
                        <strong>Ngày giao:</strong> 01/07/2025
                    </div>
                    <div class="detail-item mb-2">
                        <i class="fas fa-calendar-alt text-muted me-2"></i>
                        <strong>Hạn chót:</strong> 15/07/2025
                    </div>
                </div>
            </div>
            
            <hr>
            
            <h6 class="fw-bold mb-3">Mô tả nhiệm vụ</h6>
            <div class="bg-light p-3 rounded">
                <p class="mb-0">Chuẩn bị tài liệu giảng dạy cho khóa học JLPT N5.</p>
            </div>
            
            <hr>
            
            <h6 class="fw-bold mb-3">Quy tắc cập nhật</h6>
            <div class="alert alert-info">
                <h6 class="alert-heading">Nhiệm vụ khóa học:</h6>
                <ul class="mb-0">
                    <li>Khóa học hiện tại có trạng thái isActive = FALSE</li>
                    <li>Khi nhiệm vụ được "Duyệt", khóa học sẽ tự động được kích hoạt (isActive = TRUE)</li>
                    <li>Học viên chỉ có thể đăng ký sau khi khóa học được kích hoạt</li>
                </ul>
            </div>
        </div>
    `
}

function approveTask(taskId) {
  if (confirm("Bạn có chắc chắn muốn phê duyệt nhiệm vụ này?")) {
    // Show loading state
    showLoadingButton(event.target)

    // Create form and submit
    var form = document.createElement("form")
    form.method = "POST"
    form.action = window.location.pathname

    var actionInput = document.createElement("input")
    actionInput.type = "hidden"
    actionInput.name = "action"
    actionInput.value = "approve"

    var taskIdInput = document.createElement("input")
    taskIdInput.type = "hidden"
    taskIdInput.name = "taskId"
    taskIdInput.value = taskId

    form.appendChild(actionInput)
    form.appendChild(taskIdInput)
    document.body.appendChild(form)
    form.submit()
  }
}

function rejectTask(taskId) {
  // Set task ID in reject modal
  document.getElementById("rejectTaskId").value = taskId

  // Show reject modal
  var modal = new window.bootstrap.Modal(document.getElementById("rejectTaskModal"))
  modal.show()
}

function showLoadingButton(button) {
  var originalText = button.innerHTML
  button.innerHTML = '<span class="spinner"></span>Đang xử lý...'
  button.disabled = true

  // Reset after 3 seconds (in case of error)
  setTimeout(() => {
    button.innerHTML = originalText
    button.disabled = false
  }, 3000)
}

function showAlert(type, message) {
  var alertContainer = document.createElement("div")
  alertContainer.className = "alert alert-" + type + " alert-dismissible fade show"
  alertContainer.innerHTML =
    '<i class="fas fa-' +
    (type === "success" ? "check-circle" : "exclamation-circle") +
    '"></i>' +
    message +
    '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>'

  // Insert at the top of main content
  var mainContent = document.querySelector(".main-content")
  var pageHeader = document.querySelector(".page-header")
  mainContent.insertBefore(alertContainer, pageHeader.nextSibling)

  // Auto-hide after 5 seconds
  setTimeout(() => {
    if (alertContainer && alertContainer.parentNode) {
      alertContainer.classList.remove("show")
      setTimeout(() => {
        alertContainer.remove()
      }, 150)
    }
  }, 5000)
}

// Utility Functions
function formatDate(dateString) {
  var date = new Date(dateString)
  return date.toLocaleDateString("vi-VN")
}

function formatDateTime(dateString) {
  var date = new Date(dateString)
  return date.toLocaleString("vi-VN")
}

function isOverdue(deadlineString) {
  var deadline = new Date(deadlineString)
  var now = new Date()
  return deadline < now
}

// Export functions for global access
window.viewTaskDetail = viewTaskDetail
window.approveTask = approveTask
window.rejectTask = rejectTask
