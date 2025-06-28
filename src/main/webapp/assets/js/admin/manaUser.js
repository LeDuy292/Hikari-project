/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */
// User Management JavaScript
// Handles pagination, filtering, and modal interactions

// Import Bootstrap
const bootstrap = window.bootstrap

// Pagination and filtering logic
const rowsPerPage = 10
let currentPage = 1
let filteredRows = []

// Get all rows
const allRows = Array.from(document.querySelectorAll("#userTableBody tr"))

// Initialize pagination
function updatePagination() {
  const totalRows = filteredRows.length || allRows.length
  const totalPages = Math.ceil(totalRows / rowsPerPage)
  currentPage = Math.max(1, Math.min(currentPage, totalPages))

  // Show/hide rows based on current page
  const start = (currentPage - 1) * rowsPerPage
  const end = start + rowsPerPage

  allRows.forEach((row) => (row.style.display = "none"))
  ;(filteredRows.length ? filteredRows : allRows).slice(start, end).forEach((row) => (row.style.display = ""))

  // Update pagination info
  const pageInfo = document.getElementById("pageInfo")
  if (pageInfo) {
    pageInfo.textContent = `Trang ${currentPage} / ${totalPages || 1}`
  }

  // Enable/disable buttons
  const prevBtn = document.getElementById("prevPage")
  const nextBtn = document.getElementById("nextPage")

  if (prevBtn) prevBtn.disabled = currentPage === 1
  if (nextBtn) nextBtn.disabled = currentPage === totalPages || totalPages === 0
}

// Client-side search functionality
function performClientSearch() {
  const nameSearch = document.getElementById("nameSearch")
  if (!nameSearch) return

  const searchTerm = nameSearch.value.toLowerCase()

  if (searchTerm.trim() === "") {
    filteredRows = []
  } else {
    filteredRows = allRows.filter((row) => {
      const nameText = row.cells[2].textContent.toLowerCase() // Full name
      const usernameText = row.cells[3].textContent.toLowerCase() // Username
      const emailText = row.cells[4].textContent.toLowerCase() // Email

      return nameText.includes(searchTerm) || usernameText.includes(searchTerm) || emailText.includes(searchTerm)
    })
  }

  currentPage = 1
  updatePagination()
}

// Enhanced search with debouncing
let searchTimeout
function debounceSearch() {
  clearTimeout(searchTimeout)
  searchTimeout = setTimeout(performClientSearch, 300)
}

// Add search event listener
document.addEventListener("DOMContentLoaded", () => {
  const nameSearch = document.getElementById("nameSearch")
  if (nameSearch) {
    nameSearch.removeEventListener("input", performClientSearch)
    nameSearch.addEventListener("input", debounceSearch)
  }

  // Pagination button listeners
  const prevBtn = document.getElementById("prevPage")
  const nextBtn = document.getElementById("nextPage")

  if (prevBtn) {
    prevBtn.addEventListener("click", () => {
      if (currentPage > 1) {
        currentPage--
        updatePagination()
      }
    })
  }

  if (nextBtn) {
    nextBtn.addEventListener("click", () => {
      const totalRows = filteredRows.length || allRows.length
      const totalPages = Math.ceil(totalRows / rowsPerPage)
      if (currentPage < totalPages) {
        currentPage++
        updatePagination()
      }
    })
  }

  // Initialize pagination
  updatePagination()

  // Auto-dismiss alerts after 5 seconds
  const alerts = document.querySelectorAll(".alert")
  alerts.forEach((alert) => {
    setTimeout(() => {
      const bsAlert = new bootstrap.Alert(alert)
      bsAlert.close()
    }, 5000)
  })

  // Form validation for add user
  const addUserForm = document.querySelector("#addUserModal form")
  if (addUserForm) {
    addUserForm.addEventListener("submit", (e) => {
      const password = document.getElementById("password").value
      const confirmPassword = document.getElementById("confirmPassword").value

      if (password !== confirmPassword) {
        e.preventDefault()
        alert("Mật khẩu xác nhận không khớp!")
        return false
      }

      if (password.length < 6) {
        e.preventDefault()
        alert("Mật khẩu phải có ít nhất 6 ký tự!")
        return false
      }
    })
  }
})

// View user modal handler
document.addEventListener("click", (e) => {
  if (e.target.closest(".btn-view")) {
    const button = e.target.closest(".btn-view")

    const userId = button.getAttribute("data-user-id")
    const fullName = button.getAttribute("data-full-name")
    const username = button.getAttribute("data-username")
    const email = button.getAttribute("data-email")
    const role = button.getAttribute("data-role")
    const phone = button.getAttribute("data-phone") || "Chưa cập nhật"
    const birthDate = button.getAttribute("data-birth-date") || "Chưa cập nhật"
    const courses = button.getAttribute("data-courses")
    const createdDate = button.getAttribute("data-created-date")

    // Populate view modal
    document.getElementById("viewUserId").textContent = userId
    document.getElementById("viewFullName").textContent = fullName
    document.getElementById("viewUsername").textContent = username
    document.getElementById("viewEmail").textContent = email
    document.getElementById("viewRole").innerHTML = getRoleBadge(role)
    document.getElementById("viewPhone").textContent = phone
    document.getElementById("viewBirthDate").textContent = formatDate(birthDate)
    document.getElementById("viewCourses").textContent = courses
    document.getElementById("viewCreatedDate").textContent = formatDate(createdDate)
  }
})

// Edit user modal handler
document.addEventListener("click", (e) => {
  if (e.target.closest(".btn-edit")) {
    const button = e.target.closest(".btn-edit")

    const userId = button.getAttribute("data-user-id")
    const fullName = button.getAttribute("data-full-name")
    const username = button.getAttribute("data-username")
    const email = button.getAttribute("data-email")
    const role = button.getAttribute("data-role")
    const phone = button.getAttribute("data-phone") || ""
    const birthDate = button.getAttribute("data-birth-date") || ""

    // Populate edit modal
    document.getElementById("editUserId").value = userId
    document.getElementById("editFullName").value = fullName
    document.getElementById("editUsername").value = username
    document.getElementById("editEmail").value = email
    document.getElementById("editRole").value = role
    document.getElementById("editPhone").value = phone
    document.getElementById("editBirthDate").value = birthDate
    document.getElementById("editPassword").value = "" // Clear password field
  }
})

// Block user modal handler
document.addEventListener("click", (e) => {
  if (e.target.closest(".btn-delete")) {
    const button = e.target.closest(".btn-delete")

    const userId = button.getAttribute("data-user-id")
    const fullName = button.getAttribute("data-full-name")
    const status = button.getAttribute("data-status")

    document.getElementById("blockUserId").textContent = userId
    document.getElementById("blockFullName").textContent = fullName
    document.getElementById("blockUserIdInput").value = userId
    document.getElementById("blockStatusInput").value = status === "Hoạt Động" ? "Khóa" : "Hoạt Động"
    document.getElementById("blockAction").textContent = status === "Hoạt Động" ? "khóa" : "mở khóa"
  }
})

// Clear form when modal is hidden
document.addEventListener("hidden.bs.modal", (e) => {
  if (e.target.id === "addUserModal") {
    const form = e.target.querySelector("form")
    if (form) {
      form.reset()
    }
  }
})

// Real-time password confirmation validation
document.addEventListener("input", (e) => {
  if (e.target.id === "confirmPassword") {
    const password = document.getElementById("password").value
    const confirmPassword = e.target.value

    if (password !== confirmPassword) {
      e.target.setCustomValidity("Mật khẩu xác nhận không khớp")
    } else {
      e.target.setCustomValidity("")
    }
  }
})

// Utility function to format date
function formatDate(dateString) {
  if (!dateString) return "Chưa cập nhật"
  const date = new Date(dateString)
  return date.toLocaleDateString("vi-VN")
}

// Utility function to get role badge HTML
function getRoleBadge(role) {
  const roleConfig = {
    Admin: { color: "linear-gradient(135deg, #dc3545, #e85d75)", icon: "fas fa-crown" },
    Teacher: { color: "linear-gradient(135deg, #f39c12, #ffb347)", icon: "fas fa-chalkboard-teacher" },
    Coordinator: { color: "linear-gradient(135deg, #6f42c1, #8e6bc1)", icon: "fas fa-user-tie" },
    Student: { color: "linear-gradient(135deg, #4a90e2, #5ba0f2)", icon: "fas fa-user-graduate" },
  }

  const config = roleConfig[role] || roleConfig["Student"]
  return `<span class="badge" style="background: ${config.color};"><i class="${config.icon}"></i> ${role}</span>`
}

console.log("User Management JavaScript loaded successfully")
