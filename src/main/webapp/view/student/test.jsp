<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>JLPT N5 Practice Quiz</title>
        <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
        <style>
            .nav-item {
                width: 40px;
                height: 40px;
                display: flex;
                align-items: center;
                justify-content: center;
                border-radius: 8px;
                transition: background-color 0.3s;
            }
            .nav-item:hover {
                background-color: #e5e7eb;
            }
            .nav-item.active {
                background-color: #3b82f6;
                color: white;
            }
            .nav-item.answered {
                background-color: #10b981;
                color: white;
            }
            .nav-item.marked {
                border: 2px solid #f59e0b;
                background-color: #fef3c7;
            }
            .nav-item.selected-border {
                border: 2px solid #8b5cf6;
            }
            .answer-option {
                padding: 12px;
                border: 2px solid #e5e7eb;
                border-radius: 8px;
                cursor: pointer;
                transition: background-color 0.3s, border-color 0.3s;
            }
            .answer-option:hover {
                background-color: #f3f4f6;
            }
            .answer-option.selected {
                background-color: #bfdbfe;
                border-color: #3b82f6;
            }
            .answer-option.correct {
                background-color: #d1fae5;
                border-color: #10b981;
            }
            .answer-option.incorrect {
                background-color: #fee2e2;
                border-color: #ef4444;
            }
            .timer {
                font-weight: bold;
                color: #dc2626;
                padding: 12px;
                border-radius: 8px;
                background-color: #f3f4f6;
                text-align: center;
            }
            .timer.warning {
                background-color: #fef2f2;
                color: #dc2626;
                animation: pulse 1s infinite;
            }
            .progress-bar {
                height: 10px;
                background-color: #e5e7eb;
                border-radius: 5px;
                overflow: hidden;
            }
            .progress-fill {
                height: 100%;
                background-color: #3b82f6;
                transition: width 0.3s;
            }
            .modal {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.5);
                align-items: center;
                justify-content: center;
                z-index: 1000;
            }
            .modal-content {
                background-color: white;
                padding: 20px;
                border-radius: 8px;
                max-width: 500px;
                width: 90%;
                text-align: center;
            }
            .loading {
                color: #666;
                font-size: 0.8em;
            }
            @keyframes pulse {
                0%, 100% { opacity: 1; }
                50% { opacity: 0.5; }
            }
        </style>
    </head>
    <body class="bg-gray-100 font-sans">
        <c:if test="${empty sessionScope.test}">
            <div class="p-6 text-center">
                <h2 class="text-2xl font-bold text-red-600">Error: Test not found</h2>
                <p>Please select a valid test or contact support.</p>
                <a href="${pageContext.request.contextPath}/home" class="mt-4 inline-block bg-blue-500 text-white py-2 px-4 rounded-md hover:bg-blue-600">Return to Home</a>
            </div>
        </c:if>
        <c:if test="${not empty sessionScope.test}">
            <!-- Initialize selectedQuestions if not exists -->
            <c:if test="${empty sessionScope.selectedQuestions}">
                <c:set var="selectedQuestions" value="${[]}" scope="session" />
            </c:if>
            
            <div class="flex flex-col md:flex-row min-h-screen">
                <!-- Sidebar -->
                <div class="w-full md:w-1/4 bg-white p-6 shadow-md">
                    <h2 class="text-xl font-bold mb-4">Question Navigation</h2>
                    <div class="progress-bar mb-4">
                        <div class="progress-fill" id="progressFill" style="width: ${sessionScope.answers != null ? (sessionScope.answers.stream().filter(a -> a != null && a.answered).count() * 100.0 / sessionScope.questions.size()) : 0}%"></div>
                    </div>
                    <p class="text-sm text-gray-600 mb-4">Progress: <span id="progressText">${sessionScope.answers != null ? sessionScope.answers.stream().filter(a -> a != null && a.answered).count() : 0}/${sessionScope.questions.size()}</span></p>
                    
                    <div class="grid grid-cols-5 gap-2 mb-4">
                        <c:set var="totalQuestions" value="${sessionScope.questions != null ? sessionScope.questions.size() : 0}" />
                        <c:forEach var="i" begin="0" end="${totalQuestions - 1}">
                            <c:set var="index" value="${i}" />
                            <form action="${pageContext.request.contextPath}/Test" method="get" id="navForm${index}" class="inline">
                                <input type="hidden" name="action" value="${sessionScope.viewResult ? 'viewResult' : 'start'}">
                                <input type="hidden" name="testId" value="${sessionScope.test.id}">
                                <input type="hidden" name="index" value="${index}">
                                <button type="submit" class="nav-item ${index == sessionScope.currentQuestionIndex ? 'active' : ''} ${sessionScope.answers[index] != null && sessionScope.answers[index].answered ? 'answered' : ''} ${sessionScope.markedQuestions[index] ? 'marked' : ''} ${fn:contains(sessionScope.selectedQuestions, index) ? 'selected-border' : ''} border border-gray-300"
                                        aria-label="Go to question ${index + 1}">
                                    ${index + 1}
                                </button>
                            </form>
                        </c:forEach>
                    </div>
                    
                    <!-- Timer Display -->
                    <div class="timer mb-4" id="quizTimer">
                        <div class="text-sm text-gray-600 mb-1">Time Remaining</div>
                        <div class="text-xl font-bold" id="timerDisplay">Loading...</div>
                    </div>
                    
                    <c:if test="${not sessionScope.viewResult}">
                        <button id="markQuestion" class="w-full bg-yellow-500 text-white py-2 rounded-md hover:bg-yellow-600 transition mb-2"
                                aria-label="Mark Question">
                            <span id="markButtonText">${sessionScope.markedQuestions[sessionScope.currentQuestionIndex] ? 'Unmark' : 'Mark'} Question</span>
                        </button>
                        <button id="submitQuizBtn" class="w-full bg-green-500 text-white py-2 rounded-md hover:bg-green-600 transition"
                                aria-label="Submit Quiz">
                            Submit Quiz
                        </button>
                    </c:if>
                </div>

                <!-- Question Panel -->
                <div class="w-full md:w-3/4 p-6">
                    <h2 class="text-2xl font-bold mb-4">${sessionScope.test.title}</h2>
                    <c:set var="currentQuestion" value="${sessionScope.questions[sessionScope.currentQuestionIndex]}" />
                    <c:if test="${empty currentQuestion}">
                        <div class="bg-white p-6 rounded-lg shadow-md text-red-600">
                            Error: Question not found for index ${sessionScope.currentQuestionIndex}.
                        </div>
                    </c:if>
                    <c:if test="${not empty currentQuestion}">
                        <div class="bg-white p-6 rounded-lg shadow-md">
                            <h3 class="text-xl font-semibold mb-4">
                                Question ${sessionScope.currentQuestionIndex + 1}: ${currentQuestion.questionText}
                            </h3>
                            
                            <c:set var="selectedAnswer" value="${sessionScope.answers[sessionScope.currentQuestionIndex] != null ? sessionScope.answers[sessionScope.currentQuestionIndex].studentAnswer : null}" />
                            <div class="space-y-4" id="answerOptions">
                                <div class="answer-option ${sessionScope.viewResult && selectedAnswer == 'A' ? (sessionScope.answers[sessionScope.currentQuestionIndex].correct ? 'correct' : 'incorrect') : ''} ${selectedAnswer == 'A' ? 'selected' : ''}"
                                     data-value="A" data-question-index="${sessionScope.currentQuestionIndex}">
                                    A. ${currentQuestion.optionA}
                                </div>
                                <div class="answer-option ${sessionScope.viewResult && selectedAnswer == 'B' ? (sessionScope.answers[sessionScope.currentQuestionIndex].correct ? 'correct' : 'incorrect') : ''} ${selectedAnswer == 'B' ? 'selected' : ''}"
                                     data-value="B" data-question-index="${sessionScope.currentQuestionIndex}">
                                    B. ${currentQuestion.optionB}
                                </div>
                                <div class="answer-option ${sessionScope.viewResult && selectedAnswer == 'C' ? (sessionScope.answers[sessionScope.currentQuestionIndex].correct ? 'correct' : 'incorrect') : ''} ${selectedAnswer == 'C' ? 'selected' : ''}"
                                     data-value="C" data-question-index="${sessionScope.currentQuestionIndex}">
                                    C. ${currentQuestion.optionC}
                                </div>
                                <div class="answer-option ${sessionScope.viewResult && selectedAnswer == 'D' ? (sessionScope.answers[sessionScope.currentQuestionIndex].correct ? 'correct' : 'incorrect') : ''} ${selectedAnswer == 'D' ? 'selected' : ''}"
                                     data-value="D" data-question-index="${sessionScope.currentQuestionIndex}">
                                    D. ${currentQuestion.optionD}
                                </div>
                            </div>

                            <c:if test="${sessionScope.viewResult}">
                                <div id="resultDetail" class="mt-6 p-4 bg-gray-50 rounded-lg">
                                    <p><strong>Correct Answer:</strong> ${currentQuestion.correctOption}</p>
                                    <p><strong>Your Answer:</strong> ${sessionScope.answers[sessionScope.currentQuestionIndex] != null && sessionScope.answers[sessionScope.currentQuestionIndex].studentAnswer != null ? sessionScope.answers[sessionScope.currentQuestionIndex].studentAnswer : 'Not Answered'}</p>
                                    <p><strong>Score:</strong> ${sessionScope.answers[sessionScope.currentQuestionIndex] != null ? sessionScope.answers[sessionScope.currentQuestionIndex].score : 0}</p>
                                </div>
                            </c:if>

                            <!-- Previous/Next Buttons -->
                            <div class="mt-6 flex justify-between">
                                <c:if test="${sessionScope.currentQuestionIndex > 0}">
                                    <form action="${pageContext.request.contextPath}/Test" method="get">
                                        <input type="hidden" name="action" value="${sessionScope.viewResult ? 'viewResult' : 'start'}">
                                        <input type="hidden" name="testId" value="${sessionScope.test.id}">
                                        <input type="hidden" name="index" value="${sessionScope.currentQuestionIndex - 1}">
                                        <button type="submit" class="bg-blue-500 text-white py-2 px-4 rounded-md hover:bg-blue-600 transition">
                                            Previous
                                        </button>
                                    </form>
                                </c:if>
                                <c:if test="${sessionScope.currentQuestionIndex < sessionScope.questions.size() - 1}">
                                    <form action="${pageContext.request.contextPath}/Test" method="get">
                                        <input type="hidden" name="action" value="${sessionScope.viewResult ? 'viewResult' : 'start'}">
                                        <input type="hidden" name="testId" value="${sessionScope.test.id}">
                                        <input type="hidden" name="index" value="${sessionScope.currentQuestionIndex + 1}">
                                        <button type="submit" class="bg-blue-500 text-white py-2 px-4 rounded-md hover:bg-blue-600 transition">
                                            Next
                                        </button>
                                    </form>
                                </c:if>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- Submit Confirmation Modal -->
            <div id="submitModal" class="modal">
                <div class="modal-content">
                    <h2 class="text-xl font-bold mb-4">Confirm Submission</h2>
                    <p>Are you sure you want to submit your quiz?</p>
                    <p class="text-red-600 font-semibold">You have <span id="unansweredCount">0</span> unanswered questions.</p>
                    <p class="text-sm text-gray-600 mt-2">Time remaining: <span id="modalTimeLeft">0:00</span></p>
                    <form action="${pageContext.request.contextPath}/Test" method="post" id="submitQuizForm">
                        <input type="hidden" name="action" value="submitQuiz">
                        <input type="hidden" name="timeLeft" id="submitTimeLeftInput">
                        <div class="mt-4 space-x-2">
                            <button type="submit" class="bg-green-500 text-white py-2 px-4 rounded-md hover:bg-green-600 transition">
                                Submit Quiz
                            </button>
                            <button type="button" id="cancelSubmit" class="bg-gray-500 text-white py-2 px-4 rounded-md hover:bg-gray-600 transition">
                                Cancel
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>

        <script>
            // Timer variables - Sửa lại cách khởi tạo
            let testStartTime = ${sessionScope.testStartTime != null ? sessionScope.testStartTime : 'null'};
            let testDuration = ${sessionScope.test.duration * 60}; // Duration in seconds
            let timeLeft = 0;
            let timerInterval = null;
            let isTimerRunning = false;

            // Khởi tạo testStartTime nếu chưa có
            if (testStartTime === null) {
                testStartTime = Date.now();
                console.log('Initialized testStartTime:', new Date(testStartTime).toLocaleTimeString());
            }

            // Tính toán thời gian còn lại dựa trên thời gian thực
            function calculateTimeLeft() {
                const currentTime = Date.now();
                const elapsedSeconds = Math.floor((currentTime - testStartTime) / 1000);
                const calculatedTimeLeft = Math.max(0, testDuration - elapsedSeconds);

                console.log('Time calculation:', {
                    currentTime: new Date(currentTime).toLocaleTimeString(),
                    testStartTime: new Date(testStartTime).toLocaleTimeString(),
                    elapsedSeconds: elapsedSeconds,
                    testDuration: testDuration,
                    calculatedTimeLeft: calculatedTimeLeft
                });

                return calculatedTimeLeft;
            }

            // Format thời gian thành MM:SS
            function formatTime(seconds) {
                const minutes = Math.floor(seconds / 60);
                const secs = seconds % 60;
                return minutes + ':' + (secs < 10 ? '0' : '') + secs;
            }

            // Cập nhật hiển thị timer
            function updateTimerDisplay() {
                // Tính toán lại thời gian còn lại
                timeLeft = calculateTimeLeft();
                
                const timerDisplay = document.getElementById('timerDisplay');
                const quizTimer = document.getElementById('quizTimer');
                const submitTimeLeftInput = document.getElementById('submitTimeLeftInput');
                const modalTimeLeft = document.getElementById('modalTimeLeft');

                if (!timerDisplay) {
                    console.error('Timer display element not found!');
                    return;
                }

                // Format và hiển thị thời gian
                const timeString = formatTime(timeLeft);
                timerDisplay.textContent = timeString;
                
                console.log('Timer updated:', timeString, 'seconds left:', timeLeft);

                // Cập nhật các element khác
                if (submitTimeLeftInput) {
                    submitTimeLeftInput.value = timeLeft;
                }

                if (modalTimeLeft) {
                    modalTimeLeft.textContent = timeString;
                }

                // Thêm cảnh báo khi thời gian sắp hết
                if (timeLeft <= 60) {
                    quizTimer.classList.add('warning');
                } else {
                    quizTimer.classList.remove('warning');
                }

                // Auto-submit khi hết thời gian
                if (timeLeft <= 0) {
                    console.log("Time's up! Auto-submitting quiz...");
                    stopTimer();
                    autoSubmitQuiz();
                    return;
                }
            }

            // Khởi tạo timer
            function initializeTimer() {
                console.log('Initializing timer...');
                const timerDisplay = document.getElementById('timerDisplay');
                const quizTimer = document.getElementById('quizTimer');

                if (!timerDisplay || !quizTimer) {
                    console.error('Timer elements not found');
                    return;
                }

                // Tính toán thời gian còn lại thực tế
                timeLeft = calculateTimeLeft();
                console.log('Initial timeLeft:', timeLeft);

                // Cập nhật display ngay lập tức
                updateTimerDisplay();

                // Bắt đầu timer chỉ khi không ở chế độ xem kết quả
                <c:if test="${not sessionScope.viewResult}">
                if (timeLeft > 0 && !isTimerRunning) {
                    startTimer();
                } else if (timeLeft <= 0) {
                    console.log('Time already up, auto-submitting...');
                    autoSubmitQuiz();
                }
                </c:if>
            }

            function startTimer() {
                if (isTimerRunning) {
                    console.log('Timer already running');
                    return;
                }

                console.log('Starting timer with timeLeft:', timeLeft);
                isTimerRunning = true;

                timerInterval = setInterval(function() {
                    updateTimerDisplay();

                    // Đồng bộ với server mỗi 30 giây
                    if (timeLeft % 30 === 0 && timeLeft > 0) {
                        syncTimeWithServer();
                    }
                }, 1000);
            }

            function stopTimer() {
                if (timerInterval) {
                    clearInterval(timerInterval);
                    timerInterval = null;
                    isTimerRunning = false;
                    console.log('Timer stopped');
                }
            }

            // Đồng bộ thời gian với server
            function syncTimeWithServer() {
                const testId = ${sessionScope.test.id != null ? sessionScope.test.id : 0};
                const currentTimeLeft = calculateTimeLeft();

                fetch('${pageContext.request.contextPath}/Test', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: 'action=syncTime&testId=' + testId + '&timeLeft=' + currentTimeLeft + '&clientTime=' + Date.now()
                }).then(response => {
                    if (response.ok) {
                        return response.json();
                    }
                    throw new Error('Sync failed');
                }).then(data => {
                    if (data.status === 'success' && data.serverTimeLeft !== undefined) {
                        // Điều chỉnh thời gian nếu có sự chênh lệch lớn với server
                        const timeDiff = Math.abs(currentTimeLeft - data.serverTimeLeft);
                        if (timeDiff > 5) { // Chênh lệch > 5 giây
                            console.log('Time sync adjustment:', {
                                client: currentTimeLeft,
                                server: data.serverTimeLeft,
                                diff: timeDiff
                            });

                            // Điều chỉnh testStartTime để đồng bộ
                            const adjustment = (currentTimeLeft - data.serverTimeLeft) * 1000;
                            testStartTime += adjustment;
                        }
                    }
                }).catch(error => {
                    console.error('Error syncing time with server:', error);
                });
            }

            function autoSubmitQuiz() {
                const submitForm = document.getElementById('submitQuizForm');
                if (submitForm) {
                    const timerDisplay = document.getElementById('timerDisplay');
                    if (timerDisplay) {
                        timerDisplay.textContent = "Time's Up!";
                        timerDisplay.style.color = '#dc2626';
                    }

                    // Hiển thị thông báo
//                    alert('Thời gian đã hết! Bài thi sẽ được nộp tự động.');

                    setTimeout(() => {
                        submitForm.submit();
                    }, 1000);
                }
            }

            // Khởi tạo timer khi DOM ready
            if (document.readyState === 'loading') {
                document.addEventListener('DOMContentLoaded', initializeTimer);
            } else {
                // DOM đã sẵn sàng
                initializeTimer();
            }

            // Đồng bộ thời gian khi trang sắp đóng
            window.addEventListener('beforeunload', function() {
                stopTimer();
                syncTimeWithServer();
            });

            // Đồng bộ thời gian khi trang được focus lại
            window.addEventListener('focus', function() {
                console.log('Page focused, recalculating time...');
                timeLeft = calculateTimeLeft();
                updateTimerDisplay();
                
                <c:if test="${not sessionScope.viewResult}">
                if (timeLeft > 0 && !isTimerRunning) {
                    startTimer();
                } else if (timeLeft <= 0) {
                    autoSubmitQuiz();
                }
                </c:if>
            });

            // Debug session attributes
            console.log('Session data:', {
                testId: ${sessionScope.test.id != null ? sessionScope.test.id : 0},
                questionIndex: ${sessionScope.currentQuestionIndex != null ? sessionScope.currentQuestionIndex : -1},
                totalQuestions: ${sessionScope.questions != null ? sessionScope.questions.size() : 0},
                testStartTime: testStartTime,
                testDuration: testDuration,
                viewResult: ${sessionScope.viewResult != null ? sessionScope.viewResult : false}
            });

            // Function to update selected question
            function updateSelectedQuestion(index) {
                const form = document.getElementById('navForm' + index);
                if (form) {
                    const button = form.querySelector('.nav-item');
                    if (button && !button.classList.contains('selected-border')) {
                        button.classList.add('selected-border');
                        // Add index to sessionScope.selectedQuestions via fetch
                        fetch('${pageContext.request.contextPath}/Test?action=selectQuestion&testId=${sessionScope.test.id}&index=' + index, {
                            method: 'POST'
                        }).then(response => {
                            if (!response.ok) {
                                console.error('Failed to update selected question, status:', response.status);
                            }
                        }).catch(error => {
                            console.error('Error updating selected question:', error);
                        });
                    }
                }
            }

            // Mark Question functionality
            document.getElementById('markQuestion')?.addEventListener('click', function() {
                const testId = ${sessionScope.test.id != null ? sessionScope.test.id : 0};
                const index = ${sessionScope.currentQuestionIndex != null ? sessionScope.currentQuestionIndex : -1};
                const totalQuestions = ${sessionScope.questions != null ? sessionScope.questions.size() : 0};
                
                if (testId <= 0 || index < 0 || index >= totalQuestions) {
                    console.error('Invalid testId or index for marking:', {testId, index});
                    alert('Cannot mark question: Invalid test or question index.');
                    return;
                }
                
                const form = document.getElementById('navForm' + index);
                const markButtonText = document.getElementById('markButtonText');
                
                if (!form) {
                    console.error('Form not found for index:', index);
                    alert('Error: Navigation form not found. Please reload the page.');
                    return;
                }
                
                fetch('${pageContext.request.contextPath}/Test?action=markQuestion&testId=' + testId + '&index=' + index, {
                    method: 'POST'
                }).then(response => {
                    if (response.ok) {
                        const navButton = form.querySelector('.nav-item');
                        navButton.classList.toggle('marked');
                        
                        // Update button text
                        if (markButtonText) {
                            const isMarked = navButton.classList.contains('marked');
                            markButtonText.textContent = isMarked ? 'Unmark Question' : 'Mark Question';
                        }
                    } else {
                        console.error('Failed to mark question, status:', response.status);
                        alert('Failed to mark question. Please try again.');
                    }
                }).catch(error => {
                    console.error('Error marking question:', error);
                    alert('An error occurred while marking the question.');
                });
            });

            // Update selected question when navigating
            document.querySelectorAll('form[id^="navForm"]')?.forEach(form => {
                form.addEventListener('submit', function(e) {
                    const index = parseInt(form.querySelector('input[name="index"]').value);
                    updateSelectedQuestion(index);
                });
            });

            // Submit Quiz Confirmation
            document.getElementById('submitQuizBtn')?.addEventListener('click', function(e) {
                e.preventDefault();
                
                const totalQuestions = ${sessionScope.questions.size()};
                const answeredCount = ${sessionScope.answers != null ? sessionScope.answers.stream().filter(a -> a != null && a.answered).count() : 0};
                const unanswered = totalQuestions - answeredCount;
                
                const unansweredSpan = document.getElementById('unansweredCount');
                if (unansweredSpan) {
                    unansweredSpan.textContent = unanswered;
                }
                
                const modal = document.getElementById('submitModal');
                if (modal) {
                    modal.style.display = 'flex';
                }
            });

            document.getElementById('cancelSubmit')?.addEventListener('click', function() {
                const modal = document.getElementById('submitModal');
                if (modal) {
                    modal.style.display = 'none';
                }
            });

            window.addEventListener('click', function(e) {
                const modal = document.getElementById('submitModal');
                if (modal && e.target === modal) {
                    modal.style.display = 'none';
                }
            });

            // Handle answer selection
            <c:if test="${not sessionScope.viewResult}">
            document.querySelectorAll('.answer-option').forEach(option => {
                option.addEventListener('click', function() {
                    // Remove selected class from all options
                    document.querySelectorAll('.answer-option').forEach(opt => opt.classList.remove('selected'));
                    // Add selected class to clicked option
                    option.classList.add('selected');

                    const studentAnswer = option.dataset.value;
                    const questionIndex = option.dataset.questionIndex;
                    const totalQuestions = ${sessionScope.questions != null ? sessionScope.questions.size() : 0};
                    const testId = ${sessionScope.test.id != null ? sessionScope.test.id : 0};

                    console.log('Answer selection:', {studentAnswer, questionIndex, totalQuestions, testId});

                    if (!studentAnswer || !questionIndex || isNaN(parseInt(questionIndex)) || testId <= 0 || parseInt(questionIndex) >= totalQuestions) {
                        console.error('Invalid input:', {studentAnswer, questionIndex, testId});
                        alert('An error occurred: Invalid test or question data.');
                        return;
                    }

                    // Show loading indicator
                    const loadingSpan = document.createElement('span');
                    loadingSpan.className = 'loading';
                    loadingSpan.textContent = ' Saving...';
                    option.appendChild(loadingSpan);

                    const params = new URLSearchParams({
                        action: 'submitAnswer',
                        testId: testId,
                        index: questionIndex,
                        studentAnswer: studentAnswer,
                        timeLeft: timeLeft
                    }).toString();

                    fetch('${pageContext.request.contextPath}/Test', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                        body: params
                    })
                    .then(response => {
                        // Remove loading indicator
                        const loading = option.querySelector('.loading');
                        if (loading) loading.remove();
                        
                        if (!response.ok) {
                            throw new Error('HTTP error! Status: ' + response.status);
                        }
                        return response.json();
                    })
                    .then(data => {
                        if (data.status === 'success') {
                            // Update progress
                            const answeredCount = parseInt('${sessionScope.answers != null ? sessionScope.answers.stream().filter(a -> a != null && a.answered).count() : 0}') + 1;
                            const progressFill = document.getElementById('progressFill');
                            if (progressFill) {
                                progressFill.style.width = (answeredCount / totalQuestions) * 100 + '%';
                            }
                            const progressText = document.getElementById('progressText');
                            if (progressText) {
                                progressText.textContent = answeredCount + '/' + totalQuestions;
                            }
                            
                            // Mark question as answered in navigation
                            const form = document.getElementById('navForm' + questionIndex);
                            if (form) {
                                form.querySelector('.nav-item').classList.add('answered');
                                updateSelectedQuestion(parseInt(questionIndex));
                            }
                            
                            // Auto-navigate to next question after a short delay
                            setTimeout(() => {
                                if (parseInt(questionIndex) < totalQuestions - 1) {
                                    const nextIndex = parseInt(questionIndex) + 1;
                                    console.log('Navigating to next question:', nextIndex);
                                    window.location.href = '${pageContext.request.contextPath}/Test?action=start&testId=' + testId + '&index=' + nextIndex;
                                } else {
                                    console.log('Last question answered, showing submit button');
                                    const submitBtn = document.getElementById('submitQuizBtn');
                                    if (submitBtn) {
                                        submitBtn.style.backgroundColor = '#059669';
                                        submitBtn.style.animation = 'pulse 2s infinite';
                                    }
                                }
                            }, 500);
                        } else {
                            console.error('Server error:', data.error);
                            alert('Failed to save answer: ' + data.error);
                        }
                    })
                    .catch(error => {
                        // Remove loading indicator
                        const loading = option.querySelector('.loading');
                        if (loading) loading.remove();
                        
                        console.error('Error submitting answer:', error);
                        alert('An error occurred while submitting your answer. Please try again.');
                    });
                });
            });
            </c:if>
        </script>
    </body>
</html>
