document.addEventListener('DOMContentLoaded', () => {
    // Các phần tử DOM
    const courseListView = document.getElementById('courseListView');
    const lessonDetailView = document.getElementById('lessonDetailView');
    const backToCourses = document.getElementById('backToCourses');
    const lessonSearch = document.getElementById('lessonSearch');
    const lessonList = document.getElementById('lessonList');
    const lessonCount = document.getElementById('lessonCount');
    const contentPlaceholder = document.getElementById('contentPlaceholder');
    const lessonContent = document.getElementById('lessonContent');
    const assignmentContent = document.getElementById('assignmentContent');
    const lessonPagination = document.getElementById('lessonPagination');
    const exercisePagination = document.getElementById('exercisePagination');
    const assignmentQuestionsPagination = document.getElementById('assignmentQuestionsPagination');
    const addLessonModal = document.getElementById('addLessonModal') ? new bootstrap.Modal(document.getElementById('addLessonModal'), {backdrop: 'static', keyboard: false}) : null;
    const addAssignmentModal = document.getElementById('addAssignmentModal') ? new bootstrap.Modal(document.getElementById('addAssignmentModal'), {backdrop: 'static', keyboard: false}) : null;
    const saveLessonBtn = document.getElementById('saveLessonBtn');
    const saveAssignmentBtn = document.getElementById('saveAssignmentBtn');
    const addQuestionBtn = document.getElementById('addQuestionBtn');
    const questionsContainer = document.getElementById('questionsContainer');
    const questionCount = document.getElementById('questionCount');
    const assignmentTotalQuestionsInput = document.getElementById('assignmentTotalQuestionsInput');
    const addLessonBtn = document.getElementById('addLessonBtn');
    const addAssignmentBtn = document.getElementById('addAssignmentBtn');
    const tabButtons = document.querySelectorAll('.lesson-tab-btn:not([data-tab="translation"])');
    const documentFileInput = document.getElementById('documentFileInput');
    const documentUploadArea = document.getElementById('documentUploadArea');
    const documentFilePreview = document.getElementById('documentFilePreview');
    const documentFileName = document.getElementById('documentFileName');
    const documentFileSize = document.getElementById('documentFileSize');
    const addDocumentForm = document.getElementById('addDocumentForm');
    const addDocumentBtn = document.getElementById('addDocumentBtn');
    const documentForm = document.getElementById('documentForm');
    const saveDocumentBtn = document.getElementById('saveDocumentBtn');
    const cancelDocumentBtn = document.getElementById('cancelDocumentBtn');
    const videoFileInput = document.getElementById('videoFileInput');
    const videoUrlInput = document.getElementById('lessonVideoUrl');
    const videoUploadArea = document.getElementById('videoUploadArea');
    const videoPreview = document.getElementById('videoPreview');
    const previewVideo = document.getElementById('previewVideo');
    const removeVideoBtn = document.getElementById('removeVideoBtn');
    const videoUrlSection = document.getElementById('videoUrlSection');
    const videoFileSection = document.getElementById('videoFileSection');
    const videoFileName = document.getElementById('videoFileName');
    const videoFileSize = document.getElementById('videoFileSize');
    const addExerciseBtn = document.getElementById('addExerciseBtn');
    const addExerciseForm = document.getElementById('addExerciseForm');
    const saveExerciseBtn = document.getElementById('saveExerciseBtn');
    const cancelExerciseBtn = document.getElementById('cancelExerciseBtn');
    const exercisesContainer = document.getElementById('exercisesContainer');
    const excelExerciseFileInput = document.getElementById('excelExerciseFileInput');
    const excelExerciseUploadArea = document.getElementById('excelExerciseUploadArea');
    const excelFileInput = document.getElementById('excelFileInput');
    const excelUploadArea = document.getElementById('excelUploadArea');

    // Trạng thái
    let currentCourseId = null;
    let topics = [];
    let lessonsAndAssignments = [];
    let exercises = [];
    let assignmentQuestions = [];
    let uploadedQuestions = [];
    const expandedSections = new Set();
    let questionCounter = 0;
    let selectedVideoFile = null;
    const ITEMS_PER_PAGE = 4;
    const EXERCISE_QUESTIONS_PER_PAGE = 5; // 5 questions per page for exercises
    let selectedDocumentFile = null;
    // Trạng thái phân trang
    let currentLessonPage = 1;
    let currentExercisePage = 1;
    let currentAssignmentQuestionPage = 1;

    // Cấu hình API
    const API_BASE_URL = window.contextPath || '/Hikari';
    const API_ENDPOINTS = {
        lessons: '/LessonManagementServlet',
        topics: '/LessonManagementServlet?action=getTopics',
        addLesson: '/LessonManagementServlet?action=addLesson',
        addAssignment: '/SaveQuestionServlet',
        addDocument: '/LessonManagementServlet?action=addDocument',
        getDocument: '/LessonManagementServlet?action=getDocument',
        addExercise: '/SaveQuestionServlet',
        getExercises: '/GetExercisesServlet',
        getAssignments: '/LessonManagementServlet',
        uploadExcel: '/UploadFileExcel'
    };
    // Hàm gọi API
    async function apiRequest(endpoint, options = {}) {
        const url = API_BASE_URL + endpoint;
        const defaultOptions = {
            headers: {
                'X-Requested-With': 'XMLHttpRequest'
            }
        };
        const config = {...defaultOptions, ...options};
        try {
            showLoading();
            const response = await fetch(url, config);
            const text = await response.text();
            let data;
            try {
                data = JSON.parse(text);
            } catch (e) {
                console.error('Invalid JSON:', text);
                throw new Error('Phản hồi JSON không hợp lệ: ' + text);
            }
            if (!response.ok) {
                throw new Error(data.message || `Lỗi HTTP! Trạng thái: ${response.status}`);
            }
            if (data.status === 'error') {
                throw new Error(data.message);
            }
            return data;
        } catch (error) {
            console.error('Lỗi gọi API:', error);
            showErrorMessage(error.message || 'Có lỗi xảy ra khi kết nối với server');
            throw error;
        } finally {
            hideLoading();
    }
    }

    // Hàm hiển thị loading
    function showLoading() {
        let loader = document.getElementById('globalLoader');
        if (!loader) {
            loader = document.createElement('div');
            loader.id = 'globalLoader';
            loader.className = 'global-loader';
            loader.innerHTML = `<div class="loader-backdrop"><div class="loader-spinner"><i class="fas fa-spinner fa-spin"></i><span>Đang tải...</span></div></div>`;
            document.body.appendChild(loader);
        }
        loader.style.display = 'flex';
    }

    // Hàm ẩn loading
    function hideLoading() {
        const loader = document.getElementById('globalLoader');
        if (loader)
            loader.style.display = 'none';
    }

    // Hàm hiển thị thông báo lỗi
    function showErrorMessage(message) {
        const toast = document.createElement('div');
        toast.className = 'toast-notification error';
        toast.innerHTML = `<i class="fas fa-exclamation-circle"></i><span>${message}</span>`;
        document.body.appendChild(toast);
        setTimeout(() => toast.classList.add('show'), 100);
        setTimeout(() => {
            toast.classList.remove('show');
            setTimeout(() => document.body.removeChild(toast), 300);
        }, 5000);
    }

    // Hàm hiển thị thông báo thành công
    function showSuccessMessage(message) {
        const toast = document.createElement('div');
        toast.className = 'toast-notification success';
        toast.innerHTML = `<i class="fas fa-check-circle"></i><span>${message}</span>`;
        document.body.appendChild(toast);
        setTimeout(() => toast.classList.add('show'), 100);
        setTimeout(() => {
            toast.classList.remove('show');
            setTimeout(() => document.body.removeChild(toast), 300);
        }, 5000);
    }

    // Hàm lấy danh sách chủ đề
    async function fetchTopics(courseId) {
        try {
            const url = `${API_ENDPOINTS.topics}${courseId ? `&courseId=${courseId}` : ''}`;
            const response = await apiRequest(url);
            return response.topics || [];
        } catch (error) {
            console.error('Lỗi khi lấy chủ đề:', error);
            return [];
        }
    }



    // Hàm lấy danh sách bài học và bài tập
    async function fetchLessonsAndAssignments(courseId) {
        if (!courseId) {
            console.error('No courseId provided');
            showErrorMessage('Vui lòng chọn một khóa học');
            lessonsAndAssignments = [];
            return {data: [], topics: []};
        }
        try {
            const url = `${API_ENDPOINTS.lessons}?action=getTopics&courseId=${courseId}`;
            console.log('Fetching data from:', url); // Debug
            const response = await apiRequest(url);
            lessonsAndAssignments = response.data || []; // Cập nhật biến toàn cục
            // Kiểm tra assignments có questions không
            lessonsAndAssignments.forEach(item => {
                if (item.type === 'assignment') {
                    console.log(`Assignment ${item.id} questions:`, item.questions ? item.questions.length : 'No questions');
                }
            });
            return {data: response.data || [], topics: response.topics || []};
        } catch (error) {
            console.error('Error fetching lessons and assignments:', error);
            showErrorMessage('Không thể tải danh sách bài học');
            lessonsAndAssignments = [];
            return {data: [], topics: []};
        }
    }


    // Hàm lấy danh sách bài tập thực hành
    async function fetchExercises(courseId, lessonId) {
        try {
            const url = `${API_ENDPOINTS.getExercises}?courseId=${courseId}&lessonId=${lessonId || 1}`;
            const response = await apiRequest(url);
            return response.data || [];
        } catch (error) {
            console.error('Lỗi khi lấy bài tập thực hành:', error);
            return [];
        }
    }

    // Hàm khởi tạo ứng dụng
    function init() {
        if (!courseListView || !lessonDetailView || !lessonList || !lessonCount) {
            console.error('Thiếu phần tử DOM cần thiết');
            showErrorMessage('Lỗi giao diện, vui lòng kiểm tra HTML');
            return;
        }
        bindEvents();
        courseListView.style.display = 'block';
        lessonDetailView.style.display = 'none';
        if (contentPlaceholder)
            contentPlaceholder.style.display = 'flex';
        if (lessonContent)
            lessonContent.style.display = 'none';
        if (assignmentContent)
            assignmentContent.style.display = 'none';
    }

    // Tải danh sách chủ đề cho dropdown
    async function loadTopicsForSelects() {
        if (!currentCourseId)
            return;
        try {
            topics = await fetchTopics(currentCourseId);
            const lessonTopicSelect = document.getElementById('lessonTopicInput');
            const assignmentTopicSelect = document.getElementById('assignmentTopicInput');

            if (lessonTopicSelect) {
                lessonTopicSelect.innerHTML = '<option value="">Chọn chủ đề</option>' +
                        topics.map(topic => `<option value="${topic.id}">${topic.name}</option>`).join('');
            }
            if (assignmentTopicSelect) {
                assignmentTopicSelect.innerHTML = '<option value="">Chọn chủ đề</option>' +
                        topics.map(topic => `<option value="${topic.id}">${topic.name}</option>`).join('');
            }
        } catch (error) {
            console.error('Lỗi khi tải chủ đề:', error);
            showErrorMessage('Không thể tải danh sách chủ đề');
        }
    }

    // Gắn các sự kiện
    function bindEvents() {
        document.addEventListener('click', (e) => {
            if (e.target.classList.contains('course-action-btn')) {
                const courseCard = e.target.closest('.course-card');
                if (courseCard) {
                    currentCourseId = courseCard.getAttribute('data-course-id');
                    currentLessonPage = 1;
                    showLessonDetail();
                }
            }

            if (e.target.closest('.lesson-item')) {
                const lessonItem = e.target.closest('.lesson-item');
                showItemDetail(lessonItem, 'lesson');
            }

            if (e.target.closest('.assignment-item')) {
                const assignmentItem = e.target.closest('.assignment-item');
                showItemDetail(assignmentItem, 'assignment');
            }

            if (e.target.closest('.section-header')) {
                const sectionHeader = e.target.closest('.section-header');
                const sectionName = sectionHeader.getAttribute('data-section');
                toggleSection(sectionName);
            }

            if (e.target.closest('.page-link')) {
                const pageItem = e.target.closest('.page-item');
                const paginationContainer = pageItem.closest('.pagination');
                const page = parseInt(pageItem.dataset.page);

                if (paginationContainer.id === 'lessonPagination') {
                    currentLessonPage = page;
                    loadLessonsAndAssignments();
                } else if (paginationContainer.id === 'exercisePagination') {
                    currentExercisePage = page;
                    renderExercises();
                } else if (paginationContainer.id === 'assignmentQuestionsPagination') {
                    currentAssignmentQuestionPage = page;
                    renderAssignmentQuestions();
                }
            }
        });

        tabButtons.forEach(button => {
            button.addEventListener('click', () => {
                if (document.querySelector('.lesson-item.active')) {
                    tabButtons.forEach(btn => btn.classList.remove('active'));
                    const tabContents = document.querySelectorAll('.lesson-tab-content');
                    tabContents.forEach(content => content.classList.remove('active'));
                    const tabId = button.getAttribute('data-tab');
                    button.classList.add('active');
                    const tabContent = document.getElementById(tabId);
                    if (tabContent) {
                        tabContent.classList.add('active');
                        lessonContent.style.display = 'block';
                    }
                    if (tabId === 'exercises') {
                        currentExercisePage = 1;
                        renderExercises();
                    }
                }
            });
        });

        if (addLessonBtn) {
            addLessonBtn.addEventListener('click', () => {
                if (addLessonModal) {
                    addLessonModal.show();
                    loadTopicsForSelects();
                    resetVideoUpload();
                }
            });
        }

        if (addAssignmentBtn) {
            addAssignmentBtn.addEventListener('click', () => {
                if (addAssignmentModal) {
                    addAssignmentModal.show();
                    loadTopicsForSelects();
                    questionCounter = 0;
                    if (questionsContainer)
                        questionsContainer.innerHTML = '';
                    updateQuestionCount();
                }
            });
        }

        if (addQuestionBtn) {
            addQuestionBtn.addEventListener('click', addQuestion);
        }

        if (videoFileInput && videoUploadArea) {
            videoUploadArea.addEventListener('click', () => videoFileInput.click());
            videoFileInput.addEventListener('change', handleVideoUpload);
        }

        if (document.querySelectorAll('input[name="videoSource"]').length > 0) {
            document.querySelectorAll('input[name="videoSource"]').forEach(radio => {
                radio.addEventListener('change', (e) => {
                    if (e.target.id === 'videoUrl') {
                        if (videoUrlSection)
                            videoUrlSection.style.display = 'block';
                        if (videoFileSection)
                            videoFileSection.style.display = 'none';
                        resetVideoUpload();
                    } else if (e.target.id === 'videoFile') {
                        if (videoUrlSection)
                            videoUrlSection.style.display = 'none';
                        if (videoFileSection)
                            videoFileSection.style.display = 'block';
                    }
                });
            });
        }

        if (removeVideoBtn) {
            removeVideoBtn.addEventListener('click', resetVideoUpload);
        }

        if (excelExerciseFileInput && excelExerciseUploadArea) {
            excelExerciseUploadArea.addEventListener('click', () => {
                if (excelExerciseFileInput)
                    excelExerciseFileInput.click();
            });
            excelExerciseFileInput.addEventListener('change', handleExcelExerciseUpload);
            excelExerciseUploadArea.addEventListener('dragover', (e) => {
                e.preventDefault();
                excelExerciseUploadArea.classList.add('dragover');
            });
            excelExerciseUploadArea.addEventListener('dragleave', () => {
                excelExerciseUploadArea.classList.remove('dragover');
            });
            excelExerciseUploadArea.addEventListener('drop', (e) => {
                e.preventDefault();
                excelExerciseUploadArea.classList.remove('dragover');
                const files = e.dataTransfer.files;
                if (files.length > 0 && excelExerciseFileInput) {
                    excelExerciseFileInput.files = files;
                    handleExcelExerciseUpload({target: {files: files}});
                }
            });
        }

        if (excelFileInput && excelUploadArea) {
            excelUploadArea.addEventListener('click', () => excelFileInput.click());
            excelFileInput.addEventListener('change', handleExcelAssignmentUpload);
            excelUploadArea.addEventListener('dragover', (e) => {
                e.preventDefault();
                excelUploadArea.classList.add('dragover');
            });
            excelUploadArea.addEventListener('dragleave', () => {
                excelUploadArea.classList.remove('dragover');
            });
            excelUploadArea.addEventListener('drop', (e) => {
                e.preventDefault();
                excelUploadArea.classList.remove('dragover');
                const files = e.dataTransfer.files;
                if (files.length > 0 && excelFileInput) {
                    excelFileInput.files = files;
                    handleExcelAssignmentUpload({target: {files: files}});
                }
            });
        }

        if (saveLessonBtn) {
            saveLessonBtn.addEventListener('click', async () => {
                const title = document.getElementById('lessonTitleInput')?.value;
                const description = document.getElementById('lessonDescriptionInput')?.value;
                const topicId = document.getElementById('lessonTopicInput')?.value;
                const duration = document.getElementById('lessonDurationInput')?.value;
                const videoUrl = videoUrlInput?.value;
                if (!title || !topicId  ) {
                    showErrorMessage('Vui lòng điền đầy đủ tiêu đề, chủ đề ');
                    return;
                }

                if (document.querySelector('#videoFile')?.checked && selectedVideoFile) {
                    const formData = new FormData();
                    formData.append('video', selectedVideoFile);
                    formData.append('courseId', currentCourseId);
                    formData.append('title', title);
                    formData.append('description', description || '');
                    formData.append('topicId', topicId);
                    formData.append('duration', parseInt(duration));
                    formData.append('type', 'lesson');

                    try {
                        const data = await apiRequest(API_ENDPOINTS.addLesson, {
                            method: 'POST',
                            body: formData
                        });
                        showSuccessMessage('Thêm bài học thành công');
                        addLessonModal.hide();
                        await loadLessonsAndAssignments();
                    } catch (error) {
                        console.error('Lỗi khi thêm bài học:', error);
                        showErrorMessage('Không thể thêm bài học: ' + error.message);
                    }
                } else if (document.querySelector('#videoUrl')?.checked && videoUrl) {
                    const payload = {
                        courseId: currentCourseId,
                        title,
                        description: description || '',
                        topicId,
                        duration: parseInt(duration),
                        videoUrl,
                        type: 'lesson'
                    };
                    try {
                        const data = await apiRequest(API_ENDPOINTS.addLesson, {
                            method: 'POST',
                            body: JSON.stringify(payload)
                        });
                        showSuccessMessage('Thêm bài học thành công');
                        addLessonModal.hide();
                        await loadLessonsAndAssignments();
                    } catch (error) {
                        console.error('Lỗi khi thêm bài học:', error);
                        showErrorMessage('Không thể thêm bài học: ' + error.message);
                    }
                } else {
                    showErrorMessage('Vui lòng chọn nguồn video (URL hoặc file)');
                }
            });
        }

        if (saveAssignmentBtn) {
            saveAssignmentBtn.addEventListener('click', async () => {
                const title = document.getElementById('assignmentTitleInput')?.value;
                const description = document.getElementById('assignmentDescriptionInput')?.value;
                const topicId = document.getElementById('assignmentTopicInput')?.value;
                const duration = document.getElementById('assignmentDurationInput')?.value;
                const totalQuestions = assignmentTotalQuestionsInput?.value;
                const excelFile = excelFileInput?.files[0];

                if (!title || !topicId || !duration || !totalQuestions) {
                    showErrorMessage('Vui lòng điền đầy đủ thông tin');
                    return;
                }

                if (!duration.match(/^\d+$/)) {
                    showErrorMessage('Thời lượng phải là số nguyên dương');
                    return;
                }

                if (excelFile) {
                    const formData = new FormData();
                    formData.append('excelFile', excelFile);
                    try {
                        const data = await apiRequest(API_ENDPOINTS.uploadExcel, {
                            method: 'POST',
                            body: formData
                        });
                        uploadedQuestions = data.data || [];
                        showSuccessMessage('Tải file Excel thành công');
                        assignmentTotalQuestionsInput.value = uploadedQuestions.length;
                        console.log("uploadedQuestions.length" + uploadedQuestions.length);
                    } catch (error) {
                        console.error('Lỗi khi tải file Excel:', error);
                        showErrorMessage('Không thể tải file Excel: ' + error.message);
                        if (excelFileInput)
                            excelFileInput.value = '';
                        return;
                    }

                    const saveFormData = new FormData();
                    saveFormData.append('courseId', currentCourseId);
                    saveFormData.append('title', title);
                    saveFormData.append('description', description || '');
                    saveFormData.append('topicId', topicId);
                    saveFormData.append('duration', parseInt(duration));
                    saveFormData.append('totalQuestions', uploadedQuestions.length);
                    saveFormData.append('type', 'assignment');

                    try {
                        const saveData = await apiRequest(API_ENDPOINTS.addAssignment, {
                            method: 'POST',
                            body: saveFormData
                        });
                        showSuccessMessage('Thêm bài tập thành công');
                        addAssignmentModal.hide();
                        await loadLessonsAndAssignments();
                        if (excelFileInput)
                            excelFileInput.value = '';
                    } catch (error) {
                        console.error('Lỗi khi thêm bài tập:', error);
                        showErrorMessage('Không thể thêm bài tập: ' + error.message);
                        if (excelFileInput)
                            excelFileInput.value = '';
                    }
                } else {
                    const questions = Array.from(document.querySelectorAll('#questionsContainer .question-form')).map(q => ({
                            questionText: q.querySelector('.question-text-input').value,
                            options: Array.from(q.querySelectorAll('.option-input-group')).map((opt, index) => ({
                                    text: opt.querySelector('input[type="text"]').value,
                                    isCorrect: opt.querySelector('input[type="radio"]').checked,
                                    mark: parseInt(totalQuestions) > 0 ? 100 / parseInt(totalQuestions) : 0
                                }))
                        }));

                    if (questions.length === 0) {
                        showErrorMessage('Vui lòng thêm ít nhất một câu hỏi hoặc tải file Excel');
                        return;
                    }
                    const saveFormData = new FormData();
                    saveFormData.append('courseId', currentCourseId);
                    saveFormData.append('title', title);
                    saveFormData.append('description', description || '');
                    saveFormData.append('topicId', topicId);
                    saveFormData.append('duration', parseInt(duration));
                    saveFormData.append('totalQuestions', parseInt(totalQuestions));
                    saveFormData.append('type', 'assignment');
                    saveFormData.append('totalMark', 100);

                    try {
                        const data = await apiRequest(API_ENDPOINTS.addAssignment, {
                            method: 'POST',
                            body: saveFormData
                        });
                        showSuccessMessage('Thêm bài tập thành công');
                        addAssignmentModal.hide();
                        await loadLessonsAndAssignments();
                    } catch (error) {
                        console.error('Lỗi khi thêm bài tập:', error);
                        showErrorMessage('Không thể thêm bài tập: ' + error.message);
                    }
                }
            });
            if (addDocumentBtn) {
                addDocumentBtn.addEventListener('click', () => {
                    if (addDocumentForm) {
                        addDocumentForm.style.display = 'block';
                        resetDocumentUpload();
                    }
                });
            }

            if (documentFileInput && documentUploadArea) {
                documentUploadArea.addEventListener('click', () => documentFileInput.click());
                documentFileInput.addEventListener('change', handleDocumentUpload);
                documentUploadArea.addEventListener('dragover', (e) => {
                    e.preventDefault();
                    documentUploadArea.classList.add('dragover');
                });
                documentUploadArea.addEventListener('dragleave', () => {
                    documentUploadArea.classList.remove('dragover');
                });
                documentUploadArea.addEventListener('drop', (e) => {
                    e.preventDefault();
                    documentUploadArea.classList.remove('dragover');
                    const files = e.dataTransfer.files;
                    if (files.length > 0 && documentFileInput) {
                        documentFileInput.files = files;
                        handleDocumentUpload({target: {files}});
                    }
                });
            }

            if (saveDocumentBtn) {
                saveDocumentBtn.addEventListener('click', async () => {
                    const name = document.getElementById('documentName')?.value;
                    const description = document.getElementById('documentDescription')?.value;
                    const file = selectedDocumentFile;
                    const lessonId = document.querySelector('.lesson-item.active')?.getAttribute('data-item-id');

                    if (!name || !file || !lessonId) {
                        showErrorMessage('Vui lòng điền đầy đủ tên, chọn file tài liệu và chọn một bài học');
                        return;
                    }

                    if (file.size > 100 * 1024 * 1024) {
                        showErrorMessage('Kích thước file vượt quá 100MB');
                        resetDocumentUpload();
                        return;
                    }

                    const formData = new FormData();
                    formData.append('title', name);
                    formData.append('description', description || '');
                    formData.append('file', file);
                    formData.append('size', file.size.toString());
                    formData.append('lessonId', lessonId);

                    for (let [key, value] of formData.entries()) {
                        console.log(`FormData: ${key}=${value instanceof File ? value.name : value}`);
                    }

                    try {
                        const response = await apiRequest(API_ENDPOINTS.addDocument, {
                            method: 'POST',
                            body: formData
                        });
                        console.log('Add document response:', response);
                        showSuccessMessage('Thêm tài liệu thành công');
                        addDocumentForm.style.display = 'none';
                        resetDocumentUpload();
                        // Reload danh sách tài liệu
                        if (lessonId) {
                            await loadExercises(lessonId); // Hoặc hàm load tài liệu nếu có
                        }
                    } catch (error) {
                        console.error('Lỗi khi thêm tài liệu:', error);
                        showErrorMessage('Lỗi khi thêm tài liệu ' + error.message);
                    }
                });
            }
            if (cancelDocumentBtn) {
                cancelDocumentBtn.addEventListener('click', () => {
                    if (addDocumentForm) {
                        addDocumentForm.style.display = 'none';
                        resetDocumentUpload();
                    }
                });
            }
        }



        if (addExerciseBtn) {
            addExerciseBtn.addEventListener('click', () => {
                if (addExerciseForm) {
                    addExerciseForm.style.display = 'block';
                    const exerciseForm = document.getElementById('exerciseForm');
                    if (exerciseForm)
                        exerciseForm.reset();
                    if (excelExerciseFileInput)
                        excelExerciseFileInput.value = '';
                    if (excelExerciseUploadArea) {
                        excelExerciseUploadArea.style.display = 'block';
                        excelExerciseUploadArea.querySelector('.upload-content').style.display = 'block';
                    }
                }
            });
        }

        if (saveExerciseBtn) {
            saveExerciseBtn.addEventListener('click', async () => {
                const title = document.getElementById('exerciseTitle')?.value;
                const description = document.getElementById('exerciseDescription')?.value;
                const excelFile = excelExerciseFileInput?.files[0];
                const lessonId = document.querySelector('.lesson-item.active')?.getAttribute('data-item-id') || '1';

                if (!title) {
                    showErrorMessage('Vui lòng điền tiêu đề bài tập');
                    return;
                }

                if (!excelFile) {
                    showErrorMessage('Vui lòng chọn file Excel chứa câu hỏi');
                    return;
                }

                const uploadFormData = new FormData();
                uploadFormData.append('excelFile', excelFile);
                let uploadedQuestions = [];
                try {
                    const uploadData = await apiRequest(API_ENDPOINTS.uploadExcel, {
                        method: 'POST',
                        body: uploadFormData
                    });
                    console.log('Uploaded exercise questions:', uploadData);
                    uploadedQuestions = uploadData.data || [];
                    showSuccessMessage('Tải file Excel thành công');
                } catch (error) {
                    console.error('Lỗi khi tải file Excel:', error);
                    showErrorMessage('Không thể tải file Excel: ' + error.message);
                    if (excelExerciseFileInput)
                        excelExerciseFileInput.value = '';
                    return;
                }

                const saveFormData = new FormData();
                saveFormData.append('title', title);
                saveFormData.append('description', description || '');
                saveFormData.append('type', 'exercise');
                saveFormData.append('lessonId', lessonId);
                saveFormData.append('totalQuestions', uploadedQuestions.length || 0);
                saveFormData.append('totalMark', 100);

                try {
                    const saveData = await apiRequest(API_ENDPOINTS.addExercise, {
                        method: 'POST',
                        body: saveFormData
                    });
                    showSuccessMessage('Thêm bài tập thực hành thành công');
                    if (addExerciseForm)
                        addExerciseForm.style.display = 'none';
                    const exerciseForm = document.getElementById('exerciseForm');
                    if (exerciseForm)
                        exerciseForm.reset();
                    if (excelExerciseFileInput)
                        excelExerciseFileInput.value = '';
                    await loadExercises(lessonId);
                    const exercisesTab = document.querySelector('.lesson-tab-btn[data-tab="exercises"]');
                    if (exercisesTab)
                        exercisesTab.click();
                } catch (error) {
                    console.error('Lỗi khi thêm bài tập thực hành:', error);
                    showErrorMessage('Không thể thêm bài tập: ' + error.message);
                    if (excelExerciseFileInput)
                        excelExerciseFileInput.value = '';
                }
            });
        }

        if (cancelExerciseBtn) {
            cancelExerciseBtn.addEventListener('click', () => {
                if (addExerciseForm) {
                    addExerciseForm.style.display = 'none';
                    const exerciseForm = document.getElementById('exerciseForm');
                    if (exerciseForm)
                        exerciseForm.reset();
                    if (excelExerciseFileInput)
                        excelExerciseFileInput.value = '';
                    if (excelExerciseUploadArea) {
                        excelExerciseUploadArea.style.display = 'block';
                        excelExerciseUploadArea.querySelector('.upload-content').style.display = 'block';
                    }
                }
            });
        }

        if (backToCourses) {
            backToCourses.addEventListener('click', (e) => {
                e.preventDefault();
                showCourseList();
            });
        }

        if (lessonSearch) {
            lessonSearch.addEventListener('input', () => {
                currentLessonPage = 1;
                renderLessonsAndAssignments();
            });
        }
    }

// Hàm lấy danh sách tài liệu theo lessonId
    async function getDocuments(lessonId) {
        if (!lessonId) {
            console.error('No lessonId provided');
            showErrorMessage('Vui lòng chọn một bài học');
            return [];
        }

        try {
            const response = await apiRequest(`${API_ENDPOINTS.getDocument}&lessonId=${lessonId}`);
            if (response.status !== 'success') {
                throw new Error(response.message || 'Không thể lấy danh sách tài liệu');
            }

            const documents = response.data || [];
            console.log('Retrieved documents:', documents);
            return documents;
        } catch (error) {
            console.error('Lỗi khi lấy tài liệu:', error);
            showErrorMessage('Không thể tải danh sách tài liệu: ' + error.message);
            return [];
        }
    }
    async function loadDocuments(lessonId) {
        try {
            const documents = await getDocuments(lessonId);
            renderDocuments(documents);
        } catch (error) {
            console.error('Lỗi khi tải tài liệu:', error);
            showErrorMessage('Không thể tải danh sách tài liệu: ' + error.message);
        }
    }

// Hàm render danh sách tài liệu
    function renderDocuments(documents) {
        const documentList = document.getElementById('documentList');
        if (!documentList) {
            console.error('Không tìm thấy phần tử documentList');
            showErrorMessage('Lỗi giao diện: Không tìm thấy phần tử documentList');
            return;
        }

        documentList.innerHTML = ''; // Xóa danh sách cũ
        if (documents.length === 0) {
            documentList.innerHTML = '<p>Chưa có tài liệu nào.</p>';
            return;
        }

        documents.forEach(doc => {
            const docElement = document.createElement('div');
            docElement.className = 'document-item';
            docElement.innerHTML = `
            <div class="document-icon"><i class="fas fa-file-pdf"></i></div>
            <div class="document-info">
                <div class="document-name">${doc.title || 'Không có tiêu đề'}</div>
            </div>
            <a href="${doc.fileUrl}" target="_blank" class="document-download">Xem tài liệu</a>
        `;
            documentList.appendChild(docElement);
        });
    }
    function handleDocumentUpload(e) {
        const file = e.target.files[0];
        if (!file) {
            showErrorMessage('Vui lòng chọn file tài liệu');
            return;
        }
        if (!['application/pdf', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'].includes(file.type)) {
            showErrorMessage('Chỉ hỗ trợ file .pdf, .doc, .docx');
            if (documentFileInput)
                documentFileInput.value = '';
            return;
        }
        if (file.size > 100 * 1024 * 1024) {
            showErrorMessage('Kích thước file vượt quá 100MB');
            if (documentFileInput)
                documentFileInput.value = '';
            return;
        }

        selectedDocumentFile = file;
        if (documentUploadArea) {
            documentUploadArea.style.display = 'none';
        }
        if (documentFilePreview) {
            documentFilePreview.style.display = 'block';
            documentFileName.textContent = file.name;
            documentFileSize.textContent = `${(file.size / 1024 / 1024).toFixed(2)} MB`;
        }
    }

    function resetDocumentUpload() {
        selectedDocumentFile = null;
        if (documentFileInput)
            documentFileInput.value = '';
        if (documentUploadArea) {
            documentUploadArea.style.display = 'block';
            documentUploadArea.querySelector('.upload-content').innerHTML = `
            <i class="fas fa-file upload-icon"></i>
            <p>Kéo thả file vào đây hoặc click để chọn</p>
            <p class="upload-note">Hỗ trợ file .pdf, .doc, .docx (tối đa 10MB)</p>
        `;
        }
        if (documentFilePreview) {
            documentFilePreview.style.display = 'none';
            documentFileName.textContent = '';
            documentFileSize.textContent = '';
        }
        if (documentForm) {
            documentForm.reset();
        }
    }
    // Hiển thị danh sách khóa học
    function showCourseList() {
        if (courseListView)
            courseListView.style.display = 'block';
        if (lessonDetailView)
            lessonDetailView.style.display = 'none';
        if (lessonList)
            lessonList.innerHTML = '';
        if (lessonCount)
            lessonCount.textContent = '0';
    }

    // Hiển thị chi tiết bài học
    async function showLessonDetail() {
        if (!currentCourseId) {
            showErrorMessage('Vui lòng chọn một khóa học');
            return;
        }
        if (courseListView)
            courseListView.style.display = 'none';
        if (lessonDetailView)
            lessonDetailView.style.display = 'block';
        await loadTopicsForSelects();
        await loadLessonsAndAssignments();
    }

    // Tải danh sách bài học và bài tập
    async function loadLessonsAndAssignments() {
        if (!lessonList || !lessonCount || !currentCourseId) {
            showErrorMessage('Vui lòng chọn một khóa học');
            return;
        }

        try {
            const response = await fetchLessonsAndAssignments(currentCourseId);
            lessonsAndAssignments = Array.isArray(response.data) ? [...response.data] : [];
            lessonCount.textContent = lessonsAndAssignments.length;
            renderLessonsAndAssignments();
        } catch (error) {
            console.error('Lỗi khi tải bài học và bài tập:', error);
            showErrorMessage('Không thể tải danh sách bài học');
        }
    }

    // Tải danh sách bài tập thực hành
    async function loadExercises(lessonId) {
        if (!exercisesContainer)
            return;
        try {
            exercises = await fetchExercises(currentCourseId, lessonId);
            renderExercises();
        } catch (error) {
            console.error('Lỗi khi tải bài tập:', error);
            showErrorMessage('Không thể tải danh sách bài tập');
        }
    }

    // Render danh sách bài học và bài tập
    function renderLessonsAndAssignments() {
        if (!lessonList) {
            console.error('lessonList element not found');
            return;
        }
        lessonList.innerHTML = '';
        const filteredItems = lessonsAndAssignments.filter(item => {
            const title = item.title.toLowerCase();
            const searchTerm = lessonSearch?.value.toLowerCase() || '';
            return title.includes(searchTerm);
        });

        const totalPages = Math.ceil(filteredItems.length / ITEMS_PER_PAGE);
        const startIndex = (currentLessonPage - 1) * ITEMS_PER_PAGE;
        const endIndex = startIndex + ITEMS_PER_PAGE;
        const itemsToShow = filteredItems.slice(startIndex, endIndex);

        if (itemsToShow.length === 0) {
            lessonList.innerHTML = '<p>Không có bài học nào cho khóa học này</p>';
            renderLessonPagination(totalPages);
            return;
        }

        const groupedItems = groupItemsByTopic(itemsToShow);
        Object.keys(groupedItems).forEach((topicName) => {
            const section = createSection(topicName, groupedItems[topicName]);
            lessonList.appendChild(section);
        });

        // Xóa sự kiện cũ trước khi thêm mới
        document.querySelectorAll('.lesson-item, .assignment-item').forEach(item => {
            item.removeEventListener('click', handleItemClick); // Xóa sự kiện cũ
            item.addEventListener('click', handleItemClick); // Thêm sự kiện mới
        });

        const firstTopic = Object.keys(groupedItems)[0];
        if (firstTopic) {
            if (!(expandedSections instanceof Set)) {
                console.warn('expandedSections không phải Set, khởi tạo lại');
                expandedSections = new Set();
            }
            expandedSections.add(firstTopic);
            const firstSection = document.getElementById(firstTopic.replace(/[^a-zA-Z0-9]/g, ''));
            if (firstSection) {
                firstSection.classList.add('show');
                const toggleIcon = document.querySelector(`[data-section="${firstTopic}"] .section-toggle i`);
                if (toggleIcon)
                    toggleIcon.className = 'fas fa-chevron-down';
            }
        }

        renderLessonPagination(totalPages);
    }

    function handleItemClick(event) {
        const item = event.currentTarget;
        const itemId = item.getAttribute('data-item-id');
        const type = item.classList.contains('lesson-item') ? 'lesson' : 'assignment';
        console.log('Clicked item:', {itemId, type});
        showItemDetail(item, type);
    }
// Tạo section cho các bài học/bài tập theo chủ đề
    function createSection(topicName, items) {
        const section = document.createElement('div');
        section.className = 'section';

        const header = document.createElement('div');
        header.className = 'section-header';
        header.setAttribute('data-section', topicName);
        header.innerHTML = `
        <div class="section-title">${topicName}</div>
        <div class="section-toggle"><i class="fas fa-chevron-right"></i></div>
    `;

        const content = document.createElement('div');
        content.className = 'section-content';
        content.id = topicName.replace(/[^a-zA-Z0-9]/g, '');

        items.forEach((item) => {
            const itemElement = createItemElement(item);
            content.appendChild(itemElement);
        });

        section.appendChild(header);
        section.appendChild(content);
        return section;
    }
    function createItemElement(item) {
        const itemElement = document.createElement('div');
        itemElement.className = item.type === 'lesson' ? 'lesson-item' : 'assignment-item';
        itemElement.setAttribute('data-item-id', item.id);
        itemElement.setAttribute('data-type', item.type);

        const icon = item.type === 'lesson' ? 'fas fa-play-circle' : 'fas fa-tasks';
        const statusHtml = item.type === 'lesson'
                ? `<div class="item-status ${item.isCompleted ? 'completed' : ''}"></div>`
                : '<div class="item-status"></div>';

        itemElement.innerHTML = `
        <span><i class="${icon}"></i> ${item.title}</span>
        ${statusHtml}
    `;

        itemElement.addEventListener('click', () => showItemDetail(itemElement, item.type));
        return itemElement;
    }
// Nhóm các mục theo chủ đề
    function groupItemsByTopic(items) {
        return items.reduce((acc, item) => {
            const topicName = item.topicName || 'Chưa phân loại'; // Xử lý trường hợp topicName rỗng
            if (!acc[topicName]) {
                acc[topicName] = [];
            }
            acc[topicName].push(item);
            return acc;
        }, {});
    }
    // Render danh sách bài tập thực hành
    function renderExercises() {
        if (!exercisesContainer)
            return;
        exercisesContainer.innerHTML = '';
        let allQuestions = [];
        exercises.forEach(exercise => {
            if (exercise.questions && exercise.questions.length > 0) {
                allQuestions = allQuestions.concat(exercise.questions.map(q => ({...q, exerciseTitle: exercise.title})));
            }
        });

        const totalPages = Math.ceil(allQuestions.length / EXERCISE_QUESTIONS_PER_PAGE);
        const startIndex = (currentExercisePage - 1) * EXERCISE_QUESTIONS_PER_PAGE;
        const endIndex = startIndex + EXERCISE_QUESTIONS_PER_PAGE;
        const questionsToShow = allQuestions.slice(startIndex, endIndex);

        if (questionsToShow.length === 0) {
            exercisesContainer.innerHTML = '<p>Không có bài tập thực hành nào</p>';
            renderExercisePagination(totalPages);
            return;
        }

        const groupedByExercise = questionsToShow.reduce((acc, question) => {
            if (!acc[question.exerciseTitle]) {
                acc[question.exerciseTitle] = [];
            }
            acc[question.exerciseTitle].push(question);
            return acc;
        }, {});

        Object.keys(groupedByExercise).forEach(exerciseTitle => {
            const exerciseItem = document.createElement('div');
            exerciseItem.className = 'exercise-item';
            const questionsHtml = groupedByExercise[exerciseTitle].map((question, qIndex) => `
                <div class="exercise-question">
                    <div class="question-text">${qIndex + 1 + startIndex}. ${question.questionText || 'Không có nội dung câu hỏi'}</div>
                    <div class="question-options">
                        <div class="option-item ${question.correctOption === 'A' ? 'correct' : ''}">A. ${question.optionA || ''}</div>
                        <div class="option-item ${question.correctOption === 'B' ? 'correct' : ''}">B. ${question.optionB || ''}</div>
                        <div class="option-item ${question.correctOption === 'C' ? 'correct' : ''}">C. ${question.optionC || ''}</div>
                        <div class="option-item ${question.correctOption === 'D' ? 'correct' : ''}">D. ${question.optionD || ''}</div>
                    </div>
                </div>
            `).join('');

            exerciseItem.innerHTML = `
                <div class="exercise-header">
                    <div class="exercise-title">${exerciseTitle || 'Không có tiêu đề'}</div>
                </div>
                <div class="exercise-description">${exercises.find(ex => ex.title === exerciseTitle)?.description || ''}</div>
                ${questionsHtml}
            `;
            exercisesContainer.appendChild(exerciseItem);
        });

        renderExercisePagination(totalPages);
    }

    // Render danh sách câu hỏi bài tập
    function renderAssignmentQuestions() {
        const questionsContainer = document.getElementById('assignmentQuestions');
        if (!questionsContainer) {
            console.error('Không tìm thấy container assignmentQuestions');
            return;
        }
        questionsContainer.innerHTML = '';

        if (assignmentQuestions.length === 0) {
            questionsContainer.innerHTML = '<p>Không có câu hỏi nào cho bài tập này</p>';
            renderAssignmentQuestionsPagination(0);
            return;
        }

        const totalPages = Math.ceil(assignmentQuestions.length / ITEMS_PER_PAGE);
        const startIndex = (currentAssignmentQuestionPage - 1) * ITEMS_PER_PAGE;
        const endIndex = startIndex + ITEMS_PER_PAGE;
        const questionsToShow = assignmentQuestions.slice(startIndex, endIndex);

        questionsToShow.forEach((question, index) => {
            const questionItem = document.createElement('div');
            questionItem.className = 'question-item';
            questionItem.innerHTML = `
            <div class="question-text">${startIndex + index + 1}. ${question.questionText || 'Không có câu hỏi'}</div>
            <div class="question-options">
                <div class="option-item ${question.correctOption === 'A' ? 'correct' : ''}">A. ${question.optionA || ''}</div>
                <div class="option-item ${question.correctOption === 'B' ? 'correct' : ''}">B. ${question.optionB || ''}</div>
                <div class="option-item ${question.correctOption === 'C' ? 'correct' : ''}">C. ${question.optionC || ''}</div>
                <div class="option-item ${question.correctOption === 'D' ? 'correct' : ''}">D. ${question.optionD || ''}</div>
            </div>
        `;
            questionsContainer.appendChild(questionItem);
        });

        renderAssignmentQuestionsPagination(totalPages);
    }
    // Render phân trang cho danh sách bài học
    function renderLessonPagination(totalPages) {
        if (!lessonPagination)
            return;
        lessonPagination.innerHTML = '';
        if (totalPages <= 1)
            return;

        const prevItem = document.createElement('li');
        prevItem.className = `page-item ${currentLessonPage === 1 ? 'disabled' : ''}`;
        prevItem.dataset.page = currentLessonPage - 1;
        prevItem.innerHTML = '<a class="page-link" href="#">Trước</a>';
        lessonPagination.appendChild(prevItem);

        for (let i = 1; i <= totalPages; i++) {
            const pageItem = document.createElement('li');
            pageItem.className = `page-item ${i === currentLessonPage ? 'active' : ''}`;
            pageItem.dataset.page = i;
            pageItem.innerHTML = `<a class="page-link" href="#">${i}</a>`;
            lessonPagination.appendChild(pageItem);
        }

        const nextItem = document.createElement('li');
        nextItem.className = `page-item ${currentLessonPage === totalPages ? 'disabled' : ''}`;
        nextItem.dataset.page = currentLessonPage + 1;
        nextItem.innerHTML = '<a class="page-link" href="#">Sau</a>';
        lessonPagination.appendChild(nextItem);
    }

    // Render phân trang cho danh sách bài tập thực hành
    function renderExercisePagination(totalPages) {
        if (!exercisePagination)
            return;
        exercisePagination.innerHTML = '';
        if (totalPages <= 1)
            return;

        const prevItem = document.createElement('li');
        prevItem.className = `page-item ${currentExercisePage === 1 ? 'disabled' : ''}`;
        prevItem.dataset.page = currentExercisePage - 1;
        prevItem.innerHTML = '<a class="page-link" href="#">Trước</a>';
        exercisePagination.appendChild(prevItem);

        for (let i = 1; i <= totalPages; i++) {
            const pageItem = document.createElement('li');
            pageItem.className = `page-item ${i === currentExercisePage ? 'active' : ''}`;
            pageItem.dataset.page = i;
            pageItem.innerHTML = `<a class="page-link" href="#">${i}</a>`;
            exercisePagination.appendChild(pageItem);
        }

        const nextItem = document.createElement('li');
        nextItem.className = `page-item ${currentExercisePage === totalPages ? 'disabled' : ''}`;
        nextItem.dataset.page = currentExercisePage + 1;
        nextItem.innerHTML = '<a class="page-link" href="#">Sau</a>';
        exercisePagination.appendChild(nextItem);
    }

    // Render phân trang cho danh sách câu hỏi bài tập
    function renderAssignmentQuestionsPagination(totalPages) {
        if (!assignmentQuestionsPagination)
            return;
        assignmentQuestionsPagination.innerHTML = '';
        if (totalPages <= 1)
            return;

        const prevItem = document.createElement('li');
        prevItem.className = `page-item ${currentAssignmentQuestionPage === 1 ? 'disabled' : ''}`;
        prevItem.dataset.page = currentAssignmentQuestionPage - 1;
        prevItem.innerHTML = '<a class="page-link" href="#">Trước</a>';
        assignmentQuestionsPagination.appendChild(prevItem);

        for (let i = 1; i <= totalPages; i++) {
            const pageItem = document.createElement('li');
            pageItem.className = `page-item ${i === currentAssignmentQuestionPage ? 'active' : ''}`;
            pageItem.dataset.page = i;
            pageItem.innerHTML = `<a class="page-link" href="#">${i}</a>`;
            assignmentQuestionsPagination.appendChild(pageItem);
        }

        const nextItem = document.createElement('li');
        nextItem.className = `page-item ${currentAssignmentQuestionPage === totalPages ? 'disabled' : ''}`;
        nextItem.dataset.page = currentAssignmentQuestionPage + 1;
        nextItem.innerHTML = '<a class="page-link" href="#">Sau</a>';
        assignmentQuestionsPagination.appendChild(nextItem);
    }

    // Xử lý tải file Excel cho bài tập thực hành
    function handleExcelExerciseUpload(e) {
        const file = e.target.files[0];
        if (!file) {
            ErrorMessage('Vui lòng chọn file Excel');
            return;
        }
        if (file.size > 10 * 1024 * 1024) {
            showErrorMessage('Kích thước file vượt quá giới hạn 10MB');
            if (excelExerciseFileInput)
                excelExerciseFileInput.value = '';
            return;
        }

        if (excelExerciseUploadArea) {
            const uploadContent = excelExerciseUploadArea.querySelector('.upload-content');
            if (uploadContent) {
                uploadContent.innerHTML = `
                    <i class="fas fa-file-excel upload-icon"></i>
                    <p>File: ${file.name}</p>
                    <p class="upload-note">Kích thước: ${(file.size / 1024 / 1024).toFixed(2)} MB</p>
                `;
            }
        }

        const formData = new FormData();
        formData.append('excelFile', file);

        apiRequest(API_ENDPOINTS.uploadExcel, {
            method: 'POST',
            body: formData
        }).then(data => {
            console.log('Uploaded exercise questions:', data);
            showSuccessMessage('Tải file Excel thành công');
            if (data.data && data.data.length) {
                document.getElementById('exerciseTotalQuestions')?.setAttribute('data-total-questions', data.data.length);
            }
        }).catch(error => {
            console.error('Lỗi khi tải file Excel:', error);
            showErrorMessage('Không thể tải file Excel: ' + error.message);
            if (excelExerciseFileInput)
                excelExerciseFileInput.value = '';
            if (excelExerciseUploadArea) {
                excelExerciseUploadArea.querySelector('.upload-content').innerHTML = `
                    <i class="fas fa-file-excel upload-icon"></i>
                    <p>Kéo thả file Excel vào đây hoặc click để chọn</p>
                    <p class="upload-note">Hỗ trợ file .xlsx, .xls</p>
                `;
            }
        });
    }

    // Xử lý tải file Excel cho bài tập
    function handleExcelAssignmentUpload(e) {
        const file = e.target.files[0];
        if (!file) {
            showErrorMessage('Vui lòng chọn file Excel');
            return;
        }
        if (file.size > 10 * 1024 * 1024) {
            showErrorMessage('Kích thước file vượt quá giới hạn 10MB');
            if (excelFileInput)
                excelFileInput.value = '';
            return;
        }

        if (excelUploadArea) {
            const uploadContent = excelUploadArea.querySelector('.upload-content');
            if (uploadContent) {
                uploadContent.innerHTML = `
                    <i class="fas fa-file-excel upload-icon"></i>
                    <p>File: ${file.name}</p>
                    <p class="upload-note">Kích thước: ${(file.size / 1024 / 1024).toFixed(2)} MB</p>
                `;
            }
        }

        const formData = new FormData();
        formData.append('excelFile', file);

        apiRequest(API_ENDPOINTS.uploadExcel, {
            method: 'POST',
            body: formData
        }).then(data => {
            console.log('Uploaded questions:', data);
            showSuccessMessage('Tải file Excel thành công');
            uploadedQuestions = data.data || [];
            questionCounter = uploadedQuestions.length;

            updateQuestionCount();
            updateTotalQuestions();
            assignmentTotalQuestionsInput.value = uploadedQuestions.length;
        }).catch(error => {
            console.error('Lỗi khi tải file Excel:', error);
            showErrorMessage('Không thể tải file Excel: ' + error.message);
            if (excelFileInput)
                excelFileInput.value = '';
            if (excelUploadArea) {
                excelUploadArea.querySelector('.upload-content').innerHTML = `
                    <i class="fas fa-file-excel upload-icon"></i>
                    <p>Kéo thả file Excel vào đây hoặc click để chọn</p>
                    <p class="upload-note">Hỗ trợ file .xlsx, .xls</p>
                `;
            }
        });
    }

    // Hiển thị chi tiết mục
    function showItemDetail(itemElement, type) {
    document.querySelectorAll('.lesson-item, .assignment-item').forEach(item => {
        item.classList.remove('active');
    });
    itemElement.classList.add('active');

    if (contentPlaceholder) contentPlaceholder.style.display = 'none';
    if (lessonContent) lessonContent.style.display = 'none';
    if (assignmentContent) assignmentContent.style.display = 'none';

    const itemId = itemElement.getAttribute('data-item-id');
    const item = lessonsAndAssignments.find(i => i.id === parseInt(itemId) && i.type === type);

    console.log("Finding item with id:", itemId, "and type:", type);
    console.log("Found item:", item);

    if (item) {
        if (type === 'lesson' && lessonContent) {
        lessonContent.style.display = 'block';
        const lessonTitle = lessonContent.querySelector('#lessonTitle');
        const lessonDescription = lessonContent.querySelector('#lessonDescription');
        const videoPlayer = lessonContent.querySelector('#videoPlayer');
        const videoDuration = lessonContent.querySelector('#videoDuration');
        const videoOverlay = lessonContent.querySelector('.video-overlay');

        if (lessonTitle) lessonTitle.textContent = item.title || 'Không có tiêu đề';
        if (lessonDescription) lessonDescription.textContent = item.description || 'Không có mô tả';
        if (videoPlayer && (item.mediaUrl || item.video)) {
            const videoUrl = item.mediaUrl || item.video; // Sử dụng video nếu mediaUrl không tồn tại
            console.log("Setting video source to:", videoUrl);
            videoPlayer.querySelector('source').src = videoUrl + (videoUrl.includes('?') ? '&' : '?') + 't=' + new Date().getTime();
            videoPlayer.querySelector('source').type = videoUrl.endsWith('.mp4') ? 'video/mp4' : videoUrl.endsWith('.webm') ? 'video/webm' : 'video/ogg';
            videoPlayer.load();
            videoPlayer.onloadedmetadata = () => {
                const duration = videoPlayer.duration;
                if (videoDuration) videoDuration.textContent = formatDuration(duration);
            };
            videoPlayer.onerror = () => {
                console.error('Error loading video:', videoUrl);
                showErrorMessage('Không thể tải video từ: ' + videoUrl);
            };
        } else {
            console.warn("No mediaUrl or video found for lesson:", item.id);
            showErrorMessage('Không tìm thấy video cho bài học này');
            if (videoOverlay) videoOverlay.style.display = 'none';
        }
            loadDocuments(item.id);
            loadExercises(item.id);
        } else if (type === 'assignment' && assignmentContent) {
            assignmentContent.style.display = 'block';
            const assignmentTitle = assignmentContent.querySelector('#assignmentTitle');
            const assignmentTopic = assignmentContent.querySelector('.assignment-topic');
            const assignmentDescription = assignmentContent.querySelector('#assignmentDescription');
            if (assignmentTitle) assignmentTitle.textContent = item.title || 'Không có tiêu đề';
            if (assignmentTopic) assignmentTopic.textContent = item.topicName || 'Chưa có chủ đề';
            if (assignmentDescription) assignmentDescription.textContent = item.description || `Nội dung bài tập: Đây là mô tả chi tiết cho ${item.title}`;
        }
        const sectionName = item.topicName || 'Chưa có chủ đề';
        expandedSections.add(sectionName);
        const sectionContent = document.getElementById(sectionName.replace(/[^a-zA-Z0-9]/g, ''));
        if (sectionContent) {
            sectionContent.classList.add('show');
            const toggleIcon = document.querySelector(`[data-section="${sectionName}"] .section-toggle i`);
            if (toggleIcon) toggleIcon.className = 'fas fa-chevron-down';
        }
    } else {
        console.error("Item not found for id:", itemId, "and type:", type);
        if (contentPlaceholder) contentPlaceholder.style.display = 'block';
        showErrorMessage('Không tìm thấy nội dung');
    }
}

// Hàm hỗ trợ định dạng thời lượng video
function formatDuration(seconds) {
    const minutes = Math.floor(seconds / 60);
    const secs = Math.floor(seconds % 60);
    return `${minutes}:${secs < 10 ? '0' : ''}${secs}`;
}
    // Tạo phần tử mục
    function createItemElement(item) {
        const itemElement = document.createElement('div');
        itemElement.className = item.type === 'lesson' ? 'lesson-item' : 'assignment-item';
        itemElement.setAttribute('data-item-id', item.id);
        itemElement.setAttribute('data-type', item.type);

        const icon = item.type === 'lesson' ? 'fas fa-play-circle' : 'fas fa-tasks';
        const statusHtml = item.type === 'lesson'
                ? `<div class="item-status ${item.isCompleted ? 'completed' : ''}"></div>`
                : '<div class="item-status"></div>';

        itemElement.innerHTML = `
        <span><i class="${icon}"></i> ${item.title}</span>
        ${statusHtml}
    `;

        itemElement.addEventListener('click', () => showItemDetail(itemElement, item.type));
        return itemElement;
    }
    // Chuyển đổi trạng thái section
    function toggleSection(sectionName) {
        const content = document.getElementById(sectionName.replace(/[^a-zA-Z0-9]/g, ''));
        const header = document.querySelector(`[data-section="${sectionName}"]`);
        const toggleIcon = header?.querySelector('.section-toggle i');

        if (content && header && toggleIcon) {
            if (expandedSections.has(sectionName)) {
                expandedSections.delete(sectionName);
                content.classList.remove('show');
                toggleIcon.className = 'fas fa-chevron-right';
            } else {
                expandedSections.add(sectionName);
                content.classList.add('show');
                toggleIcon.className = 'fas fa-chevron-down';
            }
        }
    }

    // Thêm câu hỏi
    function addQuestion() {
        const questionDiv = document.createElement('div');
        questionDiv.className = 'question-form mb-3';
        questionDiv.innerHTML = `
            <div class="form-group">
                <label>Câu hỏi ${questionCounter + 1}</label>
                <input type="text" class="form-control question-text-input" placeholder="Nhập câu hỏi..." required>
            </div>
            <div class="options-container">
                <div class="option-input-group mb-2">
                    <input type="radio" name="correct-${questionCounter}" value="0" checked>
                    <input type="text" class="form-control" placeholder="Đáp án A" required>
                </div>
                <div class="option-input-group mb-2">
                    <input type="radio" name="correct-${questionCounter}" value="1">
                    <input type="text" class="form-control" placeholder="Đáp án B" required>
                </div>
                <div class="option-input-group mb-2">
                    <input type="radio" name="correct-${questionCounter}" value="2">
                    <input type="text" class="form-control" placeholder="Đáp án C" required>
                </div>
                <div class="option-input-group mb-2">
                    <input type="radio" name="correct-${questionCounter}" value="3">
                    <input type="text" class="form-control" placeholder="Đáp án D" required>
                </div>
            </div>
            <button type="button" class="btn btn-sm btn-danger remove-question-btn mt-2">
                <i class="fas fa-trash"></i> Xóa câu hỏi
            </button>
        `;
        if (questionsContainer)
            questionsContainer.appendChild(questionDiv);

        questionDiv.querySelector('.remove-question-btn').addEventListener('click', () => {
            questionDiv.remove();
            questionCounter--;
            updateQuestionCount();
            updateTotalQuestions();
        });

        questionCounter++;
        updateQuestionCount();
        updateTotalQuestions();
    }

    // Cập nhật số lượng câu hỏi
    function updateQuestionCount() {
        if (questionCount)
            questionCount.textContent = questionCounter;
    }

    // Cập nhật tổng số câu hỏi
    function updateTotalQuestions() {
        if (assignmentTotalQuestionsInput)
            assignmentTotalQuestionsInput.value = questionCounter;
    }

    // Xử lý tải video
  function handleVideoUpload(e) {
    const file = e.target.files[0];
    console.log('Selected file:', file ? { name: file.name, type: file.type, size: file.size } : 'No file');
    if (!file) {
        showErrorMessage('Vui lòng chọn file video');
        return;
    }
    if (!['video/mp4', 'video/webm', 'video/ogg'].includes(file.type)) {
        showErrorMessage('Chỉ hỗ trợ định dạng MP4, WebM, hoặc OGG');
        videoFileInput.value = '';
        return;
    }
    if (file.size > 500 * 1024 * 1024) {
        showErrorMessage('Kích thước file vượt quá 500MB');
        videoFileInput.value = '';
        return;
    }
    selectedVideoFile = file;
    if (videoFileName) videoFileName.textContent = file.name;
    if (videoFileSize) videoFileSize.textContent = `${(file.size / 1024 / 1024).toFixed(2)} MB`;
    if (videoUploadArea) videoUploadArea.style.display = 'none';
    if (videoPreview) videoPreview.style.display = 'block';
    const url = URL.createObjectURL(file);
    if (previewVideo) {
        previewVideo.src = url;
        previewVideo.load();
    }
}
    // Reset video upload
    function resetVideoUpload() {
        selectedVideoFile = null;
        if (videoFileInput)
            videoFileInput.value = '';
        if (videoUrlInput)
            videoUrlInput.value = '';
        if (videoUploadArea)
            videoUploadArea.style.display = 'block';
        if (videoPreview)
            videoPreview.style.display = 'none';
        if (previewVideo)
            previewVideo.src = '';
        if (videoFileName)
            videoFileName.textContent = '';
        if (videoFileSize)
            videoFileSize.textContent = '';      
    }

    // Khởi tạo
    init();
});