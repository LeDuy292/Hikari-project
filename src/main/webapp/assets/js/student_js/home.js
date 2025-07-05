// Import AOS library
import AOS from "aos"

// Initialize AOS (Animate On Scroll)
document.addEventListener("DOMContentLoaded", () => {
  // Initialize AOS if available
  if (typeof AOS !== "undefined") {
    AOS.init({
      duration: 800,
      easing: "ease-out-cubic",
      once: true,
      offset: 100,
    })
  }

  // Add smooth scrolling for anchor links
  document.querySelectorAll('a[href^="#"]').forEach((anchor) => {
    anchor.addEventListener("click", function (e) {
      e.preventDefault()
      const target = document.querySelector(this.getAttribute("href"))
      if (target) {
        target.scrollIntoView({
          behavior: "smooth",
          block: "start",
        })
      }
    })
  })

  // Add loading animation to buttons
  const buttons = document.querySelectorAll(".btn-primary, .btn-secondary, .btn-outline")
  buttons.forEach((button) => {
    button.addEventListener("click", function () {
      if (!this.classList.contains("loading")) {
        this.classList.add("loading")
        setTimeout(() => {
          this.classList.remove("loading")
        }, 2000)
      }
    })
  })

  // Parallax effect for hero section
  window.addEventListener("scroll", () => {
    const scrolled = window.pageYOffset
    const heroSection = document.querySelector(".hero-section")
    if (heroSection) {
      const rate = scrolled * -0.5
      heroSection.style.transform = `translateY(${rate}px)`
    }
  })

  // Counter animation for stats
  const animateCounters = () => {
    const counters = document.querySelectorAll(".stat-number")
    counters.forEach((counter) => {
      const target = Number.parseInt(counter.textContent.replace(/[^\d]/g, ""))
      const increment = target / 100
      let current = 0

      const updateCounter = () => {
        if (current < target) {
          current += increment
          if (counter.textContent.includes("+")) {
            counter.textContent = Math.ceil(current).toLocaleString() + "+"
          } else if (counter.textContent.includes("%")) {
            counter.textContent = Math.ceil(current) + "%"
          } else {
            counter.textContent = Math.ceil(current).toLocaleString()
          }
          requestAnimationFrame(updateCounter)
        } else {
          counter.textContent = counter.textContent // Reset to original
        }
      }

      updateCounter()
    })
  }

  // Trigger counter animation when stats section is visible
  const statsSection = document.querySelector(".hero-stats")
  if (statsSection) {
    const observer = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          animateCounters()
          observer.unobserve(entry.target)
        }
      })
    })
    observer.observe(statsSection)
  }
})

// Button click handlers
function startLearning() {
  // Add loading state
  const button = event.target.closest("button")
  button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang chuyển hướng...'

  // Simulate navigation delay
  setTimeout(() => {
    window.location.href = "courseInfo.jsp"
  }, 1000)
}

function viewCourses() {
  const button = event.target.closest("button")
  button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang tải...'

  setTimeout(() => {
    window.location.href = "courseInfo.jsp"
  }, 1000)
}

function viewAllCourses() {
  const button = event.target.closest("button")
  button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang tải khóa học...'

  setTimeout(() => {
    window.location.href = "courseInfo.jsp"
  }, 1000)
}

function registerNow() {
  const button = event.target.closest("button")
  button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...'

  setTimeout(() => {
    window.location.href = "register.jsp"
  }, 1000)
}

function contactUs() {
  const button = event.target.closest("button")
  button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang kết nối...'

  setTimeout(() => {
    window.location.href = "contact.jsp"
  }, 1000)
}

// Add hover effects for cards
document.addEventListener("DOMContentLoaded", () => {
  const cards = document.querySelectorAll(".feature-card, .course-card, .testimonial-card")

  cards.forEach((card) => {
    card.addEventListener("mouseenter", function () {
      this.style.transform = "translateY(-8px) scale(1.02)"
    })

    card.addEventListener("mouseleave", function () {
      this.style.transform = "translateY(0) scale(1)"
    })
  })
})

// Smooth reveal animation for sections
const revealSections = () => {
  const sections = document.querySelectorAll("section")

  sections.forEach((section) => {
    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add("fade-in-up")
            observer.unobserve(entry.target)
          }
        })
      },
      {
        threshold: 0.1,
      },
    )

    observer.observe(section)
  })
}

// Initialize reveal animations
document.addEventListener("DOMContentLoaded", revealSections)

// Add CSS for loading button state
const style = document.createElement("style")
style.textContent = `
    .btn-primary.loading,
    .btn-secondary.loading,
    .btn-outline.loading {
        pointer-events: none;
        opacity: 0.7;
    }
    
    .btn-primary.loading i,
    .btn-secondary.loading i,
    .btn-outline.loading i {
        animation: spin 1s linear infinite;
    }
    
    @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
    }
`
document.head.appendChild(style)
