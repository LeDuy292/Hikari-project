<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Lớp Học - ${currentCourse.title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .class-card {
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            margin-bottom: 20px;
            padding: 20px;
            background: #fff;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            transition: box-shadow 0.3s ease;
        }
        .class-card:hover {
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }
        .class-header {
            display: flex;
            justify-content: between;
            align-items: center;
            margin-bottom: 15px;
            border-bottom: 1px solid #f0f0f0;
            padding-bottom: 10px;
        }
        .class-name {
            color: #2c3e50;
            margin: 0;
            font-size: 1.25rem;
            font-weight: 600;
        }
        .class-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }
        .info-item {
            display: flex;
            align-items: center;
        }
        .info-icon {
            width: 40px;
            height: 40px;
            background: #f8f9fa;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 12px;
            color: #6c757d;
        }
        .info-content {
            flex: 1;
        }
        .info-label {
            display: block;
            font-size: 0.875rem;
            color: #6c757d;
            margin-bottom: 2px;
        }
        .info-value {
            display: block;
            font-weight: 500;
            color: #2c3e50;
        }
        .class-actions {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
        }
        .page-header {
            background: linear-gradient(90deg,  #4a90e2, #f39c12);
            color: white;
            padding: 30px;
            border-radius: 10px;
            margin-bottom: 30px;
        }
        .page-title {
            margin: 0;
            font-size: 2rem;
            font-weight: 600;
        }
        .page-subtitle {
            margin: 5px 0 0 0;
            opacity: 0.9;
        }
        .alert-custom {
            border-radius: 8px;
            border: none;
            padding: 15px 20px;
        }
        .modal-header {
            background: #f8f9fa;
            border-bottom: 1px solid #dee2e6;
        }
        .btn-group .btn {
            margin-right: 5px;
        }
        .btn-group .btn:last-child {
            margin-right: 0;
        }
    </style>
</head>
<body>
    <div class="container-fluid py-4">
        <!-- Page Header -->
        <div class="page-header">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1 class="page-title">Quản Lý Lớp Học</h1>
                    <p class="page-subtitle">Khóa học: ${currentCourse.title}</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/LoadCourse" class="btn btn-light me-2">
                        <i class="fas fa-arrow-left"></i> Quay lại
                    </a>
                    <button type="button" class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#addClassModal">
                        <i class="fas fa-plus"></i> Thêm Lớp Học
                    </button>
                </div>
            </div>
        </div>

        <!-- Success/Error Messages -->
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success alert-custom alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>
                ${sessionScope.successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="successMessage" scope="session" />
        </c:if>

        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger alert-custom alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>
                ${sessionScope.errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="errorMessage" scope="session" />
        </c:if>

        <!-- Class List -->
        <div class="row">
            <div class="col-12">
                <c:choose>
                    <c:when test="${not empty classList}">
                        <c:forEach var="classInfo" items="${classList}">
                            <div class="class-card">
                                <div class="class-header">
                                    <h3 class="class-name">${classInfo.name}</h3>
                                    <span class="badge bg-primary">${classInfo.classID}</span>
                                </div>
                                <div class="class-info">
                                    <div class="info-item">
                                        <span class="info-icon">
                                            <i class="fas fa-chalkboard-teacher"></i>
                                        </span>
                                        <div class="info-content">
                                            <span class="info-label">Giảng viên</span>
                                            <span class="info-value">
                                                ${not empty classInfo.teacherName ? classInfo.teacherName : 'Chưa phân công'}
                                            </span>
                                        </div>
                                    </div>
                                    <div class="info-item">
                                        <span class="info-icon">
                                            <i class="fas fa-users"></i>
                                        </span>
                                        <div class="info-content">
                                            <span class="info-label">Số học viên</span>
                                            <span class="info-value">${classInfo.numberOfStudents} học viên</span>
                                        </div>
                                    </div>
                                    <div class="info-item">
                                        <span class="info-icon">
                                            <i class="fas fa-id-badge"></i>
                                        </span>
                                        <div class="info-content">
                                            <span class="info-label">Mã giảng viên</span>
                                            <span class="info-value">
                                                ${not empty classInfo.teacherID ? classInfo.teacherID : 'N/A'}
                                            </span>
                                        </div>
                                    </div>
                                </div>
                                <div class="class-actions">
                                    <button type="button" class="btn btn-outline-warning btn-sm" 
                                            onclick="openEditModal('${classInfo.classID}', '${classInfo.name}', '${classInfo.teacherID}')">
                                        <i class="fas fa-edit"></i> Sửa
                                    </button>
                                    <button type="button" class="btn btn-outline-danger btn-sm" 
                                            onclick="confirmDelete('${classInfo.classID}', '${classInfo.name}', ${classInfo.numberOfStudents})">
                                        <i class="fas fa-trash"></i> Xóa
                                    </button>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-info alert-custom text-center">
                            <i class="fas fa-info-circle me-2"></i>
                            Chưa có lớp học nào trong khóa học này. Hãy thêm lớp học đầu tiên!
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- Add Class Modal -->
    <div class="modal fade" id="addClassModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-plus me-2"></i>Thêm Lớp Học Mới
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="ManageClass" method="post" onsubmit="return validateAddForm()">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="courseID" value="${courseID}">
                        
                        <div class="mb-3">
                            <label for="addClassID" class="form-label">Mã lớp <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="addClassID" name="classID" 
                                   value="${newClassID}" readonly>
                            <div class="form-text">Mã lớp được tự động tạo</div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="addClassName" class="form-label">Tên lớp <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="addClassName" name="className" 
                                   placeholder="Nhập tên lớp học" required maxlength="100">
                            <div class="invalid-feedback">Vui lòng nhập tên lớp học</div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="addTeacherID" class="form-label">Giảng viên <span class="text-danger">*</span></label>
                            <select class="form-select" id="addTeacherID" name="teacherID" required>
                                <option value="">-- Chọn giảng viên --</option>
                                <c:forEach var="teacher" items="${teacherList}">
                                    <option value="${teacher.teacherID}">
                                        ${teacher.fullName} (${teacher.teacherID})
                                    </option>
                                </c:forEach>
                            </select>
                            <div class="invalid-feedback">Vui lòng chọn giảng viên</div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="addNumberOfStudents" class="form-label">Số lượng học viên</label>
                            <input type="number" class="form-control" id="addNumberOfStudents" 
                                   name="numberOfStudents" value="0" min="0" readonly>
                            <div class="form-text">Số lượng học viên sẽ tự động cập nhật khi có học viên đăng ký</div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save me-2"></i>Thêm Lớp Học
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Edit Class Modal -->
    <div class="modal fade" id="editClassModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-edit me-2"></i>Sửa Thông Tin Lớp Học
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="ManageClass" method="post" onsubmit="return validateEditForm()">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="courseID" value="${courseID}">
                        <input type="hidden" name="classID" id="editClassID">
                        
                        <div class="mb-3">
                            <label for="editClassIDDisplay" class="form-label">Mã lớp</label>
                            <input type="text" class="form-control" id="editClassIDDisplay" readonly>
                            <div class="form-text">Mã lớp không thể thay đổi</div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="editClassName" class="form-label">Tên lớp <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="editClassName" name="className" 
                                   placeholder="Nhập tên lớp học" required maxlength="100">
                            <div class="invalid-feedback">Vui lòng nhập tên lớp học</div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="editTeacherID" class="form-label">Giảng viên <span class="text-danger">*</span></label>
                            <select class="form-select" id="editTeacherID" name="teacherID" required>
                                <option value="">-- Chọn giảng viên --</option>
                                <c:forEach var="teacher" items="${teacherList}">
                                    <option value="${teacher.teacherID}">
                                        ${teacher.fullName} (${teacher.teacherID})
                                    </option>
                                </c:forEach>
                            </select>
                            <div class="invalid-feedback">Vui lòng chọn giảng viên</div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-warning">
                            <i class="fas fa-save me-2"></i>Cập Nhật
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteClassModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title">
                        <i class="fas fa-exclamation-triangle me-2"></i>Xác Nhận Xóa Lớp Học
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="text-center">
                        <i class="fas fa-exclamation-triangle text-danger" style="font-size: 3rem;"></i>
                        <h4 class="mt-3">Bạn có chắc chắn muốn xóa lớp học này?</h4>
                        <p class="text-muted" id="deleteClassInfo"></p>
                        <div class="alert alert-warning" id="deleteWarning" style="display: none;">
                            <i class="fas fa-exclamation-circle me-2"></i>
                            <strong>Cảnh báo:</strong> Lớp học này có học viên đăng ký. Việc xóa sẽ ảnh hưởng đến các học viên.
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <form action="ManageClass" method="post" style="display: inline;">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="courseID" value="${courseID}">
                        <input type="hidden" name="classID" id="deleteClassID">
                        <button type="submit" class="btn btn-danger">
                            <i class="fas fa-trash me-2"></i>Xóa Lớp Học
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Validation functions
        function validateAddForm() {
            const className = document.getElementById('addClassName').value.trim();
            const teacherID = document.getElementById('addTeacherID').value;
            
            if (!className) {
                alert('Vui lòng nhập tên lớp học');
                return false;
            }
            
            if (!teacherID) {
                alert('Vui lòng chọn giảng viên');
                return false;
            }
            
            return true;
        }
        
        function validateEditForm() {
            const className = document.getElementById('editClassName').value.trim();
            const teacherID = document.getElementById('editTeacherID').value;
            
            if (!className) {
                alert('Vui lòng nhập tên lớp học');
                return false;
            }
            
            if (!teacherID) {
                alert('Vui lòng chọn giảng viên');
                return false;
            }
            
            return true;
        }
        
        // Modal functions
        function openEditModal(classID, className, teacherID) {
            document.getElementById('editClassID').value = classID;
            document.getElementById('editClassIDDisplay').value = classID;
            document.getElementById('editClassName').value = className;
            document.getElementById('editTeacherID').value = teacherID;
            
            const editModal = new bootstrap.Modal(document.getElementById('editClassModal'));
            editModal.show();
        }
        
        function confirmDelete(classID, className, numberOfStudents) {
            document.getElementById('deleteClassID').value = classID;
            document.getElementById('deleteClassInfo').innerHTML = 
                '<strong>Lớp học:</strong> ' + className + '<br>' +
                '<strong>Mã lớp:</strong> ' + classID + '<br>' +
                '<strong>Số học viên:</strong> ' + numberOfStudents;
            
            const warningDiv = document.getElementById('deleteWarning');
            if (numberOfStudents > 0) {
                warningDiv.style.display = 'block';
            } else {
                warningDiv.style.display = 'none';
            }
            
            const deleteModal = new bootstrap.Modal(document.getElementById('deleteClassModal'));
            deleteModal.show();
        }
        
        // Auto-hide alerts after 5 seconds
        document.addEventListener('DOMContentLoaded', function() {
            const alerts = document.querySelectorAll('.alert-dismissible');
            alerts.forEach(function(alert) {
                setTimeout(function() {
                    const bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                }, 5000);
            });
        });
    </script>
</body>
</html>
