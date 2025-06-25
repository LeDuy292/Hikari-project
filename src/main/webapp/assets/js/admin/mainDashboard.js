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
    // Add click handlers for stat cards
    const statCards = document.querySelectorAll(".stat-card");
    statCards.forEach((card) => {
      card.addEventListener("click", () => {
        const cardType = card.querySelector(".icon").classList[1];
        this.navigateToSection(cardType);
      });
    });

    // Add hover effects for recent items
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
    } catch (error) {
      console.error("Error initializing charts:", error);
    }
  }

  createUserGrowthChart() {
    const ctx = document.getElementById("userGrowthChart");
    if (!ctx) {
      console.error("User Growth Chart canvas not found");
      return;
    }

    const monthlyStats = this.dashboardData.monthlyStats || {};
    const months = ["Th1", "Th2", "Th3", "Th4", "Th5", "Th6", "Th7", "Th8", "Th9", "Th10", "Th11", "Th12"];
    
    // Fallback data if monthlyStats is empty
    const data = new Array(12).fill(0);
    try {
      if (Object.keys(monthlyStats).length > 0) {
        Object.entries(monthlyStats).forEach(([month, value]) => {
          const monthIndex = parseInt(month) - 1;
          if (monthIndex >= 0 && monthIndex < 12 && !isNaN(value)) {
            data[monthIndex] = Number(value);
          }
        });
      } else {
        console.warn("No monthlyStats data available, using fallback data");
      }
    } catch (error) {
      console.error("Error processing user growth data:", error);
    }

    console.log("User Growth Chart Data:", data);

    try {
      this.charts.userGrowth = new Chart(ctx.getContext('2d'), {
        type: "line",
        data: {
          labels: months,
          datasets: [
            {
              label: "Người Dùng Mới",
              data: data,
              borderColor: "#F39C12",
              backgroundColor: "rgba(243, 156, 18, 0.2)",
              borderWidth: 3,
              fill: true,
              tension: 0.4,
              pointBackgroundColor: "#F39C12",
              pointBorderColor: "#fff",
              pointBorderWidth: 2,
              pointRadius: 5,
            },
          ],
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: {
            legend: {
              display: true,
              position: "top",
              labels: {
                color: "#333333",
                font: {
                  size: 12,
                },
              },
            },
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
                color: "#333333",
                font: {
                  size: 12,
                  weight: "bold",
                },
              },
              ticks: {
                color: "#333333",
                stepSize: 1,
              },
              grid: {
                color: "rgba(0, 0, 0, 0.1)",
              },
            },
            x: {
              title: {
                display: true,
                text: "Tháng",
                color: "#333333",
                font: {
                  size: 12,
                  weight: "bold",
                },
              },
              ticks: {
                color: "#333333",
              },
              grid: {
                color: "rgba(0, 0, 0, 0.1)",
              },
            },
          },
        },
      });
    } catch (error) {
      console.error("Error creating User Growth Chart:", error);
    }
  }

  createRevenueChart() {
    const ctx = document.getElementById("revenueChart");
    if (!ctx) {
      console.error("Revenue Chart canvas not found");
      return;
    }

    const paymentStats = this.dashboardData.paymentStats || {};
    const months = ["Th1", "Th2", "Th3", "Th4", "Th5", "Th6", "Th7", "Th8", "Th9", "Th10", "Th11", "Th12"];
    
    // Fallback data if paymentStats is empty
    const data = new Array(12).fill(0);
    try {
      if (Object.keys(paymentStats).length > 0) {
        Object.entries(paymentStats).forEach(([month, value]) => {
          const monthIndex = parseInt(month) - 1;
          if (monthIndex >= 0 && monthIndex < 12 && !isNaN(value)) {
            data[monthIndex] = Number(value);
          }
        });
      } else {
        console.warn("No paymentStats data available, using fallback data");
      }
    } catch (error) {
      console.error("Error processing revenue data:", error);
    }

    console.log("Revenue Chart Data:", data);

    try {
      this.charts.revenue = new Chart(ctx.getContext('2d'), {
        type: "bar",
        data: {
          labels: months,
          datasets: [
            {
              label: "Doanh Thu (VNĐ)",
              data: data,
              backgroundColor: "#4A90E2",
              borderColor: "#4A90E2",
              borderWidth: 1,
              borderRadius: 8,
              borderSkipped: false,
            },
          ],
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: {
            legend: {
              display: true,
              position: "top",
              labels: {
                color: "#333333",
                font: {
                  size: 12,
                },
              },
            },
            tooltip: {
              backgroundColor: "rgba(0,0,0,0.8)",
              titleColor: "#fff",
              bodyColor: "#fff",
              borderColor: "#4A90E2",
              borderWidth: 1,
              callbacks: {
                label: (context) => {
                  let label = context.dataset.label || "";
                  if (label) {
                    label += ": ";
                  }
                  if (context.parsed.y !== null) {
                    label += new Intl.NumberFormat("vi-VN", {
                      style: "currency",
                      currency: "VND",
                    }).format(context.parsed.y);
                  }
                  return label;
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
                color: "#333333",
                font: {
                  size: 12,
                  weight: "bold",
                },
              },
              ticks: {
                color: "#333333",
                callback: (value) =>
                  new Intl.NumberFormat("vi-VN", {
                    style: "currency",
                    currency: "VND",
                    notation: "compact",
                  }).format(value),
              },
              grid: {
                color: "rgba(0, 0, 0, 0.1)",
              },
            },
            x: {
              title: {
                display: true,
                text: "Tháng",
                color: "#333333",
                font: {
                  size: 12,
                  weight: "bold",
                },
              },
              ticks: {
                color: "#333333",
              },
              grid: {
                display: false,
              },
            },
          },
        },
      });
    } catch (error) {
      console.error("Error creating Revenue Chart:", error);
    }
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
      if (chart) {
        chart.destroy();
      }
    });
    this.charts = {};
  }
}

// Initialize dashboard when DOM is fully loaded
document.addEventListener("DOMContentLoaded", () => {
  try {
    const dashboard = new AdminDashboard();
  } catch (error) {
    console.error("Error initializing AdminDashboard:", error);
  }

  // Auto refresh every 5 minutes (optional)
  setInterval(() => {
    console.log("Auto refreshing dashboard...");
    // dashboard.refreshDashboard(); // Uncomment if you want auto refresh
  }, 300000); // 5 minutes
});

// Handle responsive sidebar toggle
function toggleSidebar() {
  const sidebar = document.querySelector(".sidebar");
  const mainContent = document.querySelector(".main-content");
  if (sidebar && mainContent) {
    sidebar.classList.toggle("collapsed");
    mainContent.classList.toggle("expanded");
  }
}

// Export for global use
window.AdminDashboard = AdminDashboard;
window.toggleSidebar = toggleSidebar;