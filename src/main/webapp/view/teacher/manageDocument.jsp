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
    <meta name="context-path" content="${pageContext.request.contextPath}" />
    <title>Quản Lý Tài Liệu - Nền Tảng Giáo Dục</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/teacher_css/manageDocument.css" />
    <script>
        window.contextPath = '${pageContext.request.contextPath}';
        window.userID = '<%= teacherID %>';
    </script>
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
                        <div class="col-12">
                            <!-- Filter Bar and Class Selector -->
                            <div class="search-bar">
                                <div class="filter-bar">
                                    <button class="filter-btn active" data-filter="all">Tất cả tài liệu</button>
                                </div>
                                <!-- Class Selector Dropdown -->
                                <div class="class-selector-wrapper" id="classSelector">
                                    <select id="classSelect" class="form-select" onchange="fetchClassDocuments()">
                                        <option value="" disabled selected>Chọn lớp học</option>
                                    </select>
                                </div>
                            </div>
                            <button class="add-document-btn" id="addDocumentBtn" onclick="showAddDocumentForm()">Thêm Tài Liệu</button>
                            <!-- Document Grid -->
                            <div class="document-grid" id="documentGrid"></div>
                            <!-- Pagination -->
                            <div class="pagination" id="pagination">
                                <button class="pagination-btn" id="prevBtn" onclick="changePage(-1)" disabled><i class="fas fa-chevron-left"></i></button>
                                <div class="pagination-dots" id="paginationDots"></div>
                                <button class="pagination-btn" id="nextBtn" onclick="changePage(1)"><i class="fas fa-chevron-right"></i></button>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>
    <!-- Modal for Add/Update Document -->
    <div class="modal fade" id="documentModal" tabindex="-1" aria-labelledby="documentModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="documentModalLabel"></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="documentForm" enctype="multipart/form-data">
                        <input type="hidden" name="_csrf" value="${_csrf.token}" />
                        <input type="hidden" name="documentId" id="documentId" />
                        <div class="mb-3">
                            <label for="classId" class="form-label">Lớp Học</label>
                            <select class="form-control" id="classId" name="classID" required>
                                <option value="" disabled selected>Chọn lớp học</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="documentName" class="form-label">Tên Tài Liệu</label>
                            <input type="text" class="form-control" id="documentName" name="title" placeholder="Nhập tên tài liệu" required />
                        </div>
                        <div class="mb-3">
                            <label for="documentDescription" class="form-label">Mô Tả</label>
                            <textarea class="form-control" id="documentDescription" name="description" placeholder="Nhập mô tả tài liệu" rows="3"></textarea>
                        </div>
                        <div class="mb-3" id="documentFileInput">
                            <label for="documentFile" class="form-label">Tải Lên File</label>
                            <input type="file" class="form-control" id="documentFile" name="fileUrl" accept="application/pdf" required />
                        </div>
                        <div class="mb-3">
                            <label for="documentImage" class="form-label">Hình Ảnh</label>
                            <input type="file" class="form-control" id="documentImage" name="imageUrl" accept="image/*" />
                        </div>
                        <button type="submit" class="btn btn-primary">Lưu</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/teacher_js/manageDocument.js?v=2"></script>
</body>
</html>