<%@page import="model.Course"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chỉnh sửa khóa học</title>
        <style>
            /* Thay đổi: Sử dụng CSS từ course-monitoring.jsp để đồng bộ giao diện */
            .modal-overlay {
                display: flex; /* Thay đổi: Hiển thị mặc định vì đây là form chính, không phải modal ẩn */
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.5);
                z-index: 1000;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
                overflow: auto;
            }

            .form-container {
                background-color: #ffffff;
                margin: 5% auto;
                padding: 30px;
                border-radius: 16px;
                width: 100%;
                max-width: 600px;
                position: relative;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
                z-index: 1001;
            }

            .close-button {
                position: absolute;
                top: 15px;
                right: 20px;
                cursor: pointer;
                font-size: 24px;
                color: #333;
                transition: color 0.3s;
                z-index: 1002;
            }

            .close-button:hover {
                color: #ff0000;
            }

            .form-title {
                font-size: 24px;
                font-weight: 600;
                margin-bottom: 20px;
                color: #333;
                text-align: center;
            }

            .form-group {
                margin-bottom: 20px;
            }

            .form-label {
                display: block;
                font-weight: 500;
                margin-bottom: 8px;
                color: #333;
            }

            .form-input, .form-textarea, .form-select {
                width: 100%;
                padding: 12px;
                border: 1px solid #dfe1e5;
                border-radius: 12px;
                font-size: 14px;
                color: #333;
                background-color: #fafafa;
                transition: border-color 0.3s, box-shadow 0.3s;
                box-sizing: border-box;
            }

            .form-textarea {
                height: 100px;
                resize: vertical;
            }

            .form-input:focus, .form-textarea:focus, .form-select:focus {
                border-color: #007bff;
                box-shadow: 0 0 5px rgba(0, 123, 255, 0.3);
                outline: none;
            }

            .submit-button {
                width: 100%;
                padding: 12px;
                background-color: #007bff;
                color: white;
                border: none;
                border-radius: 12px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: background-color 0.3s, transform 0.2s;
            }

            .submit-button:hover {
                background-color: #0056b3;
                transform: translateY(-2px);
            }

            .submit-button:active {
                transform: translateY(0);
            }

            .error-message {
                color: #d9534f;
                font-size: 14px;
                margin-top: 5px;
                display: none;
            }

            .image-preview img {
                max-width: 200px;
                border-radius: 12px;
                margin-top: 10px;
                display: block;
            }

            @media (max-width: 480px) {
                .form-container {
                    padding: 20px;
                    max-width: 90%;
                }
            }
        </style>
    </head>
    <body>
      <!-- Thay đổi: Bọc form trong modal-overlay và form-container giống course-monitoring.jsp -->
        <div class="modal-overlay">
            <div class="form-container">
                <!-- Thay đổi: Thêm nút đóng và tiêu đề form -->
                <span onclick="window.history.back()" class="close-button">×</span>
                <h2 class="form-title">Chỉnh sửa khóa học</h2>
                <form action="EditCourse" method="post" class="course-form" enctype="multipart/form-data">
                    <input type="hidden" name="courseNum" value="${course.courseID}">
                    <div class="form-group">
                        <label for="title" class="form-label">Tên khóa học:</label>
                        <input type="text" id="title" name="title" class="form-input" value="${course.title}" required>
                        <span class="error-message" id="title-error"></span>
                    </div>
                    <div class="form-group">
                        <label for="description" class="form-label">Mô tả:</label>
                        <textarea id="description" name="description" class="form-textarea" required>${course.description}</textarea>
                        <span class="error-message" id="description-error"></span>
                    </div>
                    <div class="form-group">
                        <label for="fee" class="form-label">Học phí:</label>
                        <input type="number" step="0.01" id="fee" name="fee" class="form-input" value="${course.fee}" required>
                        <span class="error-message" id="fee-error"></span>
                    </div>
                    <div class="form-group">
                        <label for="duration" class="form-label">Thời lượng (giờ):</label>
                        <input type="number" id="duration" name="duration" class="form-input" value="${course.duration}" required>
                        <span class="error-message" id="duration-error"></span>
                    </div>
                    <div class="form-group">
                        <label for="startDate" class="form-label">Ngày bắt đầu:</label>
                        <input type="date" id="startDate" name="startDate" class="form-input" value="${course.startDate}" required>
                        <span class="error-message" id="startDate-error"></span>
                    </div>
                    <div class="form-group">
                        <label for="endDate" class="form-label">Ngày kết thúc:</label>
                        <input type="date" id="endDate" name="endDate" class="form-input" value="${course.endDate}" required>
                        <span class="error-message" id="endDate-error"></span>
                    </div>
                    <div class="form-group">
                        <label for="isActive" class="form-label">Hoạt động:</label>
                        <select id="isActive" name="isActive" class="form-select" required>
                            <option value="true" ${course.isActive ? 'selected' : ''}>Có</option>
                            <option value="false" ${!course.isActive ? 'selected' : ''}>Không</option>
                        </select>
                        <span class="error-message" id="isActive-error"></span>
                    </div>
                    <div class="form-group">
                        <!-- Thay đổi: Đồng bộ input file và preview ảnh với course-monitoring.jsp -->
                        <label for="imageUrl" class="form-label">Ảnh khóa học:</label>
                        <input type="file" id="imageUrl" name="imageUrl" class="form-input" accept="image/png,image/jpeg,image/jpg">
                        <span class="error-message" id="imageUrl-error"></span>
                        <div class="image-preview">
                            <img id="imagePreview" src="${not empty course.imageUrl ? course.imageUrl : ''}" alt="Course Image Preview" style="display: ${not empty course.imageUrl ? 'block' : 'none'};">
                        </div>
                    </div>
                    <div class="form-group">
                        <button type="submit" class="submit-button">Cập nhật khóa học</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Thay đổi: Thêm Bootstrap JS từ CDN -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            // Thay đổi: Đồng bộ JavaScript validation và preview ảnh với course-monitoring.jsp
            const form = document.querySelector('.course-form');
            form.addEventListener('submit', (e) => {
                let isValid = true;
                const title = document.getElementById('title').value.trim();
                const description = document.getElementById('description').value.trim();
                const fee = parseFloat(document.getElementById('fee').value);
                const duration = parseInt(document.getElementById('duration').value);
                const startDate = document.getElementById('startDate').value;
                const endDate = document.getElementById('endDate').value;
                const imageUrl = document.getElementById('imageUrl').files[0];

                // Reset error messages
                document.querySelectorAll('.error-message').forEach(el => el.style.display = 'none');

                if (!title) {
                    document.getElementById('title-error').textContent = 'Vui lòng nhập tên khóa học';
                    document.getElementById('title-error').style.display = 'block';
                    isValid = false;
                }
                if (!description) {
                    document.getElementById('description-error').textContent = 'Vui lòng nhập mô tả';
                    document.getElementById('description-error').style.display = 'block';
                    isValid = false;
                }
                if (isNaN(fee) || fee <= 0) {
                    document.getElementById('fee-error').textContent = 'Học phí phải lớn hơn 0';
                    document.getElementById('fee-error').style.display = 'block';
                    isValid = false;
                }
                if (isNaN(duration) || duration <= 0) {
                    document.getElementById('duration-error').textContent = 'Thời lượng phải lớn hơn 0';
                    document.getElementById('duration-error').style.display = 'block';
                    isValid = false;
                }
                if (!startDate) {
                    document.getElementById('startDate-error').textContent = 'Vui lòng chọn ngày bắt đầu';
                    document.getElementById('startDate-error').style.display = 'block';
                    isValid = false;
                }
                if (!endDate) {
                    document.getElementById('endDate-error').textContent = 'Vui lòng chọn ngày kết thúc';
                    document.getElementById('endDate-error').style.display = 'block';
                    isValid = false;
                } else if (startDate && endDate && new Date(startDate) > new Date(endDate)) {
                    document.getElementById('endDate-error').textContent = 'Ngày kết thúc phải sau ngày bắt đầu';
                    document.getElementById('endDate-error').style.display = 'block';
                    isValid = false;
                }
                if (imageUrl) {
                    const validTypes = ['image/png', 'image/jpeg', 'image/jpg'];
                    if (!validTypes.includes(imageUrl.type)) {
                        document.getElementById('imageUrl-error').textContent = 'Vui lòng chọn file ảnh (PNG, JPG, JPEG)';
                        document.getElementById('imageUrl-error').style.display = 'block';
                        isValid = false;
                    }
                    if (imageUrl.size > 5 * 1024 * 1024) {
                        document.getElementById('imageUrl-error').textContent = 'Kích thước ảnh không được vượt quá 5MB';
                        document.getElementById('imageUrl-error').style.display = 'block';
                        isValid = false;
                    }
                }

                if (!isValid) {
                    e.preventDefault();
                }
            });

            // Image preview
            document.getElementById('imageUrl').addEventListener('change', function (event) {
                const file = event.target.files[0];
                const preview = document.getElementById('imagePreview');
                const error = document.getElementById('imageUrl-error');

                if (file) {
                    const validTypes = ['image/png', 'image/jpeg', 'image/jpg'];
                    if (!validTypes.includes(file.type)) {
                        error.textContent = 'Vui lòng chọn file ảnh (PNG, JPG, JPEG)';
                        error.style.display = 'block';
                        this.value = '';
                        preview.style.display = 'none';
                        return;
                    }
                    if (file.size > 5 * 1024 * 1024) {
                        error.textContent = 'Kích thước ảnh không được vượt quá 5MB';
                        error.style.display = 'block';
                        this.value = '';
                        preview.style.display = 'none';
                        return;
                    }

                    const reader = new FileReader();
                    reader.onload = function (e) {
                        preview.src = e.target.result;
                        preview.style.display = 'block';
                    };
                    reader.readAsDataURL(file);
                    error.textContent = '';
                    error.style.display = 'none';
                } else {
                    preview.style.display = 'none';
                }
            });
        </script>
    </body>
</html>