<!-- <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> -->
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Bài Kiểm Tra - HIKARI JAPAN</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student/tests.css"/>
<!--        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/header_student.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/sidebar_student.css">-->
    </head>
    <body>
        <div class="container">
            <%@ include file="header.jsp" %>
            <div class="main-content">
                <%@ include file="sidebar.jsp" %>
                <div class="content">
                    <div class="section">
                        <h2>Bài Kiểm Tra Tiếng Nhật</h2>
                        <p>Tham gia các bài kiểm tra để đánh giá trình độ tiếng Nhật của bạn và chuẩn bị tốt nhất cho kỳ thi JLPT.</p>
                    </div>

                    <div class="section">
                        <h2>Các Loại Bài Kiểm Tra</h2>
                        <div class="test-types">
                            <div class="test-card">
                                <img src="${pageContext.request.contextPath}/assets/img/img_student/JLPT.png" alt="JLPT Test" />
                                <h3>Kỳ Thi JLPT</h3>
                                <p>Luyện tập và đánh giá kỹ năng tiếng Nhật theo chuẩn kỳ thi JLPT từ N5 đến N1.</p>
                                <a href="${pageContext.request.contextPath}/test-list">Bắt đầu thi JLPT</a>
                            </div>
                            <div class="test-card">
                                <img src="${pageContext.request.contextPath}/assets/img/img_student/KiemTraTrinhDo.png" alt="Level Assessment" />
                                <h3>Kiểm Tra Trình Độ</h3>
                                <p>Đánh giá trình độ tiếng Nhật hiện tại của bạn để chọn khóa học phù hợp.</p>
                                <a href="${pageContext.request.contextPath}/TestLevel">Kiểm tra ngay</a>
                            </div>
                        </div>
                    </div>

                    <div class="cta-section">
                        <h2>Sẵn sàng đánh giá trình độ tiếng Nhật của bạn?</h2>
                        <a href="${pageContext.request.contextPath}/TestLevel">Kiểm tra trình độ</a>
                        <a href="${pageContext.request.contextPath}/courses">Xem khóa học</a>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>