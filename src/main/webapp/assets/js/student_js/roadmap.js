document.addEventListener('DOMContentLoaded', () => {
  // Animate roadmap items on scroll
  const roadmapItems = document.querySelectorAll('.roadmap-item');
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

  roadmapItems.forEach((item) => observer.observe(item));

  // Existing modal functionality
  function openModal() {
    document.getElementById('signupModal').style.display = 'flex';
  }
  function closeModal() {
    document.getElementById('signupModal').style.display = 'none';
  }
});