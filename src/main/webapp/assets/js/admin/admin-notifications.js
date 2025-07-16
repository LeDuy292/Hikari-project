class AdminNotificationManager {
  constructor(userRole = "admin") {
    this.contextPath = window.contextPath || ""
    this.userRole = userRole // 'admin' or 'coordinator'
    this.isDropdownOpen = false
    this.notifications = []
    this.unreadCount = 0
    this.pollInterval = null
    this.readNotifications = new Set() // Track read notifications locally
    this.isInitialized = false
    this.loadingTimeout = null

    this.init()
  }

  init() {
    // Prevent multiple initialization
    if (this.isInitialized) {
      return
    }

    // Add timeout to prevent hanging
    this.loadingTimeout = setTimeout(() => {
      if (!this.isInitialized) {
        console.warn("Notification system initialization timeout")
        this.showError("Không thể khởi tạo hệ thống thông báo")
      }
    }, 5000)

    this.createNotificationElements()
    this.createModal()
    this.bindEvents()
    this.loadNotifications()
    this.startPolling()

    this.isInitialized = true
    if (this.loadingTimeout) {
      clearTimeout(this.loadingTimeout)
    }
  }

  getApiEndpoint() {
    return this.userRole === "coordinator"
      ? `${this.contextPath}/coordinator/coordinator-notifications`
      : `${this.contextPath}/admin/admin-notifications`
  }

  createNotificationElements() {
    // Check if notification already exists
    const existingContainer = document.querySelector(".admin-notification-container")
    if (existingContainer) {
      existingContainer.remove() // Remove existing to avoid duplicates
    }

    // Find the header actions container
    const headerActions = document.querySelector(".header-actions")
    if (!headerActions) return

    // Create notification container
    const container = document.createElement("div")
    container.className = "admin-notification-container"
    container.style.zIndex = "999999" // Inline style for extra priority

    // Create bell button with badge
    container.innerHTML = `
          <button class="admin-notification-bell" id="adminNotificationBell">
              <i class="fas fa-bell"></i>
              <span class="admin-notification-badge" id="adminNotificationBadge" style="display: none;">0</span>
          </button>
          <div class="admin-notification-dropdown" id="adminNotificationDropdown" style="z-index: 999999;">
              <div class="admin-notification-header">
                  <h4><i class="fas fa-bell"></i> Thông báo</h4>
                  <button class="admin-mark-all-read" id="adminMarkAllRead">
                      <i class="fas fa-check"></i> Đánh dấu đã đọc
                  </button>
              </div>
              <div class="admin-notification-list" id="adminNotificationList">
                  <div class="admin-notification-loading">
                      <i class="fas fa-spinner"></i> Đang tải...
                  </div>
              </div>
          </div>
      `

    // Insert before user profile
    const userProfile = headerActions.querySelector(".user-profile")
    if (userProfile) {
      headerActions.insertBefore(container, userProfile)
    } else {
      headerActions.appendChild(container)
    }

    // Ensure top layer
    this.ensureTopLayer()
  }

  createModal() {
    // Create modal for notification details
    const modal = document.createElement("div")
    modal.className = "admin-notification-modal"
    modal.id = "adminNotificationModal"
    modal.innerHTML = `
            <div class="admin-notification-modal-content">
                <div class="admin-notification-modal-header">
                    <h3><i class="fas fa-bell"></i> Chi tiết thông báo</h3>
                    <button class="admin-notification-modal-close" id="closeAdminNotificationModal">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
                <div class="admin-notification-modal-body" id="adminNotificationModalBody">
                    <!-- Content will be populated dynamically -->
                </div>
            </div>
        `

    document.body.appendChild(modal)
  }

  bindEvents() {
    const bellButton = document.getElementById("adminNotificationBell")
    const dropdown = document.getElementById("adminNotificationDropdown")
    const markAllReadBtn = document.getElementById("adminMarkAllRead")
    const modal = document.getElementById("adminNotificationModal")
    const closeModalBtn = document.getElementById("closeAdminNotificationModal")

    if (bellButton) {
      bellButton.addEventListener("click", (e) => {
        e.stopPropagation()
        this.toggleDropdown()
      })
    }

    if (markAllReadBtn) {
      markAllReadBtn.addEventListener("click", () => {
        this.markAllAsRead()
      })
    }

    if (closeModalBtn) {
      closeModalBtn.addEventListener("click", () => {
        this.closeModal()
      })
    }

    if (modal) {
      modal.addEventListener("click", (e) => {
        if (e.target === modal) {
          this.closeModal()
        }
      })
    }

    // Close dropdown when clicking outside
    document.addEventListener("click", (e) => {
      if (!e.target.closest(".admin-notification-container")) {
        this.closeDropdown()
      }
    })

    // Prevent dropdown from closing when clicking inside
    if (dropdown) {
      dropdown.addEventListener("click", (e) => {
        e.stopPropagation()
      })
    }

    // Handle ESC key to close modal
    document.addEventListener("keydown", (e) => {
      if (e.key === "Escape") {
        this.closeModal()
      }
    })
  }

  async loadNotifications() {
    try {
      // Add loading state
      this.setLoadingState(true)

      const controller = new AbortController()
      const timeoutId = setTimeout(() => controller.abort(), 10000) // 10 second timeout

      const response = await fetch(`${this.getApiEndpoint()}?action=list`, {
        signal: controller.signal,
        headers: {
          "Cache-Control": "no-cache",
        },
      })

      clearTimeout(timeoutId)

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`)
      }

      const data = await response.json()

      if (data.success) {
        this.notifications = data.notifications || []
        this.updateNotificationList()
        this.updateUnreadCount()
      } else {
        console.error("Failed to load notifications:", data.error)
        this.showError("Không thể tải thông báo: " + (data.error || "Lỗi không xác định"))
      }
    } catch (error) {
      if (error.name === "AbortError") {
        console.error("Request timeout")
        this.showError("Timeout khi tải thông báo")
      } else {
        console.error("Error loading notifications:", error)
        this.showError("Lỗi kết nối: " + error.message)
      }
    } finally {
      this.setLoadingState(false)
    }
  }

  async updateUnreadCount() {
    // Calculate unread count based on notifications not in readNotifications set
    const unreadNotifications = this.notifications.filter(
      (notification) => !this.readNotifications.has(notification.id),
    )
    this.unreadCount = unreadNotifications.length
    this.updateBadge()
  }

  updateBadge() {
    const badge = document.getElementById("adminNotificationBadge")
    if (badge) {
      if (this.unreadCount > 0) {
        badge.textContent = this.unreadCount > 99 ? "99+" : this.unreadCount
        badge.style.display = "flex"
      } else {
        badge.style.display = "none"
      }
    }
  }

  updateNotificationList() {
    const listContainer = document.getElementById("adminNotificationList")
    if (!listContainer) return

    if (this.notifications.length === 0) {
      listContainer.innerHTML = `
                <div class="admin-notification-empty">
                    <i class="fas fa-bell-slash"></i>
                    <p>Không có thông báo nào</p>
                </div>
            `
      return
    }

    const notificationHTML = this.notifications
      .map((notification) => {
        const date = new Date(notification.sendDate)
        const formattedDate = this.formatDate(date)
        const isRead = this.readNotifications.has(notification.id)

        return `
                <div class="admin-notification-item ${isRead ? "read" : "unread"}" data-id="${notification.id}">
                    <div class="admin-notification-title">${this.escapeHtml(notification.title)}</div>
                    <div class="admin-notification-content">${this.escapeHtml(notification.content)}</div>
                    <div class="admin-notification-meta">
                        <span class="admin-notification-type">${this.escapeHtml(notification.type)}</span>
                        <span class="admin-notification-date">${formattedDate}</span>
                    </div>
                </div>
            `
      })
      .join("")

    listContainer.innerHTML = notificationHTML

    // Add click events to notification items
    listContainer.querySelectorAll(".admin-notification-item").forEach((item) => {
      item.addEventListener("click", () => {
        const notificationId = Number.parseInt(item.dataset.id)
        const notification = this.notifications.find((n) => n.id === notificationId)
        if (notification) {
          this.showNotificationDetail(notification)
          this.markAsRead(notificationId)
        }
      })
    })
  }

  showNotificationDetail(notification) {
    const modal = document.getElementById("adminNotificationModal")
    const modalBody = document.getElementById("adminNotificationModalBody")

    if (!modal || !modalBody) return

    const date = new Date(notification.sendDate)
    const formattedDate = this.formatDetailDate(date)

    modalBody.innerHTML = `
            <div class="admin-notification-detail-type">${this.escapeHtml(notification.type)}</div>
            <div class="admin-notification-detail-title">${this.escapeHtml(notification.title)}</div>
            <div class="admin-notification-detail-content">${this.escapeHtml(notification.content)}</div>
            <div class="admin-notification-detail-meta">
                <div>
                    <strong>Đối tượng:</strong> 
                    <span class="admin-notification-detail-recipient">${this.escapeHtml(notification.recipient)}</span>
                </div>
                <div><strong>Ngày gửi:</strong> ${formattedDate}</div>
            </div>
        `

    modal.classList.add("show")
  }

  closeModal() {
    const modal = document.getElementById("adminNotificationModal")
    if (modal) {
      modal.classList.remove("show")
    }
  }

  toggleDropdown() {
    const dropdown = document.getElementById("adminNotificationDropdown")
    if (!dropdown) return

    if (this.isDropdownOpen) {
      this.closeDropdown()
    } else {
      this.openDropdown()
    }
  }

  openDropdown() {
    const dropdown = document.getElementById("adminNotificationDropdown")
    if (dropdown) {
      // Ensure proper positioning
      this.adjustDropdownPosition(dropdown)
      dropdown.classList.add("show")
      this.isDropdownOpen = true
      this.loadNotifications() // Refresh notifications when opening
    }
  }

  closeDropdown() {
    const dropdown = document.getElementById("adminNotificationDropdown")
    if (dropdown) {
      dropdown.classList.remove("show")
      this.isDropdownOpen = false
    }
  }

  async markAsRead(notificationId) {
    try {
      // Add to read notifications set immediately for UI responsiveness
      this.readNotifications.add(notificationId)

      // Update UI immediately
      const notificationItem = document.querySelector(`[data-id="${notificationId}"]`)
      if (notificationItem) {
        notificationItem.classList.remove("unread")
        notificationItem.classList.add("read")
      }

      // Update unread count
      this.updateUnreadCount()

      // Send request to server
      const response = await fetch(`${this.getApiEndpoint()}?action=markRead&id=${notificationId}`)
      const data = await response.json()

      if (!data.success) {
        // If server request fails, revert the change
        this.readNotifications.delete(notificationId)
        if (notificationItem) {
          notificationItem.classList.remove("read")
          notificationItem.classList.add("unread")
        }
        this.updateUnreadCount()
        console.error("Failed to mark notification as read:", data.error)
      }
    } catch (error) {
      // If request fails, revert the change
      this.readNotifications.delete(notificationId)
      const notificationItem = document.querySelector(`[data-id="${notificationId}"]`)
      if (notificationItem) {
        notificationItem.classList.remove("read")
        notificationItem.classList.add("unread")
      }
      this.updateUnreadCount()
      console.error("Error marking notification as read:", error)
    }
  }

  async markAllAsRead() {
    try {
      // Mark all notifications as read immediately for UI responsiveness
      this.notifications.forEach((notification) => {
        this.readNotifications.add(notification.id)
      })

      // Update UI immediately
      document.querySelectorAll(".admin-notification-item.unread").forEach((item) => {
        item.classList.remove("unread")
        item.classList.add("read")
      })

      // Update unread count
      this.updateUnreadCount()

      // Send request to server
      const response = await fetch(`${this.getApiEndpoint()}?action=markAllRead`)
      const data = await response.json()

      if (data.success) {
        this.showSuccess("Đã đánh dấu tất cả thông báo là đã đọc")
      } else {
        console.error("Failed to mark all notifications as read:", data.error)
      }
    } catch (error) {
      console.error("Error marking all notifications as read:", error)
    }
  }

  startPolling() {
    // Poll for new notifications every 30 seconds
    this.pollInterval = setInterval(() => {
      this.loadNotifications()
    }, 30000)
  }

  stopPolling() {
    if (this.pollInterval) {
      clearInterval(this.pollInterval)
      this.pollInterval = null
    }
  }

  formatDate(date) {
    const now = new Date()
    const diffInMinutes = Math.floor((now - date) / (1000 * 60))

    if (diffInMinutes < 1) {
      return "Vừa xong"
    } else if (diffInMinutes < 60) {
      return `${diffInMinutes} phút trước`
    } else if (diffInMinutes < 1440) {
      const hours = Math.floor(diffInMinutes / 60)
      return `${hours} giờ trước`
    } else {
      const days = Math.floor(diffInMinutes / 1440)
      if (days === 1) {
        return "Hôm qua"
      } else if (days < 7) {
        return `${days} ngày trước`
      } else {
        return date.toLocaleDateString("vi-VN")
      }
    }
  }

  formatDetailDate(date) {
    return date.toLocaleString("vi-VN", {
      year: "numeric",
      month: "long",
      day: "numeric",
      hour: "2-digit",
      minute: "2-digit",
    })
  }

  escapeHtml(text) {
    const div = document.createElement("div")
    div.textContent = text
    return div.innerHTML
  }

  showSuccess(message) {
    // Simple toast notification
    const toast = document.createElement("div")
    toast.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            padding: 12px 20px;
            border-radius: 8px;
            z-index: 3000;
            font-size: 14px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            animation: slideInRight 0.3s ease;
        `
    toast.textContent = message
    document.body.appendChild(toast)

    setTimeout(() => {
      toast.remove()
    }, 3000)
  }

  showError(message) {
    // Simple error toast notification
    const toast = document.createElement("div")
    toast.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            background: linear-gradient(135deg, #dc3545, #ff6b6b);
            color: white;
            padding: 12px 20px;
            border-radius: 8px;
            z-index: 3000;
            font-size: 14px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            animation: slideInRight 0.3s ease;
        `
    toast.textContent = message
    document.body.appendChild(toast)

    setTimeout(() => {
      toast.remove()
    }, 3000)
  }

  destroy() {
    this.stopPolling()
  }

  setLoadingState(isLoading) {
    const listContainer = document.getElementById("adminNotificationList")
    if (!listContainer) return

    if (isLoading) {
      listContainer.innerHTML = `
        <div class="admin-notification-loading">
          <i class="fas fa-spinner fa-spin"></i> Đang tải...
        </div>
      `
    }
  }

  adjustDropdownPosition(dropdown) {
    const rect = dropdown.getBoundingClientRect()
    const viewportHeight = window.innerHeight
    const viewportWidth = window.innerWidth

    // Adjust if dropdown goes off screen
    if (rect.bottom > viewportHeight) {
      dropdown.style.top = "auto"
      dropdown.style.bottom = "100%"
      dropdown.style.marginTop = "0"
      dropdown.style.marginBottom = "10px"
    }

    if (rect.right > viewportWidth) {
      dropdown.style.right = "0"
      dropdown.style.left = "auto"
    }
  }

  ensureTopLayer() {
    const container = document.querySelector(".admin-notification-container")
    const dropdown = document.querySelector(".admin-notification-dropdown")

    if (container) {
      container.style.zIndex = "999999"
      container.style.position = "relative"
    }

    if (dropdown) {
      dropdown.style.zIndex = "999999"
      dropdown.style.position = "absolute"
    }
  }
}

// Initialize notification manager when DOM is loaded
document.addEventListener("DOMContentLoaded", () => {
  // Detect user role from URL or other means
  const currentPath = window.location.pathname
  let userRole = "admin"

  if (currentPath.includes("/coordinator/")) {
    userRole = "coordinator"
  }

  // Initialize notification manager
  window.adminNotificationManager = new AdminNotificationManager(userRole)
})

// Clean up when page is unloaded
window.addEventListener("beforeunload", () => {
  if (window.adminNotificationManager) {
    window.adminNotificationManager.destroy()
  }
})
