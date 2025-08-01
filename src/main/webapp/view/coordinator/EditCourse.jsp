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

            .course-id-display {
                background-color: #e9ecef;
                color: #495057;
                font-weight: 600;
                cursor: not-allowed;
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
                <!-- Thay đổi: Cập nhật action để sử dụng EditCourseNew servlet -->
                <form action="EditCourse" method="post" class="course-form" enctype="multipart/form-data">
                    <input type="hidden" name="courseNum" value="${course.courseID}">
                    
                    <!-- Thay đổi: Hiển thị CourseID như một trường chỉ đọc -->
                    <div class="form-group">
                        <label for="courseIDDisplay" class="form-label">Mã khóa học:</label>
                        <input type="text" id="courseIDDisplay" name="courseIDDisplay" class="form-input course-id-display" value="${course.courseID}" readonly>
                    </div>
                    
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
                    
                    <!-- Thay đổi: Loại bỏ các trường startDate và endDate -->
                    <!-- 
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
                    -->
                    
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
            // Thay đổi: Cập nhật JavaScript validation - loại bỏ validation cho startDate và endDate
            const form = document.querySelector('.course-form');
            form.addEventListener('submit', (e) => {
                let isValid = true;
                const title = document.getElementById('title').value.trim();
                const description = document.getElementById('description').value.trim();
                const fee = parseFloat(document.getElementById('fee').value);
                const duration = parseInt(document.getElementById('duration').value);
                const imageUrl = document.getElementById('imageUrl').files[0];

                // Reset error messages
                document.querySelectorAll('.error-message').forEach(el => el.style.display = 'none');

                // Validation cho title
                if (!title) {
                    document.getElementById('title-error').textContent = 'Vui lòng nhập tên khóa học';
                    document.getElementById('title-error').style.display = 'block';
                    isValid = false;
                } else if (title.length < 3) {
                    document.getElementById('title-error').textContent = 'Tên khóa học phải có ít nhất 3 ký tự';
                    document.getElementById('title-error').style.display = 'block';
                    isValid = false;
                } else if (title.length > 200) {
                    document.getElementById('title-error').textContent = 'Tên khóa học không được vượt quá 200 ký tự';
                    document.getElementById('title-error').style.display = 'block';
                    isValid = false;
                }

                // Validation cho description
                if (!description) {
                    document.getElementById('description-error').textContent = 'Vui lòng nhập mô tả';
                    document.getElementById('description-error').style.display = 'block';
                    isValid = false;
                } else if (description.length < 10) {
                    document.getElementById('description-error').textContent = 'Mô tả phải có ít nhất 10 ký tự';
                    document.getElementById('description-error').style.display = 'block';
                    isValid = false;
                } else if (description.length > 1000) {
                    document.getElementById('description-error').textContent = 'Mô tả không được vượt quá 1000 ký tự';
                    document.getElementById('description-error').style.display = 'block';
                    isValid = false;
                }

                // Validation cho fee
                if (isNaN(fee) || fee <= 0) {
                    document.getElementById('fee-error').textContent = 'Học phí phải lớn hơn 0';
                    document.getElementById('fee-error').style.display = 'block';
                    isValid = false;
                } else if (fee > 999999999) {
                    document.getElementById('fee-error').textContent = 'Học phí không được vượt quá 999,999,999 VND';
                    document.getElementById('fee-error').style.display = 'block';
                    isValid = false;
                }

                // Validation cho duration
                if (isNaN(duration) || duration <= 0) {
                    document.getElementById('duration-error').textContent = 'Thời lượng phải lớn hơn 0';
                    document.getElementById('duration-error').style.display = 'block';
                    isValid = false;
                } else if (duration > 10000) {
                    document.getElementById('duration-error').textContent = 'Thời lượng không được vượt quá 10,000 giờ';
                    document.getElementById('duration-error').style.display = 'block';
                    isValid = false;
                }

                // Thay đổi: Loại bỏ validation cho startDate và endDate
                /*
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
                */

                // Validation cho image file
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

            // Image preview functionality
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

            // Thay đổi: Thêm hiệu ứng hover cho CourseID field
            document.getElementById('courseIDDisplay').addEventListener('mouseenter', function() {
                this.title = 'Mã khóa học không thể thay đổi';
            });

            // Thay đổi: Thêm confirmation khi submit form
            form.addEventListener('submit', function(e) {
                if (this.checkValidity()) {
                    const confirmUpdate = confirm('Bạn có chắc chắn muốn cập nhật thông tin khóa học này không?');
                    if (!confirmUpdate) {
                        e.preventDefault();
                    }
                }
            });

            // Thay đổi: Thêm auto-save draft functionality (optional)
            let autoSaveTimer;
            const formInputs = document.querySelectorAll('.form-input, .form-textarea, .form-select');
            
            formInputs.forEach(input => {
                input.addEventListener('input', function() {
                    clearTimeout(autoSaveTimer);
                    autoSaveTimer = setTimeout(() => {
                        // Save form data to localStorage
                        const formData = {};
                        formInputs.forEach(field => {
                            if (field.type !== 'file') {
                                formData[field.name] = field.value;
                            }
                        });
                        localStorage.setItem('editCourseForm_' + document.querySelector('input[name="courseNum"]').value, JSON.stringify(formData));
                    }, 2000); // Auto-save after 2 seconds of inactivity
                });
            });

            // Thay đổi: Load saved draft on page load
            window.addEventListener('load', function() {
                const courseID = document.querySelector('input[name="courseNum"]').value;
                const savedData = localStorage.getItem('editCourseForm_' + courseID);
                
                if (savedData) {
                    const formData = JSON.parse(savedData);
                    Object.keys(formData).forEach(key => {
                        const field = document.querySelector(`[name="${key}"]`);
                        if (field && field.type !== 'file') {
                            field.value = formData[key];
                        }
                    });
                }
            });

            // Thay đổi: Clear saved draft on successful form submission
            form.addEventListener('submit', function() {
                const courseID = document.querySelector('input[name="courseNum"]').value;
                localStorage.removeItem('editCourseForm_' + courseID);
            });
        </script>
    </body>
</html>