class ShoppingCart {
  constructor() {
    this.contextPath = window.contextPath || "";
    this.cartData = { cart: null, items: [] };
    this.isInitialLoad = true;
    this.debounceTimeout = null;
    this.init();
  }

  init() {
    this.loadCartData();
    this.checkPaymentStatus();
    this.bindEvents();
  }

  bindEvents() {
    const applyDiscountBtn = document.getElementById("applyDiscount");
    if (applyDiscountBtn) {
      applyDiscountBtn.addEventListener("click", () =>
        this.debounce(this.applyDiscount.bind(this), 500)
      );
    }

    const checkoutBtn = document.getElementById("checkoutBtn");
    if (checkoutBtn) {
      checkoutBtn.addEventListener("click", () => this.checkout());
    }

    const discountInput = document.getElementById("discountCode");
    if (discountInput) {
      discountInput.addEventListener("keypress", (e) => {
        if (e.key === "Enter") {
          e.preventDefault();
          this.debounce(this.applyDiscount.bind(this), 500)();
        }
      });
    }
  }

  debounce(func, wait) {
    return (...args) => {
      clearTimeout(this.debounceTimeout);
      this.debounceTimeout = setTimeout(() => func.apply(this, args), wait);
    };
  }

  async loadCartData(showSpinner = true) {
    const cartList = document.getElementById("cartList");
    const cartEmpty = document.getElementById("cartEmpty");
    const checkoutBtn = document.getElementById("checkoutBtn");
    const cartLoading = document.getElementById("cartLoading");

    if (cartLoading && showSpinner) cartLoading.classList.add("active");
    if (cartList) cartList.classList.add("opacity-0", "hidden");
    if (cartEmpty) cartEmpty.classList.add("hidden");
    if (checkoutBtn) checkoutBtn.disabled = true;

    try {
      const response = await fetch(`${this.contextPath}/cart`, {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: "action=getCartData",
      });

      if (!response.ok) {
        throw new Error(`HTTP error! Status: ${response.status}`);
      }

      const data = await response.json();
      console.log("loadCartData response:", data);
      console.log("Cart items:", data.items);
      // Debug each item's imageUrl
      if (data.items && data.items.length > 0) {
        data.items.forEach((item, index) => {
          console.log(`Item ${index}:`, {
            courseTitle: item.courseTitle,
            courseImageUrl: item.courseImageUrl,
            courseID: item.courseID,
          });
        });
      }

      if (data.success) {
        this.cartData = { cart: data.cart, items: data.items || [] };
        this.displayCartItems(data.cart, data.items || []);
        this.updateCartIcon();
      } else {
        if (data.message === "Bạn cần đăng nhập để thực hiện chức năng này.") {
          this.showMessage(
            "Vui lòng đăng nhập để xem giỏ hàng.",
            "error",
            3000
          );
          (
            () => (window.location.href = `${this.contextPath}/loginPage`)
           
          );
        } else {
          this.showMessage(data.message || "Không thể tải giỏ hàng.", "error");
        }
        this.displayCartItems(null, []);
      }
    } catch (error) {
      console.error("Error loading cart:", error);
      this.showMessage("Lỗi kết nối. Vui lòng thử lại.", "error");
      this.displayCartItems(null, []);
    } finally {
      if (cartLoading && showSpinner) cartLoading.classList.remove("active");
    }
  }

  displayCartItems(cart, items) {
    const cartList = document.getElementById("cartList");
    const cartEmpty = document.getElementById("cartEmpty");
    const cartTotal = document.getElementById("cartTotal");
    const subTotal = document.getElementById("subTotal");
    const discountAmount = document.getElementById("discountAmount");
    const checkoutBtn = document.getElementById("checkoutBtn");
    const cartItemCount = document.getElementById("cartItemCount");

    if (!items || items.length === 0) {
      if (cartList) {
        cartList.innerHTML = "";
        cartList.classList.add("opacity-0", "hidden");
      }
      if (cartEmpty) {
        cartEmpty.classList.remove("hidden");
        cartEmpty.classList.add("opacity-100");
      }
      if (cartTotal) cartTotal.textContent = "0 VNĐ";
      if (subTotal) subTotal.textContent = "0 VNĐ";
      if (discountAmount) discountAmount.textContent = "0 VNĐ";
      if (cartItemCount) cartItemCount.textContent = "0";
      if (checkoutBtn) checkoutBtn.disabled = true;
      return;
    }

    if (cartList) {
      cartList.innerHTML = items
        .map((item) => this.createCartItemHTML(item))
        .join("");
      cartList.classList.remove("hidden");
      cartList.classList.remove("opacity-0");
      cartList.classList.add("opacity-100");

      // Test image loading after DOM is updated
      setTimeout(() => {
        const images = cartList.querySelectorAll("img");
        images.forEach((img) => {
          console.log(
            "Image src:",
            img.src,
            "Complete:",
            img.complete,
            "Natural dimensions:",
            img.naturalWidth,
            "x",
            img.naturalHeight
          );
        });
      }, 100);
    }
    if (cartEmpty) cartEmpty.classList.add("hidden");
    if (checkoutBtn) checkoutBtn.disabled = false;
    if (cartItemCount) cartItemCount.textContent = items.length;

    if (cart) {
      if (cartTotal)
        cartTotal.textContent = this.formatCurrency(cart.totalAmount || 0);
      if (subTotal)
        subTotal.textContent = this.formatCurrency(
          this.calculateSubTotal(items)
        );
      if (discountAmount)
        discountAmount.textContent = this.formatCurrency(
          cart.discountAmount || 0
        );
    }
  }

  calculateSubTotal(items) {
    return items.reduce(
      (total, item) =>
        total +
        (item.priceAtTime * item.quantity - (item.discountApplied || 0)),
      0
    );
  }

  createCartItemHTML(item) {
    console.log(
      "Creating cart item for:",
      item.courseTitle,
      "Image URL:",
      item.courseImageUrl
    );

    // Better fallback logic
    let imageUrl = item.courseImageUrl;
    if (!imageUrl || imageUrl.trim() === "" || imageUrl.trim() === "null") {
      imageUrl = `${this.contextPath}/assets/img/img_student/course.jpg`;
      console.log("Using fallback image for:", item.courseTitle);
    } else {
      // Ensure absolute path
      if (!imageUrl.startsWith("http") && !imageUrl.startsWith("/")) {
        imageUrl = `${this.contextPath}/${imageUrl}`;
      } else if (imageUrl.startsWith("/")) {
        imageUrl = `${this.contextPath}${imageUrl}`;
      }
      console.log(
        "Using database image for:",
        item.courseTitle,
        "->",
        imageUrl
      );
    }

    console.log("Final image URL:", imageUrl);
    const finalPrice =
      item.priceAtTime * item.quantity - (item.discountApplied || 0);
    const escapedTitle = this.escapeHTML(item.courseTitle);
    const escapedDescription = this.escapeHTML(
      item.courseDescription || "Khóa học tiếng Nhật chất lượng cao"
    );

    return `
            <div class="cart-item flex items-center py-6 border-b border-gray-200 transition-opacity duration-300" data-item-id="${
              item.cartItemID
            }">
                <div class="flex-shrink-0">
                    <img src="${imageUrl}" alt="${escapedTitle}" loading="lazy" 
                         onerror="this.onerror=null; this.src='${
                           this.contextPath
                         }/assets/img/img_student/course.jpg';"
                         class="w-20 h-20 object-cover rounded-lg shadow-sm">
                </div>
                <div class="ml-6 flex-1">
                    <h3 class="text-lg font-semibold text-gray-900 mb-1">${escapedTitle}</h3>
                    <p class="text-sm text-gray-600 mb-2 line-clamp-2">${escapedDescription}</p>
                    <div class="flex items-center space-x-4">
                        <div class="flex items-center">
                            <label class="text-sm text-gray-500 mr-2" for="quantity-${
                              item.cartItemID
                            }">Số lượng:</label>
                            <div class="flex items-center border border-gray-300 rounded">
                                <button class="quantity-btn minus px-3 py-1 text-gray-600 hover:bg-gray-100" 
                                        onclick="cart.updateQuantity(${
                                          item.cartItemID
                                        }, ${item.quantity - 1})"
                                        aria-label="Giảm số lượng ${escapedTitle}">-</button>
                                <span class="px-3 py-1 text-center min-w-[40px]" id="quantity-${
                                  item.cartItemID
                                }">${item.quantity}</span>
                                <button class="quantity-btn plus px-3 py-1 text-gray-600 hover:bg-gray-100"
                                        onclick="cart.updateQuantity(${
                                          item.cartItemID
                                        }, ${item.quantity + 1})"
                                        aria-label="Tăng số lượng ${escapedTitle}">+</button>
                            </div>
                        </div>
                        ${
                          item.discountApplied > 0
                            ? `
                                <div class="text-sm">
                                    <span class="text-gray-500 line-through">${this.formatCurrency(
                                      item.priceAtTime * item.quantity
                                    )}</span>
                                    <span class="text-green-600 font-semibold ml-2">${this.formatCurrency(
                                      finalPrice
                                    )}</span>
                                    <span class="text-xs text-green-600 block">Tiết kiệm ${this.formatCurrency(
                                      item.discountApplied
                                    )}</span>
                                </div>
                            `
                            : `
                                <div class="text-lg font-semibold text-gray-900">${this.formatCurrency(
                                  item.priceAtTime * item.quantity
                                )}</div>
                            `
                        }
                    </div>
                </div>
                <div class="ml-6">
                    <button class="remove-btn text-red-500 hover:text-red-700 p-2 rounded-full hover:bg-red-50 transition-colors"
                            onclick="cart.removeItem(${item.cartItemID})" 
                            aria-label="Xóa ${escapedTitle} khỏi giỏ hàng">
                        <i class="fa fa-trash"></i>
                    </button>
                </div>
            </div>
        `;
  }

  escapeHTML(str) {
    return str.replace(
      /[&<>"']/g,
      (match) =>
        ({
          "&": "&amp;",
          "<": "&lt;",
          ">": "&gt;",
          '"': "&quot;",
          "'": "&#39;",
        }[match])
    );
  }

  async addToCart(courseID) {
    console.log("addToCart called with courseID:", courseID);
    if (!courseID || !courseID.match(/^CO\d{3}$/)) {
      this.showMessage("Mã khóa học không hợp lệ.", "error");
      return;
    }

    try {
      const response = await fetch(`${this.contextPath}/cart`, {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: `action=addToCart&courseID=${encodeURIComponent(courseID)}`,
      });

      if (!response.ok) {
        throw new Error(`HTTP error! Status: ${response.status}`);
      }

      const data = await response.json();
      console.log("addToCart response:", data);

      if (data.success) {
        this.showMessage(
          data.message || "Đã thêm khóa học vào giỏ hàng!",
          "success"
        );
        await this.loadCartData(false);
      } else {
        if (data.message === "Bạn cần đăng nhập để thực hiện chức năng này.") {
          this.showMessage(
            "Vui lòng đăng nhập để thêm khóa học.",
            "error",
            3000
          );
          (() => {
            window.location.href = `${this.contextPath}/loginPage`;
          });
        } else {
          this.showMessage(
            data.message || "Không thể thêm vào giỏ hàng.",
            "error"
          );
        }
      }
    } catch (error) {
      console.error("Error adding to cart:", error);
      this.showMessage("Lỗi kết nối. Vui lòng thử lại.", "error");
    }
  }

  async updateQuantity(cartItemID, newQuantity) {
    if (newQuantity < 1) {
      this.removeItem(cartItemID);
      return;
    }
    if (newQuantity > 10) {
      this.showMessage("Số lượng tối đa là 10.", "error");
      return;
    }

    try {
      const response = await fetch(`${this.contextPath}/cart`, {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: `action=updateQuantity&cartItemID=${cartItemID}&quantity=${newQuantity}`,
      });

      if (!response.ok) {
        throw new Error(`HTTP error! Status: ${response.status}`);
      }

      const data = await response.json();
      console.log("updateQuantity response:", data);

      if (data.success) {
        const item = this.cartData.items.find(
          (i) => i.cartItemID === cartItemID
        );
        if (item) {
          item.quantity = newQuantity;
          item.totalPrice =
            item.priceAtTime * newQuantity - (item.discountApplied || 0);
        }
        await this.loadCartData(false);
        this.showMessage("Đã cập nhật số lượng.", "success");
      } else {
        this.showMessage(
          data.message || "Không thể cập nhật số lượng.",
          "error"
        );
      }
    } catch (error) {
      console.error("Error updating quantity:", error);
      this.showMessage("Lỗi kết nối. Vui lòng thử lại.", "error");
    }
  }

  async removeItem(cartItemID) {
    if (!confirm("Bạn có chắc muốn xóa khóa học này khỏi giỏ hàng?")) {
      return;
    }

    try {
      const response = await fetch(`${this.contextPath}/cart`, {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: `action=removeItem&cartItemID=${cartItemID}`,
      });

      if (!response.ok) {
        throw new Error(`HTTP error! Status: ${response.status}`);
      }

      const data = await response.json();
      console.log("removeItem response:", data);

      if (data.success) {
        this.cartData.items = this.cartData.items.filter(
          (i) => i.cartItemID !== cartItemID
        );
        await this.loadCartData(false);
        this.showMessage("Đã xóa khóa học khỏi giỏ hàng.", "success");
      } else {
        this.showMessage(data.message || "Không thể xóa khóa học.", "error");
      }
    } catch (error) {
      console.error("Error removing item:", error);
      this.showMessage("Lỗi kết nối. Vui lòng thử lại.", "error");
    }
  }

  async applyDiscount() {
    const discountInput = document.getElementById("discountCode");
    const discountMessage = document.getElementById("discountMessage");
    const applyBtn = document.getElementById("applyDiscount");
    const btnText = applyBtn.querySelector(".btn-text");
    const btnSpinner = applyBtn.querySelector(".btn-spinner");
    const discountCode = discountInput.value.trim();

    if (discountMessage) {
      discountMessage.textContent = "";
      discountMessage.className = "discount-message";
    }

    if (!discountCode) {
      this.showMessage("Vui lòng nhập mã giảm giá.", "error");
      if (discountMessage) {
        discountMessage.textContent = "Vui lòng nhập mã giảm giá.";
        discountMessage.className = "discount-message error";
      }
      discountInput.focus();
      return;
    }

    applyBtn.disabled = true;
    if (btnText) btnText.style.display = "none";
    if (btnSpinner) btnSpinner.style.display = "inline-block";

    try {
      const response = await fetch(`${this.contextPath}/cart`, {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: `action=applyDiscount&discountCode=${encodeURIComponent(
          discountCode
        )}`,
      });

      if (!response.ok) {
        throw new Error(`HTTP error! Status: ${response.status}`);
      }

      const data = await response.json();
      console.log("applyDiscount response:", data);

      if (data.success) {
        await this.loadCartData(false);
        this.showMessage(data.message, "success");
        if (discountMessage) {
          discountMessage.textContent = data.message;
          discountMessage.className = "discount-message success";
        }
        discountInput.value = "";
      } else {
        this.showMessage(data.message || "Mã giảm giá không hợp lệ.", "error");
        if (discountMessage) {
          discountMessage.textContent =
            data.message || "Mã giảm giá không hợp lệ.";
          discountMessage.className = "discount-message error";
        }
        discountInput.focus();
      }
    } catch (error) {
      console.error("Error applying discount:", error);
      this.showMessage("Lỗi kết nối. Vui lòng thử lại.", "error");
      if (discountMessage) {
        discountMessage.textContent = "Lỗi kết nối. Vui lòng thử lại.";
        discountMessage.className = "discount-message error";
      }
    } finally {
      applyBtn.disabled = false;
      if (btnText) btnText.style.display = "inline";
      if (btnSpinner) btnSpinner.style.display = "none";
    }
  }

  async checkout() {
    const checkoutBtn = document.getElementById("checkoutBtn");
    if (checkoutBtn.disabled) return;

    if (!confirm("Bạn có chắc muốn thanh toán các khóa học trong giỏ hàng?")) {
      return;
    }

    checkoutBtn.disabled = true;
    checkoutBtn.innerHTML =
      '<i class="fa fa-spinner fa-spin"></i> Đang xử lý...';

    try {
      const response = await fetch(`${this.contextPath}/cart`, {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: `action=checkout`,
      });

      if (!response.ok) {
        throw new Error(`HTTP error! Status: ${response.status}`);
      }

      const data = await response.json();
      console.log("checkout response:", data);

      if (data.success && data.redirectUrl) {
        window.location.href = data.redirectUrl;
      } else {
        if (data.message === "Bạn cần đăng nhập để thực hiện chức năng này.") {
          this.showMessage("Vui lòng đăng nhập để thanh toán.", "error", 3000);
          (() => {
            window.location.href = `${this.contextPath}/loginPage`;
          });
        } else {
          this.showMessage(
            data.message ||
              "Không thể tạo liên kết thanh toán. Vui lòng thử lại.",
            "error"
          );
        }
        checkoutBtn.disabled = false;
        checkoutBtn.innerHTML = "Thanh toán ngay";
      }
    } catch (error) {
      console.error("Error during checkout:", error);
      this.showMessage("Lỗi kết nối với PayOS. Vui lòng thử lại.", "error");
      checkoutBtn.disabled = false;
      checkoutBtn.innerHTML = "Thanh toán ngay";
    }
  }

  checkPaymentStatus() {
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.has("error")) {
      const error = urlParams.get("error");
      const transactionID = urlParams.get("transactionID");
      const failedCourses = urlParams.get("failedCourses");
      let message = "Lỗi thanh toán: ";
      switch (error) {
        case "empty_cart":
          message += "Giỏ hàng trống.";
          break;
        case "payment_failed":
          message += `Thanh toán thất bại. Mã giao dịch: ${
            transactionID || "N/A"
          }.`;
          break;
        case "payment_cancelled":
          message += `Thanh toán đã bị hủy. Mã giao dịch: ${
            transactionID || "N/A"
          }.`;
          break;
        case "partial_enrollment":
          message += `Không thể ghi danh một số khóa học: ${
            failedCourses || "N/A"
          }. Vui lòng liên hệ hỗ trợ.`;
          break;
        case "invalid_session":
          message += "Vui lòng đăng nhập lại.";
          setTimeout(
            () => (window.location.href = `${this.contextPath}/login.jsp`),
            2000
          );
          break;
        case "payment_error":
          message += `Lỗi xử lý thanh toán. Mã giao dịch: ${
            transactionID || "N/A"
          }.`;
          break;
        case "invalid_request":
          message += "Yêu cầu không hợp lệ.";
          break;
        case "unknown_status":
          message += "Trạng thái thanh toán không xác định.";
          break;
        case "cart_clear_failed":
          message +=
            "Thanh toán thành công nhưng không thể xóa giỏ hàng. Vui lòng liên hệ hỗ trợ.";
          break;
        default:
          message += error;
      }
      this.showMessage(message, "error");
      window.history.replaceState({}, document.title, window.location.pathname);
    } else if (urlParams.has("success")) {
      this.showMessage(
        "Thanh toán thành công! Các khóa học đã được ghi danh.",
        "success"
      );
      window.history.replaceState({}, document.title, window.location.pathname);
    }
  }

  formatCurrency(amount) {
    return new Intl.NumberFormat("vi-VN", {
      style: "currency",
      currency: "VND",
      minimumFractionDigits: 0,
    }).format(amount);
  }

  // CHANGE START: Modified showMessage to use window.showMessage exclusively
  showMessage(message, type, duration = 5000) {
    console.log("ShoppingCart.showMessage called:", {
      message,
      type,
      duration,
    });
    if (typeof window.showMessage === "function") {
      window.showMessage(message, type, duration);
    } else {
      console.error("window.showMessage is not defined");
      // Log to console as a fallback, but do not use alert
      console.log(`${type.toUpperCase()}: ${message}`);
    }
  }
  // CHANGE END

  updateCartIcon() {
    const cartBadge = document.querySelector(".cart-badge");
    if (cartBadge && this.cartData.cart) {
      cartBadge.textContent = this.cartData.cart.itemCount || 0;
      cartBadge.style.display =
        this.cartData.cart.itemCount > 0 ? "flex" : "none";
    }
  }
}

let cart;
document.addEventListener("DOMContentLoaded", () => {
  cart = new ShoppingCart();
});

window.cart = {
  updateQuantity: (cartItemID, quantity) =>
    cart.debounce(cart.updateQuantity.bind(cart), 500)(cartItemID, quantity),
  removeItem: (cartItemID) => cart.removeItem(cartItemID),
  addToCart: (courseID) => cart.addToCart(courseID),
};