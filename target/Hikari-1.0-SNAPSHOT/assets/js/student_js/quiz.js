const now = new Date();
const startTime = new Date(now);
startTime.setHours(22, 0, 0, 0); // 10:00 PM +07 on June 1, 2025
const totalDuration = 40 * 60 + 36; // 2436 seconds (40:36)
const elapsedTime = Math.floor((now - startTime) / 1000); // Seconds elapsed
let timeLeft = Math.max(0, totalDuration - elapsedTime); // Ensure non-negative
let timerInterval;
const timerDisplay = document.getElementById('timer-display');
const pauseButton = document.getElementById('pause-button');
const submitButton = document.getElementById('submit-button');

if (!timerDisplay) {
    console.error('Timer display element not found! Check the ID "timer-display" in your HTML.');
}

function updateTimerDisplay() {
    if (timerDisplay) {
        const minutes = Math.floor(timeLeft / 60);
        const seconds = timeLeft % 60;
        timerDisplay.textContent = `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
    } else {
        console.error('Timer display element is missing during update.');
    }

    if (timeLeft <= 0) {
        clearInterval(timerInterval);
        alert('Hết giờ! Bài kiểm tra sẽ tự động nộp.');
        if (submitButton)
            submitButton.disabled = true;
        if (pauseButton)
            pauseButton.disabled = true;
    }
}

function startTimer() {
    if (timerInterval)
        clearInterval(timerInterval);
    timerInterval = setInterval(() => {
        timeLeft--;
        updateTimerDisplay();
    }, 1000);
}

function pauseTimer() {
    clearInterval(timerInterval);
}

if (pauseButton) {
    pauseButton.addEventListener('click', () => {
        if (pauseButton.textContent === 'Tạm dừng') {
            pauseTimer();
            pauseButton.textContent = 'Tiếp tục';
            pauseButton.classList.replace('bg-gray-200', 'bg-orange-500');
            pauseButton.classList.replace('text-gray-700', 'text-white');
        } else {
            startTimer();
            pauseButton.textContent = 'Tạm dừng';
            pauseButton.classList.replace('bg-orange-500', 'bg-gray-200');
            pauseButton.classList.replace('text-white', 'text-gray-700');
        }
    });
}

if (submitButton) {
    submitButton.addEventListener('click', () => {
        pauseTimer();
        alert('Nộp bài thành công!');
        submitButton.disabled = true;
        if (pauseButton)
            pauseButton.disabled = true;
        window.location.href = 'ketqua.jsp';
    });
}

document.addEventListener('DOMContentLoaded', () => {
    if (timerDisplay) {
        updateTimerDisplay();
        startTimer();
    }

    // Handle sidebar navigation
    const menuItems = document.querySelectorAll('.menu-item[data-page]');
    menuItems.forEach(item => {
        item.addEventListener('click', () => {
            const page = item.getAttribute('data-page');
            if (page) {
                window.location.href = page;
            }
        });
    });
});