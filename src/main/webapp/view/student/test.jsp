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
                border: 2px solid #8b5cf6; /* Purple border for selected question */
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
            <!-- CHANGED: Initialize selectedQuestions if not exists -->
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
                    <div class="timer mb-4" id="quizTimer">
                        Time Left: <span id="timerDisplay"></span>
                    </div>
                    <c:if test="${not sessionScope.viewResult}">
                        <button id="markQuestion" class="w-full bg-yellow-500 text-white py-2 rounded-md hover:bg-yellow-600 transition mb-2"
                                aria-label="Mark Question">
                            Mark Question
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
                            <!-- CHANGED: Set selectedAnswer to display previously selected answer -->
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
                                <div id="resultDetail" class="mt-6">
                                    <p><strong>Correct Answer:</strong> ${currentQuestion.correctOption}</p>
                                    <p><strong>Your Answer:</strong> ${sessionScope.answers[sessionScope.currentQuestionIndex] != null && sessionScope.answers[sessionScope.currentQuestionIndex].studentAnswer != null ? sessionScope.answers[sessionScope.currentQuestionIndex].studentAnswer : 'Not Answered'}</p>
                                    <p><strong>Score:</strong> ${sessionScope.answers[sessionScope.currentQuestionIndex] != null ? sessionScope.answers[sessionScope.currentQuestionIndex].score : 0}</p>
                                </div>
                            </c:if>

                            <!-- Previous/Next Buttons -->
                            <div class="mt-6 flex justify-between">
                                <c:if test="${sessionScope.currentQuestionIndex > 0}">
                                    <form action="${pageContext.request.contextPath}/Test" method="get">
                                        <input type="hidden" name="action" value="start">
                                        <input type="hidden" name="testId" value="${sessionScope.test.id}">
                                        <input type="hidden" name="index" value="${sessionScope.currentQuestionIndex - 1}">
                                        <button type="submit" class="bg-blue-500 text-white py-2 px-4 rounded-md hover:bg-blue-600 transition">
                                            Previous
                                        </button>
                                    </form>
                                </c:if>
                                <c:if test="${sessionScope.currentQuestionIndex < sessionScope.questions.size() - 1}">
                                    <form action="${pageContext.request.contextPath}/Test" method="get">
                                        <input type="hidden" name="action" value="start">
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
                    <p>Are you sure you want to submit your quiz? You have <span id="unansweredCount"></span> unanswered questions.</p>
                    <form action="${pageContext.request.contextPath}/Test" method="post" id="submitQuizForm">
                        <input type="hidden" name="action" value="submitQuiz">
                        <input type="hidden" name="timeLeft" id="submitTimeLeftInput">
                        <button type="submit" class="mt-4 bg-green-500 text-white py-2 px-4 rounded-md hover:bg-green-600 transition">
                            Submit
                        </button>
                        <button type="button" id="cancelSubmit" class="mt-4 ml-2 bg-gray-500 text-white py-2 px-4 rounded-md hover:bg-gray-600 transition">
                            Cancel
                        </button>
                    </form>
                </div>
            </div>
        </c:if>

        <script>
            let timeLeft = ${sessionScope.timeLeft != null ? sessionScope.timeLeft : sessionScope.test.duration * 60}; // CHANGED: Use test duration if timeLeft is null

            function updateTimer() {
                if (timeLeft <= 0) {
                    console.log("Time's up, submitting quiz");
                    const submitForm = document.getElementById('submitQuizForm');
                    if (submitForm)
                        submitForm.submit();
                    return;
                }
                let minutes = Math.floor(timeLeft / 60);
                let seconds = timeLeft % 60;
                const timerDisplay = document.getElementById('timerDisplay');
                if (timerDisplay)
                    timerDisplay.innerText = `${minutes}:${seconds < 10 ? '0' : ''}${seconds}`;
                            const timeInput = document.getElementById('submitTimeLeftInput');
                            if (timeInput)
                                timeInput.value = timeLeft;
                            const quizTimer = document.getElementById('quizTimer');
                            if (quizTimer && timeLeft <= 60)
                                quizTimer.classList.add('text-red-600', 'animate-pulse');
                            timeLeft--;
                            setTimeout(updateTimer, 1000);
                        }

            <c:if test="${not sessionScope.viewResult}">
                updateTimer(); // CHANGED: Ensure timer starts on page load
            </c:if>

                        // Debug session attributes
                        console.log('testId:', ${sessionScope.test.id != null ? sessionScope.test.id : 0});
                        console.log('questionIndex:', ${sessionScope.currentQuestionIndex != null ? sessionScope.currentQuestionIndex : -1});
                        console.log('totalQuestions:', ${sessionScope.questions != null ? sessionScope.questions.size() : 0});

                        // CHANGED: Function to update selected question
                        function updateSelectedQuestion(index) {
                            const form = document.getElementById(`navForm${index}`);
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

                        // Mark Question
                        document.getElementById('markQuestion')?.addEventListener('click', () => {
                            const testId = ${sessionScope.test.id != null ? sessionScope.test.id : 0};
                            const index = ${sessionScope.currentQuestionIndex != null ? sessionScope.currentQuestionIndex : -1};
                            const totalQuestions = ${sessionScope.questions != null ? sessionScope.questions.size() : 0};
                            if (testId <= 0 || index < 0 || index >= totalQuestions) {
                                console.error('Invalid testId or index for marking:', {testId, index});
                                alert('Cannot mark question: Invalid test or question index.');
                                return;
                            }
                            const form = document.getElementById(`navForm${index}`);
                            if (!form) {
                                console.error('Form navForm${index} not found for index:', index);
                                alert('Error: Navigation form not found. Please reload the page.');
                                return;
                            }
                            fetch('${pageContext.request.contextPath}/Test?action=markQuestion&testId=' + testId + '&index=' + index, {
                                method: 'POST'
                            }).then(response => {
                                if (response.ok) {
                                    form.querySelector('.nav-item').classList.toggle('marked');
                                } else {
                                    console.error('Failed to mark question, status:', response.status);
                                    alert('Failed to mark question. Please try again. (Status: ' + response.status + ')');
                                }
                            }).catch(error => {
                                console.error('Error marking question:', error);
                                alert('An error occurred while marking the question.');
                            });
                        });

                        // CHANGED: Update selected question when navigating
                        document.querySelectorAll('form[id^="navForm"]')?.forEach(form => {
                            form.addEventListener('submit', (e) => {
                                const index = parseInt(form.querySelector('input[name="index"]').value);
                                updateSelectedQuestion(index);
                            });
                        });

                        // Submit Quiz Confirmation
                        document.getElementById('submitQuizBtn')?.addEventListener('click', (e) => {
                            e.preventDefault();
                            const unanswered = ${sessionScope.questions.size()} - ${sessionScope.answers != null ? sessionScope.answers.stream().filter(a -> a != null && a.answered).count() : 0};
                            const unansweredSpan = document.getElementById('unansweredCount');
                            if (unansweredSpan)
                                unansweredSpan.textContent = unanswered;
                            const modal = document.getElementById('submitModal');
                            if (modal)
                                modal.style.display = 'flex';
                        });

                        document.getElementById('cancelSubmit')?.addEventListener('click', () => {
                            const modal = document.getElementById('submitModal');
                            if (modal)
                                modal.style.display = 'none';
                        });

                        window.addEventListener('click', (e) => {
                            const modal = document.getElementById('submitModal');
                            if (modal && e.target === modal) {
                                modal.style.display = 'none';
                            }
                        });

                        // Handle answer selection
            <c:if test="${not sessionScope.viewResult}">
                        document.querySelectorAll('.answer-option').forEach(option => {
                            option.addEventListener('click', () => {
                                document.querySelectorAll('.answer-option').forEach(opt => opt.classList.remove('selected'));
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

                                option.innerHTML += ' <span class="loading">Saving...</span>';
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
                                            option.querySelector('.loading')?.remove();
                                            if (!response.ok) {
                                                throw new Error(`HTTP error! Status: ${response.status}`);
                                            }
                                            return response.json();
                                        })
                                        .then(data => {
                                            if (data.status === 'success') {
                                                const answered = ${sessionScope.answers != null ? sessionScope.answers.stream().filter(a -> a != null && a.answered).count() : 0} + 1;
                                                const progressFill = document.getElementById('progressFill');
                                                if (progressFill)
                                                    progressFill.style.width = `${(answered / totalQuestions) * 100}%`;
                                                const progressText = document.getElementById('progressText');
                                                if (progressText)
                                                    progressText.textContent = `${answered}/${totalQuestions}`;
                                                                                const form = document.getElementById(`navForm${questionIndex}`);
                                                                                if (form)
                                                                                {
                                                                                    form.querySelector('.nav-item').classList.add('answered');
                                                                                    // CHANGED: Update selected question when answering
                                                                                    updateSelectedQuestion(parseInt(questionIndex));
                                                                                }
                                                                                if (parseInt(questionIndex) < totalQuestions - 1) {
                                                                                    const nextIndex = parseInt(questionIndex) + 1;
                                                                                    console.log('Navigating to next question:', nextIndex);
                                                                                    window.location.href = '${pageContext.request.contextPath}/Test?action=start&testId=' + testId + '&index=' + nextIndex;
                                                                                } else {
                                                                                    console.log('Triggering quiz submission');
                                                                                    const submitBtn = document.getElementById('submitQuizBtn');
                                                                                    if (submitBtn)
                                                                                        submitBtn.click();
                                                                                }
                                                                            } else {
                                                                                console.error('Server error:', data.error);
                                                                                alert('Failed to save answer: ' + data.error);
                                                                            }
                                                                        })
                                                                        .catch(error => {
                                                                            option.querySelector('.loading')?.remove();
                                                                            console.error('Error submitting answer:', error);
                                                                            alert('An error occurred while submitting your answer. Please try again.');
                                                                        });
                                                            });
                                                        });
            </c:if>
        </script>
    </body>
</html>