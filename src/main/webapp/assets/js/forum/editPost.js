// Character counters
function updateCharacterCounter(input, counter, maxLength) {
    const current = input.value.length;
    const counterElement = document.getElementById(counter);
    counterElement.textContent = `${current}/${maxLength}`;

    if (current > maxLength * 0.9) {
        counterElement.className = 'character-counter danger';
    } else if (current > maxLength * 0.7) {
        counterElement.className = 'character-counter warning';
    } else {
        counterElement.className = 'character-counter';
    }
}

// Initialize character counters
document.addEventListener('DOMContentLoaded', function () {
    const titleInput = document.getElementById('postTitle');
    const contentInput = document.getElementById('postContent');

    if (titleInput && contentInput) {
        updateCharacterCounter(titleInput, 'titleCounter', 200);
        updateCharacterCounter(contentInput, 'contentCounter', 5000);

        titleInput.addEventListener('input', () => updateCharacterCounter(titleInput, 'titleCounter', 200));
        contentInput.addEventListener('input', () => updateCharacterCounter(contentInput, 'contentCounter', 5000));

        // Auto-resize textarea
        function autoResize() {
            contentInput.style.height = 'auto';
            contentInput.style.height = Math.min(contentInput.scrollHeight, 200) + 'px';
        }

        contentInput.addEventListener('input', autoResize);
        autoResize();
    }

    // Form validation
    const form = document.getElementById('editForm');
    const submitBtn = document.getElementById('submitBtn');

    if (form) {
        form.addEventListener('submit', function (e) {
            const title = titleInput.value.trim();
            const content = contentInput.value.trim();
            const category = document.getElementById('postCategory').value;

            if (!title || !content || !category) {
                e.preventDefault();
                alert('Vui lòng điền đầy đủ thông tin!');
                return;
            }

            if (title.length > 200 || content.length > 5000) {
                e.preventDefault();
                alert('Nội dung vượt quá giới hạn cho phép!');
                return;
            }

            submitBtn.disabled = true;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang lưu...';
            form.classList.add('loading');
        });
    }

    // Ctrl + S shortcut
    document.addEventListener('keydown', function (e) {
        if (e.ctrlKey && e.key === 's') {
            e.preventDefault();
            form?.submit();
        }
    });
});

// Image preview
function previewImage(event) {
    const file = event.target.files[0];
    const preview = document.getElementById('imagePreview');
    const img = preview.querySelector('img');
    const uploadArea = document.querySelector('.file-upload-compact');

    if (file) {
        if (!file.type.startsWith('image/')) {
            alert('Vui lòng chọn file hình ảnh!');
            event.target.value = '';
            return;
        }

        if (file.size > 10 * 1024 * 1024) {
            alert('Kích thước file không được vượt quá 10MB!');
            event.target.value = '';
            return;
        }

        const reader = new FileReader();
        reader.onload = function (e) {
            img.src = e.target.result;
            preview.style.display = 'block';
            uploadArea.classList.add('has-file');
            uploadArea.querySelector('.upload-text').textContent = 'Thay đổi hình ảnh';
        };
        reader.readAsDataURL(file);
    } else {
        preview.style.display = 'none';
        uploadArea.classList.remove('has-file');
        uploadArea.querySelector('.upload-text').textContent = 'Thêm hình ảnh';
    }
}
