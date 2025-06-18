/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

      // User Growth Chart (Line Chart)
      const userGrowthCtx = document.getElementById("userGrowthChart").getContext("2d");
      new Chart(userGrowthCtx, {
        type: "line",
        data: {
          labels: ["Th1", "Th2", "Th3", "Th4", "Th5", "Th6"],
          datasets: [
            {
              label: "Người Dùng Mới",
              data: [35, 70, 95, 90, 100, 105],
              borderColor: "#F39C12",
              backgroundColor: "rgba(243, 156, 18, 0.2)",
              borderWidth: 2,
              fill: true,
            },
          ],
        },
        options: {
          responsive: true,
          scales: {
            y: {
              beginAtZero: true,
              title: {
                display: true,
                text: "Người Dùng",
                color: "#333333",
              },
              ticks: {
                color: "#333333",
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
              },
              ticks: {
                color: "#333333",
              },
              grid: {
                color: "rgba(0, 0, 0, 0.1)",
              },
            },
          },
          plugins: {
            legend: {
              labels: {
                color: "#333333",
              },
            },
          },
        },
      });

      // Revenue Chart (Bar Chart)
      const revenueCtx = document.getElementById("revenueChart").getContext("2d");
      new Chart(revenueCtx, {
        type: "bar",
        data: {
          labels: ["Th1", "Th2", "Th3", "Th4", "Th5", "Th6"],
          datasets: [
            {
              label: "Tổng Doanh Thu",
              data: [200000000, 180000000, 220000000, 190000000, 210000000, 230000000],
              backgroundColor: "#4A90E2",
              borderColor: "#4A90E2",
              borderWidth: 1,
            },
          ],
        },
        options: {
          responsive: true,
          scales: {
            y: {
              beginAtZero: true,
              title: {
                display: true,
                text: "Doanh Thu (VND)",
                color: "#333333",
              },
              ticks: {
                color: "#333333",
                callback: function(value) {
                  return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(value);
                },
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
              },
              ticks: {
                color: "#333333",
              },
              grid: {
                color: "rgba(0, 0, 0, 0.1)",
              },
            },
          },
          plugins: {
            legend: {
              labels: {
                color: "#333333",
              },
            },
            tooltip: {
              callbacks: {
                label: function(context) {
                  let label = context.dataset.label || '';
                  if (label) {
                    label += ': ';
                  }
                  if (context.parsed.y !== null) {
                    label += new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(context.parsed.y);
                  }
                  return label;
                },
              },
            },
          },
        },
      });

      // Course Card Click Handler
      document.querySelectorAll(".course-card").forEach((card) => {
        card.addEventListener("click", () => {
          const courseId = card.getAttribute("data-id");
          window.location.href = `manageCourses.jsp?id=${courseId}`;
        });
      });