// Enhanced shopping cart functionality with real backend integration
class ShoppingCart {
  constructor() {
    this.contextPath = window.contextPath || ""
    this.init()
  }

  init() {
    this.loadCartData()
    this.bindEvents()
    this.updateCartDisplay()
  }

  bindEvents() {
    // Apply discount button
    const applyDiscountBtn = document.getElementById("applyDiscount")
    if (applyDiscountBtn) {
      applyDiscountBtn.addEventListener("click", () => this.applyDiscount())
    }

    // Checkout button
    const checkoutBtn = document.getElementById("checkoutBtn")
    if (checkoutBtn) {
      checkoutBtn.addEventListener("click", () => this.checkout())
    }

    // Enter key for discount code
    const discountInput = document.getElementById("discountCode")
    if (discountInput) {
      discountInput.addEventListener("keypress", (e) => {
        if (e.key === "Enter") {
          e.preventDefault() // Prevent form submission
          this.applyDiscount()
        }
      })
    }
  }

  async loadCartData() {
    const cartLoading = document.getElementById("cartLoading")
    const cartList = document.getElementById("cartList")
    const cartEmpty = document.getElementById("cartEmpty")
    const checkoutBtn = document.getElementById("checkoutBtn")

    if (cartLoading) cartLoading.classList.remove("hidden")
    if (cartList) cartList.classList.add("hidden")
    if (cartEmpty) cartEmpty.classList.add("hidden")
    if (checkoutBtn) checkoutBtn.disabled = true

    try {
      const response = await fetch(`${this.contextPath}/cart`, {
        method: "POST",
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: "action=getCartData",
      })

      const data = await response.json()

      if (data.success) {
        this.displayCartItems(data.cart, data.items)
      } else {
        this.showMessage(data.message || "Không thể tải giỏ hàng.", "error")
        this.displayCartItems(null, []) // Show empty cart state
      }
    } catch (error) {
      console.error("Error loading cart:", error)
      this.showMessage("Lỗi kết nối. Vui lòng thử lại.", "error")
      this.displayCartItems(null, []) // Show empty cart state
    } finally {
      if (cartLoading) cartLoading.classList.add("hidden")
    }
  }

  displayCartItems(cart, items) {
    const cartList = document.getElementById("cartList")
    const cartEmpty = document.getElementById("cartEmpty")
    const cartTotal = document.getElementById("cartTotal")
    const checkoutBtn = document.getElementById("checkoutBtn")

    if (!items || items.length === 0) {
      if (cartList) cartList.classList.add("hidden")
      if (cartEmpty) cartEmpty.classList.remove("hidden")
      if (checkoutBtn) checkoutBtn.disabled = true
      if (cartTotal) cartTotal.textContent = "0 VNĐ"
      return
    }

    if (cartList) cartList.classList.remove("hidden")
    if (cartEmpty) cartEmpty.classList.add("hidden")
    if (checkoutBtn) checkoutBtn.disabled = false

    // Generate cart items HTML
    if (cartList) {
      cartList.innerHTML = items.map((item) => this.createCartItemHTML(item)).join("")
    }

    // Update total
    if (cartTotal && cart) {
      cartTotal.textContent = this.formatCurrency(cart.totalAmount)
    }

    // Bind item-specific events (already handled by onclick in HTML)
  }

  createCartItemHTML(item) {
    const imageUrl = item.courseImageUrl || `${this.contextPath}/assets/img/course-placeholder.jpg`
    const finalPrice = item.totalPrice - item.discountApplied

    return `
          <div class="cart-item flex items-center py-6 border-b border-gray-200" data-item-id="${item.cartItemID}">
              <div class="flex-shrink-0">
                  <img src="${imageUrl}" alt="${item.courseTitle}" 
                       class="w-20 h-20 object-cover rounded-lg shadow-sm"
                       onerror="this.src='${this.contextPath}/assets/img/course-placeholder.jpg'">
              </div>
              <div class="ml-6 flex-1">
                  <h3 class="text-lg font-semibold text-gray-900 mb-1">${item.courseTitle}</h3>
                  <p class="text-sm text-gray-600 mb-2">${item.courseDescription || "Khóa học tiếng Nhật chất lượng cao"}</p>
                  <div class="flex items-center space-x-4">
                      <div class="flex items-center">
                          <label class="text-sm text-gray-500 mr-2">Số lượng:</label>
                          <div class="flex items-center border border-gray-300 rounded">
                              <button class="quantity-btn minus px-3 py-1 text-gray-600 hover:bg-gray-100" 
                                      onclick="cart.updateQuantity(${item.cartItemID}, ${item.quantity - 1})">-</button>
                              <span class="px-3 py-1 text-center min-w-[40px]">${item.quantity}</span>
                              <button class="quantity-btn plus px-3 py-1 text-gray-600 hover:bg-gray-100"
                                      onclick="cart.updateQuantity(${item.cartItemID}, ${item.quantity + 1})">+</button>
                          </div>
                      </div>
                      ${
                        item.discountApplied > 0
                          ? `
                          <div class="text-sm">
                              <span class="text-gray-500 line-through">${this.formatCurrency(item.totalPrice)}</span>
                              <span class="text-green-600 font-semibold ml-2">${this.formatCurrency(finalPrice)}</span>
                              <span class="text-xs text-green-600 block">Tiết kiệm ${this.formatCurrency(item.discountApplied)}</span>
                          </div>
                      `
                          : `
                          <div class="text-lg font-semibold text-gray-900">${this.formatCurrency(item.totalPrice)}</div>
                      `
                      }
                  </div>
              </div>
              <div class="ml-6">
                  <button class="remove-btn text-red-500 hover:text-red-700 p-2 rounded-full hover:bg-red-50 transition-colors"
                          onclick="cart.removeItem(${item.cartItemID})" title="Xóa khỏi giỏ hàng">
                      <i class="fa fa-trash"></i>
                  </button>
              </div>
          </div>
      `
  }

  async addToCart(courseID) {
    try {
      const response = await fetch(`${this.contextPath}/cart`, {
        method: "POST",
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: `action=addToCart&courseID=${courseID}`,
      })

      const data = await response.json()

      if (data.success) {
        this.showMessage(data.message, "success")
        this.updateCartIcon() // Update cart icon immediately
      } else {
        this.showMessage(data.message, "error")
      }
    } catch (error) {
      console.error("Error adding to cart:", error)
      this.showMessage("Lỗi kết nối. Vui lòng thử lại.", "error")
    }
  }

  async updateQuantity(cartItemID, newQuantity) {
    if (newQuantity < 1) {
      this.removeItem(cartItemID)
      return
    }

    try {
      const response = await fetch(`${this.contextPath}/cart`, {
        method: "POST",
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: `action=updateQuantity&cartItemID=${cartItemID}&quantity=${newQuantity}`,
      })

      const data = await response.json()

      if (data.success) {
        this.loadCartData() // Reload cart to get updated totals
        this.showMessage("Đã cập nhật số lượng", "success")
      } else {
        this.showMessage(data.message || "Không thể cập nhật số lượng", "error")
      }
    } catch (error) {
      console.error("Error updating quantity:", error)
      this.showMessage("Lỗi kết nối. Vui lòng thử lại.", "error")
    }
  }

  async removeItem(cartItemID) {
    if (!confirm("Bạn có chắc muốn xóa khóa học này khỏi giỏ hàng?")) {
      return
    }

    try {
      const response = await fetch(`${this.contextPath}/cart`, {
        method: "POST",
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: `action=removeItem&cartItemID=${cartItemID}`,
      })

      const data = await response.json()

      if (data.success) {
        this.loadCartData() // Reload cart
        this.showMessage("Đã xóa khóa học khỏi giỏ hàng", "success")
        this.updateCartIcon() // Update cart icon
      } else {
        this.showMessage(data.message || "Không thể xóa khóa học", "error")
      }
    } catch (error) {
      console.error("Error removing item:", error)
      this.showMessage("Lỗi kết nối. Vui lòng thử lại.", "error")
    }
  }

  async applyDiscount() {
    const discountInput = document.getElementById("discountCode")
    const discountCode = discountInput.value.trim()

    if (!discountCode) {
      this.showMessage("Vui lòng nhập mã giảm giá", "error")
      return
    }

    try {
      const response = await fetch(`${this.contextPath}/cart`, {
        method: "POST",
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: `action=applyDiscount&discountCode=${encodeURIComponent(discountCode)}`,
      })

      const data = await response.json()

      if (data.success) {
        this.loadCartData() // Reload cart to show discount
        this.showMessage(data.message, "success")
        discountInput.value = "" // Clear input
      } else {
        this.showMessage(data.message || "Mã giảm giá không hợp lệ", "error")
      }
    } catch (error) {
      console.error("Error applying discount:", error)
      this.showMessage("Lỗi kết nối. Vui lòng thử lại.", "error")
    }
  }

  async checkout() {
    if (!confirm("Bạn có chắc muốn thanh toán các khóa học trong giỏ hàng?")) {
      return
    }

    try {
      this.showMessage("Đang xử lý thanh toán...", "info")

      const response = await fetch(`${this.contextPath}/cart`, {
        method: "POST",
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: `action=checkout`,
      })

      const data = await response.json()

      if (data.success) {
        this.showMessage(data.message, "success")
        this.loadCartData() // Reload cart to show it's empty
        this.updateCartIcon() // Update cart icon
        // Optionally redirect to a success page or user's enrolled courses
        setTimeout(() => {
          window.location.href = `${this.contextPath}/view/student/my-courses.jsp` // Example redirect
        }, 2000)
      } else {
        this.showMessage(data.message || "Lỗi trong quá trình thanh toán", "error")
      }
    } catch (error) {
      console.error("Error during checkout:", error)
      this.showMessage("Lỗi kết nối. Vui lòng thử lại.", "error")
    }
  }

  formatCurrency(amount) {
    return new Intl.NumberFormat("vi-VN", {
      style: "currency",
      currency: "VND",
      minimumFractionDigits: 0,
    }).format(amount)
  }

  showMessage(message, type = "info") {
    // Remove existing messages
    const existingMessages = document.querySelectorAll(".cart-message")
    existingMessages.forEach((msg) => msg.remove())

    // Create message element
    const messageDiv = document.createElement("div")
    messageDiv.className = `cart-message fixed top-4 right-4 px-6 py-3 rounded-lg shadow-lg z-50 ${
      type === "success"
        ? "bg-green-500 text-white"
        : type === "error"
          ? "bg-red-500 text-white"
          : "bg-blue-500 text-white"
    }`
    messageDiv.textContent = message

    document.body.appendChild(messageDiv)

    // Auto remove after 5 seconds
    setTimeout(() => {
      messageDiv.remove()
    }, 5000)
  }

  updateCartDisplay() {
    // Update cart icon in header if exists
    this.updateCartIcon()
  }

  async updateCartIcon() {
    try {
      const response = await fetch(`${this.contextPath}/cart`, {
        method: "POST",
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: "action=getCartData",
      })

      const data = await response.json()

      if (data.success && data.cart) {
        const cartBadge = document.querySelector(".cart-badge")
        if (cartBadge) {
          cartBadge.textContent = data.cart.itemCount
          cartBadge.style.display = data.cart.itemCount > 0 ? "flex" : "none" // Use flex for centering
        }
      } else {
        const cartBadge = document.querySelector(".cart-badge")
        if (cartBadge) {
          cartBadge.textContent = "0"
          cartBadge.style.display = "none"
        }
      }
    } catch (error) {
      console.error("Error updating cart icon:", error)
    }
  }
}

// Global cart instance
let cart

// Initialize when DOM is loaded
document.addEventListener("DOMContentLoaded", () => {
  cart = new ShoppingCart()
})

// Global functions for onclick handlers
window.cart = {
  updateQuantity: (cartItemID, quantity) => cart.updateQuantity(cartItemID, quantity),
  removeItem: (cartItemID) => cart.removeItem(cartItemID),
  addToCart: (courseID) => cart.addToCart(courseID), // Expose addToCart globally
}

// Modal control functions (keeping existing functionality)
function openModal() {
  document.getElementById("signupModal").style.display = "flex"
}

function closeModal() {
  document.getElementById("signupModal").style.display = "none"
}

// Close modal when clicking outside
window.onclick = (event) => {
  const modal = document.getElementById("signupModal")
  if (event.target === modal) {
    closeModal()
  }
}
