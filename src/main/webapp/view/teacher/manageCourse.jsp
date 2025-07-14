
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Quản Lý Khóa Học - Nền Tảng Giáo Dục</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" rel="stylesheet" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/teacher_css/manageCourse.css" />
        <script>
            window.contextPath = '${pageContext.request.contextPath}';
        </script>
    </head>
    <body>
        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <%@ include file="sidebar.jsp" %>

                <!-- Main Content -->
                <main class="main-content col-md-9 ms-sm-auto col-lg-10 px-md-4">
                    <div class="content-wrapper">
                        <!-- Header -->
                        <%@ include file="header.jsp" %>

                        <!-- Course List View -->
                        <div class="row" id="courseListView">
                            <div class="col-12">
                                <div class="course-grid">
                                    <c:forEach var="course" items="${courses}">
                                        <div class="course-card" data-course-id="${course.courseID}">
                                            <img src="${pageContext.request.contextPath}${course.imageUrl}" alt="${course.title}" class="course-image" />
                                            <div class="course-content">
                                                <div class="course-title">${course.title}</div>
                                                <div class="course-description">${course.description}</div>
                                                <div class="course-footer">
                                                    <span class="course-students">
                                                        <i class="fas fa-users"></i> ${studentCount[course.getCourseID()]} học viên
                                                    </span>
                                                    <button class="course-action-btn btn btn-primary">Xem chi tiết</button>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>

                        <!-- Lesson Detail View -->
                        <div class="row" id="lessonDetailView" style="display: none;">
                            <div class="col-12">
                                <a href="#" class="back-btn" id="backToCourses">
                                    <i class="fas fa-arrow-left"></i> Quay lại Khóa Học
                                </a>

                                <div class="lesson-detail-container">
                                    <!-- Left Sidebar - Lesson List -->
                                    <div class="lesson-sidebar">
                                        <div class="lesson-list-header">
                                            <div class="lesson-list-title">Nội Dung Khóa Học</div>
                                            <div class="lesson-count" id="lessonCount">0</div>
                                        </div>

                                        <input type="text" class="search-input" id="lessonSearch" placeholder="Tìm kiếm nội dung..." />

                                        <div id="lessonList" class="lesson-progress"></div>
                                        <!-- Pagination for Lesson List -->
                                        <div class="pagination-container mt-3">
                                            <nav aria-label="Lesson pagination">
                                                <ul class="pagination justify-content-center" id="lessonPagination">
                                                    <!-- Pagination items will be added dynamically -->
                                                </ul>
                                            </nav>
                                        </div>
                                    </div>

                                    <!-- Right Content Area -->
                                    <div class="lesson-content-area">
                                        <!-- Default State -->
                                        <div class="content-placeholder" id="contentPlaceholder">
                                            <div class="placeholder-icon">
                                                <i class="fas fa-graduation-cap"></i>
                                            </div>
                                            <h3>Chọn một bài học hoặc bài tập</h3>
                                            <p>Chọn nội dung từ danh sách bên trái để bắt đầu học tập</p>
                                        </div>

                                        <!-- Lesson Content -->
                                        <div class="lesson-content" id="lessonContent" style="display: none;">
                                            <!-- Video Container -->
                                            <div class="lesson-video-container">
                                                <div class="lesson-video" id="lessonVideo">
                                                    <video controls id="videoPlayer" style="width: 100%; height: 360px;">
                                                        <source src="" type="video/mp4">
                                                        Trình duyệt không hỗ trợ video.
                                                    </video>
                                                    <div class="video-overlay" style="display: none;">
                                                        <div class="play-button">
                                                            <i class="fas fa-play"></i>
                                                        </div>
                                                    </div>
                                                    <div class="video-info">
                                                        <span class="video-duration" id="videoDuration"></span>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Lesson Tabs -->
                                            <div class="lesson-tabs">
                                                <div class="lesson-tab-buttons">
                                                    <button class="lesson-tab-btn active" data-tab="lesson-info">
                                                        <i class="fas fa-book"></i>
                                                        <span>Bài học</span>
                                                    </button>
                                                    <button class="lesson-tab-btn" data-tab="exercises">
                                                        <i class="fas fa-tasks"></i>
                                                        <span>Bài tập</span>
                                                    </button>
                                                </div>

                                                <!-- Lesson Info Tab -->
                                                <div class="lesson-tab-content active" id="lesson-info">
                                                    <div class="lesson-info-section">
                                                        <div class="lesson-header">
                                                            <div class="lesson-type-badge lesson-badge">
                                                                <i class="fas fa-play-circle"></i>
                                                                <span>Bài Học</span>
                                                            </div>
                                                            <h2 class="lesson-title" id="lessonTitle"></h2>
                                                            <span class="lesson-description" id="lessonDescription"></span>
                                                        </div>
                                                        <div class="lesson-description" id="lessonDescription"></div>

                                                        <!-- Documents Section -->
                                                        <div class="documents-section">
                                                            <div class="documents-header">
                                                                <h4><i class="fas fa-file-alt"></i> Tài liệu tham khảo</h4>
                                                                <button class="btn-add-document" id="addDocumentBtn">
                                                                    <i class="fas fa-plus"></i>
                                                                    <span>Thêm tài liệu</span>
                                                                </button>
                                                            </div>
                                                            <div id="documentList" class="document-list-container"></div> 
                                                            <!-- Add Document Form (Hidden by default) -->
                                                            <div class="add-document-form" id="addDocumentForm" style="display: none;">
                                                                <div class="modal-content">
                                                                    <h3>Thêm tài liệu</h3>
                                                                    <form id="documentForm">
                                                                        <div class="form-group">
                                                                            <label for="documentName">Tên tài liệu</label>
                                                                            <input type="text" class="form-control" id="documentName" placeholder="Nhập tên tài liệu" required>
                                                                        </div>
                                                                        <div class="form-group">
                                                                            <label for="documentDescription">Mô tả</label>
                                                                            <textarea class="form-control" id="documentDescription" placeholder="Nhập mô tả"></textarea>
                                                                        </div>
                                                                        <div class="form-group">
                                                                            <label for="documentFileInput">File tài liệu</label>
                                                                            <div id="documentUploadArea" class="upload-area">
                                                                                <div class="upload-content">
                                                                                    <i class="fas fa-file upload-icon"></i>
                                                                                    <p>Kéo thả file vào đây hoặc click để chọn</p>
                                                                                    <p class="upload-note">Hỗ trợ file .pdf, .doc, .docx (tối đa 10MB)</p>
                                                                                </div>
                                                                            </div>
                                                                            <input type="file" id="documentFileInput" accept=".pdf,.doc,.docx" style="display: none;" required>
                                                                            <div id="documentFilePreview" style="display: none;">
                                                                                <p id="documentFileName"></p>
                                                                                <p id="documentFileSize"></p>
                                                                            </div>
                                                                        </div>
                                                                        <button type="button" id="saveDocumentBtn" class="btn btn-primary">Lưu</button>
                                                                        <button type="button" id="cancelDocumentBtn" class="btn btn-secondary">Hủy</button>
                                                                    </form>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <div id="documentsContainer"></div>
                                                    </div>
                                                </div>

                                                <!-- Exercises Tab -->
                                                <div class="lesson-tab-content" id="exercises">
                                                    <div class="exercise-section">
                                                        <div class="exercise-header-section">
                                                            <h3><i class="fas fa-tasks"></i> Bài tập thực hành</h3>
                                                            <button class="btn-add-exercise" id="addExerciseBtn">
                                                                <i class="fas fa-plus"></i>
                                                                <span>Thêm bài tập</span>
                                                            </button>
                                                        </div>

                                                        <!-- Add Exercise Form (Hidden by default) -->
                                                        <div class="add-exercise-form" id="addExerciseForm" style="display: none;">
                                                            <div class="form-card">
                                                                <h4>Thêm bài tập mới</h4>
                                                                <form id="exerciseForm">
                                                                    <div class="mb-3">
                                                                        <label for="exerciseTitle" class="form-label">Tiêu đề bài tập</label>
                                                                        <input type="text" class="form-control" id="exerciseTitle" placeholder="Nhập tiêu đề bài tập..." required>
                                                                    </div>
                                                                    <div class="mb-3">
                                                                        <label for="exerciseDescription" class="form-label">Mô tả</label>
                                                                        <textarea class="form-control" id="exerciseDescription" rows="3" placeholder="Mô tả bài tập..."></textarea>
                                                                    </div>
                                                                    <div class="mb-3">
                                                                        <label class="form-label">Tải lên câu hỏi từ Excel</label>
                                                                        <div class="excel-upload-area" id="excelExerciseUploadArea">
                                                                            <div class="upload-content">
                                                                                <i class="fas fa-file-excel upload-icon"></i>
                                                                                <p>Kéo thả file Excel vào đây hoặc click để chọn</p>
                                                                                <p class="upload-note">Hỗ trợ file .xlsx, .xls</p>
                                                                                <input type="file" id="excelExerciseFileInput" accept=".xlsx,.xls" style="display: none;">
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    <div class="form-actions">
                                                                        <button type="button" class="btn-save-exercise" id="saveExerciseBtn">Lưu bài tập</button>
                                                                        <button type="button" class="btn-cancel-exercise" id="cancelExerciseBtn">Hủy</button>
                                                                    </div>
                                                                </form>
                                                            </div>
                                                        </div>

                                                        <div class="exercises-container" id="exercisesContainer"></div>
                                                        <!-- Pagination for Exercises -->
                                                        <div class="pagination-container mt-3">
                                                            <nav aria-label="Exercise pagination">
                                                                <ul class="pagination justify-content-center" id="exercisePagination">
                                                                    <!-- Pagination items will be added dynamically -->
                                                                </ul>
                                                            </nav>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Assignment Content -->
                                        <div class="assignment-content" id="assignmentContent" style="display: none;">
                                            <!-- Assignment Header -->
                                            <div class="assignment-header-card">
                                                <div class="assignment-icon-large">
                                                    <i class="fas fa-tasks"></i>
                                                </div>
                                                <div class="assignment-header">
                                                    <div class="lesson-type-badge assignment-badge">
                                                        <i class="fas fa-tasks"></i>
                                                        <span>Bài Tập</span>
                                                    </div>
                                                    <h2 class="assignment-title" id="assignmentTitle"></h2>
                                                </div>

                                                <div class="assignment-stats">
                                                    <div class="stat-item">
                                                        <div class="stat-number" id="assignmentTotalQuestions">0</div>
                                                        <div class="stat-label">Câu hỏi</div>
                                                    </div>
                                                    <div class="stat-item">
                                                        <div class="stat-number" id="assignmentTotalMarks">100</div>
                                                        <div class="stat-label">Điểm</div>
                                                    </div>
                                                    <div class="stat-item">
                                                        <div class="stat-number" id="assignmentTimeLimit">0</div>
                                                        <div class="stat-label">Phút</div>
                                                    </div>
                                                </div>

                                                <div class="assignment-description" id="assignmentDescription"></div>
                                            </div>

                                            <!-- Assignment Questions -->
                                            <div class="assignment-questions-section">
                                                <div class="section-header">
                                                    <h3><i class="fas fa-question-circle"></i> Danh Sách Câu Hỏi</h3>
                                                </div>
                                                <div class="assignment-questions" id="assignmentQuestions"></div>
                                                <!-- Pagination for Assignment Questions -->
                                                <div class="pagination-container mt-3">
                                                    <nav aria-label="Assignment questions pagination">
                                                        <ul class="pagination justify-content-center" id="assignmentQuestionsPagination">
                                                            <!-- Pagination items will be added dynamically -->
                                                        </ul>
                                                    </nav>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Action Buttons -->
                            <div class="action-buttons">
                                <button class="btn btn-primary btn-add-lesson" id="addLessonBtn">
                                    <i class="fas fa-plus"></i>
                                    <span>Thêm Bài Học</span>
                                </button>
                                <button class="btn btn-warning btn-add-assignment" id="addAssignmentBtn">
                                    <i class="fas fa-plus"></i>
                                    <span>Thêm Bài Tập</span>
                                </button>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <!-- Add Lesson Modal -->
        <div class="modal fade" id="addLessonModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="fas fa-play-circle text-primary"></i>
                            Thêm Bài Học Mới
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <form id="addLessonForm">
                            <div class="mb-3">
                                <label for="lessonTitleInput" class="form-label">Tiêu đề bài học</label>
                                <input type="text" class="form-control" id="lessonTitleInput" required>
                            </div>
                            <div class="mb-3">
                                <label for="lessonDescriptionInput" class="form-label">Mô tả</label>
                                <textarea class="form-control" id="lessonDescriptionInput" rows="3"></textarea>
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="lessonTopicInput" class="form-label">Chủ đề</label>
                                        <select class="form-select" id="lessonTopicInput" required>
                                            <option value="">Chọn chủ đề</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="lessonDurationInput" class="form-label">Thời lượng (phút)</label>
                                        <input type="number" class="form-control" id="lessonDurationInput" readonly>
                                    </div>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Video bài học</label>
                                <div class="video-upload-section">
                                    <!-- Video Upload Options -->
                                        <!-- File Upload Section -->
                                        <div class="video-file-section" id="videoFileSection" ">
                                            <div class="video-upload-area" id="videoUploadArea">
                                                <div class="upload-content">
                                                    <i class="fas fa-video upload-icon"></i>
                                                    <p>Kéo thả video vào đây hoặc click để chọn</p>
                                                    <p class="upload-note">Hỗ trợ MP4, AVI, MOV (tối đa 500MB)</p>
                                                    <input type="file" id="videoFileInput" accept="video/*" style="display: none;">
                                                </div>
                                            </div>

                                            <!-- Video Preview -->
                                            <div class="video-preview" id="videoPreview" style="display: none;">
                                                <video controls class="preview-video" id="previewVideo">
                                                    <source src="" type="video/mp4">
                                                    Trình duyệt không hỗ trợ video.
                                                </video>
                                                <div class="video-info">
                                                    <div class="video-name" id="videoFileName"></div>
                                                    <div class="video-size" id="videoFileSize"></div>
                                                    <button type="button" class="btn btn-sm btn-danger" id="removeVideoBtn">
                                                        <i class="fas fa-trash"></i> Xóa video
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="button" class="btn btn-primary" id="saveLessonBtn">
                            <i class="fas fa-save"></i> Lưu Bài Học
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Add Assignment Modal -->
        <div class="modal fade" id="addAssignmentModal" tabindex="-1">
            <div class="modal-dialog modal-xl">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="fas fa-tasks text-warning"></i>
                            Thêm Bài Tập Mới
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <form id="addAssignmentForm">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="assignmentTitleInput" class="form-label">Tiêu đề bài tập</label>
                                        <input type="text" class="form-control" id="assignmentTitleInput" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="assignmentTopicInput" class="form-label">Chủ đề</label>
                                        <select class="form-select" id="assignmentTopicInput" required>
                                            <option value="">Chọn chủ đề</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="assignmentDescriptionInput" class="form-label">Mô tả</label>
                                <textarea class="form-control" id="assignmentDescriptionInput" rows="3"></textarea>
                            </div>

                            <div class="row">
                                <div class="col-md-4">
                                    <div class="mb-3">
                                        <label for="assignmentDurationInput" class="form-label" >Thời lượng (phút)</label>
                                        <input type="number" class="form-control" id="assignmentDurationInput" required>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="mb-3">
                                        <label for="assignmentTotalMarksInput" class="form-label">Tổng điểm</label>
                                        <input type="number" class="form-control" id="assignmentTotalMarksInput" value="100" readonly>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="mb-3">
                                        <label for="assignmentTotalQuestionsInput" class="form-label">Số câu hỏi</label>
                                        <input type="number" class="form-control" id="assignmentTotalQuestionsInput" readonly>
                                    </div>
                                </div>
                            </div>

                            <!-- Excel Upload -->
                            <div class="mb-4">
                                <label class="form-label">Tải lên câu hỏi từ Excel</label>
                                <div class="excel-upload-area" id="excelUploadArea">
                                    <div class="upload-content">
                                        <i class="fas fa-file-excel upload-icon"></i>
                                        <p>Kéo thả file Excel vào đây hoặc click để chọn</p>
                                        <p class="upload-note">Hỗ trợ file .xlsx, .xls</p>
                                        <input type="file" id="excelFileInput" accept=".xlsx,.xls" style="display: none;">
                                    </div>
                                </div>
                            </div>

                            <!-- Manual Questions -->
                            <div class="mb-3">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <label class="form-label">Câu hỏi (<span id="questionCount">0</span>)</label>
                                    <button type="button" class="btn btn-sm btn-outline-primary" id="addQuestionBtn">
                                        <i class="fas fa-plus"></i> Thêm câu hỏi
                                    </button>
                                </div>
                                <div id="questionsContainer"></div>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="button" class="btn btn-warning" id="saveAssignmentBtn">
                            <i class="fas fa-save"></i> Lưu Bài Tập
                        </button>
                    </div>
                </div>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/teacher_js/manageCourse.js"></script>
    </body>
</html>