// JavaScript functions for modal handling
function viewCourse(courseId) {
    fetch(contextPath + '/admin/courses?action=detail&id=' + encodeURIComponent(courseId))
            .then(response => {
                if (!response.ok) {
                    throw new Error('Lỗi khi tải thông tin khóa học');
                }
                return response.json();
            })
            .then(data => {
                if (data.error) {
                    throw new Error(data.error);
                }
                document.getElementById('viewCourseID').textContent = data.courseID;
                document.getElementById('viewCourseTitle').textContent = data.title;
                document.getElementById('viewCourseDescription').textContent = data.description || 'Không có mô tả';
                document.getElementById('viewCourseFee').textContent = new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(data.fee);
                document.getElementById('viewCourseDuration').textContent = data.duration ? data.duration + ' tuần' : 'Chưa xác định';
                document.getElementById('viewCourseStartDate').textContent = data.startDate ? new Date(data.startDate).toLocaleDateString('vi-VN') : 'Chưa xác định';
                document.getElementById('viewCourseEndDate').textContent = data.endDate ? new Date(data.endDate).toLocaleDateString('vi-VN') : 'Chưa xác định';
                document.getElementById('viewCourseStatus').innerHTML = data.isActive ? '<span class="badge badge-active">Hoạt động</span>' : '<span class="badge badge-inactive">Không hoạt động</span>';

                var modal = new bootstrap.Modal(document.getElementById('viewCourseModal'));
                modal.show();
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra khi tải thông tin khóa học: ' + error.message);
            });
}

function editCourse(courseId) {
    fetch(contextPath + '/admin/courses?action=detail&id=' + encodeURIComponent(courseId))
            .then(response => {
                if (!response.ok) {
                    throw new Error('Lỗi khi tải thông tin khóa học');
                }
                return response.json();
            })
            .then(data => {
                if (data.error) {
                    throw new Error(data.error);
                }
                document.getElementById('editCourseID').value = data.courseID;
                document.getElementById('editTitle').value = data.title;
                document.getElementById('editDescription').value = data.description || '';
                document.getElementById('editFee').value = data.fee || '';
                document.getElementById('editDuration').value = data.duration || '';
                document.getElementById('editStartDate').value = data.startDate || '';
                document.getElementById('editEndDate').value = data.endDate || '';
                document.getElementById('editIsActive').value = data.isActive.toString();
                document.getElementById('editImageUrl').value = data.imageUrl || '';

                var modal = new bootstrap.Modal(document.getElementById('editCourseModal'));
                modal.show();
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra khi tải thông tin khóa học: ' + error.message);
            });
}

function blockCourse(courseId, title, isActive) {
    document.getElementById('blockCourseTitle').textContent = title;
    document.getElementById('blockCourseId').textContent = courseId;
    document.getElementById('blockCourseIdInput').value = courseId;
    document.getElementById('blockCourseStatusInput').value = isActive ? 'false' : 'true';
    document.getElementById('blockCourseAction').textContent = isActive ? 'khóa' : 'mở khóa';

    const confirmBtn = document.querySelector('#blockCourseModal .btn-confirm-delete');
    if (confirmBtn) {
        confirmBtn.innerHTML = isActive ? '<i class="fas fa-lock"></i> Khóa' : '<i class="fas fa-unlock"></i> Mở Khóa';
    }

    var modal = new bootstrap.Modal(document.getElementById('blockCourseModal'));
    modal.show();
}

// Form validation and submission handling
document.addEventListener('DOMContentLoaded', function () {
    // Auto-dismiss alerts
    const alerts = document.querySelectorAll(".alert");
    alerts.forEach((alert) => {
        setTimeout(() => {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        }, 5000);
    });

    // Validate Edit Course Form
    const editForm = document.getElementById('editCourseForm');
    editForm.addEventListener('submit', function (e) {
        let isValid = true;
        const title = document.getElementById('editTitle');
        const fee = document.getElementById('editFee');
        const duration = document.getElementById('editDuration');
        const startDate = document.getElementById('editStartDate');
        const endDate = document.getElementById('editEndDate');
        const imageUrl = document.getElementById('editImageUrl');

        // Reset validation states
        [title, fee, duration, startDate, endDate, imageUrl].forEach(field => {
            field.classList.remove('is-invalid');
        });

        // Title validation
        if (!title.value.trim()) {
            title.classList.add('is-invalid');
            isValid = false;
        }

        // Fee validation
        if (fee.value && fee.value < 0) {
            fee.classList.add('is-invalid');
            isValid = false;
        }

        // Duration validation
        if (duration.value && duration.value < 1) {
            duration.classList.add('is-invalid');
            isValid = false;
        }

        // Date validation
        if (startDate.value && endDate.value && new Date(endDate.value) <= new Date(startDate.value)) {
            endDate.classList.add('is-invalid');
            isValid = false;
        }

        // Image URL validation
        if (imageUrl.value && !isValidUrl(imageUrl.value)) {
            imageUrl.classList.add('is-invalid');
            isValid = false;
        }

        if (!isValid) {
            e.preventDefault();
            alert('Vui lòng kiểm tra và sửa các lỗi trong biểu mẫu.');
        }
    });

    // Validate Add Course Form
    const addForm = document.getElementById('addCourseForm');
    addForm.addEventListener('submit', function (e) {
        let isValid = true;
        const courseID = document.getElementById('courseID');
        const title = document.getElementById('title');
        const fee = document.getElementById('fee');
        const duration = document.getElementById('duration');
        const startDate = document.getElementById('startDate');
        const endDate = document.getElementById('endDate');
        const imageUrl = document.getElementById('imageUrl');

        // Reset validation states
        [courseID, title, fee, duration, startDate, endDate, imageUrl].forEach(field => {
            field.classList.remove('is-invalid');
        });

        // Course ID validation
        if (!courseID.value.match(/^CO[0-9]{3}$/)) {
            courseID.classList.add('is-invalid');
            isValid = false;
        }

        // Title validation
        if (!title.value.trim()) {
            title.classList.add('is-invalid');
            isValid = false;
        }

        // Fee validation
        if (fee.value && fee.value < 0) {
            fee.classList.add('is-invalid');
            isValid = false;
        }

        // Duration validation
        if (duration.value && duration.value < 1) {
            duration.classList.add('is-invalid');
            isValid = false;
        }

        // Date validation
        if (startDate.value && endDate.value && new Date(endDate.value) <= new Date(startDate.value)) {
            endDate.classList.add('is-invalid');
            isValid = false;
        }

        // Image URL validation
        if (imageUrl.value && !isValidUrl(imageUrl.value)) {
            imageUrl.classList.add('is-invalid');
            isValid = false;
        }

        if (!isValid) {
            e.preventDefault();
            alert('Vui lòng kiểm tra và sửa các lỗi trong biểu mẫu.');
        }
    });

    // URL validation helper
    function isValidUrl(string) {
        try {
            new URL(string);
            return true;
        } catch (_) {
            return false;
        }
    }
});