/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

// Notification Management JavaScript
// Handles pagination, filtering, and modal interactions

// Import Bootstrap
const bootstrap = window.bootstrap

// Mock notification details data
const notificationDetails = {
  NOT001: {
    title: "Khóa Học N5 Mới",
    type: "Cập Nhật Khóa Học",
    content:
      "Khóa học Tiếng Nhật Sơ Cấp N5 mới sẽ bắt đầu vào 01/06/2025. Đăng ký ngay để nhận ưu đãi giảm 20% học phí!",
    sendDate: "2025-05-01",
    recipient: "Tất Cả Học Viên",
  },
  NOT002: {
    title: "Đăng Ký JLPT N3",
    type: "Sự Kiện",
    content: "Hạn đăng ký thi JLPT N3 là 30/06/2025. Đăng ký ngay tại J-Learning để nhận tài liệu ôn thi miễn phí!",
    sendDate: "2025-05-02",
    recipient: "Học Viên N3",
  },
  NOT003: {
    title: "Lễ Hội Hanami 2025",
    type: "Sự Kiện",
    content:
      "Tham gia lớp học làm bánh Mochi tại lễ hội Hanami vào 15/06/2025. Đăng ký trước 10/06 để nhận vé miễn phí!",
    sendDate: "2025-05-03",
    recipient: "Tất Cả Học Viên",
  },
  NOT004: {
    title: "Bảo Trì Hệ Thống",
    type: "Thông Báo Hệ Thống",
    content:
      "Hệ thống J-Learning sẽ bảo trì từ 00:00 đến 02:00 ngày 10/05/2025. Vui lòng đăng nhập lại sau thời gian này.",
    sendDate: "2025-05-04",
    recipient: "Tất Cả Học Viên",
  },
  NOT005: {
    title: "Lớp Học Trà Đạo",
    type: "Sự Kiện",
    content: "Tham gia lớp học Trà Đạo Nhật Bản vào 20/06/2025 tại HIKARI. Số lượng giới hạn, đăng ký sớm!",
    sendDate: "2025-05-05",
    recipient: "Học Viên N3",
  },
  NOT006: {
    title: "Khóa Học Kanji N4",
    type: "Cập Nhật Khóa Học",
    content: "Khóa học Kanji N4 mới đã được cập nhật với tài liệu mới và bài tập thực hành. Đăng ký ngay hôm nay!",
    sendDate: "2025-05-06",
    recipient: "Học Viên N4",
  },
  NOT007: {
    title: "Hội Thảo JLPT N2",
    type: "Sự Kiện",
    content:
      "Hội thảo ôn thi JLPT N2 sẽ diễn ra vào 25/06/2025. Đăng ký để nhận tài liệu và gặp gỡ giảng viên hàng đầu!",
    sendDate: "2025-05-07",
    recipient: "Học Viên N2",
  },
  NOT008: {
    title: "Cập Nhật Ứng Dụng",
    type: "Thông Báo Hệ Thống",
    content: "Ứng dụng J-Learning đã được cập nhật phiên bản 2.1.0 với giao diện mới và tính năng học Kanji cải tiến.",
    sendDate: "2025-05-08",
    recipient: "Tất Cả Học Viên",
  },
  NOT009: {
    title: "Lớp Hội Thoại N3",
    type: "Cập Nhật Khóa Học",
    content: "Lớp hội thoại N3 mới sẽ khai giảng vào 01/07/2025. Đăng ký để nâng cao kỹ năng giao tiếp tiếng Nhật!",
    sendDate: "2025-05-09",
    recipient: "Học Viên N3",
  },
  NOT010: {
    title: "Cuộc Thi Kanji 2025",
    type: "Sự Kiện",
    content: "Đăng ký cuộc thi Kanji toàn quốc 2025 tại HIKARI. Giải thưởng hấp dẫn đang chờ bạn!",
    sendDate: "2025-05-10",
    recipient: "Tất Cả Học Viên",
  },
}

// Function to show notification details in view modal
function showNotificationDetails(notificationId) {
  const row = document.querySelector(`tr[data-notification-id="${notificationId}"]`)
  const details = notificationDetails[notificationId]

  document.getElementById("modalNotificationId").textContent = row.cells[0].textContent
  document.getElementById("modalTitle").textContent = row.cells[1].textContent
  document.getElementById("modalType").textContent = row.cells[2].textContent
  document.getElementById("modalContent").textContent = details.content
  document.getElementById("modalSendDate").textContent = formatDate(row.cells[4].textContent)
  document.getElementById("modalRecipient").textContent = details.recipient
}

// Function to populate edit notification modal
function populateEditNotificationModal(notificationId) {
  const row = document.querySelector(`tr[data-notification-id="${notificationId}"]`)
  const details = notificationDetails[notificationId]

  document.getElementById("editNotificationId").value = row.cells[0].textContent
  document.getElementById("editTitle").value = row.cells[1].textContent
  document.getElementById("editType").value = row.cells[2].textContent
  document.getElementById("editContent").value = details.content
  document.getElementById("editRecipient").value = details.recipient
  document.getElementById("editSendDate").value = row.cells[4].textContent
}

// Function to populate delete notification modal
function populateDeleteNotificationModal(notificationId, title) {
  document.getElementById("deleteNotificationId").textContent = notificationId
  document.getElementById("deleteTitle").textContent = title
  document.getElementById("deleteNotificationIdInput").value = notificationId
}

// Function to create a new notification row
function createNotificationRow(id, title, type, content, sendDate, recipient) {
  const truncatedContent = truncateText(content, 50)
  const row = document.createElement("tr")
  row.setAttribute("data-notification-id", id)
  row.innerHTML = `
    <td>${id}</td>
    <td>${title}</td>
    <td>${type}</td>
    <td>${truncatedContent}</td>
    <td>${formatDate(sendDate)}</td>
    <td>
      <button class="btn btn-view btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#viewNotificationModal" data-notification-id="${id}"><i class="fas fa-eye"></i></button>
      <button class="btn btn-edit btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#editNotificationModal" data-notification-id="${id}"><i class="fas fa-edit"></i></button>
      <button class="btn btn-delete btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#deleteNotificationModal" data-notification-id="${id}" data-title="${title}"><i class="fas fa-trash"></i></button>
    </td>
  `
  return row
}

// Handle create notification form submission
document.getElementById("createNotificationForm").addEventListener("submit", (e) => {
  e.preventDefault()
  const form = e.target
  if (!form.checkValidity()) {
    form.reportValidity()
    return
  }

  const title = document.getElementById("createTitle").value
  const type = document.getElementById("createType").value
  const content = document.getElementById("createContent").value
  const recipient = document.getElementById("createRecipient").value
  const sendDate = document.getElementById("createSendDate").value

  // Generate new ID
  const existingIds = Object.keys(notificationDetails).map((id) => Number.parseInt(id.replace("NOT", "")))
  const newIdNum = Math.max(...existingIds, 0) + 1
  const newId = `NOT${newIdNum.toString().padStart(3, "0")}`

  // Add to notificationDetails
  notificationDetails[newId] = { title, type, content, sendDate, recipient }

  // Add to table
  const newRow = createNotificationRow(newId, title, type, content, sendDate, recipient)
  document.getElementById("notificationTableBody").prepend(newRow)

  // Update pagination
  applyFilters()

  // Close modal and reset form
  const modal = bootstrap.Modal.getInstance(document.getElementById("createNotificationModal"))
  modal.hide()
  form.reset()
  document.getElementById("createSendDate").value = new Date().toISOString().split("T")[0]
})

// Set default send date to today for create modal
document.getElementById("createSendDate").value = new Date().toISOString().split("T")[0]

// Add event listeners to buttons
document.querySelectorAll(".btn-view").forEach((button) => {
  button.addEventListener("click", () => {
    const notificationId = button.getAttribute("data-notification-id")
    showNotificationDetails(notificationId)
  })
})

document.querySelectorAll(".btn-edit").forEach((button) => {
  button.addEventListener("click", () => {
    const notificationId = button.getAttribute("data-notification-id")
    populateEditNotificationModal(notificationId)
  })
})

document.querySelectorAll(".btn-delete").forEach((button) => {
  button.addEventListener("click", () => {
    const notificationId = button.getAttribute("data-notification-id")
    const title = button.getAttribute("data-title")
    populateDeleteNotificationModal(notificationId, title)
  })
})

// Pagination and filtering logic
const rowsPerPage = 10
let currentPage = 1
let filteredRows = []

// Get all rows
const allRows = Array.from(document.querySelectorAll("#notificationTableBody tr"))

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
  const search = document.getElementById("search")
  if (!search) return

  const searchTerm = search.value.toLowerCase()

  if (searchTerm.trim() === "") {
    filteredRows = []
  } else {
    filteredRows = allRows.filter((row) => {
      const titleText = row.cells[1].textContent.toLowerCase() // Title
      const contentText = row.cells[3].textContent.toLowerCase() // Content
      const idText = row.cells[0].textContent.toLowerCase() // ID

      return titleText.includes(searchTerm) || contentText.includes(searchTerm) || idText.includes(searchTerm)
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
  const search = document.getElementById("search")
  if (search) {
    search.removeEventListener("input", performClientSearch)
    search.addEventListener("input", debounceSearch)
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

  // Form validation for create notification
  const createNotificationForm = document.querySelector("#createNotificationModal form")
  if (createNotificationForm) {
    createNotificationForm.addEventListener("submit", (e) => {
      const title = document.getElementById("createTitle").value.trim()
      const content = document.getElementById("createContent").value.trim()

      if (title.length < 5) {
        e.preventDefault()
        alert("Tiêu đề phải có ít nhất 5 ký tự!")
        return false
      }

      if (content.length < 10) {
        e.preventDefault()
        alert("Nội dung phải có ít nhất 10 ký tự!")
        return false
      }
    })
  }

  // Form validation for edit notification
  const editNotificationForm = document.querySelector("#editNotificationModal form")
  if (editNotificationForm) {
    editNotificationForm.addEventListener("submit", (e) => {
      const title = document.getElementById("editTitle").value.trim()
      const content = document.getElementById("editContent").value.trim()

      if (title.length < 5) {
        e.preventDefault()
        alert("Tiêu đề phải có ít nhất 5 ký tự!")
        return false
      }

      if (content.length < 10) {
        e.preventDefault()
        alert("Nội dung phải có ít nhất 10 ký tự!")
        return false
      }
    })
  }
})

// Clear form when modal is hidden
document.addEventListener("hidden.bs.modal", (e) => {
  if (e.target.id === "createNotificationModal") {
    const form = e.target.querySelector("form")
    if (form) {
      form.reset()
      // Reset send date to today
      document.getElementById("createSendDate").value = new Date().toISOString().split("T")[0]
    }
  }
})

// Utility function to format date
function formatDate(dateString) {
  if (!dateString) return "Chưa cập nhật"
  const date = new Date(dateString)
  return date.toLocaleDateString("vi-VN")
}

// Utility function to truncate text
function truncateText(text, maxLength) {
  if (text.length <= maxLength) return text
  return text.substring(0, maxLength) + "..."
}

console.log("Notification Management JavaScript loaded successfully")
