
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Xem Bài Học </title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" rel="stylesheet" />
        <link href="${pageContext.request.contextPath}/assets/css/student_css/coursedetail.css" rel="stylesheet">
    </head>
    <body>
        <div class="preview-container">
            <a href="${pageContext.request.contextPath}/myCourses" class="back-btn">
                <i class="fas fa-arrow-left"></i> Quay lại Khóa Học
            </a>

            <div class="lesson-detail-container">
                <div class="lesson-sidebar">
                    <div class="lesson-list-header">
                        <div class="lesson-list-title">Nội Dung Khóa Học</div>
                        <div class="lesson-count"><c:out value="${count}"/></div>
                    </div>

                    <input type="text" class="search-input" placeholder="Tìm kiếm nội dung..." />

                    <div class="lesson-progress" id="lessonProgress">
                        <%-- Lặp qua các phần (topics) của khóa học, mỗi topic có thể chứa bài học hoặc bài tập --%>
                        <c:forEach var="topic" items="${topics}">
                            <div class="topic">
                                <div class="topic-header">
                                    <div class="topic-title"><c:out value="${topic.topicName}"/></div>
                                    <div class="topic-toggle"><i class="fas fa-chevron-right"></i></div> <%-- Mặc định mũi tên chỉ sang phải (thu gọn) --%>
                                </div>
                                <div class="topic-content" style="display: none;">
                                    <%-- Lặp qua các mục (bài học/bài tập) trong mỗi phần --%>
                                    <%-- Phần hiển thị Lessons --%>
                                    <c:if test="${not empty topic.lessons}">
                                        <c:forEach var="lesson" items="${topic.lessons}">
                                            <div class="lesson-item" onclick="showLesson(${lesson.id})">
                                                <span><i class="fas fa-play-circle"></i> <c:out value="${lesson.title}"/></span>
                                                <%-- Sử dụng isCompleted() cho Lesson --%>
                                                <div class="lesson-status <c:if test="${requestScope.completedLessonsMap[lesson.id]}">completed</c:if>"></div>
                                                </div>
                                        </c:forEach>
                                    </c:if>


                                    <%-- Phần hiển thị Assignments --%>
                                    <c:if test="${not empty topic.assignments}">
                                        <c:forEach var="assignment" items="${topic.assignments}">
                                            <div class="assignment-item" onclick="showAssignment(${assignment.id})">
                                                <span><i class="fas fa-trophy"></i> <c:out value="${assignment.title}"/></span>
                                                <%-- Sử dụng isIsComplete() cho Assignment --%>
                                                <div class="lesson-status <c:if test="${requestScope.completedAssignmentsMap[assignment.id]}">completed</c:if>"></div>
                                                </div>
                                        </c:forEach>
                                    </c:if>

                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    <div class="pagination-controls" id="lessonPagination">
                        <button class="pagination-button" id="lessonPrevBtn">Trước</button>
                        <span class="pagination-info" id="lessonPageInfo"></span>
                        <button class="pagination-button" id="lessonNextBtn">Sau</button>
                    </div>
                </div>

                <div class="lesson-content-area">
                    <%-- Hiển thị placeholder nếu không có bài học/bài tập nào được chọn hoặc truyền vào --%>
                    <div class="content-placeholder" id="contentPlaceholder" style="display: <c:choose><c:when test="${empty currentLesson && empty currentAssignment}">block</c:when><c:otherwise>none</c:otherwise></c:choose>; "> <%-- Đổi currentExam thành currentAssignment --%>
                                <div class="placeholder-icon">
                                    <i class="fas fa-graduation-cap"></i>
                                </div>
                                    <h3>Chọn một bài học hoặc bài tập</h3> <%-- Đổi "bài kiểm tra" thành "bài tập" --%>
                        <h5>Chọn nội dung từ danh sách bên trái để bắt đầu học tập hoặc làm bài tập</h5> <%-- Đổi "bài kiểm tra" thành "bài tập" --%>
                    </div>

                    <%-- Hiển thị nội dung bài học nếu currentLesson có dữ liệu --%>
                    <div class="lesson-content" id="lessonContent" style="display: <c:choose><c:when test="${not empty currentLesson}">block</c:when><c:otherwise>none</c:otherwise></c:choose>; ">
                                <div class="lesson-video-container">
                                    <div class="lesson-video">
                                        <video id="lessonVideoPlayer" controls ">
                                                <source src="${currentLesson.mediaUrl}" type="video/mp4">
                                    Trình duyệt của bạn không hỗ trợ thẻ video HTML5.
                                </video>
                            </div>
                        </div>

                        <div class="lesson-tabs">
                            <div class="lesson-tab-buttons">
                                <button class="lesson-tab-btn active" onclick="switchLessonTab('lesson-info')">
                                    <i class="fas fa-book"></i>
                                    <span>Bài học</span>
                                </button>
                                <button class="lesson-tab-btn" onclick="switchLessonTab('exercises')">
                                    <i class="fas fa-tasks"></i>
                                    <span>Bài tập</span>
                                </button>

                            </div>

                            <div class="lesson-tab-content active" id="lesson-info">
                                <div class="lesson-info-topic">
                                    <div class="lesson-header">
                                        <div class="lesson-type-badge lesson-badge">
                                            <i class="fas fa-play-circle"></i>
                                            <span>Bài Học</span>
                                        </div>
                                        <h2 id="lessonTitle"><c:out value="${currentLesson.title}"/></h2>
                                    </div>

                                    <div class="lesson-description">
                                        <p id="lessonDescription"><c:out value="${currentLesson.description}"/></p>
                                    </div>
                                    <div class="documents-topic">
                                        <h4><i class="fas fa-file-alt"></i> Tài liệu tham khảo</h4>
                                        <div id="lessonDocumentsList">

                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="lesson-tab-content" id="exercises">
                                <div class="exercise-topic">
                                    <div class="exercise-header-topic">
                                        <h3><i class="fas fa-tasks"></i> Bài tập thực hành</h3>
                                    </div>

                                    <div class="exercise-question">
                                    </div>

                                    <div class="pagination-controls" id="exercisePagination">
                                        <button class="pagination-button" id="exercisePrevBtn">Trước</button>
                                        <span class="pagination-info" id="exercisePageInfo"></span>
                                        <button class="pagination-button" id="exerciseNextBtn">Sau</button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <%-- Hiển thị nội dung bài tập nếu currentAssignment có dữ liệu --%>
                        <div class="assignment-content" id="assignmentContent" style="display: <c:choose><c:when test="${not empty currentAssignment}">block</c:when><c:otherwise>none</c:otherwise></c:choose>; "> <%-- Đổi id và class từ exam thành assignment --%>
                            <div class="assignment-header-card"> <%-- Đổi từ exam-header-card --%>
                                <div class="assignment-icon-large"> <%-- Đổi từ exam-icon-large --%>
                                    <i class="fas fa-trophy"></i>
                                </div>
                                <div class="assignment-header"> <%-- Đổi từ exam-header --%>
                                    <div class="lesson-type-badge assignment-badge"> <%-- Đổi từ exam-badge --%>
                                        <i class="fas fa-trophy"></i>
                                        <span>Bài Tập</span> <%-- Đổi "Bài Kiểm Tra" thành "Bài Tập" --%>
                                    </div>
                                    <h2 id="assignmentTitle"></h2>
                                </div>

                                <div class="assignment-stats">
                                    <div class="stat-item">
                                        <div class="stat-number" id="assignmentQuestionCount"></div>
                                        <div class="stat-label">Câu hỏi</div>
                                    </div>
                                    <div class="stat-item">
                                        <div class="stat-number" id="assignmentTotalMarks"></div>
                                        <div class="stat-label">Điểm</div>
                                    </div>
                                    <div class="stat-item">
                                        <div class="stat-number" id="assignmentDurationMinutes"></div>
                                        <div class="stat-label">Phút</div>
                                    </div>
                                </div>

                                <div class="assignment-description" style="font-size: 1.1rem;" id="assignmentDescription"> <%-- Đổi từ exam-description --%>
                                </div>
                            </div>

                            <div class="assignment-questions-topic"> <%-- Đổi từ exam-questions-topic --%>
                                <div class="topic-header">
                                    <h3><i class="fas fa-question-circle" style="color: var(--warning-color);"></i> Danh Sách Câu Hỏi</h3>
                                </div>
                                <div class="assignment-questions" id="assignmentQuestionsList">

                                </div>
                                <div class="pagination-controls" id="assignmentPagination" >
                                    <button class="pagination-button" id="assignmentPrevBtn">Trước</button>
                                    <span class="pagination-info" id="assignmentPageInfo"></span>
                                    <button class="pagination-button" id="assignmentNextBtn">Sau</button>
                                </div>

                                <div class="submit-button-container">
                                    <button class="submit-button" id="submitAssignmentBtn">Nộp bài</button>
                                </div>
                                <div id="assignmentResultModal" class="modal">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>Kết quả bài tập</h3>
                                <span class="close-btn" onclick="closeModal()">×</span>
                            </div>
                            <div class="modal-body">
                                <p>Điểm của bạn:</p>
                                <p class="score" id="modalScore"></p>
                            </div>
                            <div class="modal-footer">
                                <button onclick="closeModal()">Đóng</button>
                            </div>
                        </div>
                    </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <input type="hidden" id="lessonId" value="" />
            <input type="hidden" id="currentStudentId" value="${requestScope.currentStudentId}"> 
            <input type="hidden" id="currentCourseId" value="${courseID}">
            <input type="hidden" id="studentEnrollmentId" value="${requestScope.currentEnrollment.enrollmentID}">
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
            <script src="${pageContext.request.contextPath}/assets/js/student_js/coursedetail.js"></script>

    </body>
</html>
