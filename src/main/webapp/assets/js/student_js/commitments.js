document.addEventListener('DOMContentLoaded', () => {
  // Animate commitment cards on scroll
  const commitmentCards = document.querySelectorAll('.commitment-card');
  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.classList.add('animate-fadeInUp');
          observer.unobserve(entry.target); // Stop observing after animation
        }
      });
    },
    { threshold: 0.2 }
  );

  commitmentCards.forEach((card) => observer.observe(card));
});