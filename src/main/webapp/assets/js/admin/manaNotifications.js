// Set default send date to today for create modal
document.addEventListener('DOMContentLoaded', function () {
    const today = new Date().toISOString().split('T')[0];
    document.getElementById('createSendDate').value = today;

    // Auto-dismiss alerts after 5 seconds
    const alerts = document.querySelectorAll(".alert");
    alerts.forEach((alert) => {
        setTimeout(() => {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        }, 5000);
    });

    // Form validation for Create and Edit Notification Forms
    const forms = document.querySelectorAll("#createNotificationForm, #editNotificationForm");
    forms.forEach((form) => {
        form.addEventListener("submit", (e) => {
            let isValid = true;
            const title = form.querySelector('input[name="title"]');
            const content = form.querySelector('textarea[name="content"]');
            const type = form.querySelector('select[name="type"]');

            // Reset validation states
            [title, content, type].forEach(field => {
                field.classList.remove('is-invalid');
            });

            // Title validation
            if (!title.value.trim()) {
                title.classList.add('is-invalid');
                isValid = false;
            }

            // Content validation
            if (!content.value.trim()) {
                content.classList.add('is-invalid');
                isValid = false;
            }

            // Type validation
            if (!type.value.trim()) {
                type.classList.add('is-invalid');
                isValid = false;
            }

            if (!isValid) {
                e.preventDefault();
                alert('Vui lòng điền đầy đủ thông tin bắt buộc.');
            }
        });
    });

    // Character count for content textarea
    const contentTextareas = document.querySelectorAll('textarea[name="content"]');
    contentTextareas.forEach((textarea) => {
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

    // Date validation for send date
    const sendDateInputs = document.querySelectorAll('input[name="sendDate"]');
    sendDateInputs.forEach((input) => {
        const today = new Date().toISOString().split("T")[0];
        input.min = today;
        input.addEventListener("change", function () {
            if (this.value && this.value < today) {
                this.classList.add('is-invalid');
                alert("Ngày gửi không thể là ngày trong quá khứ");
                this.value = today;
            } else {
                this.classList.remove('is-invalid');
            }
        });
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

// JavaScript functions for modal handling
function viewNotification(id) {
    fetch(contextPath + '/admin/notifications?action=view&id=' + id)
            .then(response => {
                if (!response.ok) {
                    throw new Error('Lỗi khi tải thông tin thông báo');
                }
                return response.json();
            })
            .then(data => {
                if (data.error) {
                    throw new Error(data.error);
                }
                document.getElementById('viewNotificationId').textContent = data.id;
                document.getElementById('viewNotificationTitle').textContent = data.title;
                document.getElementById('viewNotificationType').textContent = data.type;
                document.getElementById('viewNotificationRecipient').textContent = data.recipient;
                document.getElementById('viewNotificationSendDate').textContent = formatDate(data.sendDate);
                document.getElementById('viewNotificationContent').textContent = data.content;

                var modal = new bootstrap.Modal(document.getElementById('viewNotificationModal'));
                modal.show();
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra khi tải thông tin thông báo: ' + error.message);
            });
}

function editNotification(id) {
    fetch(contextPath + '/admin/notifications?action=view&id=' + id)
            .then(response => {
                if (!response.ok) {
                    throw new Error('Lỗi khi tải thông tin thông báo');
                }
                return response.json();
            })
            .then(data => {
                if (data.error) {
                    throw new Error(data.error);
                }
                document.getElementById('editNotificationId').value = data.id;
                document.getElementById('editTitle').value = data.title;
                document.getElementById('editContent').value = data.content;
                document.getElementById('editType').value = data.type;
                document.getElementById('editRecipient').value = data.recipient || 'Tất cả';

                var modal = new bootstrap.Modal(document.getElementById('editNotificationModal'));
                modal.show();

                // Update character counter for editContent
                const editContent = document.getElementById('editContent');
                editContent.dispatchEvent(new Event('input'));
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra khi tải thông tin thông báo: ' + error.message);
            });
}

function deleteNotification(id, title) {
    document.getElementById('deleteNotificationTitle').textContent = title;
    document.getElementById('deleteNotificationId').textContent = id;
    document.getElementById('deleteNotificationIdInput').value = id;

    var modal = new bootstrap.Modal(document.getElementById('deleteNotificationModal'));
    modal.show();
}

function goToPage(page) {
    const urlParams = new URLSearchParams(window.location.search);
    urlParams.set('page', page);
    window.location.href = contextPath + '/admin/notifications?' + urlParams.toString();
}


function formatDate(dateString) {
    if (!dateString)
        return 'Chưa cập nhật';
    const date = new Date(dateString);
    return date.toLocaleDateString('vi-VN');
}