<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Test" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Kiểm Tra Trình Độ Tiếng Nhật - HIKARI JAPAN</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student/jlpt-test.css"/>
        <style>
            html, body {
                height: 100%;
                margin: 0;
                font-family: Arial, sans-serif;
                background-color: #f4f7f6;
            }

            .container {
                display: flex;
                flex-direction: column;
                min-height: 100vh;
            }

            .main-content {
                display: flex;
                flex: 1;
                margin-top: 20px;
            }

            .content {
                flex-grow: 1;
                padding: 20px;
                background-color: #fff;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }

            footer {
                background-color: #333;
                color: white;
                text-align: center;
                padding: 20px 0;
                margin-top: auto;
            }

            .test-list {
                margin-top: 20px;
            }
            .test-item {
                background: #fff;
                border-radius: 8px;
                padding: 15px;
                margin-bottom: 15px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .test-info h4 {
                margin: 0 0 5px 0;
                color: #2c3e50;
            }
            .test-meta {
                color: #7f8c8d;
                font-size: 0.9em;
                margin-bottom: 5px;
            }
            .test-actions a {
                background-color: #e74c3c;
                color: white;
                padding: 8px 15px;
                border-radius: 4px;
                text-decoration: none;
                transition: background-color 0.3s;
            }
            .test-actions a:hover {
                background-color: #c0392b;
            }
            .no-tests {
                text-align: center;
                padding: 20px;
                color: #7f8c8d;
                font-style: italic;
            }

            .sidebar {
                width: 250px;
                background-color: #f8f8f8;
                padding: 20px;
                box-shadow: 2px 0 4px rgba(0,0,0,0.05);
            }

            .cta-section {
                text-align: center;
                padding: 30px 20px;
                background-color: #f0f8ff;
                border-radius: 8px;
                margin-top: 30px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            }

            .cta-section h2 {
                color: #2c3e50;
                margin-bottom: 15px;
            }

            .cta-section a {
                display: inline-block;
                background-color: #3498db;
                color: white;
                padding: 10px 20px;
                border-radius: 5px;
                text-decoration: none;
                margin: 5px;
                transition: background-color 0.3s ease;
            }

            .cta-section a:hover {
                background-color: #2980b9;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <%@ include file="header.jsp" %>
            <div class="main-content">
                <%@ include file="sidebar.jsp" %>
                <div class="content">
                    <div class="section">
                        <h2>Kiểm Tra Trình Độ Tiếng Nhật</h2>
                        <p>Làm bài kiểm tra để đánh giá trình độ tiếng Nhật hiện tại của bạn và tìm khóa học phù hợp nhất.</p>
                    </div>

                    <div class="section">
                        <h2>Bài Kiểm Tra Trình Độ</h2>

                        <!-- Level Tests -->
                        <h3>Chọn bài kiểm tra phù hợp</h3>
                        <div class="test-list">
                            <%                                List<Test> levelTests = (List<Test>) request.getAttribute("levelTests");

                                if (levelTests != null) {
                                    System.out.println("DEBUG - levelTests size: " + levelTests.size());
                                    if (!levelTests.isEmpty()) {
                                        for (Test test : levelTests) {
                                            System.out.println("DEBUG - Processing test: " + test.getId() + " - " + test.getTitle());
                            %>
                            <div class="test-item">
                                <div class="test-info">
                                    <h4><%= test.getTitle()%> </h4>
                                    <div class="test-meta">
                                        Số câu hỏi: <%= test.getTotalQuestions()%> | 
                                        Tổng điểm: <%= test.getTotalMarks()%> | 
                                        Thời gian: <%= test.getDuration()%> phút |
                                    </div>
                                    <p><%= test.getDescription()%></p>
                                </div>
                                <div class="test-actions">
                                    <a href="${pageContext.request.contextPath}/Test?testId=<%= test.getId()%>&action=start">Làm bài ngay</a>
                                </div>
                            </div>
                            <%
                                }
                            } else {
                                System.out.println("DEBUG - levelTests is empty");
                            %>
                            <div class="no-tests">Hiện tại chưa có bài kiểm tra trình độ nào.</div>
                            <%
                                }
                            } else {
                                System.out.println("DEBUG - levelTests is null");
                            %>
                            <div class="no-tests">Không tìm thấy dữ liệu bài kiểm tra.</div>
                            <% }%>
                        </div>

                        <div class="cta-section">
                            <h2>Tìm khóa học phù hợp với bạn!</h2>
                            <a href="${pageContext.request.contextPath}/LoadTest">Xem tất cả bài kiểm tra</a>
                            <a href="${pageContext.request.contextPath}/courses">Khám phá khóa học tiếng Nhật</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>