document.addEventListener('DOMContentLoaded', () => {
  const startLearningBtn = document.getElementById('startLearningBtn');

  startLearningBtn.addEventListener('click', () => {
    // Chuyển hướng đến trang học (giả định là learnvideo.jsp)
    window.location.href = 'continueLearning.jsp?courseId=N5';
  });
});