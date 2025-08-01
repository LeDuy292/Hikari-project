<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý Khóa học - HIKARI Japanese</title>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <!-- Custom CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/teacher_css/task.css">

        <style>
            :root {
                --primary-color: #007bff;
                --accent-color: #0056b3;
                --text-dark: #212529;
                --text-muted: #6c757d;
                --blue-primary: #007bff;
                --blue-dark: #0056b3;
                --blue-light: #e3f2fd;
            }

            .course-management-container {
                display: grid;
                grid-template-columns: 3fr 1fr;
                gap: 2rem;
                margin-top: 1rem;
            }

            .topic-card {
                background: #ffffff;
                border-radius: 12px;
                padding: 1.5rem;
                margin-bottom: 1rem;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                border-left: 4px solid var(--primary-color);
                transition: transform 0.2s, box-shadow 0.2s;
                cursor: pointer;
            }

            .topic-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
            }

            .topic-card.selected {
                border-left-color: var(--accent-color);
                box-shadow: 0 0 0 2px var(--accent-color);
            }

            .topic-header {
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
                margin-bottom: 1rem;
            }

            .topic-title-section {
                display: flex;
                align-items: center;
                gap: 1rem;
            }

            .topic-order {
                width: 32px;
                height: 32px;
                border-radius: 50%;
                background: linear-gradient(45deg, var(--primary-color), var(--accent-color));
                color: white;
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: bold;
                font-size: 0.9rem;
            }

            .topic-info h4 {
                margin: 0;
                font-size: 1.1rem;
                color: var(--text-dark);
            }

            .topic-info p {
                margin: 0;
                font-size: 0.9rem;
                color: #666;
            }

            .completion-badge {
                padding: 0.25rem 0.75rem;
                border-radius: 20px;
                font-size: 0.8rem;
                font-weight: 500;
                background-color: #e3f2fd;
                color: #1976d2;
            }

            .completion-badge.completed {
                background-color: #e8f5e8;
                color: #388e3c;
            }

            .topic-progress {
                margin: 1rem 0;
            }

            .progress-bar-custom {
                width: 100%;
                height: 8px;
                background-color: #e0e0e0;
                border-radius: 4px;
                overflow: hidden;
            }

            .progress-fill-custom {
                height: 100%;
                background: linear-gradient(90deg, var(--primary-color), var(--accent-color));
                border-radius: 4px;
                transition: width 0.3s ease;
            }

            .topic-stats {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 1rem;
                margin: 1rem 0;
            }

            .stat-item {
                display: flex;
                align-items: center;
                gap: 0.5rem;
                font-size: 0.9rem;
            }

            .stat-icon {
                font-size: 1rem;
            }

            .stat-icon.lesson {
                color: #2196f3;
            }
            .stat-icon.document {
                color: #4caf50;
            }
            .stat-icon.exercise {
                color: #ff9800;
            }

            .topic-actions {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 0.5rem;
                margin-top: 1rem;
                padding-top: 1rem;
                border-top: 1px solid #e0e0e0;
            }

            .topic-action-btn {
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                padding: 1rem;
                border: 1px solid #ddd;
                background: #f8f9fa;
                border-radius: 8px;
                text-decoration: none;
                color: var(--text-dark);
                transition: all 0.2s;
                min-height: 80px;
            }

            .topic-action-btn:hover {
                background: var(--primary-color);
                color: white;
                border-color: var(--primary-color);
            }

            .topic-action-btn i {
                font-size: 1.5rem;
                margin-bottom: 0.5rem;
            }

            .topic-action-btn span {
                font-size: 0.8rem;
                font-weight: 500;
            }

            .expand-btn {
                background: none;
                border: none;
                color: var(--primary-color);
                cursor: pointer;
                padding: 0.5rem;
                border-radius: 4px;
                transition: background-color 0.2s;
            }

            .expand-btn:hover {
                background-color: #f0f0f0;
            }

            .overall-progress-card {
                background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
                color: white;
                border-radius: 12px;
                padding: 1.5rem;
                margin-bottom: 2rem;
            }

            .overall-progress-card h3 {
                margin: 0 0 1rem 0;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .overall-stats {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 1rem;
                margin-top: 1rem;
                font-size: 0.9rem;
            }

            @media (max-width: 768px) {
                .course-management-container {
                    grid-template-columns: 1fr;
                }

                .topic-stats {
                    grid-template-columns: 1fr;
                }

                .overall-stats {
                    grid-template-columns: 1fr;
                }
            }

            /* Enhanced Sidebar Styles */
            .detail-card {
                background: #ffffff;
                border-radius: 12px;
                padding: 1.5rem;
                margin-bottom: 1.5rem;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                border-left: 4px solid var(--primary-color);
            }

            .card-title {
                display: flex;
                align-items: center;
                gap: 0.5rem;
                margin-bottom: 1rem;
                font-size: 1.1rem;
                font-weight: 600;
                color: var(--text-dark);
            }

            .task-meta {
                display: flex;
                flex-direction: column;
                gap: 1rem;
            }

            .task-meta-item {
                display: flex;
                align-items: center;
                gap: 1rem;
                padding: 1rem;
                background: #f8f9fa;
                border-radius: 8px;
                transition: all 0.2s;
            }

            .task-meta-item:hover {
                background: #e9ecef;
                transform: translateX(4px);
            }

            .meta-icon {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                background: linear-gradient(45deg, var(--primary-color), var(--accent-color));
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 1rem;
            }

            .meta-content {
                flex: 1;
            }

            .meta-content strong {
                display: block;
                font-size: 0.95rem;
                color: var(--text-dark);
                margin-bottom: 0.25rem;
            }

            .meta-content small {
                color: #6c757d;
                font-size: 0.85rem;
            }

            .guide-content {
                display: flex;
                flex-direction: column;
                gap: 1.5rem;
            }

            .guide-section {
                background: #f8f9fa;
                border-radius: 8px;
                padding: 1rem;
                border-left: 3px solid var(--accent-color);
            }

            .guide-subtitle {
                display: flex;
                align-items: center;
                gap: 0.5rem;
                margin-bottom: 0.75rem;
                font-size: 0.95rem;
                font-weight: 600;
                color: var(--text-dark);
            }

            .guide-list {
                margin: 0;
                padding-left: 1.5rem;
                font-size: 0.9rem;
                color: #495057;
            }

            .guide-list li {
                margin-bottom: 0.5rem;
                line-height: 1.4;
            }

            .guide-list strong {
                color: var(--text-dark);
            }

            /* Modal Styles */
            .modal-content {
                border-radius: 12px;
                border: none;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
                transition: all 0.3s ease;
            }

            .modal-content:hover {
                box-shadow: 0 8px 30px rgba(0, 123, 255, 0.2);
            }

            .modal-header {
                background: linear-gradient(135deg, var(--blue-primary), var(--blue-dark));
                color: white;
                border-radius: 12px 12px 0 0;
                border-bottom: none;
                position: relative;
                overflow: hidden;
            }

            .modal-header::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.1), transparent);
                transition: left 0.5s;
            }

            .modal-header:hover::before {
                left: 100%;
            }

            .modal-title {
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .btn-close {
                filter: invert(1);
            }

            .form-label {
                font-weight: 600;
                color: var(--text-dark);
                margin-bottom: 0.5rem;
            }

            .form-control {
                border-radius: 8px;
                border: 2px solid #e9ecef;
                transition: all 0.2s;
            }

            .form-control:focus {
                border-color: var(--blue-primary);
                box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
            }

            .btn-primary {
                background: linear-gradient(135deg, var(--blue-primary), var(--blue-dark));
                border: none;
                border-radius: 8px;
                padding: 0.5rem 1.5rem;
                font-weight: 500;
                transition: all 0.2s;
            }

            .btn-primary:hover {
                background: linear-gradient(135deg, var(--blue-dark), #004085);
                transform: translateY(-1px);
                box-shadow: 0 4px 12px rgba(0, 123, 255, 0.3);
            }

            /* Modal Footer Button */
            .modal-footer .btn-primary {
                background: linear-gradient(135deg, var(--blue-primary), var(--blue-dark));
                border: none;
                color: white;
                padding: 0.75rem 1.5rem;
                border-radius: 8px;
                font-weight: 600;
                transition: all 0.3s ease;
                box-shadow: 0 2px 8px rgba(0, 123, 255, 0.3);
            }

            .modal-footer .btn-primary:hover {
                background: linear-gradient(135deg, var(--blue-dark), #004085);
                color: white;
                transform: translateY(-2px);
                box-shadow: 0 4px 16px rgba(0, 123, 255, 0.4);
            }

            .modal-footer .btn-primary:disabled {
                background: #6c757d;
                transform: none;
                box-shadow: none;
                cursor: not-allowed;
            }

            /* Custom Blue Button for Add Topic */
            .btn-add-topic {
                background: linear-gradient(135deg, var(--blue-primary), var(--blue-dark));
                border: none;
                color: white;
                padding: 0.75rem 1.5rem;
                border-radius: 8px;
                font-weight: 600;
                transition: all 0.3s ease;
                box-shadow: 0 2px 8px rgba(0, 123, 255, 0.3);
            }

            .btn-add-topic:hover {
                background: linear-gradient(135deg, var(--blue-dark), #004085);
                color: white;
                transform: translateY(-2px);
                box-shadow: 0 4px 16px rgba(0, 123, 255, 0.4);
            }

            .btn-add-topic:active {
                transform: translateY(0);
                box-shadow: 0 2px 8px rgba(0, 123, 255, 0.3);
            }

            /* Pagination Styles */
            .pagination-container {
                background: #ffffff;
                border-radius: 12px;
                padding: 1.5rem;
                margin-top: 2rem;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                display: flex;
                justify-content: space-between;
                align-items: center;
                flex-wrap: wrap;
                gap: 1rem;
                border: 1px solid #e9ecef;
            }

            .pagination-info {
                display: flex;
                align-items: center;
            }

            .pagination-text {
                font-size: 0.9rem;
                color: var(--text-muted);
                font-weight: 500;
            }

            .pagination-controls {
                display: flex;
                align-items: center;
                gap: 0.5rem;
                flex-wrap: wrap;
            }

            .page-numbers {
                display: flex;
                align-items: center;
                gap: 0.25rem;
            }

            .pagination-btn {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                min-width: 40px;
                height: 40px;
                padding: 0.5rem 0.75rem;
                border: 2px solid #e9ecef;
                background: #ffffff;
                color: var(--text-dark);
                text-decoration: none;
                border-radius: 8px;
                font-weight: 500;
                font-size: 0.9rem;
                transition: all 0.2s ease;
                gap: 0.5rem;
            }

            .pagination-btn:hover {
                background: var(--blue-primary);
                color: white;
                border-color: var(--blue-primary);
                transform: translateY(-1px);
                box-shadow: 0 4px 8px rgba(0, 123, 255, 0.2);
            }

            .pagination-btn.active {
                background: var(--blue-primary);
                color: white;
                border-color: var(--blue-primary);
                box-shadow: 0 2px 4px rgba(0, 123, 255, 0.3);
                font-weight: 600;
            }

            .pagination-btn.prev-btn,
            .pagination-btn.next-btn {
                min-width: 80px;
                font-weight: 600;
            }

            .pagination-dots {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                min-width: 40px;
                height: 40px;
                color: var(--text-muted);
                font-weight: 600;
            }

            /* Single page pagination styling */
            .pagination-container.single-page {
                background: linear-gradient(135deg, #f8f9fa, #e9ecef);
                border: 1px solid #dee2e6;
            }

            .pagination-container.single-page .pagination-btn.active {
                background: var(--blue-primary);
                color: white;
                border-color: var(--blue-primary);
                box-shadow: 0 2px 8px rgba(0, 123, 255, 0.3);
            }

            /* Responsive pagination */
            @media (max-width: 768px) {
                .pagination-container {
                    flex-direction: column;
                    align-items: stretch;
                    gap: 1rem;
                }

                .pagination-controls {
                    justify-content: center;
                }

                .page-numbers {
                    order: 2;
                }

                .pagination-btn.prev-btn,
                .pagination-btn.next-btn {
                    order: 1;
                }

                .pagination-btn {
                    min-width: 36px;
                    height: 36px;
                    font-size: 0.8rem;
                }

                .pagination-btn.prev-btn,
                .pagination-btn.next-btn {
                    min-width: 70px;
                }
            }

            /* Empty State Styles */
            .empty-topics-state {
                text-align: center;
                padding: 4rem 2rem;
                background: linear-gradient(135deg, #f8f9fa, #e9ecef);
                border-radius: 12px;
                margin: 2rem 0;
                border: 2px dashed #dee2e6;
            }

            .empty-topics-icon {
                font-size: 4rem;
                color: #dee2e6;
                margin-bottom: 1.5rem;
                opacity: 0.7;
            }

            .empty-topics-state h4 {
                font-size: 1.5rem;
                font-weight: 600;
                color: var(--text-dark);
                margin-bottom: 1rem;
            }

            .empty-topics-state p {
                font-size: 1rem;
                color: var(--text-muted);
                margin-bottom: 2rem;
                max-width: 400px;
                margin-left: auto;
                margin-right: auto;
                line-height: 1.5;
            }

            .empty-topics-state .btn {
                padding: 0.75rem 1.5rem;
                font-size: 1rem;
                font-weight: 600;
            }
        </style>
    </head>
    <body>
        <!-- Include Sidebar -->
        <%@ include file="sidebar.jsp" %>

        <div class="main-content">
            <!-- Include Header -->
            <%@ include file="header.jsp" %>

            <!-- Back Button -->
            <div class="mb-3">
                <a href="${pageContext.request.contextPath}/teacher/tasks" class="btn btn-outline">
                    <i class="fas fa-arrow-left"></i>
                    Quay lại
                </a>
            </div>

            <div class="course-management-container">
                <!-- Main Content -->
                <div>
                    <!-- Overall Progress -->
                    <div class="overall-progress-card">
                        <h3>
                            <i class="fas fa-book-open"></i>
                            Tiến độ tổng quan - ${course.title}
                        </h3>

                        <c:set var="totalLessons" value="0" />
                        <c:set var="totalAssignments" value="0" />

                        <c:if test="${topics != null && not empty topics}">
                            <c:forEach var="topic" items="${topics}">
                                <c:set var="lessonCount" value="${topic.lessons != null ? topic.lessons.size() : 0}" />
                                <c:set var="assignmentCount" value="${topic.assignments != null ? topic.assignments.size() : 0}" />

                                <c:set var="totalLessons" value="${totalLessons + lessonCount}" />
                                <c:set var="totalAssignments" value="${totalAssignments + assignmentCount}" />
                            </c:forEach>
                        </c:if>

                        <div class="progress-bar-custom">
                            <div class="progress-fill-custom" style="width: ${overallProgress}%; background: rgba(255,255,255,0.8);"></div>
                        </div>

                        <div class="overall-stats">
                            <div>Tổng chủ đề: ${topics != null ? topics.size() : 0}</div>
                            <div>Tổng bài học: ${totalLessons}</div>
                            <div>Tổng bài kiểm tra :  ${totalAssignments}</div>

                        </div>
                    </div>

                    <!-- Topics List -->
                    <div class="d-flex justify-content-between align-items-center mb-3" data-course-id="${task.courseID}">
                        <h3>Danh sách chủ đề</h3>
                        <div class="d-flex align-items-center gap-3">
                            <span class="badge bg-secondary">${topics.size()} topics</span>
                            <button class="btn btn-add-topic" data-bs-toggle="modal" data-bs-target="#addTopicModal">
                                <i class="fas fa-plus"></i>
                                Thêm chủ đề
                            </button>
                            <button class="btn btn-complete-task" onclick="completeTask(${taskID})" style="background-color: #28a745; color: white; border: none;">
                                <i class="fas fa-check"></i>
                                Hoàn thành
                            </button>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${empty topics}">
                            <div class="empty-topics-state">
                                <div class="empty-topics-icon">
                                    <i class="fas fa-folder-open"></i>
                                </div>
                                <h4>Chưa có topic nào</h4>
                                <p>Bắt đầu bằng cách thêm topic đầu tiên cho khóa học này.</p>
                                <button class="btn btn-add-topic" data-bs-toggle="modal" data-bs-target="#addTopicModal">
                                    <i class="fas fa-plus"></i>
                                    Thêm Topic Đầu Tiên
                                </button>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div id="topics-container">
                                <c:forEach var="topic" items="${topics}" varStatus="status">
                                    <div class="topic-card" id="topic-${topic.topicId}" onclick="toggleTopic('${topic.topicId}')" data-topic-index="${status.index}">
                                        <div class="topic-header">
                                            <div class="topic-title-section">
                                                <div class="topic-order">${topic.orderIndex}</div>
                                                <div class="topic-info">
                                                    <h4>${topic.topicName}</h4>
                                                    <p>${topic.description}</p>
                                                </div>
                                            </div>                                
                                        </div>
                                        <div class="topic-stats">
                                            <div class="stat-item">
                                                <i class="fas fa-video stat-icon lesson"></i>
                                                <span>${topic.lessons != null ? topic.lessons.size() : 0} Bài học</span>
                                            </div>                               
                                            <div class="stat-item">
                                                <i class="fas fa-clipboard-check stat-icon exercise"></i>
                                                <span>${topic.assignments != null ? topic.assignments.size() : 0} Bài kiểm tra</span>
                                            </div>
                                        </div>

                                        <div class="topic-actions" id="actions-${topic.topicId}" style="display: none;">
<a href="${pageContext.request.contextPath}/createLesson?topicId=${topic.topicId}&taskID=${taskID}" class="topic-action-btn">                                                <i class="fas fa-video"></i>
                                                <span>Thêm bài học</span>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/createAssignment?topicId=${topic.topicId}&taskID=${taskID}" class="topic-action-btn">
                                                <i class="fas fa-clipboard-check"></i>
                                                <span>Thêm bài kiểm tra</span>
                                            </a>
                                        </div>

                                        <div class="text-center mt-2">
                                            <button class="expand-btn" onclick="toggleTopic('${topic.topicId}'); event.stopPropagation();">
                                                <i class="fas fa-plus" id="icon-${topic.topicId}"></i>
                                                <span id="text-${topic.topicId}">Thêm nội dung</span>
                                            </button>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <!-- Pagination -->
                    <div class="pagination-container" id="pagination-container" style="display: none;">
                        <div class="pagination-controls">
                            <!-- Nút Previous -->
                            <button class="pagination-btn prev-btn" id="prev-btn" onclick="changePage(-1)">
                                <i class="fas fa-chevron-left"></i>
                                <span>Trước</span>
                            </button>

                            <!-- Các nút số trang -->
                            <div class="page-numbers" id="page-numbers">
                                <!-- Sẽ được tạo bằng JavaScript -->
                            </div>

                            <!-- Nút Next -->
                            <button class="pagination-btn next-btn" id="next-btn" onclick="changePage(1)">
                                <span>Sau</span>
                                <i class="fas fa-chevron-right"></i>
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Sidebar Info -->
                <div class="space-y-4">
                    <!-- Task Info -->
                    <div class="detail-card">
                        <h4 class="card-title">
                            <i class="fas fa-info-circle text-primary"></i>
                            Thông tin Nhiệm vụ
                        </h4>

                        <div class="task-meta">
                            <div class="task-meta-item">
                                <div class="meta-icon">
                                    <i class="fas fa-user"></i>
                                </div>
                                <div class="meta-content">
                                    <strong>${task.coordinatorName}</strong>
                                    <small class="text-muted">Coordinator</small>
                                </div>
                            </div>

                            <div class="task-meta-item">
                                <div class="meta-icon">
                                    <i class="fas fa-calendar"></i>
                                </div>
                                <div class="meta-content">
                                    <strong>Hạn chót</strong>
                                    <small><fmt:formatDate value="${task.deadline}" pattern="dd/MM/yyyy" /></small>
                                </div>
                            </div>

                            <div class="task-meta-item">
                                <div class="meta-icon">
                                    <i class="fas fa-book-open"></i>
                                </div>
                                <div class="meta-content">
                                    <strong>${course.title}</strong>
                                    <small>Mã: ${course.courseID}</small>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Guide -->
                    <div class="detail-card">
                        <h4 class="card-title">
                            <i class="fas fa-lightbulb text-warning"></i>
                            Hướng dẫn
                        </h4>

                        <div class="guide-content">
                            <div class="guide-section">
                                <h6 class="guide-subtitle">
                                    <i class="fas fa-plus-circle text-success"></i>
                                    Cách thêm nội dung:
                                </h6>
                                <ol class="guide-list">
                                    <li>Chọn topic cần thêm nội dung</li>
                                    <li>Nhấn nút loại nội dung tương ứng</li>
                                    <li>Điền thông tin và upload file</li>
                                    <li>Lưu hoặc gửi để hoàn thành</li>
                                </ol>
                            </div>

                            <div class="guide-section">
                                <h6 class="guide-subtitle">
                                    <i class="fas fa-file-alt text-info"></i>
                                    Loại file hỗ trợ:
                                </h6>
                                <ul class="guide-list">
                                    <li><strong>Bài học:</strong> Video (MP4, MOV, AVI)</li>
                                    <li><strong>Tài liệu:</strong> PDF</li>
                                    <li><strong>Bài tập:</strong> Excel (XLSX, XLS)</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>


        <!-- Add Topic Modal -->
        <div class="modal fade" id="addTopicModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="fas fa-folder-plus text-white"></i>
                            Thêm chủ đề Mới
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <form id="addTopicForm">
                            <div class="mb-3">
                                <label for="topicName" class="form-label">Tên chủ đề <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="topicName" required 
                                       placeholder="Nhập tên chủ đề..." maxlength="100">
                                <div class="form-text">Tên chủ đề sẽ hiển thị cho học viên</div>
                            </div>
                            <div class="mb-3">
                                <label for="topicDescription" class="form-label">Mô tả</label>
                                <textarea class="form-control" id="topicDescription" rows="3" 
                                          placeholder="Mô tả chi tiết về chủ đề này..." maxlength="500"></textarea>
                                <div class="form-text">Mô tả giúp học viên hiểu rõ nội dung topic</div>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="button" class="btn btn-primary" onclick="addTopic()" id="addTopicBtn">
                            <i class="fas fa-save"></i>
                            Thêm chủ đề
                        </button>
                    </div>
                </div>
            </div>
        </div>



        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        <!-- Custom JavaScript -->
        <script src="${pageContext.request.contextPath}/assets/js/teacher_js/taskCourse.js"></script>
    </body>
</html>