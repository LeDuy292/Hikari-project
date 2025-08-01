<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết Nhiệm vụ - HIKARI Japanese</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/teacher_css/task.css">
    <style>                       
        .task-detail-container {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 2rem;
            margin-top: 1rem;
            }       
        .detail-card {
            background: #ffffff;
            border-radius: 12px;
            padding: 2rem;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }
        
        .requirements-list {
            list-style: none;
            padding: 0;
        }
        
        .requirements-list li {
            display: flex;
            align-items: flex-start;
            gap: 0.5rem;
            margin-bottom: 0.75rem;
            padding: 0.5rem;
            background-color: #f8f9fa;
            border-radius: 6px;
        }
        
        .requirement-icon {
            color: var(--success-color);
            margin-top: 0.1rem;
        }
        
        .task-meta {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }
        
        .task-meta-item {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.75rem;
            background-color: #f8f9fa;
            border-radius: 8px;
        }
        
        .task-meta-icon {
            color: var(--primary-color);
            font-size: 1.2rem;
            width: 20px;
        }
        
        .progress-indicator {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin: 1rem 0;
        }
        
        .progress-steps {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            flex: 1;
        }
        
        .progress-step {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background-color: #e0e0e0;
        }
        
        .progress-step.completed {
            background-color: var(--success-color);
        }
        
        .progress-step.current {
            background-color: var(--primary-color);
        }
        
        .progress-line {
            flex: 1;
            height: 2px;
            background-color: #e0e0e0;
            margin: 0 0.5rem;
        }
        
        .progress-line.completed {
            background-color: var(--success-color);
        }
        
        .sidebar-info {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }
        
        @media (max-width: 768px) {
            .main-content {
                padding-left: 1rem;
            }
            
            .task-detail-container {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Include Sidebar -->
            <%@ include file="sidebar.jsp" %>
            
            <div class="main-content">
                <!-- Include Header -->
                <%@ include file="header.jsp" %>
                
                <!-- Error Display -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger" role="alert">
                        <strong>Lỗi:</strong> ${error}
                    </div>
                </c:if>
                
                <!-- Back Button -->
                <div class="mb-3">
                    <a href="${pageContext.request.contextPath}/teacher/tasks" class="btn btn-outline">
                        <i class="fas fa-arrow-left"></i>
                        Quay lại
                    </a>
                </div>
                
                <div class="task-detail-container">
                    <!-- Main Content -->
                    <div class="detail-card">
                        <div class="task-header">
                            <h2 class="task-title">
                                <i class="task-icon ${not empty task.courseID ? 'fas fa-book-open' : 'fas fa-clipboard-check'}"></i>
                                <c:choose>
                                    <c:when test="${not empty task.courseID}">Quản lý Khóa học</c:when>
                                    <c:otherwise>Tạo Bài Test</c:otherwise>
                                </c:choose>
                            </h2>
                            <span class="task-status ${task.status == 'Assigned' ? 'status-assigned' : 
                                                      task.status == 'In Progress' ? 'status-progress' : 
                                                      task.status == 'Submitted' ? 'status-submitted' : 'status-reviewed'}">
                                ${task.status}
                            </span>
                        </div>
                        
                        <div class="mt-4">
                            <h4>Mô tả nhiệm vụ</h4>
                            <p class="task-description">${task.description}</p>
                        </div>                               
                        <hr>
                        
                        <div>
                            <h4>Yêu cầu cụ thể</h4>
                            <ul class="requirements-list">
                                <c:choose>
                                    <c:when test="${not empty task.courseID}">
                                        <li>
                                            <i class="fas fa-check-circle requirement-icon"></i>
                                            <span>Quản lý và tổ chức nội dung khóa học</span>
                                        </li>
                                        <li>
                                            <i class="fas fa-check-circle requirement-icon"></i>
                                            <span>Tạo và cập nhật các topic trong khóa học</span>
                                        </li>
                                        <li>
                                            <i class="fas fa-check-circle requirement-icon"></i>
                                            <span>Thêm bài học, tài liệu và bài tập cho từng topic</span>
                                        </li>
                                        <li>
                                            <i class="fas fa-check-circle requirement-icon"></i>
                                            <span>Đảm bảo chất lượng nội dung phù hợp với cấp độ</span>
                                        </li>
                                    </c:when>
                                    <c:otherwise>
                                        <li>
                                            <i class="fas fa-check-circle requirement-icon"></i>
                                            <span>Tạo bài test JLPT ${task.jlptLevel} hoàn chỉnh</span>
                                        </li>
                                        <li>
                                            <i class="fas fa-check-circle requirement-icon"></i>
                                            <span>File Excel với cấu trúc câu hỏi chuẩn</span>
                                        </li>
                                        <li>
                                            <i class="fas fa-check-circle requirement-icon"></i>
                                            <span>Phân bố câu hỏi theo tiêu chuẩn JLPT</span>
                                        </li>
                                        <li>
                                            <i class="fas fa-check-circle requirement-icon"></i>
                                            <span>Thời gian và điểm số phù hợp với cấp độ</span>
                                        </li>
                                    </c:otherwise>
                                </c:choose>
                            </ul>
                        </div>
                        
                        <!-- Action Buttons -->
                        <div class="task-actions mt-4">
                            <c:choose>
                                <c:when test="${task.status == 'Assigned'}">
                                    <button class="btn btn-primary" onclick="startTask(${task.taskID}, '${not empty task.courseID ? 'course' : 'test'}')">
                                        <i class="fas fa-play"></i>
                                        Bắt đầu làm nhiệm vụ
                                    </button>
                                </c:when>
                                <c:when test="${task.status == 'In Progress'}">
                                    <button class="btn btn-success" onclick="continueTask(${task.taskID}, '${not empty task.courseID ? 'course' : 'test'}')">
                                        <i class="fas fa-arrow-right"></i>
                                        Tiếp tục làm việc
                                    </button>
                                </c:when>
                            </c:choose>
                            
                            
                            <a href="${pageContext.request.contextPath}/message?receiverID=${task.coordinatorID}" class="btn btn-outline">
                                <i class="fas fa-user"></i>
                                Liên hệ Coordinator
                            </a>
                        </div>
                    </div>
                    
                    <!-- Sidebar Info -->
                    <div class="sidebar-info">
                        <!-- Task Info -->
                        <div class="detail-card">
                            <h4>Thông tin Nhiệm vụ</h4>
                            
                            <div class="task-meta">
                                <div class="task-meta-item">
                                    <i class="fas fa-user task-meta-icon"></i>
                                    <div>
                                        <strong>${task.coordinatorName}</strong>
                                        <br>
                                        <small class="text-muted">Coordinator</small>
                                    </div>
                                </div>
                                
                                <div class="task-meta-item">
                                    <i class="fas fa-calendar task-meta-icon"></i>
                                    <div>
                                        <strong>Ngày phân công</strong>
                                        <br>
                                        <small>${task.assignedDate}</small>
                                    </div>
                                </div>
                                
                                <div class="task-meta-item">
                                    <i class="fas fa-clock task-meta-icon"></i>
                                    <div>
                                        <strong>Hạn chót</strong>
                                        <br>
                                        <small>${task.deadline}</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Course/Test Info -->
                        <c:if test="${not empty task.courseID}">
                            <div class="detail-card">
                                <h4>Thông tin Khóa học</h4>
                                
                                <div class="task-meta">
                                    <div class="task-meta-item">
                                        <i class="fas fa-book-open task-meta-icon"></i>
                                        <div>
                                            <strong>${task.courseName}</strong>
                                            <br>
                                            <small>Mã: ${task.courseID}</small>
                                        </div>
                                    </div>
                                    

                                </div>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty task.testID}">
                            <div class="detail-card">
                                <h4>Thông tin Test</h4>
                                
                                <div class="task-meta">
                                    <div class="task-meta-item">
                                        <i class="fas fa-clipboard-check task-meta-icon"></i>
                                        <div>
                                            <strong>JLPT ${task.jlptLevel}</strong>
                                            <br>
                                            <small>Cấp độ test</small>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="mt-3">
                                    <h6>Tiêu chuẩn JLPT ${task.jlptLevel}</h6>
                                    <c:choose>
                                        <c:when test="${task.jlptLevel == 'N5'}">
                                            <ul class="list-unstyled small text-muted">
                                                <li>• Hiragana, Katakana cơ bản</li>
                                                <li>• 100 Kanji cơ bản</li>
                                                <li>• 800 từ vựng</li>
                                                <li>• Ngữ pháp cơ bản</li>
                                                <li>• Hội thoại đơn giản</li>
                                            </ul>
                                        </c:when>
                                        <c:when test="${task.jlptLevel == 'N4'}">
                                            <ul class="list-unstyled small text-muted">
                                                <li>• 300 Kanji</li>
                                                <li>• 1,500 từ vựng</li>
                                                <li>• Ngữ pháp trung cấp</li>
                                                <li>• Đọc hiểu văn bản ngắn</li>
                                                <li>• Nghe hiểu hội thoại</li>
                                            </ul>
                                        </c:when>
                                        <c:otherwise>
                                            <ul class="list-unstyled small text-muted">
                                                <li>• Kiến thức nâng cao</li>
                                                <li>• Từ vựng phong phú</li>
                                                <li>• Ngữ pháp phức tạp</li>
                                                <li>• Đọc hiểu chuyên sâu</li>
                                            </ul>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:if>
                        
                        <!-- Progress -->
                        <div class="detail-card">
                            <h4>Tiến độ</h4>
                            
                            <div class="progress-indicator">
                                <div class="progress-steps">
                                    <div class="progress-step ${task.status == 'Assigned' || task.status == 'In Progress' || task.status == 'Submitted' || task.status == 'Reviewed' ? 'completed' : ''}"></div>
                                    <div class="progress-line ${task.status == 'In Progress' || task.status == 'Submitted' || task.status == 'Reviewed' ? 'completed' : ''}"></div>
                                    <div class="progress-step ${task.status == 'In Progress' ? 'current' : task.status == 'Submitted' || task.status == 'Reviewed' ? 'completed' : ''}"></div>
                                    <div class="progress-line ${task.status == 'Submitted' || task.status == 'Reviewed' ? 'completed' : ''}"></div>
                                    <div class="progress-step ${task.status == 'Submitted' ? 'current' : task.status == 'Reviewed' ? 'completed' : ''}"></div>
                                    <div class="progress-line ${task.status == 'Reviewed' ? 'completed' : ''}"></div>
                                    <div class="progress-step ${task.status == 'Reviewed' ? 'completed' : ''}"></div>
                                </div>
                            </div>
                            
                            <div class="d-flex justify-content-between small text-muted mt-2">
                                <span>Bắt đầu</span>
                                <span>Hoàn thành</span>
                            </div>
                            
                            <div class="mt-3">
                                <strong>Trạng thái hiện tại:</strong> ${task.status}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Custom JS -->
    <script src="${pageContext.request.contextPath}/assets/js/teacher_js/task.js"></script>
</body>
</html>