document.addEventListener('DOMContentLoaded', () => {
  // Animate level cards on scroll
  const levelCards = document.querySelectorAll('.level-card');
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

  levelCards.forEach((card) => observer.observe(card));
});