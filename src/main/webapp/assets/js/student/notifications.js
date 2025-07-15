class NotificationManager {
  constructor() {
    this.contextPath = window.contextPath || ""
    this.isDropdownOpen = false
    this.notifications = []
    this.unreadCount = 0
    this.pollInterval = null
    this.readNotifications = new Set() // Track read notifications locally

    this.init()
  }

  init() {
    this.createNotificationElements()
    this.createModal()
    this.bindEvents()
    this.loadNotifications()
    this.startPolling()
  }

  createNotificationElements() {
    const bellButton = document.querySelector(".notification-bell-btn")
    if (!bellButton) return

    // Create notification container
    const container = document.createElement("div")
    container.className = "notification-container"

    // Create bell button with badge
    container.innerHTML = `
            <button class="notification-bell" id="notificationBell">
                <i class="fa fa-bell"></i>
                <span class="notification-badge" id="notificationBadge" style="display: none;">0</span>
            </button>
            <div class="notification-dropdown" id="notificationDropdown">
                <div class="notification-header">
                    <h4><i class="fa fa-bell"></i> Thông báo</h4>
                    <button class="mark-all-read" id="markAllRead">
                        <i class="fa fa-check"></i> Đánh dấu đã đọc
                    </button>
                </div>
                <div class="notification-list" id="notificationList">
                    <div class="notification-loading">
                        <i class="fa fa-spinner"></i> Đang tải...
                    </div>
                </div>
            </div>
        `

    // Replace the original bell button
    bellButton.parentNode.replaceChild(container, bellButton)
  }

  createModal() {
    // Create modal for notification details
    const modal = document.createElement("div")
    modal.className = "notification-modal"
    modal.id = "notificationModal"
    modal.innerHTML = `
            <div class="notification-modal-content">
                <div class="notification-modal-header">
                    <h3><i class="fa fa-bell"></i> Chi tiết thông báo</h3>
                    <button class="notification-modal-close" id="closeNotificationModal">
                        <i class="fa fa-times"></i>
                    </button>
                </div>
                <div class="notification-modal-body" id="notificationModalBody">
                    <!-- Content will be populated dynamically -->
                </div>
            </div>
        `

    document.body.appendChild(modal)
  }

  bindEvents() {
    const bellButton = document.getElementById("notificationBell")
    const dropdown = document.getElementById("notificationDropdown")
    const markAllReadBtn = document.getElementById("markAllRead")
    const modal = document.getElementById("notificationModal")
    const closeModalBtn = document.getElementById("closeNotificationModal")

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
      if (!e.target.closest(".notification-container")) {
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
      const response = await fetch(`${this.contextPath}/student/notifications?action=list`)
      const data = await response.json()

      if (data.success) {
        this.notifications = data.notifications || []
        this.updateNotificationList()
        this.updateUnreadCount()
      } else {
        console.error("Failed to load notifications:", data.error)
      }
    } catch (error) {
      console.error("Error loading notifications:", error)
      this.showError("Không thể tải thông báo")
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
    const badge = document.getElementById("notificationBadge")
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
    const listContainer = document.getElementById("notificationList")
    if (!listContainer) return

    if (this.notifications.length === 0) {
      listContainer.innerHTML = `
                <div class="notification-empty">
                    <i class="fa fa-bell-slash"></i>
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
                <div class="notification-item ${isRead ? "read" : "unread"}" data-id="${notification.id}">
                    <div class="notification-title">${this.escapeHtml(notification.title)}</div>
                    <div class="notification-content">${this.escapeHtml(notification.content)}</div>
                    <div class="notification-meta">
                        <span class="notification-type">${this.escapeHtml(notification.type)}</span>
                        <span class="notification-date">${formattedDate}</span>
                    </div>
                </div>
            `
      })
      .join("")

    listContainer.innerHTML = notificationHTML

    // Add click events to notification items
    listContainer.querySelectorAll(".notification-item").forEach((item) => {
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
    const modal = document.getElementById("notificationModal")
    const modalBody = document.getElementById("notificationModalBody")

    if (!modal || !modalBody) return

    const date = new Date(notification.sendDate)
    const formattedDate = this.formatDetailDate(date)

    modalBody.innerHTML = `
            <div class="notification-detail-type">${this.escapeHtml(notification.type)}</div>
            <div class="notification-detail-title">${this.escapeHtml(notification.title)}</div>
            <div class="notification-detail-content">${this.escapeHtml(notification.content)}</div>
            <div class="notification-detail-meta">
                <div>
                    <strong>Đối tượng:</strong> 
                    <span class="notification-detail-recipient">${this.escapeHtml(notification.recipient)}</span>
                </div>
                <div><strong>Ngày gửi:</strong> ${formattedDate}</div>
            </div>
        `

    modal.classList.add("show")
  }

  closeModal() {
    const modal = document.getElementById("notificationModal")
    if (modal) {
      modal.classList.remove("show")
    }
  }

  toggleDropdown() {
    const dropdown = document.getElementById("notificationDropdown")
    if (!dropdown) return

    if (this.isDropdownOpen) {
      this.closeDropdown()
    } else {
      this.openDropdown()
    }
  }

  openDropdown() {
    const dropdown = document.getElementById("notificationDropdown")
    if (dropdown) {
      dropdown.classList.add("show")
      this.isDropdownOpen = true
      this.loadNotifications() // Refresh notifications when opening
    }
  }

  closeDropdown() {
    const dropdown = document.getElementById("notificationDropdown")
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
      const response = await fetch(`${this.contextPath}/student/notifications?action=markRead&id=${notificationId}`)
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
      document.querySelectorAll(".notification-item.unread").forEach((item) => {
        item.classList.remove("unread")
        item.classList.add("read")
      })

      // Update unread count
      this.updateUnreadCount()

      // Send request to server
      const response = await fetch(`${this.contextPath}/student/notifications?action=markAllRead`)
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
}

// Initialize notification manager when DOM is loaded
document.addEventListener("DOMContentLoaded", () => {
  // Only initialize if user is logged in and bell button exists
  if (document.querySelector(".icon-btn i.fa-bell")) {
    window.notificationManager = new NotificationManager()
  }
})

// Clean up when page is unloaded
window.addEventListener("beforeunload", () => {
  if (window.notificationManager) {
    window.notificationManager.destroy()
  }
})
