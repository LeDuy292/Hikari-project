<!-- <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> -->
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Kỳ Thi JLPT - HIKARI JAPAN</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student/jlpt-test.css"/>
    </head>
    <body>
        <div class="container">
            <%@ include file="header.jsp" %>
            <div class="main-content">
                <%@ include file="sidebar.jsp" %>
                <div class="content">
                    <div class="section">
                        <h2>Kỳ Thi JLPT</h2>
                        <p>Chọn cấp độ JLPT phù hợp với bạn để luyện tập và đánh giá kỹ năng tiếng Nhật từ N5 đến N1.</p>
                    </div>

                    <div class="section">
                        <h2>Các Cấp Độ JLPT</h2>
                        <div class="test-levels">
                            <div class="level-card">
                                <img src="${pageContext.request.contextPath}/assets/img/img_student/JLPT-N5.png" alt="JLPT N5" class="logo" />
                                <h3>JLPT N5</h3>
                                <p>Cấp độ cơ bản dành cho người mới bắt đầu học tiếng Nhật.</p>
                                <div class="button-container">
                                    <a href="${pageContext.request.contextPath}/Test?testId=1&action=start">Bắt đầu thi</a>
                                </div>
                            </div>
                            <div class="level-card">
                                <img src="${pageContext.request.contextPath}/assets/img/img_student/JLPT-N4.png" alt="JLPT N4" class="logo" />
                                <h3>JLPT N4</h3>
                                <p>Cấp độ trung cấp cơ bản, tập trung vào kỹ năng nghe và đọc.</p>
                                <div class="button-container">
                                    <a href="${pageContext.request.contextPath}/Test?testId=2&action=start">Bắt đầu thi</a>
                                </div>
                            </div>
                            <div class="level-card">
                                <img src="${pageContext.request.contextPath}/assets/img/img_student/JLPT-N3.png" alt="JLPT N3" class="logo" />
                                <h3>JLPT N3</h3>
                                <p>Cấp độ trung cấp nâng cao, chuẩn bị cho giao tiếp thực tế.</p>
                                <div class="button-container">
                                    <a href="${pageContext.request.contextPath}/Test?testId=3&action=start">Bắt đầu thi</a>
                                </div>
                            </div>
                            <div class="level-card">
                                <img src="${pageContext.request.contextPath}/assets/img/img_student/JLPT-N2.png" alt="JLPT N2" class="logo" />
                                <h3>JLPT N2</h3>
                                <p>Cấp độ nâng cao, yêu cầu kỹ năng ngôn ngữ toàn diện.</p>
                                <div class="button-container">
                                    <a href="${pageContext.request.contextPath}/Test?testId=4&action=start">Bắt đầu thi</a>
                                </div>
                            </div>
                            <div class="level-card">
                                <img src="${pageContext.request.contextPath}/assets/img/img_student/JLPT-N1.png" alt="JLPT N1" class="logo" />
                                <h3>JLPT N1</h3>
                                <p>Cấp độ cao nhất, dành cho người muốn thành thạo tiếng Nhật.</p>
                                <div class="button-container">
                                    <a href="${pageContext.request.contextPath}/Test?testId=5&action=start">Bắt đầu thi</a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="cta-section">
                        <h2>Sẵn sàng chinh phục kỳ thi JLPT?</h2>
                        <a href="${pageContext.request.contextPath}/jlpt-test/start">Bắt đầu ngay</a>
                        <a href="${pageContext.request.contextPath}/courses">Xem khóa học JLPT</a>
                    </div>
                </div>
            </div>
            <%@ include file="footer.jsp" %>
        </div>
    </body>
</html>