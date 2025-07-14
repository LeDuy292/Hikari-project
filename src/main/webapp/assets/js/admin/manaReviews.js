// manaReviews.js
document.addEventListener('DOMContentLoaded', function () {
    // Auto-dismiss alerts after 5 seconds
    const alerts = document.querySelectorAll(".alert");
    alerts.forEach((alert) => {
        setTimeout(() => {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        }, 5000);
    });

    // Form validation for Edit Review Form
    const editForm = document.querySelector("#editReviewForm");
    if (editForm) {
        editForm.addEventListener("submit", (e) => {
            let isValid = true;
            const rating = editForm.querySelector('select[name="rating"]');
            const reviewText = editForm.querySelector('textarea[name="reviewText"]');

            // Reset validation states
            [rating, reviewText].forEach(field => {
                field.classList.remove('is-invalid');
            });

            // Rating validation
            if (!rating.value.trim()) {
                rating.classList.add('is-invalid');
                isValid = false;
            }

            // Review text validation
            if (!reviewText.value.trim()) {
                reviewText.classList.add('is-invalid');
                isValid = false;
            }

            if (!isValid) {
                e.preventDefault();
                alert('Vui lòng điền đầy đủ thông tin bắt buộc.');
            }
        });
    }

    // Character count for review text textarea
    const reviewTextareas = document.querySelectorAll('textarea[name="reviewText"]');
    reviewTextareas.forEach((textarea) => {
        const maxLength = 1000;
        const counter = textarea.nextElementSibling;
        function updateCounter() {
            const remaining = maxLength - textarea.value.length;
            counter.textContent = `${textarea.value.length}/${maxLength} ký tự`;
            if (remaining < 50) {
                counter.className = "text-warning";
            } else if (remaining < 0) {
                counter.className = "text-danger";
            } else {
                counter.className = "text-muted";
            }
        }
        textarea.addEventListener("input", updateCounter);
        updateCounter(); // Initial count
    });

    // Auto-resize textareas
    const textareas = document.querySelectorAll("textarea");
    textareas.forEach((textarea) => {
        textarea.addEventListener("input", function () {
            this.style.height = "auto";
            this.style.height = this.scrollHeight + "px";
        });
    });

    // Modal cleanup
    document.addEventListener("hidden.bs.modal", (event) => {
        const backdrops = document.querySelectorAll(".modal-backdrop");
        backdrops.forEach((backdrop) => backdrop.remove());
        document.body.classList.remove("modal-open");
        document.body.style.paddingRight = "";
        document.body.style.overflow = "";
        // Reset form validation states
        const form = event.target.querySelector('form');
        if (form) {
            form.querySelectorAll('.is-invalid').forEach(field => field.classList.remove('is-invalid'));
        }
    });

    // Focus on first input in modal
    document.addEventListener("shown.bs.modal", (event) => {
        const modal = event.target;
        const firstInput = modal.querySelector('input:not([type="hidden"]), textarea, select');
        if (firstInput) {
            setTimeout(() => firstInput.focus(), 100);
        }
    });
});

function viewReview(id) {
    fetch(contextPath + '/admin/reviews?action=view&id=' + id)
        .then(response => {
            if (!response.ok) {
                throw new Error('Lỗi khi tải thông tin đánh giá');
            }
            return response.json();
        })
        .then(data => {
            if (data.error) {
                throw new Error(data.error);
            }
            document.getElementById('viewReviewId').textContent = 'REV' + String(data.id).padStart(3, '0');
            document.getElementById('viewReviewer').textContent = data.reviewerName;
            document.getElementById('viewCourse').textContent = data.courseName;
            document.getElementById('viewRating').innerHTML = generateStars(data.rating) + ' (' + data.rating + ')';
            document.getElementById('viewStatus').textContent = data.status === 'active' ? 'Hoạt Động' : 'Bị Chặn';
            document.getElementById('viewReviewDate').textContent = formatDate(data.reviewDate);
            document.getElementById('viewReviewText').textContent = data.reviewText;

            var modal = new bootstrap.Modal(document.getElementById('viewReviewModal'));
            modal.show();
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Có lỗi xảy ra khi tải thông tin đánh giá: ' + error.message);
        });
}

function editReview(id) {
    fetch(contextPath + '/admin/reviews?action=view&id=' + id)
        .then(response => {
            if (!response.ok) {
                throw new Error('Lỗi khi tải thông tin đánh giá');
            }
            return response.json();
        })
        .then(data => {
            if (data.error) {
                throw new Error(data.error);
            }
            document.getElementById('editReviewId').value = data.id;
            document.getElementById('editRating').value = data.rating;
            document.getElementById('editReviewText').value = data.reviewText;

            var modal = new bootstrap.Modal(document.getElementById('editReviewModal'));
            modal.show();

            // Update character counter for editReviewText
            const editReviewText = document.getElementById('editReviewText');
            editReviewText.dispatchEvent(new Event('input'));
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Có lỗi xảy ra khi tải thông tin đánh giá: ' + error.message);
        });
}

function blockReview(id, reviewerName) {
    document.getElementById('blockReviewId').textContent = 'REV' + String(id).padStart(3, '0');
    document.getElementById('blockReviewer').textContent = reviewerName;
    document.getElementById('blockConfirmReviewId').value = id;

    var modal = new bootstrap.Modal(document.getElementById('blockReviewModal'));
    modal.show();
}

function unblockReview(id, reviewerName) {
    document.getElementById('unblockReviewId').textContent = 'REV' + String(id).padStart(3, '0');
    document.getElementById('unblockReviewer').textContent = reviewerName;
    document.getElementById('unblockConfirmReviewId').value = id;

    var modal = new bootstrap.Modal(document.getElementById('unblockReviewModal'));
    modal.show();
}

function goToPage(page) {
    const urlParams = new URLSearchParams(window.location.search);
    urlParams.set('page', page);
    window.location.href = contextPath + '/admin/reviews?' + urlParams.toString();
}

function generateStars(rating) {
    let stars = '';
    for (let i = 1; i <= 5; i++) {
        stars += i <= rating ? '★' : '☆';
    }
    return '<span class="rating-stars">' + stars + '</span>';
}

function formatDate(dateString) {
    if (!dateString) return 'Chưa cập nhật';
    const date = new Date(dateString);
    return date.toLocaleDateString('vi-VN');
}