<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bảng Xếp Hạng - HIKARI JAPAN</title>
    
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@700&family=Roboto:wght@400;500;600&display=swap" rel="stylesheet" />
    
    <!-- CSS Files -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/sidebar_student.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/header_student.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css">
    
    <style>
        :root {
            --primary-color: #ff9800;
            --secondary-color: #ffb347;
            --accent-color: #ffb347;
            --background-color: #FFF4E5;
            --text-color: #444;
            --text-light: #fff;
            --shadow-color: rgba(255, 145, 0, 0.08);
            --active-shadow-color: rgba(255, 145, 0, 0.12);
        }

        body {
            background: linear-gradient(135deg, #fff4e5 0%, #ffe0b3 100%);
            font-family: 'Roboto', sans-serif;
            margin: 0;
            padding: 0;
        }

        .main-container {
            margin-left: 320px;
            min-height: 100vh;
        }

        .main-content {
            padding: 0;
        }

        /* Header Section */
        .ranking-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            padding: 2rem 0;
            text-align: center;
            box-shadow: 0 4px 20px rgba(255, 152, 0, 0.3);
        }

        .ranking-header h1 {
            font-size: 2.5rem;
            font-weight: 700;
            margin: 0;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
        }

        .ranking-header p {
            font-size: 1.1rem;
            margin: 0.5rem 0 0 0;
            opacity: 0.9;
        }

        /* Content Container */
        .content-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 2rem;
        }

        /* Statistics Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            border: 2px solid transparent;
            transition: all 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(255, 152, 0, 0.2);
            border-color: var(--primary-color);
        }

        .stat-card .icon {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            margin-bottom: 1rem;
        }

        .stat-card .icon.users { background: linear-gradient(135deg, #ff9800, #ffb347); color: white; }
        .stat-card .icon.average { background: linear-gradient(135deg, #ffc107, #ffeb3b); color: white; }
        .stat-card .icon.highest { background: linear-gradient(135deg, #4caf50, #8bc34a); color: white; }
        .stat-card .icon.tests { background: linear-gradient(135deg, #2196f3, #03a9f4); color: white; }

        .stat-card .value {
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary-color);
            margin: 0;
        }

        .stat-card .label {
            color: #666;
            font-size: 0.9rem;
            margin: 0;
        }

        /* Controls Section */
        .controls-section {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            border: 2px solid var(--background-color);
        }

        .controls-header {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 1rem;
            color: var(--primary-color);
            font-weight: 600;
            font-size: 1.1rem;
        }

        .controls-form {
            display: grid;
            grid-template-columns: 1fr auto auto;
            gap: 1rem;
            align-items: end;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .form-group label {
            font-weight: 500;
            color: var(--text-color);
            font-size: 0.9rem;
        }

        .form-control {
            padding: 0.75rem;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(255, 152, 0, 0.1);
        }

        .search-input {
            position: relative;
        }

        .search-input i {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: #999;
        }

        .search-input input {
            padding-left: 2.5rem;
        }

        .btn-group {
            display: flex;
            gap: 0.5rem;
        }

        .btn {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 8px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background: none;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
        }

        .btn-outline {
            background: white;
            color: var(--primary-color);
            border: 2px solid var(--primary-color);
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #e68900, #ff9800);
        }

        .btn-outline:hover {
            background: var(--primary-color);
            color: white;
        }

        /* Rankings Table */
        .rankings-section {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            border: 2px solid var(--background-color);
        }

        .rankings-header {
            background: linear-gradient(135deg, var(--background-color), #ffe0b3);
            padding: 1.5rem;
            border-bottom: 2px solid #e0e0e0;
        }

        .rankings-header h3 {
            margin: 0;
            color: var(--primary-color);
            font-size: 1.3rem;
            font-weight: 600;
        }

        .rankings-table {
            width: 100%;
            border-collapse: collapse;
        }

        .rankings-table th {
            background: #f8f9fa;
            padding: 1rem;
            text-align: left;
            font-weight: 600;
            color: #666;
            border-bottom: 2px solid #e0e0e0;
        }

        .rankings-table td {
            padding: 1rem;
            border-bottom: 1px solid #e0e0e0;
            vertical-align: middle;
        }

        .rankings-table tr:hover {
            background: linear-gradient(135deg, #fff4e5, #ffe0b3);
        }

        .rankings-table tr.top-3 {
            background: linear-gradient(135deg, #fff9c4, #ffecb3);
        }

        /* Rank Icons */
        .rank-icon {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            font-weight: bold;
        }

        .rank-1 { background: linear-gradient(135deg, #ffd700, #ffed4e); color: #b8860b; }
        .rank-2 { background: linear-gradient(135deg, #c0c0c0, #e8e8e8); color: #666; }
        .rank-3 { background: linear-gradient(135deg, #cd7f32, #daa520); color: #8b4513; }
        .rank-other { background: #f0f0f0; color: #666; }

        /* Student Info */
        .student-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .student-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid var(--background-color);
        }

        .student-details h4 {
            margin: 0;
            font-weight: 600;
            color: var(--text-color);
        }

        .student-details p {
            margin: 0;
            color: #666;
            font-size: 0.9rem;
        }

        /* JLPT Badges */
        .jlpt-badge {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            margin: 0.1rem;
        }

        .jlpt-n5 { background: #e8f5e8; color: #2e7d32; border: 1px solid #c8e6c9; }
        .jlpt-n4 { background: #e3f2fd; color: #1565c0; border: 1px solid #bbdefb; }
        .jlpt-n3 { background: #f3e5f5; color: #7b1fa2; border: 1px solid #e1bee7; }
        .jlpt-n2 { background: #fff3e0; color: #ef6c00; border: 1px solid #ffcc02; }
        .jlpt-n1 { background: #ffebee; color: #c62828; border: 1px solid #ffcdd2; }

        /* Score Display */
        .score-display {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary-color);
        }

        .score-unit {
            font-size: 0.9rem;
            color: #666;
            font-weight: normal;
        }

        /* Status Badge */
        .status-badge {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            margin-left: 0.5rem;
        }

        .status-pass { background: #e8f5e8; color: #2e7d32; border: 1px solid #c8e6c9; }
        .status-fail { background: #ffebee; color: #c62828; border: 1px solid #ffcdd2; }

        /* Loading and Empty States */
        .empty-state, .error-state {
            text-align: center;
            padding: 3rem;
            color: #666;
        }

        .empty-state i, .error-state i {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: #ccc;
        }

        .error-state i {
            color: #f44336;
        }

        .error-state p:first-of-type {
            color: #f44336;
            font-weight: 600;
        }

        /* Highlight current student's row */
        .current-student {
            background-color: #e6f7ff !important;
            box-shadow: 0 0 0 2px #1890ff;
            position: relative;
        }
        
        .current-student:after {
            content: 'Bạn';
            position: absolute;
            right: 15px;
            background: #1890ff;
            color: white;
            padding: 2px 8px;
            border-radius: 10px;
            font-size: 0.75rem;
            font-weight: normal;
        }

        /* Pagination Styles */
        .pagination-section {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            margin-top: 2rem;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            border: 2px solid var(--background-color);
        }

        .pagination-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .pagination-info .info-text {
            color: #666;
            font-size: 0.9rem;
        }

        .pagination-info .page-size-selector {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .pagination-info .page-size-selector select {
            padding: 0.5rem;
            border: 2px solid #e0e0e0;
            border-radius: 6px;
            font-size: 0.9rem;
        }

        .pagination-controls {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 0.5rem;
            flex-wrap: wrap;
        }

        .pagination-btn {
            padding: 0.5rem 0.75rem;
            border: 2px solid #e0e0e0;
            background: white;
            color: #666;
            text-decoration: none;
            border-radius: 6px;
            font-size: 0.9rem;
            transition: all 0.3s ease;
            min-width: 40px;
            text-align: center;
        }

        .pagination-btn:hover {
            border-color: var(--primary-color);
            color: var(--primary-color);
            transform: translateY(-1px);
        }

        .pagination-btn.active {
            background: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
            font-weight: 600;
        }

        .pagination-btn.disabled {
            opacity: 0.5;
            cursor: not-allowed;
            pointer-events: none;
        }

        .pagination-ellipsis {
            padding: 0.5rem;
            color: #999;
        }
    </style>
</head>

<body>
    <!-- Include Sidebar -->
    <%@ include file="sidebar.jsp" %>

    <div class="main-container">
        <!-- Include Header -->
        <%@ include file="header.jsp" %>

        <!-- Main Content -->
        <main class="main-content">
            <!-- Header Section -->
            <div class="ranking-header">
                <h1><i class="fas fa-trophy"></i> Bảng Xếp Hạng Học Sinh</h1>
                <p>Theo dõi thành tích và xếp hạng của các học viên HIKARI JAPAN</p>
            </div>

            <div class="content-container">
                <!-- Statistics Cards -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="icon users">
                            <i class="fas fa-users"></i>
                        </div>
                        <p class="value">${stats.totalStudents}</p>
                        <p class="label">
                            <c:choose>
                                <c:when test="${currentViewMode eq 'individual'}">Tổng bài thi</c:when>
                                <c:otherwise>Tổng học sinh</c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                    <div class="stat-card">
                        <div class="icon average">
                            <i class="fas fa-chart-line"></i>
                        </div>
                        <p class="value">
                            <fmt:formatNumber value="${stats.averageScore}" maxFractionDigits="1"/>
                        </p>
                        <p class="label">Điểm trung bình</p>
                    </div>
                    <div class="stat-card">
                        <div class="icon highest">
                            <i class="fas fa-star"></i>
                        </div>
                        <p class="value">
                            <fmt:formatNumber value="${stats.highestScore}" maxFractionDigits="1"/>
                        </p>
                        <p class="label">Điểm cao nhất</p>
                    </div>
                    <div class="stat-card">
                        <div class="icon tests">
                            <i class="fas fa-clipboard-list"></i>
                        </div>
                        <p class="value">${stats.totalTests}</p>
                        <p class="label">
                            <c:choose>
                                <c:when test="${currentViewMode eq 'individual'}">Kết quả</c:when>
                                <c:otherwise>Tổng bài thi</c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </div>

                <!-- Controls Section -->
                <div class="controls-section">
                    <div class="controls-header">
                        <i class="fas fa-filter"></i>
                        <span>Tìm kiếm và Lọc</span>
                    </div>
                    <form method="GET" action="${pageContext.request.contextPath}/ranking" class="controls-form">
                        <div class="form-group">
                            <label for="searchTerm">Tìm kiếm học viên</label>
                            <div class="search-input">
                                <i class="fas fa-search"></i>
                                <input type="text" id="searchTerm" name="searchTerm" class="form-control" 
                                       placeholder="Tìm kiếm theo tên hoặc mã học viên..." 
                                       value="${currentSearchTerm}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="jlptLevel">Cấp độ JLPT</label>
                            <select id="jlptLevel" name="jlptLevel" class="form-control">
                                <c:forEach var="level" items="${jlptLevels}">
                                    <option value="${level}" ${level eq currentJlptLevel ? 'selected' : ''}>${level}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="btn-group">
                            <button type="submit" name="viewMode" value="individual" 
                                    class="btn ${currentViewMode eq 'individual' ? 'btn-primary' : 'btn-outline'}">
                                <i class="fas fa-user"></i>
                                Điểm cá nhân
                            </button>
                            <button type="submit" name="viewMode" value="average" 
                                    class="btn ${currentViewMode eq 'average' ? 'btn-primary' : 'btn-outline'}">
                                <i class="fas fa-chart-bar"></i>
                                Điểm trung bình
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Rankings Section -->
                <div class="rankings-section">
                    <div class="rankings-header">
                        <h3>${pageTitle}</h3>
                    </div>
                    <div class="rankings-content">
                        <!-- Error Message -->
                        <c:if test="${not empty errorMessage}">
                            <div class="error-state">
                                <i class="fas fa-exclamation-triangle"></i>
                                <p>Có lỗi xảy ra</p>
                                <p>${errorMessage}</p>
                            </div>
                        </c:if>

                        <!-- Individual Results Table -->
                        <c:if test="${currentViewMode eq 'individual' and empty errorMessage}">
                            <c:choose>
                                <c:when test="${hasResults}">
                                    <table class="rankings-table">
                                        <thead>
                                            <tr>
                                                <th>Hạng</th>
                                                <th>Học viên</th>
                                                <th>Bài thi</th>
                                                <th>Điểm số</th>
                                                <th>Thời gian</th>
                                                <th>Trạng thái</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="result" items="${individualResults}" varStatus="status">
                                                <tr class="${status.count <= 3 ? 'top-3' : ''} ${result.studentID eq currentStudentId ? 'current-student' : ''}">
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${status.index + 1 == 1}">
                                                                <div class="rank-icon rank-1">
                                                                    <i class="fas fa-trophy"></i>
                                                                </div>
                                                            </c:when>
                                                            <c:when test="${status.index + 1 == 2}">
                                                                <div class="rank-icon rank-2">
                                                                    <i class="fas fa-medal"></i>
                                                                </div>
                                                            </c:when>
                                                            <c:when test="${status.index + 1 == 3}">
                                                                <div class="rank-icon rank-3">
                                                                    <i class="fas fa-award"></i>
                                                                </div>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="rank-icon rank-other">
                                                                    #${status.index + 1}
                                                                </div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <div class="student-info">
                                                            <img src="${not empty result.profilePicture ? result.profilePicture : pageContext.request.contextPath.concat('/assets/img/default-avatar.png')}" 
                                                                 alt="${result.studentName}" class="student-avatar">
                                                            <div class="student-details">
                                                                <h4>${result.studentName}</h4>
                                                                <p>${result.studentID}</p>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div>
                                                            <span class="jlpt-badge jlpt-${fn:toLowerCase(result.jlptLevel)}">${result.jlptLevel}</span>
                                                            <p style="margin: 0.5rem 0 0 0; font-size: 0.9rem; color: #666;">${result.testTitle}</p>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <span class="score-display">
                                                            <fmt:formatNumber value="${result.score}" maxFractionDigits="1"/>
                                                            <span class="score-unit">điểm</span>
                                                        </span>
                                                    </td>
                                                    <td>${result.timeTaken}</td>
                                                    <td>
                                                        <span class="status-badge status-${fn:toLowerCase(result.status)}">
                                                            ${result.status}
                                                        </span>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </c:when>
                                <c:otherwise>
                                    <div class="empty-state">
                                        <i class="fas fa-search"></i>
                                        <p>Không tìm thấy kết quả phù hợp</p>
                                        <p style="color: #999;">Thử thay đổi từ khóa tìm kiếm hoặc bộ lọc</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </c:if>

                        <!-- Average Rankings Table -->
                        <c:if test="${currentViewMode eq 'average' and empty errorMessage}">
                            <c:choose>
                                <c:when test="${hasResults}">
                                    <table class="rankings-table">
                                        <thead>
                                            <tr>
                                                <th>Hạng</th>
                                                <th>Học viên</th>
                                                <th>Cấp độ</th>
                                                <th>Điểm trung bình</th>
                                                <th>Số bài thi</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="ranking" items="${averageRankings}" varStatus="status">
                                                <tr class="${ranking.rank <= 3 ? 'top-3' : ''} ${ranking.studentID eq currentStudentId ? 'current-student' : ''}">
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${ranking.rank == 1}">
                                                                <div class="rank-icon rank-1">
                                                                    <i class="fas fa-trophy"></i>
                                                                </div>
                                                            </c:when>
                                                            <c:when test="${ranking.rank == 2}">
                                                                <div class="rank-icon rank-2">
                                                                    <i class="fas fa-medal"></i>
                                                                </div>
                                                            </c:when>
                                                            <c:when test="${ranking.rank == 3}">
                                                                <div class="rank-icon rank-3">
                                                                    <i class="fas fa-award"></i>
                                                                </div>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="rank-icon rank-other">
                                                                    #${ranking.rank}
                                                                </div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <div class="student-info">
                                                            <img src="${not empty ranking.profilePicture ? ranking.profilePicture : pageContext.request.contextPath.concat('/assets/img/default-avatar.png')}" 
                                                                 alt="${ranking.studentName}" class="student-avatar">
                                                            <div class="student-details">
                                                                <h4>${ranking.studentName}</h4>
                                                                <p>${ranking.studentID}</p>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div>
                                                            <c:forTokens items="${ranking.jlptLevels}" delims="," var="level">
                                                                <span class="jlpt-badge jlpt-${fn:toLowerCase(fn:trim(level))}">${fn:trim(level)}</span>
                                                            </c:forTokens>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <span class="score-display">
                                                            <fmt:formatNumber value="${ranking.averageScore}" maxFractionDigits="1"/>
                                                            <span class="score-unit">điểm</span>
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <span style="color: #2196f3; font-weight: 600;">${ranking.testCount} bài</span>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </c:when>
                                <c:otherwise>
                                    <div class="empty-state">
                                        <i class="fas fa-search"></i>
                                        <p>Không tìm thấy kết quả phù hợp</p>
                                        <p style="color: #999;">Thử thay đổi từ khóa tìm kiếm hoặc bộ lọc</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </c:if>
                    </div>
                </div>

                <!-- Pagination Section -->
                <c:if test="${totalPages > 1}">
                    <div class="pagination-section">
                        <div class="pagination-info">
                            <div class="info-text">
                                Hiển thị ${startItem}-${endItem} trong tổng số ${totalItems} kết quả
                            </div>
                            <div class="page-size-selector">
                                <label for="pageSize">Hiển thị:</label>
                                <select id="pageSize" onchange="changePageSize(this.value)">
                                    <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                                    <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                                    <option value="30" ${pageSize == 30 ? 'selected' : ''}>30</option>
                                    <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="pagination-controls">
                            <!-- First Page -->
                            <c:if test="${currentPage > 1}">
                                <a href="javascript:void(0)" onclick="goToPage(1)" class="pagination-btn">
                                    <i class="fas fa-angle-double-left"></i>
                                </a>
                            </c:if>
                            
                            <!-- Previous Page -->
                            <c:if test="${currentPage > 1}">
                                <a href="javascript:void(0)" onclick="goToPage(${currentPage - 1})" class="pagination-btn">
                                    <i class="fas fa-angle-left"></i>
                                </a>
                            </c:if>
                            
                            <!-- Page Numbers -->
                            <c:set var="startPage" value="${currentPage - 2 > 1 ? currentPage - 2 : 1}" />
                            <c:set var="endPage" value="${currentPage + 2 < totalPages ? currentPage + 2 : totalPages}" />
                            
                            <c:if test="${startPage > 1}">
                                <a href="javascript:void(0)" onclick="goToPage(1)" class="pagination-btn">1</a>
                                <c:if test="${startPage > 2}">
                                    <span class="pagination-ellipsis">...</span>
                                </c:if>
                            </c:if>
                            
                            <c:forEach var="pageNum" begin="${startPage}" end="${endPage}">
                                <a href="javascript:void(0)" onclick="goToPage(${pageNum})" 
                                   class="pagination-btn ${pageNum == currentPage ? 'active' : ''}">
                                    ${pageNum}
                                </a>
                            </c:forEach>
                            
                            <c:if test="${endPage < totalPages}">
                                <c:if test="${endPage < totalPages - 1}">
                                    <span class="pagination-ellipsis">...</span>
                                </c:if>
                                <a href="javascript:void(0)" onclick="goToPage(${totalPages})" class="pagination-btn">${totalPages}</a>
                            </c:if>
                            
                            <!-- Next Page -->
                            <c:if test="${currentPage < totalPages}">
                                <a href="javascript:void(0)" onclick="goToPage(${currentPage + 1})" class="pagination-btn">
                                    <i class="fas fa-angle-right"></i>
                                </a>
                            </c:if>
                            
                            <!-- Last Page -->
                            <c:if test="${currentPage < totalPages}">
                                <a href="javascript:void(0)" onclick="goToPage(${totalPages})" class="pagination-btn">
                                    <i class="fas fa-angle-double-right"></i>
                                </a>
                            </c:if>
                        </div>
                    </div>
                </c:if>
            </div>
        </main>

        <!-- Include Footer -->
        <%@ include file="footer.jsp" %>
    </div>

    <script>
    function goToPage(page) {
        const form = document.createElement('form');
        form.method = 'GET';
        form.action = '${pageContext.request.contextPath}/ranking';
        
        // Preserve current form values
        const params = {
            'viewMode': '${currentViewMode}',
            'jlptLevel': '${currentJlptLevel}',
            'searchTerm': '${currentSearchTerm}',
            'pageSize': '${pageSize}',
            'page': page
        };
        
        for (const [key, value] of Object.entries(params)) {
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = key;
            input.value = value;
            form.appendChild(input);
        }
        
        document.body.appendChild(form);
        form.submit();
    }

    function changePageSize(newPageSize) {
        const form = document.createElement('form');
        form.method = 'GET';
        form.action = '${pageContext.request.contextPath}/ranking';
        
        // Preserve current form values but reset to page 1
        const params = {
            'viewMode': '${currentViewMode}',
            'jlptLevel': '${currentJlptLevel}',
            'searchTerm': '${currentSearchTerm}',
            'pageSize': newPageSize,
            'page': 1
        };
        
        for (const [key, value] of Object.entries(params)) {
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = key;
            input.value = value;
            form.appendChild(input);
        }
        
        document.body.appendChild(form);
        form.submit();
    }

    // Update form submission to reset page to 1 when searching/filtering
    document.querySelector('.controls-form').addEventListener('submit', function(e) {
        // Add hidden page input to reset to page 1
        const pageInput = document.createElement('input');
        pageInput.type = 'hidden';
        pageInput.name = 'page';
        pageInput.value = '1';
        this.appendChild(pageInput);
        
        // Add pageSize to maintain current page size
        const pageSizeInput = document.createElement('input');
        pageSizeInput.type = 'hidden';
        pageSizeInput.name = 'pageSize';
        pageSizeInput.value = '${pageSize}';
        this.appendChild(pageSizeInput);
    });
    </script>
</body>
</html>
