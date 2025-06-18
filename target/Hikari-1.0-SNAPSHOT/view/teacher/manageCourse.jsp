<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% 
     String teacherID = (String) session.getAttribute("teacherID");
    if (teacherID == null) {
        teacherID = "T002"; // Giả lập cho test
        session.setAttribute("teacherID", teacherID);
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quản Lý Khóa Học - Nền Tảng Giáo Dục</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/teacher_css/manageCourse.css" />
    <script>
        window.contextPath = '${pageContext.request.contextPath}';
        window.userID = '<%= teacherID %>';
    </script>
</script>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <%@ include file="sidebar.jsp" %>
            <!-- Main Content -->
            <main class="main-content col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="content-wrapper">
                    <!-- Header -->
                    <%@ include file="header.jsp" %>
                    <div class="row">
                        <!-- Course List -->
                        <div class="col-12" id="courseList">
                            <div class="course-grid">
                                <c:forEach var="course" items="${courses}">
                                    <div class="course-card" data-course-id="${course.courseID}">
                                        <img src="${pageContext.request.contextPath}/img/${course.image}" alt="${course.title}" class="course-image" />
                                        <div class="course-content">
                                            <div class="course-title">${course.title}</div>
                                            <div class="course-description">${course.description}</div>
                                            <div class="course-footer">
                                                <span class="course-students"><i class="fas fa-users"></i> ${course.studentCount} học viên</span>
                                                <button class="course-action-btn btn btn-primary">Xem chi tiết</button>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                        <!-- Lesson Detail -->
                        <div class="col-12" id="lessonDetail" style="display: none;">
                            <a href="#" class="back-btn" id="backToCourses"><i class="fas fa-arrow-left"></i> Quay lại Khóa Học</a>
                            <div class="lesson-detail">
                                <div class="lesson-detail-left">
                                    <div class="lesson-list-header">
                                        <div class="lesson-list-title">Danh Sách Bài Học</div>
                                        <div class="lesson-count" id="lessonCount">0</div>
                                        <button class="btn btn-primary add-lesson-btn" id="addLessonBtn">Thêm Bài Học</button>
                                    </div>
                                    <input type="text" class="search-input form-control" id="lessonSearch" placeholder="Tìm kiếm bài học..." />
                                    <div id="lessonList" class="lesson-progress">
                                        <!-- Bài học sẽ được tải động qua JavaScript -->
                                    </div>
                                </div>
                                <div class="lesson-detail-right">
                                    <div class="lesson-video">
                                        <div class="progress-bar">
                                            <div class="progress"></div>
                                        </div>
                                        <div class="play-icon"><i class="fas fa-play"></i></div>
                                    </div>
                                    <div class="navigation-buttons">
                                        <button class="btn btn-lesson active" id="showLessonBtn">Bài học</button>
                                        <button class="btn btn-exercise" id="showExerciseBtn">Bài tập</button>
                                    </div>
                                    <div class="lesson-content" id="lessonContent" style="display: block;">
                                        <h3>Chọn một bài học</h3>
                                        <p>Vui lòng chọn một bài học từ danh sách bên trái để xem chi tiết.</p>
                                    </div>
                                    <div class="exercise-section" id="exerciseSection" style="display: none;">
                                        <div class="exercise-content" id="exerciseContent">
                                            <h3>Bài tập</h3>
                                            <p>Chọn một bài học để xem bài tập liên quan.</p>
                                        </div>
                                    </div>
                                    <div class="edit-lesson-form" id="editLessonForm" style="display: none;">
                                        <form>
                                            <div class="mb-3">
                                                <label for="editLessonName" class="form-label">Tên Bài Học</label>
                                                <input type="text" class="form-control" id="editLessonName" value="">
                                            </div>
                                            <div class="mb-3">
                                                <label for="editLessonDescription" class="form-label">Mô Tả</label>
                                                <textarea class="form-control" id="editLessonDescription" rows="4"></textarea>
                                            </div>
                                            <div class="mb-3">
                                                <label for="editLessonDuration" class="form-label">Thời Lượng (phút)</label>
                                                <input type="number" class="form-control" id="editLessonDuration" value="0" step="1">
                                            </div>
                                            <div class="mb-3">
                                                <label for="editLessonResource" class="form-label">Liên Kết Tài Liệu/Video</label>
                                                <input type="url" class="form-control" id="editLessonResource" value="">
                                            </div>
                                            <div class="mb-3">
                                                <label for="editLessonTopic" class="form-label">Chủ Đề</label>
                                                <select class="form-control" id="editLessonTopic">
                                                 
                                                </select>
                                            </div>
                                            <div class="lesson-actions">
                                                <button type="button" class="btn btn-success" id="saveEditLessonBtn">Lưu</button>
                                                <button type="button" class="btn btn-secondary" id="cancelEditLessonBtn">Hủy</button>
                                            </div>
                                        </form>
                                    </div>
                                    <div class="edit-exercise-form" id="editExerciseForm" style="display: none;">
                                        <form>
                                            <div class="mb-3">
                                                <label for="editExerciseName" class="form-label">Tên Bài Tập</label>
                                                <input type="text" class="form-control" id="editExerciseName" value="">
                                            </div>
                                            <div class="mb-3">
                                                <label for="editExerciseDescription" class="form-label">Mô Tả</label>
                                                <textarea class="form-control" id="editExerciseDescription" rows="4"></textarea>
                                            </div>
                                            <div class="mb-3">
                                                <label for="editExerciseResource" class="form-label">Liên Kết Tài Liệu/Bài Tập</label>
                                                <input type="url" class="form-control" id="editExerciseResource" value="">
                                            </div>
                                            <div class="lesson-actions">
                                                <button type="button" class="btn btn-success" id="saveEditExerciseBtn">Lưu</button>
                                                <button type="button" class="btn btn-secondary" id="cancelEditExerciseBtn">Hủy</button>
                                            </div>
                                        </form>
                                    </div>
                                    <div class="add-lesson-form" id="addLessonForm" style="display: none;">
                                        <form>
                                            <div class="mb-3">
                                                <label for="addLessonName" class="form-label">Tên Bài Học</label>
                                                <input type="text" class="form-control" id="addLessonName" placeholder="Nhập tên bài học">
                                            </div>
                                            <div class="mb-3">
                                                <label for="addLessonDescription" class="form-label">Mô Tả</label>
                                                <textarea class="form-control" id="addLessonDescription" rows="4" placeholder="Nhập mô tả bài học"></textarea>
                                            </div>
                                            <div class="mb-3">
                                                <label for="addLessonDuration" class="form-label">Thời Lượng (phút)</label>
                                                <input type="number" class="form-control" id="addLessonDuration" value="0" step="1">
                                            </div>
                                            <div class="mb-3">
                                                <label for="addLessonResource" class="form-label">Liên Kết Tài Liệu/Video</label>
                                                <input type="url" class="form-control" id="addLessonResource" placeholder="Nhập liên kết">
                                            </div>
                                            
                                            <div class="mb-3">
                                                <label for="addLessonTopic" class="form-label">Chủ Đề</label>
                                                <select class="form-control" id="addLessonTopic">                                                  
                                                </select>
                                            </div>
                                            <div class="lesson-actions">
                                                <button type="button" class="btn btn-success" id="saveAddLessonBtn">Lưu</button>
                                                <button type="button" class="btn btn-secondary" id="cancelAddLessonBtn">Hủy</button>
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
    <script src="${pageContext.request.contextPath}/assets/js/teacher_js/manageCourse.js"></script>
</body>
</html>