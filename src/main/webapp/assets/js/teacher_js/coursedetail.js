// Global pagination variables (retained from your original JS)
let currentLessonPage = 1;
let lessonSectionsPerPage = 3;
let totalLessonSections;
let lessonSections;

let currentExercisePage = 1; // This might be for exercises *within* a lesson, if that's your structure
let exercisesPerPage = 5;
let totalExercises;
let exercises;

let currentAssignmentPage = 1;
let assignmentQuestionsPerPage = 5;
let totalAssignmentQuestions;
let assignmentQuestions;

// Helper function to hide all content sections
function hideAllContentSections() {
    document.getElementById('contentPlaceholder').style.display = 'none';
    document.getElementById('lessonContent').style.display = 'none';
    document.getElementById('assignmentContent').style.display = 'none';
}
function updateSubmitButtonState() {
    const submitBtn = document.getElementById('submitAssignmentBtn');
    if (!submitBtn)
        return;

    const totalQuestions = document.querySelectorAll('#assignmentQuestionsList .question-item').length;
    const answeredQuestions = document.querySelectorAll('#assignmentQuestionsList input[type="radio"]:checked').length;

    submitBtn.disabled = answeredQuestions < totalQuestions;
    submitBtn.style.display = totalQuestions > 0 ? 'block' : 'none';
}

function submitAssignment(assignmentId) {
    const answers = [];
    const questions = document.querySelectorAll('#assignmentQuestionsList .question-item');

    questions.forEach((question, index) => {
        const selectedOption = question.querySelector(`input[name="assignment-question-${index}"]:checked`);
        answers.push({
            questionIndex: index,
            answer: selectedOption ? selectedOption.value : null
        });
    });

    const unansweredCount = answers.filter(answer => answer.answer === null).length;
    if (unansweredCount > 0) {
        alert(`Vui lòng trả lời tất cả ${totalAssignmentQuestions} câu hỏi trước khi nộp bài.`);
        return;
    }

    const urlParams = new URLSearchParams(window.location.search);
    const courseId = urlParams.get('courseID');
    const submitData = {
        assignmentId: assignmentId,
        courseId: courseId,
        answers: answers
    };

    fetch(`${getContextPath()}/submitAssignment`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(submitData)
    })
            .then(response => {
                console.log('Submit response status:', response.status);
                if (!response.ok) {
                    return response.json().then(err => {
                        throw new Error(err.error || 'Lỗi khi nộp bài');
                    });
                }
                return response.json();
            })
            .then(result => {
                console.log('Submit result:', result);
                alert('Nộp bài thành công! Điểm: ' + (result.score || 'Chưa có điểm'));
                document.getElementById('submitAssignmentBtn').disabled = true;
            })
            .catch(error => {
                console.error('Lỗi khi nộp bài:', error);
                alert(`Lỗi khi nộp bài: ${error.message}. Vui lòng thử lại.`);
            });
}
function showLesson(lessonId) {
    hideAllContentSections(); // Hide everything first

    // Explicitly show lesson-specific containers that might have been hidden by showAssignment
    const lessonVideoContainer = document.querySelector('.lesson-video-container');
    const lessonTabs = document.querySelector('.lesson-tabs');
    const assignmentContent = document.getElementById('assignmentContent'); // Get assignment content

    if (lessonVideoContainer) {
        lessonVideoContainer.style.display = 'block'; // Make sure video player is visible
    }
    if (lessonTabs) {
        lessonTabs.style.display = 'block'; // Make sure lesson tabs are visible
    }
    if (assignmentContent) {
        assignmentContent.style.display = 'none'; // Ensure assignment content is hidden
    }

    // Get current courseId from URL, if available, to pass to servlet
    const urlParams = new URLSearchParams(window.location.search);
    const courseId = urlParams.get('courseID'); // Use courseID as per your servlet

    let url = `${getContextPath()}/learn?fetchType=details&lessonId=${lessonId}`;
    if (courseId) {
        url += `&learnID=${courseId}`;
    }

    fetch(url)
        .then(response => {
            if (!response.ok) {
                if (response.status === 400) {
                    return response.json().then(err => {
                        throw new Error(err.error);
                    });
                }
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            return response.json();
        })
        .then(lesson => {
            if (!lesson) {
                document.getElementById('contentPlaceholder').style.display = 'block';
                document.getElementById('contentPlaceholder').innerHTML = '<p style="color: orange;">Không tìm thấy chi tiết bài học này.</p>';
                return;
            }
            // Populate Lesson Content
            document.getElementById('lessonVideoPlayer').querySelector('source').src = lesson.mediaUrl || '';
            document.getElementById('lessonVideoPlayer').load(); // Load new video source
            document.getElementById('lessonVideoPlayer').pause(); // Pause if playing previous
            document.getElementById('lessonVideoPlayer').currentTime = 0; // Reset time
            document.getElementById('lessonTitle').textContent = lesson.title || 'Không có tiêu đề';
            document.getElementById('lessonDescription').textContent = lesson.description || 'Không có mô tả.';

            const exercisesTabContent = document.getElementById('exercises');
            const exerciseQuestionDiv = exercisesTabContent.querySelector('.exercise-question');

            if (exerciseQuestionDiv) {
                exerciseQuestionDiv.innerHTML = ''; // Xóa nội dung cũ
            }

            if (lesson.exercises && Array.isArray(lesson.exercises) && lesson.exercises.length > 0) {
                // Lặp qua từng bài tập (exercise) trong danh sách exercises của lesson
                lesson.exercises.forEach((exercise) => { // Không cần 'index' ở đây nếu không dùng đến exerciseIndex
                    // Kiểm tra xem bài tập này có câu hỏi nào không
                    if (exercise.questions && Array.isArray(exercise.questions) && exercise.questions.length > 0) {
                        // Lặp qua từng câu hỏi (question) trong danh sách questions của bài tập hiện tại
                        exercise.questions.forEach((question, questionIndex) => { // Dùng 'question' và 'questionIndex'
                            const questionItem = document.createElement('div');
                            questionItem.classList.add('question-item');
                            questionItem.setAttribute('data-correct-option', question.correctOption);

                            questionItem.innerHTML = `
                                <div class="question-text">${questionIndex + 1}. ${question.questionText || ''}</div>
                                ${question.optionA ? `<div class="option-item ${'A' === question.correctOption ? 'correct' : ''}" data-option-value="A">A. ${question.optionA}</div>` : ''}
                                ${question.optionB ? `<div class="option-item ${'B' === question.correctOption ? 'correct' : ''}" data-option-value="B">B. ${question.optionB}</div>` : ''}
                                ${question.optionC ? `<div class="option-item ${'C' === question.correctOption ? 'correct' : ''}" data-option-value="C">C. ${question.optionC}</div>` : ''}
                                ${question.optionD ? `<div class="option-item ${'D' === question.correctOption ? 'correct' : ''}" data-option-value="D">D. ${question.optionD}</div>` : ''}
                                <div class="question-explanation" style="display: none;"><strong>Giải thích:</strong> ${question.explanation || 'Không có giải thích.'}</div>
                            `;

                            if (exerciseQuestionDiv) {
                                exerciseQuestionDiv.appendChild(questionItem);
                            }
                        });
                    }
                });

                // Các phần tử cho phân trang cần được lấy sau khi tất cả các câu hỏi đã được thêm vào DOM
                exercises = exercisesTabContent.querySelectorAll('.question-item');
                totalExercises = exercises.length;
                currentExercisePage = 1;
                updateExercisePagination(); // Hàm này sẽ hoạt động sau khi có các phần tử .question-item
            } else {
                // Trường hợp không có bài tập nào cho bài học này
                if (exerciseQuestionDiv) {
                    exerciseQuestionDiv.innerHTML = '<p>Không có bài tập thực hành nào cho bài học này.</p>';
                }
                const exercisePaginationDiv = document.getElementById('exercisePagination');
                if (exercisePaginationDiv) {
                    exercisePaginationDiv.style.display = 'none'; // Ẩn phân trang nếu không có bài tập
                }
            }
            // Populate Documents
            const documentsListDiv = document.getElementById('lessonDocumentsList');
            documentsListDiv.innerHTML = ''; // Clear previous
            if (lesson.documents && Array.isArray(lesson.documents) && lesson.documents.length > 0) {
                lesson.documents.forEach(doc => {
                    const docItem = document.createElement('div');
                    docItem.classList.add('document-item');
                    docItem.innerHTML = `
                        <div class="document-icon">
                            <i class="fas ${doc.type === 'pdf' ? 'fa-file-pdf' : (doc.type === 'pptx' ? 'fa-file-powerpoint' : 'fa-file')}"></i>
                        </div>
                        <div class="document-info">
                            <div class="document-name">${doc.title || ''}</div>
                        </div>
                        <a href="${doc.fileUrl || '#'}" class="document-download" target="_blank">
                            <i class="fas fa-eye"></i> xem
                        </a>
                    `;
                    documentsListDiv.appendChild(docItem);
                });
            } else {
                documentsListDiv.innerHTML = '<p>Không có tài liệu tham khảo nào cho bài học này.</p>';
            }

            document.getElementById('lessonContent').style.display = 'block';
            switchLessonTab('lesson-info'); // Default to lesson info tab

            // Highlight the active lesson item
            document.querySelectorAll('.lesson-item').forEach(item => item.classList.remove('active'));
            const clickedLessonItem = document.querySelector(`.lesson-item[data-lesson-id="${lessonId}"]`);
            if (clickedLessonItem) {
                clickedLessonItem.classList.add('active');
                // Ensure the parent topic is expanded
                const parentTopicContent = clickedLessonItem.closest('.topic-content');
                if (parentTopicContent) {
                    parentTopicContent.style.display = 'block';
                    const toggleIcon = parentTopicContent.previousElementSibling.querySelector('.topic-toggle i');
                    if (toggleIcon) {
                        toggleIcon.classList.remove('fa-chevron-right');
                        toggleIcon.classList.add('fa-chevron-down');
                    }
                }
            }

            window.scrollTo({top: 0, behavior: 'smooth'}); // Scroll to top
        })
        .catch(error => {
            console.error('Lỗi khi tải bài học:', error);
            document.getElementById('contentPlaceholder').style.display = 'block';
            document.getElementById('contentPlaceholder').innerHTML = `<p style="color: red;">Không thể tải nội dung bài học: ${error.message}. Vui lòng thử lại.</p>`;
        });
}
function showAssignment(assignmentId) {
    hideAllContentSections();

    const lessonContent = document.getElementById('lessonContent');
    const assignmentContent = document.getElementById('assignmentContent');
    if (!lessonContent || !assignmentContent) {
        console.error('Không tìm thấy lessonContent hoặc assignmentContent trong DOM');
        document.getElementById('contentPlaceholder').style.display = 'block';
        document.getElementById('contentPlaceholder').innerHTML = '<p style="color: red;">Không tìm thấy nội dung bài tập.</p>';
        return;
    }
    lessonContent.style.cssText = 'display: block ;';
    assignmentContent.style.cssText = 'display: block ;';

    // Ẩn các thành phần không liên quan của lesson
    const lessonVideoContainer = document.querySelector('.lesson-video-container');
    const lessonTabs = document.querySelector('.lesson-tabs');
    if (lessonVideoContainer)
        lessonVideoContainer.style.display = 'none';
    if (lessonTabs)
        lessonTabs.style.display = 'none';

    const urlParams = new URLSearchParams(window.location.search);
    const courseId = urlParams.get('courseID');
    let url = `${getContextPath()}/learn?fetchType=details&assignmentId=${assignmentId}`;
    if (courseId) {
        url += `&courseID=${courseId}`;
    }

    fetch(url)
            .then(response => {
                if (!response.ok) {
                    if (response.status === 400) {
                        return response.json().then(err => {
                            throw new Error(err.error);
                        });
                    }
                    throw new Error(`HTTP error! status: ${response.status}`);
                }
                return response.json();
            })
            .then(assignment => {
                console.log('Dữ liệu Assignment:', assignment);
                if (!assignment) {
                    document.getElementById('contentPlaceholder').style.display = 'block';
                    document.getElementById('contentPlaceholder').innerHTML = '<p style="color: orange;">Không tìm thấy chi tiết bài tập này.</p>';
                    return;
                }

                document.getElementById('contentPlaceholder').style.display = 'none';

                document.getElementById('assignmentTitle').textContent = assignment.title || 'Không có tiêu đề';
                document.getElementById('assignmentQuestionCount').textContent = assignment.totalQuestions || 0;
                document.getElementById('assignmentTotalMarks').textContent = assignment.totalMark || 0;
                document.getElementById('assignmentDurationMinutes').textContent = assignment.duration || 0;
                document.getElementById('assignmentDescription').textContent = assignment.description || 'Không có mô tả.';

                const questionsListDiv = document.getElementById('assignmentQuestionsList');
                if (!questionsListDiv) {
                    console.error('Không tìm thấy assignmentQuestionsList trong DOM');
                    document.getElementById('contentPlaceholder').style.display = 'block';
                    document.getElementById('contentPlaceholder').innerHTML = '<p style="color: red;">Không tìm thấy phần tử assignmentQuestionsList.</p>';
                    return;
                }
                questionsListDiv.innerHTML = '';

                if (assignment.questions && Array.isArray(assignment.questions) && assignment.questions.length > 0) {
                    assignment.questions.forEach((question, index) => {
                        const questionItem = document.createElement('div');
                        questionItem.classList.add('question-item');
                        questionItem.style.display = 'block';
                        questionItem.innerHTML = `
                        <div class="question-text">${index + 1}. ${question.questionText || ''}</div>
                        <div class="options">
                            <label><input type="radio" name="assignment-question-${index}" value="A"> A. ${question.optionA || ''}</label><br>
                            <label><input type="radio" name="assignment-question-${index}" value="B"> B. ${question.optionB || ''}</label><br>
                            <label><input type="radio" name="assignment-question-${index}" value="C"> C. ${question.optionC || ''}</label><br>
                            <label><input type="radio" name="assignment-question-${index}" value="D"> D. ${question.optionD || ''}</label><br>
                        </div>
                    `;
                        questionsListDiv.appendChild(questionItem); // Thêm questionItem vào DOM
                    });

                    assignmentQuestions = document.querySelectorAll('#assignmentQuestionsList .question-item');
                    totalAssignmentQuestions = assignmentQuestions.length;
                    currentAssignmentPage = 1;
                    updateAssignmentPagination();
                    updateSubmitButtonState();


                } else {
                    questionsListDiv.innerHTML = '<p>Không có câu hỏi nào cho bài tập này.</p>';
                    document.getElementById('assignmentPagination').style.display = 'none';
                    const submitBtn = document.getElementById('submitAssignmentBtn');
                    if (submitBtn)
                        submitBtn.style.display = 'none';
                }

                document.querySelectorAll('.assignment-item').forEach(item => item.classList.remove('active'));
                const clickedAssignmentItem = document.querySelector(`.assignment-item[onclick="showAssignment(${assignmentId})"]`);
                if (clickedAssignmentItem) {
                    clickedAssignmentItem.classList.add('active');
                    const parentTopicContent = clickedAssignmentItem.closest('.topic-content');
                    if (parentTopicContent) {
                        parentTopicContent.style.display = 'block';
                        const toggleIcon = parentTopicContent.previousElementSibling.querySelector('.topic-toggle i');
                        if (toggleIcon) {
                            toggleIcon.classList.remove('fa-chevron-right');
                            toggleIcon.classList.add('fa-chevron-down');
                        }
                    }
                }

                window.scrollTo({top: 0, behavior: 'smooth'});
            })
            .catch(error => {
                console.error('Lỗi trong showAssignment:', error);
                document.getElementById('contentPlaceholder').style.display = 'block';
                document.getElementById('contentPlaceholder').innerHTML = `<p style="color: red;">Không thể tải nội dung bài tập: ${error.message}. Vui lòng thử lại.</p>`;
            });
}
// Function to switch between lesson tabs (Lesson Info, Documents, Transcript)
function switchLessonTab(tabId) {
    // Hide all tab content
    document.querySelectorAll('.lesson-tab-content').forEach(tab => {
        tab.classList.remove('active');
        tab.style.display = 'none';
    });
    // Remove active class from all tab buttons
    document.querySelectorAll('.lesson-tab-btn').forEach(btn => {
        btn.classList.remove('active');
    });

    // Show selected tab content
    const selectedTab = document.getElementById(tabId);
    if (selectedTab) {
        selectedTab.classList.add('active');
        selectedTab.style.display = 'block';
    }

    // Set active class for corresponding button
    const correspondingButton = document.querySelector(`.lesson-tab-btn[onclick="switchLessonTab('${tabId}')"]`);
    if (correspondingButton) {
        correspondingButton.classList.add('active');
    }
}

// --- Pagination Functions (Updated to work with dynamic content) ---

// Pagination for the main lesson topics in the sidebar
function updateLessonPagination() {
    if (!lessonSections || lessonSections.length === 0) {
        document.getElementById('lessonPagination').style.display = 'none';
        return;
    } else {
        document.getElementById('lessonPagination').style.display = 'flex';
    }

    const startIndex = (currentLessonPage - 1) * lessonSectionsPerPage;
    const endIndex = Math.min(startIndex + lessonSectionsPerPage, totalLessonSections);

    lessonSections.forEach((section, index) => {
        if (index >= startIndex && index < endIndex) {
            section.style.display = 'block';
        } else {
            section.style.display = 'none';
        }
    });

    document.getElementById('lessonPageInfo').textContent = `Trang ${currentLessonPage}/${Math.ceil(totalLessonSections / lessonSectionsPerPage)}`;
    document.getElementById('lessonPrevBtn').disabled = currentLessonPage === 1;
    document.getElementById('lessonNextBtn').disabled = currentLessonPage * lessonSectionsPerPage >= totalLessonSections;
}
function updateAssignmentPagination() {

    if (!assignmentQuestions || assignmentQuestions.length === 0) {
        document.getElementById('assignmentPagination').style.display = 'none';
        return;
    } else {
        document.getElementById('assignmentPagination').style.display = 'flex';
    }

    const startIndex = (currentAssignmentPage - 1) * assignmentQuestionsPerPage;
    const endIndex = Math.min(startIndex + assignmentQuestionsPerPage, totalAssignmentQuestions);

    assignmentQuestions.forEach((question, index) => {
        if (index >= startIndex && index < endIndex) {
            question.style.display = 'block';
        } else {
            question.style.display = 'none';
        }
    });

    document.getElementById('assignmentPageInfo').textContent = `Trang ${currentAssignmentPage}/${Math.ceil(totalAssignmentQuestions / assignmentQuestionsPerPage)}`;
    document.getElementById('assignmentPrevBtn').disabled = currentAssignmentPage === 1;
    document.getElementById('assignmentNextBtn').disabled = currentAssignmentPage * assignmentQuestionsPerPage >= totalAssignmentQuestions;
    updateSubmitButtonState();

    const submitAssignmentBtn = document.getElementById('submitAssignmentBtn');
    if (submitAssignmentBtn) {
        submitAssignmentBtn.addEventListener('click', () => {
            const urlParams = new URLSearchParams(window.location.search);
            const assignmentId = urlParams.get('assignmentId') || document.querySelector('.assignment-item.active')?.getAttribute('onclick')?.match(/\d+/)?.[0];
            if (assignmentId) {
                submitAssignment(assignmentId);
            } else {
                console.error('Không tìm thấy assignmentId');
                alert('Lỗi: Không xác định được bài tập để nộp.');
            }
        });
    }
}// Function to update pagination for Exercises
function updateExercisePagination() {
    const exercisePaginationDiv = document.getElementById('exercisePagination'); // Lấy element một lần
    const exerciseItems = document.querySelectorAll('#exercises .question-item');

    if (!exercisePaginationDiv) { // Thêm kiểm tra này
        console.warn("Element with ID 'exercisePagination' not found. Skipping pagination update.");
        return; // Thoát nếu không tìm thấy phần tử
    }

    if (exerciseItems.length === 0) {
        // Ẩn thanh phân trang nếu không có bài tập
        exercisePaginationDiv.style.display = 'none';
        return;
    }

    // Nếu có bài tập và phần tử phân trang tồn tại
    exercises = exerciseItems; // Cập nhật biến global 'exercises'
    totalExercises = exercises.length;
    exercisePaginationDiv.style.display = 'flex'; // Hiển thị lại thanh phân trang

    const start = (currentExercisePage - 1) * exercisesPerPage;
    const end = start + exercisesPerPage;

    exercises.forEach((item, index) => {
        if (index >= start && index < end) {
            item.style.display = 'block';
        } else {
            item.style.display = 'none';
        }
    });

    // Cập nhật thông tin trang
    const exercisePageInfoSpan = document.getElementById('exercisePageInfo');
    if (exercisePageInfoSpan) { // Kiểm tra null cho các phần tử con cũng vậy
        const totalPages = Math.ceil(totalExercises / exercisesPerPage);
        exercisePageInfoSpan.textContent = `Trang ${currentExercisePage} / ${totalPages}`;
    }

    // Cập nhật trạng thái nút Prev/Next
    const exercisePrevBtn = document.getElementById('exercisePrevBtn');
    const exerciseNextBtn = document.getElementById('exerciseNextBtn');

    if (exercisePrevBtn) {
        exercisePrevBtn.disabled = currentExercisePage === 1;
    }
    if (exerciseNextBtn) {
        const totalPages = Math.ceil(totalExercises / exercisesPerPage);
        exerciseNextBtn.disabled = currentExercisePage === totalPages;
    }
}
function getContextPath() {
    return window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));
}
function initExerciseInteractivity() {
    const exerciseQuestionContainer = document.querySelector('#exercises .exercise-question');
    if (!exerciseQuestionContainer) {
        return;
    }

    exerciseQuestionContainer.addEventListener('click', function (event) {
        let clickedElement = event.target;

        let optionItem = null;
        let questionItem = null;

        while (clickedElement && clickedElement !== this) {
            if (clickedElement.classList.contains('option-item')) {
                optionItem = clickedElement;
            }
            if (clickedElement.classList.contains('question-item')) {
                questionItem = clickedElement;
                break; // Found the question-item, stop traversing
            }
            clickedElement = clickedElement.parentElement;
        }

        if (optionItem && questionItem && !questionItem.classList.contains('revealed-answer')) {
            const correctOptionValue = questionItem.dataset.correctOption;
            const selectedOptionValue = optionItem.dataset.optionValue;

            questionItem.classList.add('revealed-answer');

            if (selectedOptionValue !== correctOptionValue) {
                optionItem.classList.add('selected-incorrect');
            }

            const options = questionItem.querySelectorAll('.option-item');
            options.forEach(option => {
                option.style.pointerEvents = 'none'; // Ngăn chặn sự kiện click
                option.style.cursor = 'default';     // Thay đổi con trỏ chuột
            });

        }
    });
}
// Initial page load logic
document.addEventListener('DOMContentLoaded', function () {
    initExerciseInteractivity();

    // Sidebar Topic Toggle
    document.querySelectorAll('.topic-header').forEach(header => {
        header.addEventListener('click', function () {
            const topicContent = this.nextElementSibling;
            const toggleIcon = this.querySelector('.topic-toggle i');
            if (topicContent.style.display === 'none' || topicContent.style.display === '') {
                topicContent.style.display = 'block';
                toggleIcon.classList.remove('fa-chevron-right');
                toggleIcon.classList.add('fa-chevron-down');
            } else {
                topicContent.style.display = 'none';
                toggleIcon.classList.remove('fa-chevron-down');
                toggleIcon.classList.add('fa-chevron-right');
            }
        });
    });

    // Initialize Lesson Sidebar Pagination
    lessonSections = document.querySelectorAll('.lesson-progress .topic');
    totalLessonSections = lessonSections.length;
    updateLessonPagination();

    const lessonPrevBtn = document.getElementById('lessonPrevBtn');
    const lessonNextBtn = document.getElementById('lessonNextBtn');

    if (lessonPrevBtn) {
        lessonPrevBtn.addEventListener('click', () => {
            if (currentLessonPage > 1) {
                currentLessonPage--;
                updateLessonPagination();
            }
        });
    }

    if (lessonNextBtn) {
        lessonNextBtn.addEventListener('click', () => {
            if (currentLessonPage * lessonSectionsPerPage < totalLessonSections) {
                currentLessonPage++;
                updateLessonPagination();
            }
        });
    }

    // Event Listeners for Assignment Questions Pagination (initially hidden)
    const assignmentPrevBtn = document.getElementById('assignmentPrevBtn');
    const assignmentNextBtn = document.getElementById('assignmentNextBtn');

    if (assignmentPrevBtn) {
        assignmentPrevBtn.addEventListener('click', () => {
            if (currentAssignmentPage > 1) {
                currentAssignmentPage--;
                updateAssignmentPagination();
            }
        });
    }

    if (assignmentNextBtn) {
        assignmentNextBtn.addEventListener('click', () => {
            if (currentAssignmentPage * assignmentQuestionsPerPage < totalAssignmentQuestions) {
                currentAssignmentPage++;
                updateAssignmentPagination();
            }
        });
    }

    // Handle initial load based on URL parameters
    const urlParams = new URLSearchParams(window.location.search);
    const initialLessonId = urlParams.get('lessonId');
    const initialAssignmentId = urlParams.get('assignmentId');
    document.getElementById('assignmentQuestionsList').addEventListener('change', () => {
        updateSubmitButtonState();
    });
    if (initialLessonId) {
        showLesson(initialLessonId); // Fetch and display initial lesson via AJAX
    } else if (initialAssignmentId) {
        showAssignment(initialAssignmentId); // Fetch and display initial assignment via AJAX
    } else {
        // If no specific lesson/assignment ID, show the placeholder
        document.getElementById('contentPlaceholder').style.display = 'block';
    }
});