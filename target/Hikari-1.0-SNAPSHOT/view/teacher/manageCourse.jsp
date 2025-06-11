<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
                    <div class="row">
                        <!-- Course List -->
                        <div class="col-12" id="courseList">
                            <div class="course-grid">
                                <div class="course-card" data-course-id="1">
                                    <img src="${pageContext.request.contextPath}/img/Japanese-N1.jpg" alt="Tiếng Nhật N1" class="course-image" />
                                    <div class="course-content">
                                        <div class="course-title">Tiếng Nhật N1</div>
                                        <div class="course-description">Khóa học N1 dành cho người học nâng cao, chuẩn bị thi JLPT N1.</div>
                                        <div class="course-footer">
                                            <span class="course-students"><i class="fas fa-users"></i> 120 học viên</span>
                                            <button class="course-action-btn btn-primary">Xem chi tiết</button>
                                        </div>
                                    </div>
                                </div>
                                <div class="course-card" data-course-id="2">
                                    <img src="img/Japanese-N2.png" alt="Tiếng Nhật N2" class="course-image" />
                                    <div class="course-content">
                                        <div class="course-title">Tiếng Nhật N2</div>
                                        <div class="course-description">Khóa học N2 dành cho người học trung cấp, chuẩn bị thi JLPT N2.</div>
                                        <div class="course-footer">
                                            <span class="course-students"><i class="fas fa-users"></i> 85 học viên</span>
                                            <button class="course-action-btn btn-primary ">Xem chi tiết</button>
                                        </div>
                                    </div>
                                </div>
                                <div class="course-card" data-course-id="3">
                                    <img src="${pageContext.request.contextPath}/img/Japanese-N1.jpg" alt="Tiếng Nhật N3" class="course-image" />
                                    <div class="course-content">
                                        <div class="course-title">Tiếng Nhật N3</div>
                                        <div class="course-description">Khóa học N3 dành cho người học trung cấp, chuẩn bị thi JLPT N3.</div>
                                        <div class="course-footer">
                                            <span class="course-students"><i class="fas fa-users"></i> 60 học viên</span>
                                            <button class="course-action-btn btn-primary">Xem chi tiết</button>
                                        </div>
                                    </div>
                                </div>
                                <div class="course-card" data-course-id="4">
                                    <img src="${pageContext.request.contextPath}/img/Japanese-N4.jpg" alt="Tiếng Nhật N4" class="course-image" />
                                    <div class="course-content">
                                        <div class="course-title">Tiếng Nhật N4</div>
                                        <div class="course-description">Khóa học N4 dành cho người học cơ bản, chuẩn bị thi JLPT N4.</div>
                                        <div class="course-footer">
                                            <span class="course-students"><i class="fas fa-users"></i> 45 học viên</span>
                                            <button class="course-action-btn btn-primary">Xem chi tiết</button>
                                        </div>
                                    </div>
                                </div>
                                <div class="course-card" data-course-id="5">
                                    <img src="${pageContext.request.contextPath}/img/Japanese-N4.jpg" alt="Tiếng Nhật N5" class="course-image" />
                                    <div class="course-content">
                                        <div class="course-title">Tiếng Nhật N5</div>
                                        <div class="course-description">Khóa học N5 dành cho người mới bắt đầu, chuẩn bị thi JLPT N5.</div>
                                        <div class="course-footer">
                                            <span class="course-students"><i class="fas fa-users"></i> 30 học viên</span>
                                            <button class="course-action-btn btn-primary">Xem chi tiết</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- Sections List -->
                        <div class="col-12" id="sectionList" style="display: none;">
                            <a href="#" class="back-btn" id="backToCourses"><i class="fas fa-arrow-left"></i> Quay lại Khóa Học</a>
                            <h2 class="course-title" id="selectedCourseTitle"></h2>
                            <div class="section-card " data-section="speaking">
                                <div class="section-info">
                                    <i class="fas fa-microphone section-icon "></i>
                                    <div class="section-title">Speaking</div>
                                </div>
                                <button class="add-lesson-btn" data-section="speaking">Thêm Bài Học</button>
                            </div>
                            <div class="section-card " data-section="listening">
                                <div class="section-info">
                                    <i class="fas fa-headphones section-icon"></i>
                                    <div class="section-title">Listening</div>
                                </div>
                                <button class="add-lesson-btn" data-section="listening">Thêm Bài Học</button>
                            </div>
                            <div class="section-card" data-section="reading">
                                <div class="section-info">
                                    <i class="fas fa-book-open section-icon "></i>
                                    <div class="section-title">Reading</div>
                                </div>
                                <button class="add-lesson-btn" data-section="reading">Thêm Bài Học</button>
                            </div>
                            <div class="section-card" data-section="writing">
                                <div class="section-info">
                                    <i class="fas fa-pen section-icon"></i>
                                    <div class="section-title">Writing</div>
                                </div>
                                <button class="add-lesson-btn" data-section="writing">Thêm Bài Học</button>
                            </div>
                            <!-- Add Lesson Form -->
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
                                        <label for="addLessonDuration" class="form-label">Thời Lượng (giờ)</label>
                                        <input type="number" class="form-control" id="addLessonDuration" placeholder="Nhập thời lượng" step="0.1">
                                    </div>
                                    <div class="mb-3">
                                        <label for="addLessonResource" class="form-label">Liên Kết Tài Liệu/Video</label>
                                        <input type="url" class="form-control" id="addLessonResource" placeholder="Nhập liên kết tài liệu hoặc video">
                                    </div>
                                    <div class="lesson-actions">
                                        <button type="button" class="btn btn-success" id="saveNewLessonBtn">Lưu</button>
                                        <button type="button" class="btn btn-secondary" id="cancelAddLessonBtn">Hủy</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                        <!-- Lesson Detail -->
                        <div class="col-12" id="lessonDetail" style="display: none;">
                            <a href="#" class="back-btn" id="backToSections"><i class="fas fa-arrow-left"></i> Quay lại Phần</a>
                            <div class="lesson-detail">
                                <div class="lesson-detail-left">
                                    <div class="lesson-list-header">
                                        <div class="lesson-list-title">Danh Sách Bài Học</div>
                                        <div class="lesson-count" id="lessonCount">10</div>
                                    </div>
                                    <input type="text" class="search-input" id="lessonSearch" placeholder="Tìm kiếm bài học..." />
                                    <div id="lessonList" class="lesson-progress">
                                        <!-- Section 0 -->
                                        <div class="section">
                                            <div class="section-header" data-section="section-0">
                                                <div class="section-title">Bộ 0: Nhập môn</div>
                                                <div class="section-toggle"><i class="fas fa-chevron-right"></i></div>
                                            </div>
                                            <div class="section-content" id="section-0">
                                                <div class="lesson-item" data-lesson-id="1">
                                                    <span>Grammar explanation</span>
                                                    <div class="lesson-status completed"></div>
                                                </div>
                                                <div class="lesson-item active" data-lesson-id="2">
                                                    <span>Lesson 1</span>
                                                    <div class="lesson-status completed"></div>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- Section 1 -->
                                        <div class="section">
                                            <div class="section-header" data-section="section-1">
                                                <div class="section-title">Bộ 1: Giới thiệu về tần, tưới, quẹo quạn, nghề nghiệp</div>
                                                <div class="section-toggle"><i class="fas fa-chevron-down"></i></div>
                                            </div>
                                            <div class="section-content show" id="section-1">
                                                <div class="lesson-item" data-lesson-id="3">
                                                    <span>Lesson 2</span>
                                                    <div class="lesson-status completed"></div>
                                                </div>
                                                <div class="lesson-item" data-lesson-id="4">
                                                    <span>Lesson 3</span>
                                                    <div class="lesson-status completed"></div>
                                                </div>
                                                <div class="lesson-item" data-lesson-id="5">
                                                    <span>Lesson 4</span>
                                                    <div class="lesson-status completed"></div>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- Section 2 -->
                                        <div class="section">
                                            <div class="section-header" data-section="section-2">
                                                <div class="section-title">Bộ 2: Giới thiệu về đồ vật</div>
                                                <div class="section-toggle"><i class="fas fa-chevron-right"></i></div>
                                            </div>
                                            <div class="section-content" id="section-2">
                                                <div class="lesson-item" data-lesson-id="6">
                                                    <span>Lesson 5</span>
                                                    <div class="lesson-status completed"></div>
                                                </div>
                                                <div class="lesson-item" data-lesson-id="7">
                                                    <span>Lesson 6</span>
                                                    <div class="lesson-status"></div>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- Section 3 -->
                                        <div class="section">
                                            <div class="section-header" data-section="section-3">
                                                <div class="section-title">Bộ 3: Giới thiệu về thời gian</div>
                                                <div class="section-toggle"><i class="fas fa-chevron-right"></i></div>
                                            </div>
                                            <div class="section-content" id="section-3">
                                                <div class="lesson-item" data-lesson-id="8">
                                                    <span>Lesson 7</span>
                                                    <div class="lesson-status"></div>
                                                </div>
                                                <div class="lesson-item" data-lesson-id="9">
                                                    <span>Lesson 8</span>
                                                    <div class="lesson-status"></div>
                                                </div>
                                                <div class="lesson-item" data-lesson-id="10">
                                                    <span>Lesson 9</span>
                                                    <div class="lesson-status"></div>
                                                </div>
                                            </div>
                                        </div>
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
                                    <div class="lesson-content" id="lessonContent">
                                        <h3>Lesson 1</h3>
                                        <div class="lesson-meta">
                                            <span><i class="fas fa-clock"></i> 1 giờ</span>
                                            <span><i class="fas fa-link"></i> <a href="https://example.com/video" target="_blank">Xem tài liệu</a></span>
                                        </div>
                                        <p>Learn basic speaking skills with this introductory lesson.</p>
                                        <div class="lesson-actions">
                                            <button class="btn btn-primary" id="editLessonBtn">Chỉnh sửa bài học</button>
                                        </div>
                                    </div>
                                    <div class="exercise-section" id="exerciseSection" style="display: none;">
                                        <div class="exercise-content" id="exerciseContent">
                                            <h3>Bài tập - Speaking</h3>
                                            <p>Practice speaking with these exercises.</p>
                                            <div class="lesson-actions">
                                                <button class="btn btn-primary" id="editExerciseBtn">Chỉnh sửa bài tập</button>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="edit-lesson-form" id="editLessonForm" style="display: none;">
                                        <form>
                                            <div class="mb-3">
                                                <label for="editLessonName" class="form-label">Tên Bài Học</label>
                                                <input type="text" class="form-control" id="editLessonName" value="Lesson 1">
                                            </div>
                                            <div class="mb-3">
                                                <label for="editLessonDescription" class="form-label">Mô Tả</label>
                                                <textarea class="form-control" id="editLessonDescription" rows="4">Learn basic speaking skills with this introductory lesson.</textarea>
                                            </div>
                                            <div class="mb-3">
                                                <label for="editLessonDuration" class="form-label">Thời Lượng (giờ)</label>
                                                <input type="number" class="form-control" id="editLessonDuration" value="1" step="0.1">
                                            </div>
                                            <div class="mb-3">
                                                <label for="editLessonResource" class="form-label">Liên Kết Tài Liệu/Video</label>
                                                <input type="url" class="form-control" id="editLessonResource" value="https://example.com/video">
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
                                                <input type="text" class="form-control" id="editExerciseName" value="Bài tập - Speaking">
                                            </div>
                                            <div class="mb-3">
                                                <label for="editExerciseDescription" class="form-label">Mô Tả</label>
                                                <textarea class="form-control" id="editExerciseDescription" rows="4">Practice speaking with these exercises.</textarea>
                                            </div>
                                            <div class="mb-3">
                                                <label for="editExerciseResource" class="form-label">Liên Kết Tài Liệu/Bài Tập</label>
                                                <input type="url" class="form-control" id="editExerciseResource" value="https://example.com/exercise">
                                            </div>
                                            <div class="lesson-actions">
                                                <button type="button" class="btn btn-success" id="saveEditExerciseBtn">Lưu</button>
                                                <button type="button" class="btn btn-secondary" id="cancelEditExerciseBtn">Hủy</button>
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
   <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
               <script src="${pageContext.request.contextPath}/assets/js/teacher_js/manageCourse.js"></script>

</body>
</html>