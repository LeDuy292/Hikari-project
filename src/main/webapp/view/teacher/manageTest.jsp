<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
                                <div class="test-grid">
                                    <div class="test-card" data-test-id="1">
                                        <img src="img/tests/test1.jpg" alt="Bài Test N1" class="test-image" />
                                        <div class="test-content">
                                            <div class="test-title">Bài Test N1</div>
                                            <div class="test-description">Bài test kiểm tra trình độ N1, gồm 50 câu hỏi.</div>
                                            <div class="test-footer">
                                                <span class="test-info"><i class="fas fa-question-circle"></i> 50 câu hỏi | 60 phút</span>
                                                <button class="test-action-btn">Xem chi tiết</button>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="test-card" data-test-id="2">
                                        <img src="img/tests/test2.jpg" alt="Bài Test N2" class="test-image" />
                                        <div class="test-content">
                                            <div class="test-title">Bài Test N2</div>
                                            <div class="test-description">Bài test kiểm tra trình độ N2, gồm 40 câu hỏi.</div>
                                            <div class="test-footer">
                                                <span class="test-info"><i class="fas fa-question-circle"></i> 40 câu hỏi | 50 phút</span>
                                                <button class="test-action-btn">Xem chi tiết</button>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="test-card" data-test-id="3">
                                        <img src="img/tests/test3.jpg" alt="Bài Test N3" class="test-image" />
                                        <div class="test-content">
                                            <div class="test-title">Bài Test N3</div>
                                            <div class="test-description">Bài test kiểm tra trình độ N3, gồm 30 câu hỏi.</div>
                                            <div class="test-footer">
                                                <span class="test-info"><i class="fas fa-question-circle"></i> 30 câu hỏi | 40 phút</span>
                                                <button class="test-action-btn">Xem chi tiết</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- Question Detail -->
                            <div class="col-12" id="questionDetail" style="display: none;">
                                <a href="#" class="back-btn" id="backToTests"><i class="fas fa-arrow-left"></i> Quay lại Bài Test</a>
                                <div class="test-header">
                                    <h2 class="header-title" id="testTitle"></h2>
                                    <div>
                                        <button class="set-time-btn" id="setTimeBtn">Cài Đặt Thời Gian</button>
                                        <button class="set-questions-btn" id="setQuestionsBtn">Cài Đặt Số Câu Hỏi</button>
                                    </div>
                                </div>
                                <div class="set-time-form" id="setTimeForm" style="display: none;">
                                    <form>
                                        <div class="mb-3">
                                            <label for="testDuration" class="form-label">Thời Gian Làm Bài (phút)</label>
                                            <input type="number" class="form-control" id="testDuration" placeholder="Nhập thời gian (phút)" min="1">
                                        </div>
                                        <div class="question-actions">
                                            <button type="button" class="btn btn-success" id="saveTimeBtn">Lưu</button>
                                            <button type="button" class="btn btn-secondary" id="cancelTimeBtn">Hủy</button>
                                        </div>
                                    </form>
                                </div>
                                <div class="set-questions-form" id="setQuestionsForm" style="display: none;">
                                    <form>
                                        <div class="mb-3">
                                            <label for="totalQuestionsInput" class="form-label">Tổng Số Câu Hỏi</label>
                                            <input type="number" class="form-control" id="totalQuestionsInput" placeholder="Nhập tổng số câu hỏi" min="1" max="100">
                                        </div>
                                        <div class="question-actions">
                                            <button type="button" class="btn btn-success" id="saveQuestionsBtn">Lưu</button>
                                            <button type="button" class="btn btn-secondary" id="cancelQuestionsBtn">Hủy</button>
                                        </div>
                                    </form>
                                </div>
                                <div class="question-detail">
                                    <div class="question-detail-left">
                                        <div class="question-list-header">
                                            <div class="question-list-title">Danh Sách Câu Hỏi</div>
                                            <div class="question-stats">
                                                <span id="totalQuestions">Tổng: 0 câu</span>
                                                <span id="multipleChoiceCountDisplay">Trắc nghiệm: 0 câu</span>
                                                <span id="essayCountDisplay">Tự luận: 0 câu</span>
                                            </div>
                                        </div>
                                        <div id="questionList" class="question-progress">
                                            <!-- Questions will be populated dynamically -->
                                        </div>
                                        <div class="pagination" id="pagination">
                                            <button class="pagination-btn" id="prevPageBtn" disabled><i class="fas fa-chevron-left"></i></button>
                                            <div class="pagination-dots" id="paginationDots"></div>
                                            <button class="pagination-btn" id="nextPageBtn"><i class="fas fa-chevron-right"></i></button>
                                        </div>
                                    </div>
                                    <div class="question-detail-right">
                                        <div class="question-content" id="questionContent">
                                            <h3></h3>
                                            <div class="question-meta">
                                                <span></span>
                                            </div>
                                            <p></p>
                                            <div class="question-options" id="questionOptions"></div>
                                            <div class="question-answer" id="questionAnswer" style="display: none;">
                                                <label for="correctAnswerText" class="form-label">Đáp Án Đúng (Tự Luận)</label>
                                                <textarea class="form-control" id="correctAnswerText" rows="4" placeholder="Nhập đáp án đúng cho câu hỏi tự luận"></textarea>
                                            </div>
                                            <div class="question-actions">
                                                <button class="btn btn-primary" id="editQuestionBtn">Chỉnh sửa câu hỏi</button>
                                            </div>
                                        </div>
                                        <div class="edit-question-form" id="editQuestionForm" style="display: none;">
                                            <form>
                                                <div class="mb-3">
                                                    <label for="editQuestionText" class="form-label">Nội Dung Câu Hỏi</label>
                                                    <textarea class="form-control" id="editQuestionText" rows="4"></textarea>
                                                </div>
                                                <div class="mb-3">
                                                    <label for="editQuestionType" class="form-label">Loại Câu Hỏi</label>
                                                    <select class="form-control" id="editQuestionType">
                                                        <option value="multiple-choice">Trắc nghiệm</option>
                                                        <option value="text">Tự luận</option>
                                                    </select>
                                                </div>
                                                <div class="mb-3" id="editOptionsContainer">
                                                    <label class="form-label">Đáp Án</label>
                                                    <div class="mb-2">
                                                        <input type="text" class="form-control" value="" />
                                                        <input type="radio" name="correctAnswer" /> Đáp án đúng
                                                    </div>
                                                    <div class="mb-2">
                                                        <input type="text" class="form-control" value="" />
                                                        <input type="radio" name="correctAnswer" /> Đáp án đúng
                                                    </div>
                                                    <div class="mb-2">
                                                        <input type="text" class="form-control" value="" />
                                                        <input type="radio" name="correctAnswer" /> Đáp án đúng
                                                    </div>
                                                    <div class="mb-2">
                                                        <input type="text" class="form-control" value="" />
                                                        <input type="radio" name="correctAnswer" /> Đáp án đúng
                                                    </div>
                                                </div>
                                                <div class="mb-3" id="editAnswerContainer" style="display: none;">
                                                    <label for="editCorrectAnswerText" class="form-label">Đáp Án Đúng (Tự Luận)</label>
                                                    <textarea class="form-control" id="editCorrectAnswerText" rows="4" placeholder="Nhập đáp án đúng cho câu hỏi tự luận"></textarea>
                                                </div>
                                                <div class="question-actions">
                                                    <button type="button" class="btn btn-success" id="saveEditBtn">Lưu</button>
                                                    <button type="button" class="btn btn-secondary" id="cancelEditQuestionBtn">Hủy</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/teacher_js/test.js"></script>
    </body>
</html>