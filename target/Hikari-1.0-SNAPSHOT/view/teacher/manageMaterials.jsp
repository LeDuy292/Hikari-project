<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quản Lý Tài Liệu - Nền Tảng Giáo Dục</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/teacher_css/manageMaterials.css" />
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
                            <!-- Filter Bar, Search Bar, and Add Button -->
                            <div class="search-bar">
                                <div class="filter-bar">
                                    <button class="filter-btn active" onclick="applyFilter('all')">Tất cả tài liệu</button>
                                    <button class="filter-btn" onclick="applyFilter('mine')">Tài liệu của tôi</button>
                                </div>
                                <div class="search-input-wrapper">
                                    <i class="fas fa-search"></i>
                                    <input type="text" class="search-input" id="searchInput" placeholder="Tìm kiếm tài liệu..." onkeyup="filterMaterials()" />
                                </div>
                            </div>
                            <button class="add-material-btn" id="addMaterialBtn" onclick="showAddMaterialForm()">Thêm Tài Liệu</button>
                            <!-- Material Grid -->
                            <div class="material-grid" id="materialGrid">
                                <c:forEach var="material" items="${materialList}">
                                    <div class="material-card" data-material-id="${material.id}">
                                        <img src="${pageContext.request.contextPath}/img/materials/${material.image}" alt="${material.name}" class="material-image" />
                                        <div class="material-content">
                                            <h3 class="material-title"><c:out value="${material.name}" /></h3>
                                            <p class="material-description"><c:out value="${material.description}" /></p>
                                            <p class="material-meta"><i class="fas fa-user"></i> Cập nhật bởi: <c:out value="${material.updatedBy}" /></p>
                                            <div class="material-actions">
                                                <button class="btn btn-primary" onclick="viewMaterial('${material.url}', '${material.type}')"><i class="fas fa-eye"></i> Xem</button>
                                                <c:if test="${material.owner == sessionScope.userName}">
                                                    <button class="btn btn-accent" onclick="showUpdateMaterialForm(${material.id})"><i class="fas fa-edit"></i> Cập Nhật</button>
                                                    <button class="btn btn-danger" onclick="deleteMaterial(${material.id})"><i class="fas fa-trash"></i> Xóa</button>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                                <c:if test="${empty materialList}">
                                    <!-- Sample materials for empty state -->
                                    <div class="material-card" data-material-id="1">
                                        <img src="https://via.placeholder.com/250x150?text=Toan+Cao+Cap" alt="Tài liệu Toán Cao Cấp" class="material-image" />
                                        <div class="material-content">
                                            <h3 class="material-title">Tài liệu Toán Cao Cấp - Chương 1</h3>
                                            <p class="material-description">Tài liệu về tích phân và ứng dụng trong toán cao cấp.</p>
                                            <p class="material-meta"><i class="fas fa-user"></i> Cập nhật bởi: Nguyễn Văn A</p>
                                            <div class="material-actions">
                                                <button class="btn btn-primary" onclick="viewMaterial('/assets/files/math_ch1.pdf', 'pdf')"><i class="fas fa-eye"></i> Xem</button>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="material-card" data-material-id="2">
                                        <img src="https://via.placeholder.com/250x150?text=Link+Toan" alt="Link Toán" class="material-image" />
                                        <div class="material-content">
                                            <h3 class="material-title">Link tham khảo Toán Cao Cấp</h3>
                                            <p class="material-description">Link đến các tài liệu tham khảo toán học nâng cao.</p>
                                            <p class="material-meta"><i class="fas fa-user"></i> Cập nhật bởi: Trần Thị B</p>
                                            <div class="material-actions">
                                                <button class="btn btn-primary" onclick="viewMaterial('https://mathreference.com', 'link')"><i class="fas fa-eye"></i> Xem</button>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
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
    <!-- Modal for Add/Update Material -->
    <div class="modal fade" id="materialModal" tabindex="-1" aria-labelledby="materialModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="materialModalLabel"></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="materialForm">
                        <input type="hidden" name="_csrf" value="${_csrf.token}" />
                        <div class="mb-3">
                            <label for="materialName" class="form-label">Tên Tài Liệu</label>
                            <input type="text" class="form-control" id="materialName" name="materialName" placeholder="Nhập tên tài liệu" required />
                        </div>
                        <div class="mb-3">
                            <label for="materialDescription" class="form-label">Mô Tả</label>
                            <textarea class="form-control" id="materialDescription" name="materialDescription" placeholder="Nhập mô tả tài liệu" rows="3"></textarea>
                        </div>
                        <div class="mb-3">
                            <label for="materialImage" class="form-label">Hình Ảnh</label>
                            <input type="file" class="form-control" id="materialImage" name="materialImage" accept="image/*" />
                        </div>
                        <div class="mb-3">
                            <label for="materialType" class="form-label">Loại Tài Liệu</label>
                            <select class="form-control" id="materialType" name="materialType" required>
                                <option value="pdf">PDF</option>
                                <option value="link">Link</option>
                            </select>
                        </div>
                        <div class="mb-3" id="materialFileInput">
                            <label for="materialFile" class="form-label">Tải Lên File (PDF)</label>
                            <input type="file" class="form-control" id="materialFile" name="materialFile" accept="application/pdf" />
                        </div>
                        <div class="mb-3" id="materialLinkInput" style="display: none;">
                            <label for="materialLink" class="form-label">Link Tài Liệu</label>
                            <input type="url" class="form-control" id="materialLink" name="materialLink" placeholder="Nhập URL của tài liệu" />
                        </div>
                        <button type="submit" class="btn btn-primary">Lưu</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/teacher_js/manageMaterials.js"></script>
</body>
</html>