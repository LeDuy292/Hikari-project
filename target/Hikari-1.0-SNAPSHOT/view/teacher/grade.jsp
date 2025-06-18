<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Chấm Điểm Bài Tập - Nền Tảng Giáo dục</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" rel="stylesheet" />
        <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@700&display=swap" rel="stylesheet" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/teacher_css/grade.css" />
    </head>
    <body>
        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <%@ include file="/view/teacher/sidebar.jsp" %>
                <!-- Main Content -->
                <main class="main-content">
                    <div class="content-wrapper">
                        <!-- Header -->
                        <%@ include file="/view/teacher/header.jsp" %>
                        <!-- Main Content -->
                        <div class="row">

                            <a href="${pageContext.request.contextPath}/view/teacher/manageClasses.jsp#" class="back-btn"><i class="fas fa-arrow-left"></i> Quay lại Quản lý Khóa học</a>
                            <div class="assignment-list">
                                <div class="assignment-list-header">
                                    <h2 class="assignment-list-title">Danh sách Bài tập đã nộp</h2>
                                </div>
                                <c:forEach var="assignment" items="${assignments}">
                                    <div class="assignment-item" data-assignment-id="${assignment.id}" ${assignment.active ? 'class="active"' : ''}>
                                        <i class="fas fa-file-alt assignment-icon"></i>
                                        <div class="assignment-info">
                                            <h3 class="assignment-title">${assignment.title}</h3>
                                            <div class="assignment-meta">Học sinh: ${assignment.studentName} | Nộp: ${assignment.submissionDate}</div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                            <div class="assignment-detail">
                                <div class="assignment-detail-left">
                                    <h3 class="assignment-list-title">Danh sách Câu hỏi</h3>
                                    <div class="question-list">
                                        <c:forEach var="question" items="${questions}">
                                            <div class="question-item" data-question-id="${question.id}">
                                                <span class="question-text">${question.text}</span>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                                <div class="assignment-detail-right">
                                    <h3 class="assignment-content">Chi tiết Câu hỏi</h3>
                                    <div class="question-details">
                                        <div class="question-box">
                                            <label>Câu hỏi:</label>
                                            <p id="selectedQuestionText"></p>
                                        </div>
                                        <div class="answer-box">
                                            <label>Đáp án của học sinh:</label>
                                            <div id="selectedAnswerText"></div>
                                        </div>
                                    </div>
                                    <div class="grading-form">
                                        <h3 class="assignment-content">Chấm điểm và Nhận xét</h3>
                                        <form id="gradingForm">
                                            <div class="mb-3">
                                                <label for="grade" class="form-label">Điểm (0 - 100)</label>
                                                <input type="number" class="form-control score-input" id="grade" placeholder="0" min="0" max="100" value="${selectedAssignment.grade}" />
                                                <span class="score-max">/ 100</span>
                                            </div>
                                            <div class="mb-3">
                                                <label for="feedback" class="form-label">Nhận xét</label>
                                                <textarea class="form-control" id="feedback" rows="4" placeholder="Nhập nhận xét cho học sinh...">${selectedAssignment.feedback}</textarea>
                                            </div>
                                            <button type="submit" class="btn-submit-grade">Gửi điểm</button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/teacher_js/grade.js"></script>
    </body>
</html>