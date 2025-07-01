
class AdminDashboard {
  constructor() {
    this.charts = {};
    this.dashboardData = window.dashboardData || {};
    this.init();
  }

  init() {
    this.bindEvents();
    this.initializeCharts();
    this.animateStatCards();
  }

  bindEvents() {
    const statCards = document.querySelectorAll(".stat-card");
    statCards.forEach((card) => {
      card.addEventListener("click", () => {
        const cardType = card.querySelector(".icon").classList[1];
        this.navigateToSection(cardType);
      });
    });

    const recentItems = document.querySelectorAll(".recent-item");
    recentItems.forEach((item) => {
      item.addEventListener("mouseenter", () => {
        item.style.transform = "translateX(5px)";
        item.style.transition = "transform 0.3s ease";
      });

      item.addEventListener("mouseleave", () => {
        item.style.transform = "translateX(0)";
      });
    });
  }

  navigateToSection(section) {
    const baseUrl = window.location.origin + "/" + window.location.pathname.split("/")[1] + "/admin/";
    const sectionMap = {
      users: "users",
      courses: "courses",
      materials: "payments",
      tests: "reviews",
    };
    const targetSection = sectionMap[section] || section;
    window.location.href = baseUrl + targetSection;
  }

  initializeCharts() {
    try {
      this.createUserGrowthChart();
      this.createRevenueChart();
      this.createOverviewChart();
    } catch (error) {
      console.error("Error initializing charts:", error);
    }
  }

  createUserGrowthChart() {
    const ctx = document.getElementById("userGrowthChart");
    if (!ctx) return;

    const monthlyStats = this.dashboardData.monthlyStats || {};
    const months = ["Th1", "Th2", "Th3", "Th4", "Th5", "Th6", "Th7", "Th8", "Th9", "Th10", "Th11", "Th12"];
    const data = new Array(12).fill(0);

    try {
      Object.entries(monthlyStats).forEach(([month, value]) => {
        const monthIndex = parseInt(month) - 1;
        if (monthIndex >= 0 && monthIndex < 12) {
          data[monthIndex] = Number(value);
        }
      });
    } catch (error) {
      console.warn("Fallback used for userGrowthChart");
    }

    this.charts.userGrowth = new Chart(ctx.getContext("2d"), {
      type: "line",
      data: {
        labels: months,
        datasets: [{
          label: "Người Dùng Mới",
          data,
          borderColor: "#F39C12",
          backgroundColor: "rgba(243, 156, 18, 0.2)",
          borderWidth: 3,
          fill: true,
          tension: 0.4,
          pointBackgroundColor: "#F39C12",
          pointBorderColor: "#fff",
          pointBorderWidth: 2,
          pointRadius: 5,
        }],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { display: true },
          tooltip: {
            backgroundColor: "rgba(0,0,0,0.8)",
            titleColor: "#fff",
            bodyColor: "#fff",
            borderColor: "#F39C12",
            borderWidth: 1,
          },
        },
        scales: {
          y: {
            beginAtZero: true,
            title: {
              display: true,
              text: "Số Người Dùng",
              font: { size: 12, weight: "bold" },
            },
            ticks: { stepSize: 1 },
          },
          x: {
            title: {
              display: true,
              text: "Tháng",
              font: { size: 12, weight: "bold" },
            },
          },
        },
      },
    });
  }

  createRevenueChart() {
    const ctx = document.getElementById("revenueChart");
    if (!ctx) return;

    const paymentStats = this.dashboardData.paymentStats || {};
    const months = ["Th1", "Th2", "Th3", "Th4", "Th5", "Th6", "Th7", "Th8", "Th9", "Th10", "Th11", "Th12"];
    const data = new Array(12).fill(0);

    try {
      Object.entries(paymentStats).forEach(([month, value]) => {
        const monthIndex = parseInt(month) - 1;
        if (monthIndex >= 0 && monthIndex < 12) {
          data[monthIndex] = Number(value);
        }
      });
    } catch (error) {
      console.warn("Fallback used for revenueChart");
    }

    this.charts.revenue = new Chart(ctx.getContext("2d"), {
      type: "bar",
      data: {
        labels: months,
        datasets: [{
          label: "Doanh Thu (VNĐ)",
          data,
          backgroundColor: "#4A90E2",
          borderColor: "#4A90E2",
          borderWidth: 1,
          borderRadius: 8,
        }],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { display: true },
          tooltip: {
            backgroundColor: "rgba(0,0,0,0.8)",
            titleColor: "#fff",
            bodyColor: "#fff",
            borderColor: "#4A90E2",
            borderWidth: 1,
            callbacks: {
              label: (context) => {
                const value = context.parsed.y;
                return `Doanh Thu: ${new Intl.NumberFormat("vi-VN", {
                  style: "currency", currency: "VND"
                }).format(value)}`;
              },
            },
          },
        },
        scales: {
          y: {
            beginAtZero: true,
            title: {
              display: true,
              text: "Doanh Thu (VNĐ)",
              font: { size: 12, weight: "bold" },
            },
            ticks: {
              callback: (value) =>
                new Intl.NumberFormat("vi-VN", {
                  style: "currency", currency: "VND", notation: "compact"
                }).format(value),
            },
          },
          x: {
            title: {
              display: true,
              text: "Tháng",
              font: { size: 12, weight: "bold" },
            },
          },
        },
      },
    });
  }

  createOverviewChart() {
    const ctx = document.getElementById("overviewChart");
    if (!ctx) {
      console.error("overviewChart canvas not found");
      return;
    }

    const overview = this.dashboardData?.overviewData || {};
    const users = Number(overview.totalUsers || 0);
    const courses = Number(overview.totalCourses || 0);
    const payments = Number(overview.totalPayments || 0);
    const reviews = Number(overview.totalReviews || 0);

    console.log("Overview Chart Data:", { users, courses, payments, reviews });

    this.charts.overview = new Chart(ctx.getContext("2d"), {
      type: "doughnut",
      data: {
        labels: ["Người Dùng", "Khóa Học", "Thanh Toán", "Đánh Giá"],
        datasets: [{
          data: [users, courses, payments, reviews],
          backgroundColor: ["#3498db", "#27ae60", "#f39c12", "#e74c3c"],
          borderWidth: 0
        }],
      },
      options: {
        cutout: "70%",
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { display: false },
          tooltip: {
            callbacks: {
              label: function(context) {
                const label = context.label || '';
                const value = context.parsed || 0;
                return `${label}: ${value.toLocaleString("vi-VN")}`;
              }
            }
          }
        },
      },
    });
  }

  animateStatCards() {
    const statCards = document.querySelectorAll(".stat-card");
    statCards.forEach((card, index) => {
      setTimeout(() => {
        card.style.opacity = "0";
        card.style.transform = "translateY(20px)";
        card.style.transition = "all 0.5s ease";
        setTimeout(() => {
          card.style.opacity = "1";
          card.style.transform = "translateY(0)";
        }, 100);
      }, index * 100);
    });
  }

  formatCurrency(amount) {
    return new Intl.NumberFormat("vi-VN", {
      style: "currency",
      currency: "VND",
    }).format(amount);
  }

  formatDate(date) {
    return new Intl.DateTimeFormat("vi-VN").format(new Date(date));
  }

  refreshDashboard() {
    window.location.reload();
  }

  destroyCharts() {
    Object.values(this.charts).forEach((chart) => {
      if (chart) chart.destroy();
    });
    this.charts = {};
  }
}

// Khởi tạo dashboard sau khi DOM đã sẵn sàng
document.addEventListener("DOMContentLoaded", () => {
  try {
    const dashboard = new AdminDashboard();
  } catch (error) {
    console.error("Error initializing AdminDashboard:", error);
  }

  // Refresh sau 5 phút (tùy chọn)
  setInterval(() => {
    console.log("Auto refreshing dashboard...");
    // dashboard.refreshDashboard(); // Bỏ comment nếu cần
  }, 300000);
});

// Export các hàm toàn cục
window.toggleSidebar = function () {
  const sidebar = document.querySelector(".sidebar");
  const mainContent = document.querySelector(".main-content");
  if (sidebar && mainContent) {
    sidebar.classList.toggle("collapsed");
    mainContent.classList.toggle("expanded");
  }
};
