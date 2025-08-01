document.addEventListener("DOMContentLoaded", () => {
  // Animate level cards on scroll
  const levelCards = document.querySelectorAll(".level-card");
  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.classList.add("animate-fadeInUp");
          observer.unobserve(entry.target); // Stop observing after animation
        }
      });
    },
    { threshold: 0.2 }
  );

  levelCards.forEach((card) => observer.observe(card));

  // Enhanced notification system
  window.showNotification = function (message, type = "info", duration = 5000) {
    try {
      // Remove existing notifications
      const existing = document.querySelectorAll(".notification-message");
      existing.forEach((notification) => {
        notification.style.transform = "translateX(100%)";
        setTimeout(() => {
          if (notification.parentNode) {
            notification.remove();
          }
        }, 300);
      });

      const notification = document.createElement("div");
      notification.className = `notification-message fixed top-4 right-4 ${type} text-white px-6 py-4 rounded-lg shadow-lg z-50 transform translate-x-full transition-all duration-300 max-w-sm`;

      const icons = {
        success: "fas fa-check-circle",
        error: "fas fa-exclamation-circle",
        warning: "fas fa-exclamation-triangle",
        info: "fas fa-info-circle",
      };

      notification.innerHTML = `
        <div class="flex items-start">
          <i class="${icons[type]} mr-3 mt-0.5 flex-shrink-0"></i>
          <div class="flex-1">
            <div class="font-medium">${message}</div>
          </div>
          <button onclick="this.parentElement.parentElement.remove()" 
                  class="ml-4 text-white hover:text-gray-200 flex-shrink-0">
            <i class="fas fa-times"></i>
          </button>
        </div>
      `;

      document.body.appendChild(notification);

      // Slide in
      setTimeout(() => {
        notification.style.transform = "translateX(0)";
      }, 100);

      // Auto remove
      if (duration > 0) {
        setTimeout(() => {
          if (notification.parentNode) {
            notification.style.transform = "translateX(100%)";
            setTimeout(() => {
              if (notification.parentNode) {
                notification.remove();
              }
            }, 300);
          }
        }, duration);
      }

      return notification;
    } catch (error) {
      console.error("Error showing notification:", error);
    }
  };

  // Enhanced button loading state
  window.setButtonLoading = function (button, loading = true) {
    if (loading) {
      button.disabled = true;
      button.classList.add("btn-loading");
    } else {
      button.disabled = false;
      button.classList.remove("btn-loading");
    }
  };

  // Enhanced modal functions
  window.showModal = function (modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
      modal.classList.remove("hidden");
      modal.classList.add("show");
      modal.classList.remove("hide");
      document.body.style.overflow = "hidden";
    }
  };

  window.hideModal = function (modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
      modal.classList.add("hide");
      modal.classList.remove("show");
      setTimeout(() => {
        modal.classList.add("hidden");
        modal.classList.remove("hide");
        document.body.style.overflow = "";
      }, 300);
    }
  };

  // Enhanced error handling and debugging
  window.addEventListener("load", function () {
    console.log("Window loaded");
    console.log("Document ready state:", document.readyState);

    // Check for navigation errors
    if (performance.navigation.type === performance.navigation.TYPE_RELOAD) {
      console.log("Page was reloaded");
    }

    // Monitor for any JavaScript errors
    window.addEventListener("error", function (e) {
      console.error("JavaScript error:", e.error);
      console.error("Error at:", e.filename, "line", e.lineno);
    });
  });

  // Enhanced URL handling
  window.handleCourseNavigation = function (courseId) {
    if (!courseId || courseId.trim() === "") {
      console.error("Invalid course ID provided");
      window.showNotification("ID khóa học không hợp lệ", "error");
      return;
    }

    // Validate course ID format
    if (!/^CO\d{3}$/.test(courseId)) {
      console.error("Invalid course ID format:", courseId);
      window.showNotification("Định dạng ID khóa học không đúng", "error");
      return;
    }

    const baseUrl =
      window.location.origin +
      window.location.pathname.substring(
        0,
        window.location.pathname.indexOf("/", 1)
      );
    const targetUrl = `${baseUrl}/courseInfo?id=${encodeURIComponent(
      courseId
    )}&timestamp=${Date.now()}`;

    console.log("Navigating to course:", courseId);
    console.log("Target URL:", targetUrl);

    // Show loading indicator
    window.showNotification("Đang tải thông tin khóa học...", "info", 2000);

    // Navigate with a small delay to show the loading message
    setTimeout(() => {
      window.location.href = targetUrl;
    }, 100);
  };
});
