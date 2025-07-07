<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Quản Lý Bài Test - Nền Tảng Giáo Dục</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" rel="stylesheet" />
        <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@700&display=swap" rel="stylesheet" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/teacher_css/test.css" />
    </head>
    <body>
        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <%@ include file="sidebar.jsp" %>

                <!-- Main Content -->
                <main class="main-content">
                    <div class="content-wrapper">
                        <!-- Header -->
                        <%@ include file="header.jsp" %>

                        <!-- Main Content -->
                        <div class="row">
                            <!-- Test List -->
                            <div class="col-12" id="testList">
                                <div class="test-header-main">
                                    <button class="btn btn-primary uploadExcel-btn" id="uploadExcelBtn">
                                        <i class="fas fa-upload"></i> Thêm Bài Test 
                                    </button>
                                </div>

                                <div class="test-grid" id="testGrid">
                                    <c:choose>
                                        <c:when test="${not empty testList}">
                                            <c:forEach var="test" items="${testList}" varStatus="status">
                                                <div class="test-card">
                                                    <div class="test-content">
                                                        <div class="test-title">${test.title}</div>
                                                        <div class="test-description">
                                                            ${test.description != null ? test.description : 'Bài test kiểm tra trình độ, gồm nhiều câu hỏi dạng.'}
                                                        </div>
                                                        <div class="test-info">
                                                            <span><i class="fas fa-question"></i> <span class="question-count">${test.totalQuestions}</span> câu hỏi</span>
                                                            <span><i class="fas fa-level"></i> Level:<span class="jlptLevel">${test.jlptLevel}</span></span>
                                                            <span><i class="fas fa-clock"></i> <span class="duration">${test.duration != null ? test.duration : 60}</span> phút</span>
                                                        </div>
                                                        <div class="test-actions">
                                                            <button class="btn-edit" onclick="editTest(${test.id})">
                                                                <i class="fas fa-edit"></i> Chỉnh sửa
                                                            </button>
                                                            <button class="btn-view" onclick="viewResults(${test.id})">
                                                                <i class="fas fa-chart-bar"></i> Xem kết quả
                                                            </button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="col-12">
                                                <div class="empty-state">
                                                    <i class="fas fa-clipboard-list"></i>
                                                    <h3>Chưa có bài test nào</h3>
                                                    <p>Hãy tạo bài test đầu tiên bằng cách upload file Excel</p>
                                                </div>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <nav aria-label="Test pagination" class="mt-4" id="testListPagination">
                                    <ul class="pagination justify-content-center">
                                        <!-- Pagination sẽ được điền bởi JavaScript -->
                                    </ul>
                                </nav>
                            </div>
                            <!-- Question Detail Section -->
                            <div class="col-12" id="questionDetail" style="display: none;">
                                <!-- Back Button -->
                                <div class="question-detail-header">
                                    <a href="#" class="back-btn" id="backToTests">
                                        <i class="fas fa-arrow-left"></i> Quay lại Bài Test
                                    </a>
                                </div>

                                <!-- Question Detail Layout -->
                                <div class="question-detail-container">
                                    <!-- Left Navigation -->
                                    <div class="question-detail-left">
                                        <div class="question-list-header">
                                            <h5 class="question-list-title">Danh sách câu hỏi</h5>
                                            <div class="question-stats">
                                                <div class="stat-badge total">
                                                    Tổng: <span id="totalQuestions">0</span> câu
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Question Navigation Grid -->
                                        <div class="question-progress" id="questionProgress">
                                            <!-- Questions will be populated by JavaScript -->
                                        </div>

                                        <!-- Add Question Button -->
                                        <div class="question-actions-nav">
                                            <button class="btn btn-success btn-sm w-100" id="addQuestionBtn">
                                                <i class="fas fa-plus"></i> Thêm câu hỏi
                                            </button>
                                        </div>
                                    </div>

                                    <!-- Right Content Area -->
                                    <div class="question-detail-right">
                                        <!-- Question Content Display -->
                                        <div class="question-content" id="questionContent">
                                            <div class="empty-question-state">
                                                <i class="fas fa-question-circle"></i>
                                                <h4>Chọn câu hỏi để xem chi tiết</h4>
                                                <p>Click vào số thứ tự câu hỏi bên trái để xem nội dung</p>
                                            </div>
                                        </div>

                                        <!-- Edit Question Form -->
                                        <div class="edit-question-form" id="editQuestionForm" style="display: none;">
                                            <div class="form-card">
                                                <div class="form-header">
                                                    <h5>Chỉnh sửa câu hỏi <span id="editQuestionNumber"></span></h5>
                                                    <button type="button" class="btn-close-form" id="cancelEditQuestionBtn">
                                                        <i class="fas fa-times"></i>
                                                    </button>
                                                </div>

                                                <form id="questionEditForm">
                                                    <div class="mb-3">
                                                        <label for="editQuestionText" class="form-label">Nội Dung Câu Hỏi *</label>
                                                        <textarea class="form-control" id="editQuestionText" rows="4" required></textarea>
                                                    </div>

                                                    <div class="mb-3">
                                                        <label class="form-label">Đáp Án *</label>
                                                        <div class="option-group">
                                                            <div class="option-item-edit">
                                                                <div class="option-input-group">
                                                                    <span class="option-label">A.</span>
                                                                    <input type="text" class="form-control option-input" placeholder="Đáp án A" required />
                                                                </div>
                                                                <div class="form-check">
                                                                    <input type="radio" name="correctAnswer" value="A" class="form-check-input" />
                                                                    <label class="form-check-label">Đúng</label>
                                                                </div>
                                                            </div>

                                                            <div class="option-item-edit">
                                                                <div class="option-input-group">
                                                                    <span class="option-label">B.</span>
                                                                    <input type="text" class="form-control option-input" placeholder="Đáp án B" required />
                                                                </div>
                                                                <div class="form-check">
                                                                    <input type="radio" name="correctAnswer" value="B" class="form-check-input" />
                                                                    <label class="form-check-label">Đúng</label>
                                                                </div>
                                                            </div>

                                                            <div class="option-item-edit">
                                                                <div class="option-input-group">
                                                                    <span class="option-label">C.</span>
                                                                    <input type="text" class="form-control option-input" placeholder="Đáp án C" required />
                                                                </div>
                                                                <div class="form-check">
                                                                    <input type="radio" name="correctAnswer" value="C" class="form-check-input" />
                                                                    <label class="form-check-label">Đúng</label>
                                                                </div>
                                                            </div>

                                                            <div class="option-item-edit">
                                                                <div class="option-input-group">
                                                                    <span class="option-label">D.</span>
                                                                    <input type="text" class="form-control option-input" placeholder="Đáp án D" required />
                                                                </div>
                                                                <div class="form-check">
                                                                    <input type="radio" name="correctAnswer" value="D" class="form-check-input" />
                                                                    <label class="form-check-label">Đúng</label>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="form-actions">
                                                        <button type="button" class="btn btn-success" id="saveEditBtn">
                                                            <i class="fas fa-save"></i> Lưu thay đổi
                                                        </button>
                                                        <button type="button" class="btn btn-secondary" id="cancelEditBtn">
                                                            <i class="fas fa-times"></i> Hủy
                                                        </button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>

                                        <!-- Add Question Form -->
                                        <div class="add-question-form" id="addQuestionForm" style="display: none;">
                                            <div class="form-card">
                                                <div class="form-header">
                                                    <h5>Thêm câu hỏi mới</h5>
                                                    <button type="button" class="btn-close-form" id="cancelAddQuestionBtn">
                                                        <i class="fas fa-times"></i>
                                                    </button>
                                                </div>

                                                <form id="questionAddForm">
                                                    <div class="mb-3">
                                                        <label for="addQuestionText" class="form-label">Nội Dung Câu Hỏi *</label>
                                                        <textarea class="form-control" id="addQuestionText" rows="4" required></textarea>
                                                    </div>

                                                    <div class="mb-3">
                                                        <label class="form-label">Đáp Án *</label>
                                                        <div class="option-group">
                                                            <div class="option-item-edit">
                                                                <div class="option-input-group">
                                                                    <span class="option-label">A.</span>
                                                                    <input type="text" class="form-control option-input-add" placeholder="Đáp án A" required />
                                                                </div>
                                                                <div class="form-check">
                                                                    <input type="radio" name="correctAnswerAdd" value="A" class="form-check-input" />
                                                                    <label class="form-check-label">Đúng</label>
                                                                </div>
                                                            </div>

                                                            <div class="option-item-edit">
                                                                <div class="option-input-group">
                                                                    <span class="option-label">B.</span>
                                                                    <input type="text" class="form-control option-input-add" placeholder="Đáp án B" required />
                                                                </div>
                                                                <div class="form-check">
                                                                    <input type="radio" name="correctAnswerAdd" value="B" class="form-check-input" />
                                                                    <label class="form-check-label">Đúng</label>
                                                                </div>
                                                            </div>

                                                            <div class="option-item-edit">
                                                                <div class="option-input-group">
                                                                    <span class="option-label">C.</span>
                                                                    <input type="text" class="form-control option-input-add" placeholder="Đáp án C" required />
                                                                </div>
                                                                <div class="form-check">
                                                                    <input type="radio" name="correctAnswerAdd" value="C" class="form-check-input" />
                                                                    <label class="form-check-label">Đúng</label>
                                                                </div>
                                                            </div>

                                                            <div class="option-item-edit">
                                                                <div class="option-input-group">
                                                                    <span class="option-label">D.</span>
                                                                    <input type="text" class="form-control option-input-add" placeholder="Đáp án D" required />
                                                                </div>
                                                                <div class="form-check">
                                                                    <input type="radio" name="correctAnswerAdd" value="D" class="form-check-input" />
                                                                    <label class="form-check-label">Đúng</label>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="form-actions">
                                                        <button type="button" class="btn btn-primary" id="saveAddBtn">
                                                            <i class="fas fa-plus"></i> Thêm câu hỏi
                                                        </button>
                                                        <button type="button" class="btn btn-secondary" id="cancelAddBtn">
                                                            <i class="fas fa-times"></i> Hủy
                                                        </button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Test Results Section -->
                            <div class="col-12" id="testResults" style="display: none;">
                                <!-- Results Header -->
                                <div class="results-header">
                                    <div class="results-header-left">
                                        <a href="#" class="back-btn" id="backToTestsFromResults">
                                            <i class="fas fa-arrow-left"></i> Quay lại Bài Test
                                        </a>
                                    </div>
                                    <div class="results-actions">
                                        <div class="search-box">
                                            <input type="text" class="form-control" id="searchStudents" placeholder="Tìm kiếm học sinh...">
                                            <i class="fas fa-search"></i>
                                        </div>
                                    </div>
                                </div>

                                <!-- Test Statistics -->
                                <div class="test-statistics" id="testStatistics">
                                    <div class="stat-card">
                                        <div class="stat-icon">
                                            <i class="fas fa-users"></i>
                                        </div>
                                        <div class="stat-content">
                                            <div class="stat-number" id="totalStudentsCount">0</div>
                                            <div class="stat-label">Tổng học sinh</div>
                                        </div>
                                    </div>
                                    <div class="stat-card">
                                        <div class="stat-icon">
                                            <i class="fas fa-check-circle"></i>
                                        </div>
                                        <div class="stat-content">
                                            <div class="stat-number" id="completedCount">0</div>
                                            <div class="stat-label">Đã hoàn thành</div>
                                        </div>
                                    </div>
                                    <div class="stat-card">
                                        <div class="stat-icon">
                                            <i class="fas fa-chart-line"></i>
                                        </div>
                                        <div class="stat-content">
                                            <div class="stat-number" id="averageScore">0</div>
                                            <div class="stat-label">Điểm trung bình</div>
                                        </div>
                                    </div>
                                    <div class="stat-card">
                                        <div class="stat-icon">
                                            <i class="fas fa-trophy"></i>
                                        </div>
                                        <div class="stat-content">
                                            <div class="stat-number" id="passRate">0%</div>
                                            <div class="stat-label">Tỷ lệ đậu</div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Results Table -->
                                <div class="results-table-container">
                                    <div class="table-responsive">
                                        <table class="table table-hover results-table" id="resultsTable">
                                            <thead>
                                                <tr>
                                                    <th>STT</th>
                                                    <th>Mã học sinh</th>
                                                    <th>Tên học sinh</th>
                                                    <th>Điểm số</th>
                                                    <th>Thời gian làm bài</th>
                                                    <th>Trạng thái</th>
                                                </tr>
                                            </thead>
                                            <tbody id="resultsTableBody">
                                                <!-- Results will be populated by JavaScript -->
                                            </tbody>
                                        </table>
                                    </div>
                                </div>

                                <!-- Empty Results State -->
                                <div class="empty-results-state" id="emptyResultsState" style="display: none;">
                                    <i class="fas fa-chart-bar"></i>
                                    <h3>Chưa có kết quả nào</h3>
                                    <p>Chưa có học sinh nào làm bài test này</p>
                                </div>

                                <!-- Pagination for Results -->
                                <nav aria-label="Results pagination" class="mt-4" id="resultsPagination" style="display: none;">
                                    <ul class="pagination justify-content-center">
                                        <!-- Pagination will be populated by JavaScript -->
                                    </ul>
                                </nav>
                            </div>

                            <!-- Student Answer Detail Section -->
                            <div class="col-12" id="studentAnswerDetail" style="display: none;">
                                <!-- Student Answer Header -->
                                <div class="student-info-header">
                                    <div class="student-info">
                                        <a href="#" class="back-btn" id="backToResults">
                                            <i class="fas fa-arrow-left"></i> Quay lại Kết quả
                                        </a>
                                        <div class="student-details-section">
                                            <h3 id="studentName">Chi tiết bài làm</h3>
                                        </div>
                                    </div>
                                </div>

                                <!-- Answer Review Container -->
                                <div class="answer-review-container">
                                    <!-- Question Navigation -->
                                    <div class="question-navigation">
                                        <div class="nav-header">
                                            <h5>Danh sách câu hỏi</h5>
                                            <div class="nav-stats">
                                                <div class="correct-count">Đúng: <span id="correctAnswersCount">0</span></div>
                                                <div class="wrong-count">Sai: <span id="wrongAnswersCount">0</span></div>
                                                <div class="unanswered-count">Chưa trả lời: <span id="unansweredCount">0</span></div>
                                            </div>
                                        </div>
                                        <div class="question-nav-grid" id="questionNavGrid">
                                            <!-- Question navigation will be populated by JavaScript -->
                                        </div>
                                    </div>

                                    <!-- Answer Detail -->
                                    <div class="answer-detail">
                                        <div class="answer-comparison" id="answerContent">
                                            <div class="empty-answer-state">
                                                <i class="fas fa-clipboard-check"></i>
                                                <h4>Chọn câu hỏi để xem chi tiết</h4>
                                                <p>Click vào số thứ tự câu hỏi bên trái để xem câu trả lời</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- Student Answer Detail Section -->
                            <div id="studentAnswerDetail" style="display: none;">
                                <div class="card mb-4">
                                    <div class="card-header d-flex justify-content-between align-items-center">
                                        <h3 class="mb-0">Chi tiết bài làm</h3>
                                        <button id="backToResults" class="btn btn-secondary">
                                            <i class="fas fa-arrow-left"></i> Quay lại kết quả
                                        </button>
                                    </div>
                                    <div class="card-body">
                                        <!-- Student Information -->
                                        <div class="student-info mb-4">
                                            <h4 id="studentName" class="mb-2"></h4>
                                            <p><strong>Mã học sinh:</strong> <span id="studentId"></span></p>
                                            <p><strong>Điểm số:</strong> <span id="studentScore"></span></p>
                                            <p><strong>Thời gian làm bài:</strong> <span id="studentTime"></span></p>
                                            <p><strong>Trạng thái:</strong> <span id="studentStatus"></span></p>
                                        </div>

                                        <!-- Answer Statistics -->
                                        <div class="answer-stats mb-4 d-flex gap-4">
                                            <span><strong>Đúng:</strong> <span id="correctAnswersCount">0</span></span>
                                            <span><strong>Sai:</strong> <span id="wrongAnswersCount">0</span></span>
                                            <span><strong>Chưa trả lời:</strong> <span id="unansweredCount">0</span></span>
                                        </div>

                                        <!-- Question Navigation Grid -->
                                        <div id="questionNavGrid" class="question-nav-grid mb-4"></div>

                                        <!-- Answer Comparison -->
                                        <div id="answerContent" class="answer-comparison"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <!-- Upload Excel Modal -->
        <div class="modal fade" id="uploadExcelModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Thêm bài test mới</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <p class="text-muted">
                                <i class="fas fa-info-circle me-2"></i>
                                Chọn file Excel (.xlsx) với định dạng: questionText, optionA, optionB, optionC, optionD, correctOption
                            </p>
                        </div>
                        <div class="mb-3">
                            <label for="excelFileInput" class="form-label">Chọn file Excel</label>
                            <input type="file" class="form-control" id="excelFileInput" accept=".xlsx,.xls">
                            <div class="form-text">Chỉ chấp nhận file .xlsx hoặc .xls</div>
                        </div>
                        <div id="uploadProgress" class="progress" style="display: none;">
                            <div class="progress-bar progress-bar-striped progress-bar-animated" 
                                 role="progressbar" style="width: 0%"></div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="button" class="btn btn-primary" id="uploadFileBtn">
                            <i class="fas fa-upload me-2"></i>Tải lên
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Success/Error Messages -->
        <c:if test="${not empty successMessage}">
            <div class="position-fixed top-0 end-0 p-3" style="z-index: 9999;">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>
                    ${successMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </div>
        </c:if>

        <c:if test="${not empty errorMessage}">
            <div class="position-fixed top-0 end-0 p-3" style="z-index: 9999;">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>
                    ${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </div>
        </c:if>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/teacher_js/test.js"></script>
    </body>
</html>
