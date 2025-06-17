<%@page import="model.Course"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chỉnh sửa khóa học</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f4f4f9;
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
                margin: 0;
                padding: 20px;
            }

            .course-form {
                background-color: #ffffff;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                width: 100%;
                max-width: 500px;
            }

            .form-group {
                margin-bottom: 20px;
            }

            .form-label {
                display: block;
                font-weight: bold;
                margin-bottom: 8px;
                color: #333;
            }

            .form-input,
            .form-textarea,
            .form-select {
                width: 100%;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 5px;
                font-size: 16px;
                box-sizing: border-box;
            }

            .form-textarea {
                height: 100px;
                resize: vertical;
            }

            .form-input:focus,
            .form-textarea:focus,
            .form-select:focus {
                outline: none;
                border-color: #4a90e2;
                box-shadow: 0 0 5px rgba(74, 144, 226, 0.3);
            }

            .submit-button {
                background-color: #4a90e2;
                color: white;
                padding: 12px 20px;
                border: none;
                border-radius: 5px;
                font-size: 16px;
                cursor: pointer;
                width: 100%;
                transition: background-color 0.3s;
            }

            .submit-button:hover {
                background-color: #357abd;
            }

            .error-message {
                color: #d9534f;
                font-size: 14px;
                margin-top: 5px;
                display: none;
            }

            @media (max-width: 600px) {
                .course-form {
                    padding: 20px;
                }
            }
        </style>
    </head>
    <body>
        <form action="EditCourse" method="get" class="course-form">
            <input type="hidden" name="courseNum" value="${course.courseNum}">
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
                <button type="submit" class="submit-button">Cập nhật khóa học</button>
            </div>
        </form>

        <script>
            // Basic client-side validation
            const form = document.querySelector('.course-form');
            form.addEventListener('submit', (e) => {
                let isValid = true;
                const title = document.getElementById('title').value.trim();
                const description = document.getElementById('description').value.trim();
                const fee = parseFloat(document.getElementById('fee').value);
                const duration = parseInt(document.getElementById('duration').value);
                const startDate = document.getElementById('startDate').value;
                const endDate = document.getElementById('endDate').value;

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

                if (!isValid) {
                    e.preventDefault();
                }
            });
        </script>
    </body>
</html>