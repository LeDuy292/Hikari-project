<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="context-path" content="${pageContext.request.contextPath}">
        <title>Tạo bài tập mới - HIKARI Japanese</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/teacher_css/createTest.css">
        <style>
            .assignment-stats {
                background: #f8f9fa;
                border-radius: 8px;
                padding: 1rem;
                margin-bottom: 1.5rem;
                border: 1px solid #e0e0e0;
            }
            .stat-card {
                display: flex;
                align-items: center;
                gap: 0.75rem;
                margin-bottom: 0.5rem;
            }
            .stat-icon {
                font-size: 1.2rem;
                color: #4a90e2;
            }
            .stat-content {
                flex: 1;
            }
            .stat-value {
                font-size: 1.1rem;
                font-weight: 600;
                color: #333;
            }
            .stat-label {
                font-size: 0.8rem;
                color: #6c757d;
            }
            .excel-upload-area {
                border: 2px dashed #ddd;
                border-radius: 8px;
                padding: 2rem;
                text-align: center;
                cursor: pointer;
                transition: all 0.3s ease;
            }
            .excel-upload-area:hover,
            .excel-upload-area.dragover {
                border-color: #4a90e2;
                background-color: #f0f7fa;
                transform: scale(1.02);
            }
            .question-item {
                background: #fff;
                border: 1px solid #e0e0e0;
                border-radius: 8px;
                padding: 1rem;
                margin-bottom: 1rem;
            }
            .form-row {
                display: flex;
                gap: 1rem;
                margin-bottom: 1rem;
            }
            .form-row .form-group {
                flex: 1;
            }
            .btn:disabled {
                opacity: 0.6;
                cursor: not-allowed;
            }
            .fa-spinner {
                animation: spin 1s linear infinite;
            }
            @keyframes spin {
                0% {
                    transform: rotate(0deg);
                }
                100% {
                    transform: rotate(360deg);
                }
            }
            .alert {
                margin-bottom: 1rem;
            }
            .upload-progress {
                display: none;
                margin-top: 1rem;
            }
            .progress {
                height: 20px;
            }
        </style>
    </head>
    <body>
        <%@ include file="sidebar.jsp" %>
        <div class="main-content">
            <%@ include file="header.jsp" %>
            <div class="page-header">
                <h1 class="page-title">
                    <i class="fas fa-plus-circle"></i>
                    Tạo bài tập mới
                </h1>
                <div class="header-actions">
                    <a href="taskCourse?taskID=${task.taskID}" class="btn btn-outline">       
                        <i class="fas fa-arrow-left"></i>
                        Quay lại
                    </a>
                </div>
            </div>

            <c:if test="${not empty successMessage}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle"></i>
                    ${successMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle"></i>
                    ${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="form-container">
                <form method="POST" action="${pageContext.request.contextPath}/createAssignment" class="assignment-form" id="createAssignmentForm" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="create">
                    <input type="hidden" name="topicId" value="${topic.topicId}">
                    <input type="hidden" name="taskID" value="${task.taskID}">
                    <input type="hidden" name="totalQuestions" value="0">
                    <input type="hidden" name="totalMark" value="100">

                    <div class="form-section">
                        <h3 class="section-title">
                            <i class="fas fa-info-circle"></i>
                            Thông tin cơ bản
                        </h3>
                        <div class="form-row">
                            <div class="form-group">
                                <label for="title" class="form-label">Tên bài tập *</label>
                                <input type="text" id="title" name="title" class="form-control" required placeholder="Nhập tên bài tập...">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="description" class="form-label">Mô tả</label>
                            <textarea id="description" name="description" class="form-control" rows="4" placeholder="Mô tả về nội dung và mục đích của bài tập..."></textarea>
                        </div>
                    </div>

                    <div class="form-section">
                        <h3 class="section-title">
                            <i class="fas fa-question-circle"></i>
                            Câu hỏi
                        </h3>
                        <div class="question-input-methods">
                            <ul class="nav nav-pills mb-3" id="questionTabs" role="tablist">
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link active" id="manual-tab" data-bs-toggle="pill" data-bs-target="#manual-questions" type="button" role="tab" aria-controls="manual-questions" aria-selected="true">
                                        <i class="fas fa-edit"></i> Nhập thủ công
                                    </button>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link" id="excel-tab" data-bs-toggle="pill" data-bs-target="#excel-questions" type="button" role="tab" aria-controls="excel-questions" aria-selected="false">
                                        <i class="fas fa-file-excel"></i> Import Excel
                                    </button>
                                </li>
                            </ul>

                            <div class="tab-content" id="questionTabsContent">
                                <div class="tab-pane fade show active" id="manual-questions" role="tabpanel" aria-labelledby="manual-tab">
                                    <div class="questions-container">
                                        <div class="questions-header">
                                            <h5>Danh sách câu hỏi</h5>
                                            <button type="button" class="btn btn-primary btn-sm" onclick="addQuestion()">
                                                <i class="fas fa-plus"></i> Thêm câu hỏi
                                            </button>
                                        </div>
                                        <div class="questions-list" id="questionsList"></div>
                                    </div>
                                </div>
                                <div class="tab-pane fade" id="excel-questions" role="tabpanel" aria-labelledby="excel-tab">
                                    <div class="excel-import-section">
                                        <div class="import-instructions">
                                            <h5><i class="fas fa-info-circle"></i> Hướng dẫn import Excel</h5>
                                            <ul>
                                                <li>File Excel phải có header: questionText, optionA, optionB, optionC, optionD, correctOption</li>
                                                <li>Đáp án đúng ghi bằng chữ cái (A, B, C, D)</li>
                                                <li>Điểm mỗi câu sẽ được tính tự động</li>
                                            </ul>
                                        </div>
                                        <div class="excel-upload-area" id="excelUploadArea">
                                            <div class="upload-placeholder">
                                                <i class="fas fa-file-excel"></i>
                                                <p>Kéo thả file Excel vào đây hoặc click để chọn</p>
                                                <small>Hỗ trợ: XLS, XLSX (tối đa 10MB)</small>
                                            </div>
                                            <input type="file" id="excelFile" name="excelFile" accept=".xls,.xlsx" style="display: none;">
                                        </div>
                                        <div class="upload-progress" id="uploadProgress">
                                            <div class="progress">
                                                <div class="progress-bar" role="progressbar" style="width: 0%"></div>
                                            </div>
                                            <small class="text-muted">Đang xử lý file...</small>
                                        </div>
                                        <div class="assignment-stats" id="assignmentStats" style="display: none;">
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="stat-card">
                                                        <div class="stat-icon">
                                                            <i class="fas fa-question-circle"></i>
                                                        </div>
                                                        <div class="stat-content">
                                                            <div class="stat-value" id="statsQuestions">0</div>
                                                            <div class="stat-label">Tổng số câu hỏi</div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="stat-card">
                                                        <div class="stat-icon">
                                                            <i class="fas fa-star"></i>
                                                        </div>
                                                        <div class="stat-content">
                                                            <div class="stat-value" id="statsPoints">0</div>
                                                            <div class="stat-label">Tổng điểm</div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="button" class="btn btn-outline" onclick="history.back()">
                            <i class="fas fa-times"></i>
                            Hủy
                        </button>
                        <button type="submit" class="btn btn-primary" id="submitBtn">
                            <i class="fas fa-check"></i>
                            Tạo bài tập
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/teacher_js/createAssignment.js"></script>
    </body>
</html>