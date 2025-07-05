<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>HIKARI | Tài liệu</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&family=Dancing+Script:wght@700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student/style.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student/sidebar_course.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student/header_course.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student/footer_course.css"/>
</head>
<body class="main-body">
  <div class="main-container">
    <!-- Sidebar -->
    <%@include file="sidebar_course.jsp" %>

    <!-- Main content -->
    <main class="main-content">
      <div class="content-wrapper">
        <!-- Header -->
        <%@include file="header_course.jsp" %>

        <!-- Tabs and search -->
        <div class="tabs-search">
          <div class="tabs">
            <button id="paidDocsTab" class="tab-button">Tài liệu mới</button>
            <button id="studyingDocsTab" class="tab-button">Tài liệu đang học</button>
            <button id="freeDocsTab" class="tab-button">Tài liệu miễn phí</button>
          </div>
          <div class="search-container">
            <input type="text" id="searchInput" placeholder="Tìm kiếm tài liệu..." class="search-input">
            <i class="fa fa-search search-icon"></i>
          </div>
        </div>

        <!-- Content area -->
        <div id="contentArea" class="content-area">
          <!-- Content will be dynamically loaded here -->
        </div>

        <!-- Pagination -->
        <div class="pagination">
          <button id="prevPage" class="pagination-btn disabled">
            <i class="fa fa-chevron-left"></i>
          </button>
          <div id="pageNumbers" class="page-numbers">
            <!-- Page numbers will be dynamically generated -->
          </div>
          <button id="nextPage" class="pagination-btn">
            <i class="fa fa-chevron-right"></i>
          </button>
        </div>
      </div>

      <!-- Footer -->
      <%@include file="footer_course.jsp" %>
    </main>
  </div>

  <!-- Pass the document type and contextPath to JavaScript -->
  <%
    String docType = request.getParameter("type");
    if (docType == null || docType.isEmpty()) {
      docType = "paid"; // Default to "paid" if no parameter is provided
    }
  %>
  <script>
    // Pass the document type and contextPath to JavaScript
    const contextPath = "${pageContext.request.contextPath}";
    const initialDocType = '<%=docType%>';
  </script>
  <script src="${pageContext.request.contextPath}/assets/js/student/script.js"></script>
  <script src="${pageContext.request.contextPath}/assets/js/student/sidebar.js"></script>
  <script src="${pageContext.request.contextPath}/assets/js/student/header.js"></script>
  <script src="${pageContext.request.contextPath}/assets/js/student/footer.js"></script>
</body>
</html>