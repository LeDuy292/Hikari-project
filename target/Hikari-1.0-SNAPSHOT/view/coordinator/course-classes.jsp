<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản Lý Lớp Học - Coordinator Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            :root {
                --primary-color: #007bff;
                --secondary-color: #6c757d;
                --success-color: #28a745;
                --background-color: #f8f9fa;
                --border-radius: 12px;
                --box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: var(--background-color);
            }

            .main-content {
                padding: 2rem;
                margin-left: 320px;
            }

            .page-header {
                margin-bottom: 2rem;
            }

            .page-title {
                font-size: 1.75rem;
                font-weight: 600;
                color: #333;
                margin-bottom: 0.5rem;
            }

            .page-subtitle {
                color: var(--secondary-color);
                font-size: 1rem;
            }

            .class-card {
                background: white;
                border-radius: var(--border-radius);
                box-shadow: var(--box-shadow);
                padding: 1.5rem;
                margin-bottom: 1.5rem;
                transition: transform 0.2s, box-shadow 0.2s;
            }

            .class-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 16px rgba(0, 0, 0, 0.15);
            }

            .class-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 1rem;
            }

            .class-name {
                font-size: 1.25rem;
                font-weight: 600;
                color: #333;
                margin: 0;
            }

            .class-status {
                padding: 0.5rem 1rem;
                border-radius: 20px;
                font-size: 0.875rem;
                font-weight: 500;
            }

            .status-active {
                background-color: #e8f5e9;
                color: #2e7d32;
            }

            .status-inactive {
                background-color: #ffebee;
                color: #c62828;
            }

            .class-info {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 1rem;
                margin-bottom: 1rem;
            }

            .info-item {
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .info-icon {
                width: 32px;
                height: 32px;
                background-color: #f8f9fa;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                color: var(--primary-color);
            }

            .info-content {
                display: flex;
                flex-direction: column;
            }

            .info-label {
                font-size: 0.875rem;
                color: var(--secondary-color);
            }

            .info-value {
                font-weight: 500;
                color: #333;
            }

            .class-actions {
                display: flex;
                gap: 0.5rem;
                justify-content: flex-end;
            }

            .action-button {
                padding: 0.5rem 1rem;
                border-radius: 8px;
                font-size: 0.875rem;
                font-weight: 500;
                display: flex;
                align-items: center;
                gap: 0.5rem;
                transition: all 0.2s;
            }

            .btn-view {
                background-color: #e3f2fd;
                color: var(--primary-color);
                border: none;
            }

            .btn-view:hover {
                background-color: #bbdefb;
                color: #0056b3;
            }

            .search-container {
                margin-bottom: 2rem;
            }

            .search-input-group {
                display: flex;
                align-items: center;
                background: white;
                border-radius: var(--border-radius);
                padding: 0.5rem;
                box-shadow: var(--box-shadow);
                max-width: 400px;
            }

            .search-input {
                border: none;
                background: transparent;
                padding: 0.5rem;
                width: 100%;
                font-size: 0.875rem;
            }

            .search-input:focus {
                outline: none;
            }

            .search-button {
                background: transparent;
                border: none;
                color: var(--primary-color);
                padding: 0.5rem;
                cursor: pointer;
            }

            @media (max-width: 768px) {
                .class-info {
                    grid-template-columns: 1fr;
                }

                .class-actions {
                    flex-direction: column;
                }

                .action-button {
                    width: 100%;
                    justify-content: center;
                }
            }
        </style>
    </head>
    <body>
        <div class="d-flex">
            <!-- Sidebar -->
            <jsp:include page="sidebarCoordinator.jsp" />

            <!-- Main Content -->
            <div class="main-content flex-grow-1">
                <!-- Header -->
                <jsp:include page="headerCoordinator.jsp" />

                <div class="content-wrapper">
                    <div class="page-header">
                        <h1 class="page-title">Quản Lý Lớp Học</h1>
                        <p class="page-subtitle">Xem và quản lý thông tin các lớp học</p>
                    </div>

                    <div class="search-container">
                        <div class="search-input-group">
                            <input type="text" class="search-input" placeholder="Tìm kiếm lớp học...">
                            <button class="search-button">
                                <i class="fas fa-search"></i>
                            </button>
                        </div>
                    </div>

                    <div class="class-list">
                        <c:forEach var="classInfo" items="${requestScope.listClass}">
                            <div class="class-card">
                                <div class="class-header">
                                    <h3 class="class-name">${classInfo.name}</h3>
                                    <span class="class-status status-active">Đang hoạt động</span>
                                </div>
                                <div class="class-info">
                                    <div class="info-item">
                                        <div class="info-icon">
                                            <i class="fas fa-users"></i>
                                        </div>
                                        <div class="info-content">
                                            <span class="info-label">Số lượng học viên</span>
                                            <span class="info-value">${classInfo.studentCount}</span>
                                        </div>
                                    </div>
                                    <div class="info-item">
                                        <div class="info-icon">
                                            <i class="fas fa-users"></i>
                                        </div>
                                        <div class="info-content">
                                            <span class="info-label">Ngày bắt đầu - Ngày kết thúc</span>
                                            <span class="info-value">Bắt đầu: ${classInfo.startDate}<br>Kết thúc: ${classInfo.endDate}</span>
                                        </div>
                                    </div>
                                    <div class="info-item">
                                        <div class="info-icon">
                                            <i class="fas fa-chalkboard-teacher"></i>
                                        </div>
                                        <div class="info-content">
                                            <span class="info-label">Giảng viên</span>
                                            <span class="info-value">${classInfo.teacherName}</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="class-actions">
                                    <a href="LoadStudentOfClass?StudentID=${classInfo.courseID}" class="action-button btn-view">
                                        <i class="fas fa-eye"></i>
                                        Xem chi tiết
                                    </a>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Thêm chức năng tìm kiếm
            const searchInput = document.querySelector('.search-input');
            const classCards = document.querySelectorAll('.class-card');

            searchInput.addEventListener('input', function() {
                const searchTerm = this.value.toLowerCase();
                
                classCards.forEach(card => {
                    const className = card.querySelector('.class-name').textContent.toLowerCase();
                    const teacherName = card.querySelector('.info-value').textContent.toLowerCase();
                    
                    if (className.includes(searchTerm) || teacherName.includes(searchTerm)) {
                        card.style.display = '';
                    } else {
                        card.style.display = 'none';
                    }
                });
            });
        </script>
    </body>
</html>