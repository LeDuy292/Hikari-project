<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Test" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Kỳ Thi JLPT - HIKARI JAPAN</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student/jlpt-test.css"/>
        <style>
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
        </style>
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
                        
                        <!-- N5 Tests -->
                        <h3>JLPT N5</h3>
                        <div class="test-list">
                            <% List<Test> n5Tests = (List<Test>) request.getAttribute("n5Tests"); 
                               if (n5Tests != null && !n5Tests.isEmpty()) { 
                                   for (Test test : n5Tests) { %>
                                <div class="test-item">
                                    <div class="test-info">
                                        <h4><%= test.getTitle() %></h4>
                                        <div class="test-meta">
                                            Số câu: <%= test.getTotalQuestions() %> | 
                                            Tổng điểm: <%= test.getTotalMarks() %> | 
                                            Thời gian: <%= test.getDuration() %> phút
                                        </div>
                                        <p><%= test.getDescription() %></p>
                                    </div>
                                    <div class="test-actions">
                                        <a href="${pageContext.request.contextPath}/Test?testId=<%= test.getId() %>&action=start">Bắt đầu thi</a>
                                    </div>
                                </div>
                            <%   } 
                               } else { %>
                                <div class="no-tests">Chưa có bài kiểm tra nào cho cấp độ N5.</div>
                            <% } %>
                        </div>
                        
                        <!-- N4 Tests -->
                        <h3>JLPT N4</h3>
                        <div class="test-list">
                            <% List<Test> n4Tests = (List<Test>) request.getAttribute("n4Tests"); 
                               if (n4Tests != null && !n4Tests.isEmpty()) { 
                                   for (Test test : n4Tests) { %>
                                <div class="test-item">
                                    <div class="test-info">
                                        <h4><%= test.getTitle() %></h4>
                                        <div class="test-meta">
                                            Số câu: <%= test.getTotalQuestions() %> | 
                                            Tổng điểm: <%= test.getTotalMarks() %> | 
                                            Thời gian: <%= test.getDuration() %> phút
                                        </div>
                                        <p><%= test.getDescription() %></p>
                                    </div>
                                    <div class="test-actions">
                                        <a href="${pageContext.request.contextPath}/Test?testId=<%= test.getId() %>&action=start">Bắt đầu thi</a>
                                    </div>
                                </div>
                            <%   } 
                               } else { %>
                                <div class="no-tests">Chưa có bài kiểm tra nào cho cấp độ N4.</div>
                            <% } %>
                        </div>
                        
                        <!-- N3 Tests -->
                        <h3>JLPT N3</h3>
                        <div class="test-list">
                            <% List<Test> n3Tests = (List<Test>) request.getAttribute("n3Tests"); 
                               if (n3Tests != null && !n3Tests.isEmpty()) { 
                                   for (Test test : n3Tests) { %>
                                <div class="test-item">
                                    <div class="test-info">
                                        <h4><%= test.getTitle() %></h4>
                                        <div class="test-meta">
                                            Số câu: <%= test.getTotalQuestions() %> | 
                                            Tổng điểm: <%= test.getTotalMarks() %> | 
                                            Thời gian: <%= test.getDuration() %> phút
                                        </div>
                                        <p><%= test.getDescription() %></p>
                                    </div>
                                    <div class="test-actions">
                                        <a href="${pageContext.request.contextPath}/Test?testId=<%= test.getId() %>&action=start">Bắt đầu thi</a>
                                    </div>
                                </div>
                            <%   } 
                               } else { %>
                                <div class="no-tests">Chưa có bài kiểm tra nào cho cấp độ N3.</div>
                            <% } %>
                        </div>
                        
                        <!-- N2 Tests -->
                        <h3>JLPT N2</h3>
                        <div class="test-list">
                            <% List<Test> n2Tests = (List<Test>) request.getAttribute("n2Tests"); 
                               if (n2Tests != null && !n2Tests.isEmpty()) { 
                                   for (Test test : n2Tests) { %>
                                <div class="test-item">
                                    <div class="test-info">
                                        <h4><%= test.getTitle() %></h4>
                                        <div class="test-meta">
                                            Số câu: <%= test.getTotalQuestions() %> | 
                                            Tổng điểm: <%= test.getTotalMarks() %> | 
                                            Thời gian: <%= test.getDuration() %> phút
                                        </div>
                                        <p><%= test.getDescription() %></p>
                                    </div>
                                    <div class="test-actions">
                                        <a href="${pageContext.request.contextPath}/Test?testId=<%= test.getId() %>&action=start">Bắt đầu thi</a>
                                    </div>
                                </div>
                            <%   } 
                               } else { %>
                                <div class="no-tests">Chưa có bài kiểm tra nào cho cấp độ N2.</div>
                            <% } %>
                        </div>
                        
                        <!-- N1 Tests -->
                        <h3>JLPT N1</h3>
                        <div class="test-list">
                            <% List<Test> n1Tests = (List<Test>) request.getAttribute("n1Tests"); 
                               if (n1Tests != null && !n1Tests.isEmpty()) { 
                                   for (Test test : n1Tests) { %>
                                <div class="test-item">
                                    <div class="test-info">
                                        <h4><%= test.getTitle() %></h4>
                                        <div class="test-meta">
                                            Số câu: <%= test.getTotalQuestions() %> | 
                                            Tổng điểm: <%= test.getTotalMarks() %> | 
                                            Thời gian: <%= test.getDuration() %> phút
                                        </div>
                                        <p><%= test.getDescription() %></p>
                                    </div>
                                    <div class="test-actions">
                                        <a href="${pageContext.request.contextPath}/Test?testId=<%= test.getId() %>&action=start">Bắt đầu thi</a>
                                    </div>
                                </div>
                            <%   } 
                               } else { %>
                                <div class="no-tests">Chưa có bài kiểm tra nào cho cấp độ N1.</div>
                            <% } %>
                        </div>
                    </div>

                    <div class="cta-section">
                        <h2>Sẵn sàng chinh phục kỳ thi JLPT?</h2>
                        <a href="${pageContext.request.contextPath}/LoadTest">Xem tất cả bài kiểm tra</a>
                        <a href="${pageContext.request.contextPath}/courses">Xem khóa học JLPT</a>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>