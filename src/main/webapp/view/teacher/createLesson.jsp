<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tạo bài học mới - HIKARI Japanese</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/assets/css/teacher_css/createLesson.css" rel="stylesheet">

</head>
<body>
    <!-- Include Sidebar -->
        <%@ include file="sidebar.jsp" %>
    
    <div class="main-content">
        <!-- Include Header -->
            <%@ include file="header.jsp" %>
        
        <!-- Page Header -->
        <div class="page-header">
            <h1 class="page-title">
                <i class="fas fa-chalkboard-teacher"></i>
                Tạo bài học mới
            </h1>
            <div class="header-actions">
                <a href="manageLessons" class="btn btn-outline">
                    <i class="fas fa-arrow-left"></i>
                    Quay lại
                </a>
            </div>
        </div>
 

        <!-- Create Lesson Form -->
        <div class="form-container">
            <form method="POST" action="${pageContext.request.contextPath}/createLesson" class="lesson-form" id="createLessonForm" enctype="multipart/form-data">
                <input type="hidden" name="action" value="create">
                <c:if test="${not empty task}">
                    <input type="hidden" name="taskId" value="${task.taskId}">
                </c:if>
                <c:if test="${not empty param.taskID}">
                    <input type="hidden" name="taskID" value="${param.taskID}">
                </c:if>
                <c:if test="${not empty param.topicId}">
                    <input type="hidden" name="topicId" value="${param.topicId}">
                </c:if>
                
                <!-- Basic Information Section -->
                <div class="form-section">
                    <h3 class="section-title">
                        <i class="fas fa-info-circle"></i>
                        Thông tin cơ bản
                    </h3>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="title" class="form-label">Tiêu đề bài học *</label>
                            <input type="text" id="title" name="title" class="form-control" required 
                                   placeholder="Nhập tiêu đề bài học..." value="${lesson.title}">
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="courseInfo" class="form-label">Khóa học</label>
                            <input type="text" id="courseInfo" class="form-control" value="${course.title}" readonly>
                        </div>
                        
                        <div class="form-group">
                            <label for="topicInfo" class="form-label">Chủ đề</label>
                            <input type="text" id="topicInfo" class="form-control" value="${topic.topicName}" readonly>
                        </div>
                    </div>
                    
                    <div class="form-row">                      
                        <div class="form-group">
                            <label for="description" class="form-label">Mô tả bài học</label>
                            <textarea id="description" name="description" class="form-control" rows="4" 
                                      placeholder="Mô tả nội dung và mục tiêu của bài học...">${lesson.description}</textarea>
                        </div>
                    </div>
                </div>
                
                <!-- Content Section -->
                <div class="form-section">
                    <h3 class="section-title">
                        <i class="fas fa-file-alt"></i>
                        Nội dung bài học
                    </h3>
                    
                    <!-- Content Tabs -->
                    <div class="content-tabs">
                        <ul class="nav nav-tabs" id="contentTabs" role="tablist">
                            <li class="nav-item" role="presentation">
                                <button class="nav-link active" id="media-tab" data-bs-toggle="tab" data-bs-target="#media-content" 
                                        type="button" role="tab" aria-controls="media-content" aria-selected="true">
                                    <i class="fas fa-photo-video"></i> Media
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="documents-tab" data-bs-toggle="tab" data-bs-target="#documents-content" 
                                        type="button" role="tab" aria-controls="documents-content" aria-selected="false">
                                    <i class="fas fa-file-pdf"></i> Tài liệu
                                </button>
                            </li>
                        </ul>
                        
                        <div class="tab-content" id="contentTabsContent">
                            <!-- Media Content Tab -->
                            <div class="tab-pane fade show active" id="media-content" role="tabpanel" aria-labelledby="media-tab">
                                <div class="media-upload-section">
                                    <!-- Video Upload -->
                                    <div class="upload-group">
                                        <h5><i class="fas fa-video"></i> Video bài giảng <span class="text-danger">*</span></h5>
                                        <div class="upload-area" id="videoUploadArea">
                                            <div class="upload-placeholder">
                                                <i class="fas fa-cloud-upload-alt"></i>
                                                <p>Kéo thả video vào đây hoặc click để chọn</p>
                                                <small>Hỗ trợ: MP4, AVI, MOV, WEBM, MKV (tối đa 500MB) - <strong>Bắt buộc</strong></small>
                                            </div>
                                            <input type="file" id="mediaFile" name="mediaFile" accept="video/*" required style="display: none;">
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Documents Tab -->
                            <div class="tab-pane fade" id="documents-content" role="tabpanel" aria-labelledby="documents-tab">
                                <div class="documents-section">
                                    <div class="upload-group">
                                        <h5><i class="fas fa-file-pdf"></i> Tài liệu PDF</h5>
                                        <div class="upload-area" id="pdfUploadArea">
                                            <div class="upload-placeholder">
                                                <i class="fas fa-file-upload"></i>
                                                <p>Kéo thả file PDF vào đây hoặc click để chọn</p>
                                                <small>Hỗ trợ: PDF (tối đa 50MB)</small>
                                            </div>
                                            <input type="file" id="pdfFiles" name="pdfFiles" accept=".pdf" multiple style="display: none;">
                                        </div>
                                        <div class="documents-list" id="documentsList"></div>
                                    </div>
                                    
                                    <div class="upload-group">
                                        <h5><i class="fas fa-file-excel"></i> Bài tập Excel</h5>
                                        <div class="alert alert-info">
                                            <i class="fas fa-info-circle"></i>
                                            <strong>Hướng dẫn:</strong> Upload file Excel chứa câu hỏi để tạo bài tập. 
                                            File Excel cần có các cột: questionText, optionA, optionB, optionC, optionD, correctOption
                                        </div>
                                        <div class="upload-area" id="excelUploadArea">
                                            <div class="upload-placeholder">
                                                <i class="fas fa-table"></i>
                                                <p>Kéo thả file Excel vào đây hoặc click để chọn</p>
                                                <small>Hỗ trợ: XLS, XLSX (tối đa 20MB)</small>
                                            </div>
                                            <input type="file" id="excelFiles" name="excelFiles" accept=".xls,.xlsx" style="display: none;">
                                        </div>
                                        <div class="documents-list" id="excelList"></div>
                                        
                                        <!-- Exercise Details Form -->
                                        <div class="exercise-details" id="exerciseDetails" style="display: none;">
                                            <h5><i class="fas fa-edit"></i> Thông tin bài tập</h5>
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label for="exerciseTitle">Tiêu đề bài tập <span class="text-danger">*</span></label>
                                                        <input type="text" class="form-control" id="exerciseTitle" name="exerciseTitle" 
                                                               placeholder="Nhập tiêu đề bài tập" required>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label for="exerciseDescription">Mô tả</label>
                                                        <textarea class="form-control" id="exerciseDescription" name="exerciseDescription" 
                                                                  rows="3" placeholder="Mô tả ngắn về bài tập"></textarea>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <!-- Questions Preview -->
                                            <div class="questions-preview" id="questionsPreview">
                                                <h6><i class="fas fa-list"></i> Xem trước câu hỏi</h6>
                                                <div class="questions-list" id="questionsList"></div>
                                            </div>
                                            
                                            <div class="exercise-actions" style="display: none;">
                                                <button type="button" class="btn btn-success" id="createExerciseBtn">
                                                    <i class="fas fa-plus"></i> Tạo bài tập
                                                </button>
                                                <button type="button" class="btn btn-secondary" id="clearExerciseBtn">
                                                    <i class="fas fa-trash"></i> Xóa
                                                </button>
                                            </div>
                                            <div class="alert alert-success mt-3">
                                                <i class="fas fa-info-circle"></i>
                                                <strong>Lưu ý:</strong> Bài tập sẽ được tạo tự động khi bạn nhấn "Tạo bài học" (nếu có file Excel và tiêu đề bài tập).
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                                
                <!-- Form Actions -->
                <div class="form-actions">
                    <button type="button" class="btn btn-outline" onclick="history.back()">
                        <i class="fas fa-times"></i>
                        Hủy
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-check"></i>
                        Tạo bài học
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Custom JS -->
    <script src="${pageContext.request.contextPath}/assets/js/teacher_js/createLesson.js"></script>
</body>
</html>
