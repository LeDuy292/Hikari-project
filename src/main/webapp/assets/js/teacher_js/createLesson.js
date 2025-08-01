// Create Lesson JavaScript
document.addEventListener('DOMContentLoaded', function () {
    initializeForm();
    initializeFileUploads();
});

function initializeForm() {
    const form = document.getElementById('createLessonForm');
    if (form) {
        form.addEventListener('submit', handleFormSubmit);
    }
}
function handleFormSubmit(event) {
    event.preventDefault();

    const formData = new FormData(event.target);
    const title = formData.get('title');
    const description = formData.get('description');
    const topicId = formData.get('topicId');

    if (!title || title.trim() === '') {
        showNotification('Tiêu đề không được để trống.', 'error');
        return;
    }
    if (!description || description.trim() === '') {
        showNotification('Mô tả không được để trống.', 'error');
        return;
    }
    if (!topicId || topicId.trim() === '') {
        showNotification('Chủ đề không được để trống.', 'error');
        return;
    }

    // Validate video upload
    const mediaFile = document.getElementById('mediaFile');
    if (!mediaFile.files || mediaFile.files.length === 0) {
        showNotification('Vui lòng chọn video cho bài học. Video là bắt buộc.', 'error');
        return;
    }

    // Show loading state
    const submitBtn = event.target.querySelector('button[type="submit"]');
    const originalText = submitBtn.innerHTML;
    submitBtn.disabled = true;
    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang tạo bài học...';

    const url = event.target.getAttribute('action');

    fetch(url, {
        method: 'POST',
        body: formData
    })
            .then(response => response.json())
            .then(data => {
                if (data.status === 'success') {
                    showNotification('Tạo bài học thành công!', 'success');

                    // Save lessonId for exercise creation
                    if (data.lessonId) {
                        localStorage.setItem('currentLessonId', data.lessonId);

                        // Check if exercise should be created
                        const exerciseTitle = document.getElementById('exerciseTitle')?.value;
                        const hasUploadedQuestions = sessionStorage.getItem('hasUploadedQuestions') === 'true';

                        if (exerciseTitle && exerciseTitle.trim() && hasUploadedQuestions) {
                            // Get taskID and topicId for exercise creation
                            const taskID = data.taskID || new URLSearchParams(window.location.search).get('taskID');
                            const topicId = formData.get('topicId');

                            // Create exercise automatically
                            createExerciseAfterLesson(data.lessonId, submitBtn, originalText, taskID, topicId);
                            return; // Don't redirect yet, wait for exercise creation
                        }
                    }

                    // Redirect to taskCourse with taskID from localStorage or URL
                    setTimeout(() => {
                        const taskID = data.taskID || new URLSearchParams(window.location.search).get('taskID') || localStorage.getItem('currentTaskID');
                        window.location.href = '/Hikari/taskCourse?taskID=' + taskID;

                    }, 1500);
                } else {
                    showNotification('Lỗi: ' + data.message, 'error');
                    // Reset button
                    submitBtn.disabled = false;
                    submitBtn.innerHTML = originalText;
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showNotification('Lỗi khi gửi biểu mẫu: ' + error.message, 'error');
                // Reset button
                submitBtn.disabled = false;
                submitBtn.innerHTML = originalText;
            });
}
function initializeFileUploads() {
    // Media file upload
    const mediaFile = document.getElementById('mediaFile');
    const videoUploadArea = document.getElementById('videoUploadArea');
    const pdfFiles = document.getElementById('pdfFiles');
    const pdfUploadArea = document.getElementById('pdfUploadArea');
    const exerciseExcelFile = document.getElementById('exerciseExcelFile');
    const exerciseExcelUploadArea = document.getElementById('exerciseExcelUploadArea');

    if (mediaFile && videoUploadArea) {
        // Click to select file
        videoUploadArea.addEventListener('click', function () {
            mediaFile.click();
        });

        // Drag and drop functionality
        videoUploadArea.addEventListener('dragover', function (e) {
            e.preventDefault();
            this.classList.add('dragover');
        });

        videoUploadArea.addEventListener('dragleave', function (e) {
            e.preventDefault();
            this.classList.remove('dragover');
        });

        videoUploadArea.addEventListener('drop', function (e) {
            e.preventDefault();
            this.classList.remove('dragover');
            const files = e.dataTransfer.files;
            if (files.length > 0) {
                mediaFile.files = files;
                handleMediaFile(files[0]);
            }
        });

        // File input change
        mediaFile.addEventListener('change', function () {
            if (this.files.length > 0) {
                handleMediaFile(this.files[0]);
            }
        });
    }

    // PDF files upload (already declared above)

    if (pdfFiles && pdfUploadArea) {
        // Click to select file
        pdfUploadArea.addEventListener('click', function () {
            pdfFiles.click();
        });

        // Drag and drop functionality
        pdfUploadArea.addEventListener('dragover', function (e) {
            e.preventDefault();
            this.classList.add('dragover');
        });

        pdfUploadArea.addEventListener('dragleave', function (e) {
            e.preventDefault();
            this.classList.remove('dragover');
        });

        pdfUploadArea.addEventListener('drop', function (e) {
            e.preventDefault();
            this.classList.remove('dragover');
            const files = e.dataTransfer.files;
            if (files.length > 0) {
                pdfFiles.files = files;
                handlePdfFiles(files);
            }
        });

        // File input change
        pdfFiles.addEventListener('change', function () {
            if (this.files.length > 0) {
                handlePdfFiles(this.files);
            }
        });
    }

    // Excel files upload
    const excelFiles = document.getElementById('excelFiles');
    const excelUploadArea = document.getElementById('excelUploadArea');

    if (excelFiles && excelUploadArea) {
        // Click to select file
        excelUploadArea.addEventListener('click', function () {
            excelFiles.click();
        });

        // Drag and drop functionality
        excelUploadArea.addEventListener('dragover', function (e) {
            e.preventDefault();
            this.classList.add('dragover');
        });

        excelUploadArea.addEventListener('dragleave', function (e) {
            e.preventDefault();
            this.classList.remove('dragover');
        });

        excelUploadArea.addEventListener('drop', function (e) {
            e.preventDefault();
            this.classList.remove('dragover');
            const files = e.dataTransfer.files;
            if (files.length > 0) {
                excelFiles.files = files;
                handleExcelFiles(files);
            }
        });

        // File input change
        excelFiles.addEventListener('change', function () {
            if (this.files.length > 0) {
                handleExcelFiles(this.files);
            }
        });
    }



    // Initialize exercise form handlers
    initializeExerciseHandlers();
}

function handleMediaFile(file) {
    const uploadArea = document.getElementById('videoUploadArea');
    const placeholder = uploadArea.querySelector('.upload-placeholder');

    // Validate file type
    const allowedTypes = ['video/mp4', 'video/avi', 'video/mov', 'video/webm', 'video/mkv'];
    if (!allowedTypes.includes(file.type)) {
        showNotification('Loại file không được hỗ trợ. Vui lòng chọn file video (MP4, AVI, MOV, WEBM, MKV).', 'error');
        return;
    }

    // Validate file size (500MB)
    const maxSize = 500 * 1024 * 1024; // 500MB in bytes
    if (file.size > maxSize) {
        showNotification('File quá lớn. Kích thước tối đa là 500MB.', 'error');
        return;
    }

    // Show selected file info
    placeholder.innerHTML = `
        <i class="fas fa-check-circle text-success"></i>
        <p>Đã chọn: ${file.name}</p>
        <small>Kích thước: ${formatFileSize(file.size)}</small>
    `;

    // Add remove button
    const removeBtn = document.createElement('button');
    removeBtn.type = 'button';
    removeBtn.className = 'btn btn-sm btn-danger mt-2';
    removeBtn.innerHTML = '<i class="fas fa-times"></i> Xóa file';
    removeBtn.onclick = function () {
        document.getElementById('mediaFile').value = '';
        placeholder.innerHTML = `
                <i class="fas fa-cloud-upload-alt"></i>
                <p>Kéo thả video vào đây hoặc click để chọn</p>
                <small>Hỗ trợ: MP4, AVI, MOV, WEBM, MKV (tối đa 500MB)</small>
            `;
        removeBtn.remove();
    };
    uploadArea.appendChild(removeBtn);
}

function handlePdfFiles(files) {
    const uploadArea = document.getElementById('pdfUploadArea');
    const documentsList = document.getElementById('documentsList');

    // Clear previous list
    documentsList.innerHTML = '';

    for (let file of files) {
        // Validate file type
        if (file.type !== 'application/pdf') {
            showNotification(`File ${file.name} không phải là PDF.`, 'error');
            continue;
        }

        // Validate file size (50MB)
        const maxSize = 50 * 1024 * 1024; // 50MB in bytes
        if (file.size > maxSize) {
            showNotification(`File ${file.name} quá lớn. Kích thước tối đa là 50MB.`, 'error');
            continue;
        }

        // Add file to list
        const fileItem = document.createElement('div');
        fileItem.className = 'file-item d-flex align-items-center justify-content-between p-2 border rounded mb-2';
        fileItem.innerHTML = `
            <div>
                <i class="fas fa-file-pdf text-danger"></i>
                <span class="ms-2">${file.name}</span>
                <small class="text-muted ms-2">(${formatFileSize(file.size)})</small>
            </div>
            <button type="button" class="btn btn-sm btn-outline-danger" onclick="removeFile(this)">
                <i class="fas fa-times"></i>
            </button>
        `;
        documentsList.appendChild(fileItem);
    }

    // Update placeholder
    const placeholder = uploadArea.querySelector('.upload-placeholder');
    if (files.length > 0) {
        placeholder.innerHTML = `
            <i class="fas fa-check-circle text-success"></i>
            <p>Đã chọn ${files.length} file PDF</p>
        `;
    }
}

function handleExcelFiles(files) {
    const uploadArea = document.getElementById('excelUploadArea');
    const excelList = document.getElementById('excelList');

    // Clear previous list
    excelList.innerHTML = '';

    for (let file of files) {
        // Validate file type
        const allowedTypes = [
            'application/vnd.ms-excel',
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
        ];
        if (!allowedTypes.includes(file.type)) {
            showNotification(`File ${file.name} không phải là Excel file.`, 'error');
            continue;
        }

        // Validate file size (20MB)
        const maxSize = 20 * 1024 * 1024; // 20MB in bytes
        if (file.size > maxSize) {
            showNotification(`File ${file.name} quá lớn. Kích thước tối đa là 20MB.`, 'error');
            continue;
        }

        // Upload and parse Excel file for exercise
        uploadExcelFileForExercise(file);

        // Add file to list
        const fileItem = document.createElement('div');
        fileItem.className = 'file-item d-flex align-items-center justify-content-between p-2 border rounded mb-2';
        fileItem.innerHTML = `
            <div>
                <i class="fas fa-file-excel text-success"></i>
                <span class="ms-2">${file.name}</span>
                <small class="text-muted ms-2">(${formatFileSize(file.size)})</small>
            </div>
            <button type="button" class="btn btn-sm btn-outline-danger" onclick="removeFile(this)">
                <i class="fas fa-times"></i>
            </button>
        `;
        excelList.appendChild(fileItem);
    }

    // Update placeholder
    const placeholder = uploadArea.querySelector('.upload-placeholder');
    if (files.length > 0) {
        placeholder.innerHTML = `
            <i class="fas fa-check-circle text-success"></i>
            <p>Đã chọn ${files.length} file Excel</p>
        `;
    }
}

function removeFile(button) {
    const fileItem = button.closest('.file-item');
    if (fileItem) {
        fileItem.remove();
    }
}

function formatFileSize(bytes) {
    if (bytes === 0)
        return '0 Bytes';
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
}

// Global context path variable
const contextPath = document.querySelector('meta[name="context-path"]')?.getAttribute('content') || '';

// Notification function
function showNotification(message, type = 'info') {
    // Remove existing notifications
    const existingNotifications = document.querySelectorAll('.custom-notification');
    existingNotifications.forEach(notification => notification.remove());

    // Create notification element
    const notification = document.createElement('div');
    notification.className = `custom-notification custom-notification-${type}`;
    notification.innerHTML = `
        <div class="notification-content">
            <i class="fas ${type === 'success' ? 'fa-check-circle' : type === 'error' ? 'fa-exclamation-circle' : 'fa-info-circle'}"></i>
            <span>${message}</span>
            <button class="notification-close" onclick="this.parentElement.parentElement.remove()">
                <i class="fas fa-times"></i>
            </button>
        </div>
    `;

    // Add to page
    document.body.appendChild(notification);

    // Auto-hide after 5 seconds
    setTimeout(() => {
        if (notification.parentElement) {
            notification.remove();
        }
    }, 5000);
}

// Exercise handling functions
function initializeExerciseHandlers() {
    const createExerciseBtn = document.getElementById('createExerciseBtn');
    const clearExerciseBtn = document.getElementById('clearExerciseBtn');

    if (createExerciseBtn) {
        createExerciseBtn.addEventListener('click', createExercise);
    }

    if (clearExerciseBtn) {
        clearExerciseBtn.addEventListener('click', clearExerciseData);
    }
}

function uploadExcelFileForExercise(file) {
    const formData = new FormData();
    formData.append('excelFile', file);

    // Show loading
    showNotification('Đang xử lý file Excel...', 'info');

    fetch(contextPath + '/Hikari/UploadFileExcel', {
        method: 'POST',
        body: formData
    })
            .then(response => response.json())
            .then(data => {
                if (Array.isArray(data)) {
                    // Success - questions parsed
                    showNotification(`Đã đọc thành công ${data.length} câu hỏi từ file Excel.`, 'success');
                    displayQuestions(data);
                    showExerciseDetails();
                    // Mark that questions have been uploaded
                    sessionStorage.setItem('hasUploadedQuestions', 'true');
                } else if (data.status === 'error') {
                    showNotification(data.message, 'error');
                    sessionStorage.setItem('hasUploadedQuestions', 'false');
                }
            })
            .catch(error => {
                console.error('Error uploading Excel file:', error);
                showNotification('Lỗi khi upload file Excel.', 'error');
            });
}

function displayQuestions(questions) {
    const questionsList = document.getElementById('questionsList');
    questionsList.innerHTML = '';

    questions.forEach((question, index) => {
        const questionItem = document.createElement('div');
        questionItem.className = 'question-item border rounded p-3 mb-2';
        questionItem.innerHTML = `
            <div class="question-header">
                <strong>Câu ${index + 1}:</strong> ${question.questionText}
            </div>
            <div class="question-options mt-2">
                <div class="row">
                    <div class="col-md-6">
                        <small><strong>A:</strong> ${question.optionA}</small><br>
                        <small><strong>B:</strong> ${question.optionB}</small>
                    </div>
                    <div class="col-md-6">
                        <small><strong>C:</strong> ${question.optionC}</small><br>
                        <small><strong>D:</strong> ${question.optionD}</small>
                    </div>
                </div>
                <div class="mt-2">
                    <span class="badge bg-success">Đáp án đúng: ${question.correctOption}</span>
                    <span class="badge bg-info ms-2">Điểm: ${question.mark}</span>
                </div>
            </div>
        `;
        questionsList.appendChild(questionItem);
    });
}

function showExerciseDetails() {
    const exerciseDetails = document.getElementById('exerciseDetails');
    exerciseDetails.style.display = 'block';
}

function createExercise() {
    const exerciseTitle = document.getElementById('exerciseTitle').value;
    const exerciseDescription = document.getElementById('exerciseDescription').value;

    if (!exerciseTitle.trim()) {
        showNotification('Vui lòng nhập tiêu đề bài tập.', 'error');
        return;
    }

    // Get lesson ID from localStorage (set when lesson is created)
    const lessonId = localStorage.getItem('currentLessonId');

    if (!lessonId) {
        showNotification('Vui lòng tạo bài học trước khi tạo bài tập.', 'error');
        return;
    }

    const formData = new FormData();
    formData.append('type', 'exercise');
    formData.append('title', exerciseTitle);
    formData.append('description', exerciseDescription);
    formData.append('lessonId', lessonId);

    // Show loading
    const createBtn = document.getElementById('createExerciseBtn');
    const originalText = createBtn.innerHTML;
    createBtn.disabled = true;
    createBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang tạo bài tập...';

    fetch(contextPath + '/Hikari/SaveQuestionServlet', {
        method: 'POST',
        body: formData
    })
            .then(response => response.json())
            .then(data => {
                if (data.status === 'success') {
                    showNotification('Tạo bài tập thành công!', 'success');
                    clearExerciseData();
                } else {
                    showNotification(data.message || 'Lỗi khi tạo bài tập.', 'error');
                }
            })
            .catch(error => {
                console.error('Error creating exercise:', error);
                showNotification('Lỗi khi tạo bài tập.', 'error');
            })
            .finally(() => {
                createBtn.disabled = false;
                createBtn.innerHTML = originalText;
            });
}

function createExerciseAfterLesson(lessonId, submitBtn, originalText, taskID, topicId) {
    const exerciseTitle = document.getElementById('exerciseTitle').value;
    const exerciseDescription = document.getElementById('exerciseDescription').value;

    showNotification('Đang tạo bài tập...', 'info');

    const formData = new FormData();
    formData.append('type', 'exercise');
    formData.append('title', exerciseTitle);
    formData.append('description', exerciseDescription);
    formData.append('lessonId', lessonId);

    fetch(contextPath + '/Hikari/SaveQuestionServlet', {
        method: 'POST',
        body: formData
    })
            .then(response => response.json())
            .then(data => {
                if (data.status === 'success') {
                    showNotification('Tạo bài học và bài tập thành công!', 'success');

                    // Clear session storage
                    sessionStorage.removeItem('hasUploadedQuestions');

                    // Redirect after successful creation
                    setTimeout(() => {
                        const finalTaskID = taskID || localStorage.getItem('currentTaskID');
                        window.location.href = '/Hikari/taskCourse?taskID=' + taskID;

                    }, 1500);
                } else {
                    showNotification('Bài học đã tạo thành công nhưng có lỗi khi tạo bài tập: ' + (data.message || 'Lỗi không xác định'), 'warning');

                    // Still redirect even if exercise creation failed
                    setTimeout(() => {
                        const finalTaskID = taskID || localStorage.getItem('currentTaskID');
                        window.location.href = '/Hikari/taskCourse?taskID=' + taskID;

                    }, 2000);
                }
            })
            .catch(error => {
                console.error('Error creating exercise:', error);
                showNotification('Bài học đã tạo thành công nhưng có lỗi khi tạo bài tập.', 'warning');

                // Still redirect even if exercise creation failed
                setTimeout(() => {
                    const finalTaskID = taskID || localStorage.getItem('currentTaskID');
                    window.location.href = '/Hikari/taskCourse?taskID=' + taskID;

                }, 2000);
            })
            .finally(() => {
                // Reset button state
                submitBtn.disabled = false;
                submitBtn.innerHTML = originalText;
            });
}

function clearExerciseData() {
    // Clear form
    document.getElementById('exerciseTitle').value = '';
    document.getElementById('exerciseDescription').value = '';

    // Clear file input
    const excelFiles = document.getElementById('excelFiles');
    if (excelFiles) {
        excelFiles.value = '';
    }

    // Reset upload area
    const uploadArea = document.getElementById('excelUploadArea');
    if (uploadArea) {
        const placeholder = uploadArea.querySelector('.upload-placeholder');
        if (placeholder) {
            placeholder.innerHTML = `
                <i class="fas fa-table"></i>
                <p>Kéo thả file Excel vào đây hoặc click để chọn</p>
                <small>Hỗ trợ: XLS, XLSX (tối đa 20MB)</small>
            `;
        }
    }

    // Clear questions list
    const questionsList = document.getElementById('questionsList');
    if (questionsList) {
        questionsList.innerHTML = '';
    }

    // Hide exercise details
    const exerciseDetails = document.getElementById('exerciseDetails');
    if (exerciseDetails) {
        exerciseDetails.style.display = 'none';
    }

    // Clear session storage
    sessionStorage.removeItem('hasUploadedQuestions');

    showNotification('Đã xóa dữ liệu bài tập.', 'info');
}