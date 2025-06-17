
// Character counters
function updateCharacterCounter(input, counter, maxLength) {
    const current = input.value.length;
    const counterElement = document.getElementById(counter);
    counterElement.textContent = `${current}/${maxLength} ký tự`;

    if (current > maxLength * 0.9) {
        counterElement.className = 'character-counter danger';
    } else if (current > maxLength * 0.7) {
        counterElement.className = 'character-counter warning';
    } else {
        counterElement.className = 'character-counter';
    }
}

// Initialize character counters
const titleInput = document.getElementById('postTitle');
const contentInput = document.getElementById('postContent');

titleInput.addEventListener('input', () => updateCharacterCounter(titleInput, 'titleCounter', 200));
contentInput.addEventListener('input', () => updateCharacterCounter(contentInput, 'contentCounter', 5000));

// Initial counter update
updateCharacterCounter(titleInput, 'titleCounter', 200);
updateCharacterCounter(contentInput, 'contentCounter', 5000);

// Image preview
function previewImage(event) {
    const file = event.target.files[0];
    const preview = document.getElementById('imagePreview');
    const img = preview.querySelector('img');
    const uploadArea = document.querySelector('.file-upload-area');

    if (file) {
        // Validate file type
        if (!file.type.startsWith('image/')) {
            alert('Vui lòng chọn file hình ảnh!');
            event.target.value = '';
            return;
        }

        // Validate file size (10MB)
        if (file.size > 10 * 1024 * 1024) {
            alert('Kích thước file không được vượt quá 10MB!');
            event.target.value = '';
            return;
        }

        const reader = new FileReader();
        reader.onload = function (e) {
            img.src = e.target.result;
            preview.style.display = 'block';
            uploadArea.querySelector('.upload-text').textContent = 'Thay đổi hình ảnh';
            uploadArea.querySelector('.upload-hint').textContent = 'Nhấp để chọn hình ảnh khác';
        };
        reader.readAsDataURL(file);
    } else {
        preview.style.display = 'none';
        uploadArea.querySelector('.upload-text').textContent = 'Thêm hình ảnh';
        uploadArea.querySelector('.upload-hint').textContent = 'Nhấp để chọn hình ảnh mới hoặc kéo thả vào đây (PNG, JPG, GIF tối đa 10MB)';
    }
}

// Auto-resize textarea
function autoResize() {
    contentInput.style.height = 'auto';
    contentInput.style.height = contentInput.scrollHeight + 'px';
}

contentInput.addEventListener('input', autoResize);
autoResize();

// Form submission with loading state
document.getElementById('editForm').addEventListener('submit', function (e) {
    const submitBtn = document.getElementById('submitBtn');
    const form = this;

    // Validate form
    const title = document.getElementById('postTitle').value.trim();
    const content = document.getElementById('postContent').value.trim();
    const category = document.getElementById('postCategory').value;

    if (!title || !content || !category) {
        e.preventDefault();
        alert('Vui lòng điền đầy đủ thông tin!');
        return;
    }

    if (title.length > 200) {
        e.preventDefault();
        alert('Tiêu đề không được vượt quá 200 ký tự!');
        return;
    }

    if (content.length > 5000) {
        e.preventDefault();
        alert('Nội dung không được vượt quá 5000 ký tự!');
        return;
    }

    // Add loading state
    submitBtn.disabled = true;
    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang lưu...';
    form.classList.add('loading');
});

// Drag and drop for file upload
const uploadArea = document.querySelector('.file-upload-area');
const fileInput = document.getElementById('imageInput');

['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
    uploadArea.addEventListener(eventName, preventDefaults, false);
});

function preventDefaults(e) {
    e.preventDefault();
    e.stopPropagation();
}

['dragenter', 'dragover'].forEach(eventName => {
    uploadArea.addEventListener(eventName, highlight, false);
});

['dragleave', 'drop'].forEach(eventName => {
    uploadArea.addEventListener(eventName, unhighlight, false);
});

function highlight(e) {
    uploadArea.classList.add('dragover');
}

function unhighlight(e) {
    uploadArea.classList.remove('dragover');
}

uploadArea.addEventListener('drop', handleDrop, false);

function handleDrop(e) {
    const dt = e.dataTransfer;
    const files = dt.files;

    if (files.length > 0) {
        fileInput.files = files;
        previewImage({target: fileInput});
    }
}

// Keyboard shortcuts
document.addEventListener('keydown', function (e) {
    // Ctrl+S to save
    if (e.ctrlKey && e.key === 's') {
        e.preventDefault();
        document.getElementById('editForm').submit();
    }

    // Escape to cancel
    if (e.key === 'Escape') {
        if (confirm('Bạn có chắc chắn muốn hủy? Các thay đổi sẽ không được lưu.')) {
            window.location.href = '<%= request.getContextPath() %>/forum/post/<%= post != null ? post.getId() : "" %>';
        }
    }
});

// Warn before leaving if form is dirty
let formChanged = false;
const formElements = document.querySelectorAll('#editForm input, #editForm textarea, #editForm select');

formElements.forEach(element => {
    element.addEventListener('change', () => {
        formChanged = true;
    });
});

window.addEventListener('beforeunload', function (e) {
    if (formChanged) {
        e.preventDefault();
        e.returnValue = '';
    }
});

// Remove warning when form is submitted
document.getElementById('editForm').addEventListener('submit', function () {
    formChanged = false;
});

// Auto-save draft
let autoSaveTimer;
function autoSaveDraft() {
    const title = titleInput.value;
    const content = contentInput.value;
    const category = document.getElementById('postCategory').value;

    if (title || content || category) {
        localStorage.setItem('editPostDraft', JSON.stringify({
            title,
            content,
            category,
            timestamp: Date.now()
        }));
    }
}

// Auto-save every 30 seconds
formElements.forEach(element => {
    element.addEventListener('input', () => {
        clearTimeout(autoSaveTimer);
        autoSaveTimer = setTimeout(autoSaveDraft, 30000);
    });
});

// Load draft on page load
window.addEventListener('load', function () {
    const draft = localStorage.getItem('editPostDraft');
    if (draft) {
        const draftData = JSON.parse(draft);
        // Only load if draft is less than 24 hours old
        if (Date.now() - draftData.timestamp < 24 * 60 * 60 * 1000) {
            if (confirm('Có bản nháp được lưu trước đó. Bạn có muốn khôi phục không?')) {
                if (draftData.title)
                    titleInput.value = draftData.title;
                if (draftData.content)
                    contentInput.value = draftData.content;
                if (draftData.category)
                    document.getElementById('postCategory').value = draftData.category;

                // Update counters
                updateCharacterCounter(titleInput, 'titleCounter', 200);
                updateCharacterCounter(contentInput, 'contentCounter', 5000);
                autoResize();
            }
        }
        localStorage.removeItem('editPostDraft');
    }
});

// Clear draft when form is submitted successfully
document.getElementById('editForm').addEventListener('submit', function () {
    localStorage.removeItem('editPostDraft');
});