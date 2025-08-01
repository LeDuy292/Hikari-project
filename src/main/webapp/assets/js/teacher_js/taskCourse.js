// Pagination variables
let currentPage = 1;
const pageSize = 3;
let totalTopics = 0;
let totalPages = 1;

// Initialize pagination when page loads
document.addEventListener('DOMContentLoaded', function() {
    // Get total topics from the badge
    const badgeElement = document.querySelector('.badge.bg-secondary');
    
    if (badgeElement) {
        const badgeText = badgeElement.textContent;
        const match = badgeText.match(/(\d+)\s+topics/);
        
        if (match) {
            totalTopics = parseInt(match[1]);
            totalPages = Math.max(1, Math.ceil(totalTopics / pageSize));
            
            if (totalTopics > 0) {
                initializePagination();
                showCurrentPage();
            }
        }
    }
});

function initializePagination() {
    const paginationContainer = document.getElementById('pagination-container');
    
    if (paginationContainer && totalTopics > 0) {
        paginationContainer.style.display = 'flex';
        createPageNumbers();
        updateNavigationButtons();
    }
}

function showCurrentPage() {
    const topicCards = document.querySelectorAll('.topic-card');
    const startIndex = (currentPage - 1) * pageSize;
    const endIndex = Math.min(startIndex + pageSize, totalTopics);

    topicCards.forEach((card, index) => {
        if (index >= startIndex && index < endIndex) {
            card.style.display = 'block';
        } else {
            card.style.display = 'none';
        }
    });
}

function createPageNumbers() {
    const pageNumbersContainer = document.getElementById('page-numbers');
    if (!pageNumbersContainer) return;
    
    pageNumbersContainer.innerHTML = '';

    if (totalPages <= 7) {
        // Show all page numbers
        for (let i = 1; i <= totalPages; i++) {
            const pageBtn = createPageButton(i);
            pageNumbersContainer.appendChild(pageBtn);
        }
    } else {
        // Show smart pagination
        if (currentPage > 3) {
            pageNumbersContainer.appendChild(createPageButton(1));
            pageNumbersContainer.appendChild(createDots());
        }

        const start = Math.max(1, currentPage - 2);
        const end = Math.min(totalPages, currentPage + 2);
        
        for (let i = start; i <= end; i++) {
            const pageBtn = createPageButton(i);
            pageNumbersContainer.appendChild(pageBtn);
        }

        if (currentPage < totalPages - 2) {
            pageNumbersContainer.appendChild(createDots());
            pageNumbersContainer.appendChild(createPageButton(totalPages));
        }
    }
}

function createPageButton(pageNum) {
    const button = document.createElement('button');
    button.className = `pagination-btn ${pageNum === currentPage ? 'active' : ''}`;
    button.textContent = pageNum;
    button.onclick = () => goToPage(pageNum);
    return button;
}

function createDots() {
    const dots = document.createElement('span');
    dots.className = 'pagination-dots';
    dots.textContent = '...';
    return dots;
}

function updateNavigationButtons() {
    const prevBtn = document.getElementById('prev-btn');
    const nextBtn = document.getElementById('next-btn');

    if (prevBtn) {
        prevBtn.disabled = currentPage <= 1;
        prevBtn.style.opacity = currentPage <= 1 ? '0.5' : '1';
    }
    if (nextBtn) {
        nextBtn.disabled = currentPage >= totalPages;
        nextBtn.style.opacity = currentPage >= totalPages ? '0.5' : '1';
    }
}

function changePage(direction) {
    const newPage = currentPage + direction;
    if (newPage >= 1 && newPage <= totalPages) {
        goToPage(newPage);
    }
}

function goToPage(pageNum) {
    currentPage = pageNum;
    showCurrentPage();
    createPageNumbers();
    updateNavigationButtons();
}

let selectedTopic = null;

function toggleTopic(topicId) {
    const actionsDiv = document.getElementById('actions-' + topicId);
    const icon = document.getElementById('icon-' + topicId);
    const text = document.getElementById('text-' + topicId);
    const card = document.getElementById('topic-' + topicId);

    if (!actionsDiv || !icon || !text || !card) return;

    // Close previously selected topic
    if (selectedTopic && selectedTopic !== topicId) {
        const prevActions = document.getElementById('actions-' + selectedTopic);
        const prevIcon = document.getElementById('icon-' + selectedTopic);
        const prevText = document.getElementById('text-' + selectedTopic);
        const prevCard = document.getElementById('topic-' + selectedTopic);

        if (prevActions) prevActions.style.display = 'none';
        if (prevIcon) prevIcon.className = 'fas fa-plus';
        if (prevText) prevText.textContent = 'Thêm nội dung';
        if (prevCard) prevCard.classList.remove('selected');
    }

    // Toggle current topic
    if (selectedTopic === topicId) {
        actionsDiv.style.display = 'none';
        icon.className = 'fas fa-plus';
        text.textContent = 'Thêm nội dung';
        card.classList.remove('selected');
        selectedTopic = null;
    } else {
        actionsDiv.style.display = 'grid';
        icon.className = 'fas fa-minus';
        text.textContent = 'Ẩn';
        card.classList.add('selected');
        selectedTopic = topicId;
    }
}

// Complete Task function
function completeTask(taskId) {
    showConfirmModal(
        'Hoàn thành nhiệm vụ',
        'Bạn có chắc chắn muốn nộp và hoàn thành nhiệm vụ này?',
        'Hoàn thành',
        'Hủy',
        () => {
            // Callback khi xác nhận
            updateTaskStatus(taskId, 'Submitted').then(success => {
                if (success) {
                    showNotification('Nhiệm vụ đã được hoàn thành thành công!', 'success');
                    setTimeout(() => {
                        window.location.href = '/Hikari/teacher/tasks';
                    }, 1500);
                }
            });
        }
    );
}

// Update task status
async function updateTaskStatus(taskId, status) {
    try {
        const response = await fetch('/Hikari/teacher/tasks', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: `action=updateStatus&taskID=${taskId}&status=${status}`
        });
        
        if (response.ok) {
            const result = await response.json();
            if (result.success) {
                showNotification('Cập nhật trạng thái thành công!', 'success');
                return true;
            } else {
                showNotification('Có lỗi xảy ra khi cập nhật trạng thái!', 'error');
                return false;
            }
        } else {
            showNotification('Có lỗi xảy ra khi cập nhật trạng thái!', 'error');
            return false;
        }
    } catch (error) {
        console.error('Error updating task status:', error);
        showNotification('Có lỗi xảy ra khi cập nhật trạng thái!', 'error');
        return false;
    }
}

// Modal xác nhận
function showConfirmModal(title, message, confirmText = 'Xác nhận', cancelText = 'Hủy', onConfirm) {
    // Tạo modal container nếu chưa có
    let modalContainer = document.getElementById('confirm-modal-container');
    if (!modalContainer) {
        modalContainer = document.createElement('div');
        modalContainer.id = 'confirm-modal-container';
        modalContainer.style.cssText = `
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 10000;
            opacity: 0;
            transition: opacity 0.3s ease;
        `;
        document.body.appendChild(modalContainer);
    }

    // Tạo modal content
    const modalContent = document.createElement('div');
    modalContent.style.cssText = `
        background: white;
        border-radius: 12px;
        padding: 2rem;
        max-width: 400px;
        width: 90%;
        text-align: center;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
        transform: scale(0.8);
        transition: transform 0.3s ease;
    `;

    modalContent.innerHTML = `
        <div style="margin-bottom: 1.5rem;">
            <i class="fas fa-question-circle" style="font-size: 3rem; color: #28a745; margin-bottom: 1rem;"></i>
            <h3 style="margin: 0 0 0.5rem 0; color: #333; font-size: 1.2rem;">${title}</h3>
            <p style="margin: 0; color: #666; line-height: 1.5;">${message}</p>
        </div>
        <div style="display: flex; gap: 1rem; justify-content: center;">
            <button id="confirm-cancel" style="
                padding: 0.75rem 1.5rem;
                border: 1px solid #ddd;
                background: white;
                color: #666;
                border-radius: 6px;
                cursor: pointer;
                font-weight: 500;
                transition: all 0.2s;
            ">${cancelText}</button>
            <button id="confirm-ok" style="
                padding: 0.75rem 1.5rem;
                border: none;
                background: #28a745;
                color: white;
                border-radius: 6px;
                cursor: pointer;
                font-weight: 500;
                transition: all 0.2s;
            ">${confirmText}</button>
        </div>
    `;

    modalContainer.appendChild(modalContent);

    // Hiển thị modal với animation
    setTimeout(() => {
        modalContainer.style.opacity = '1';
        modalContent.style.transform = 'scale(1)';
    }, 10);

    // Event listeners
    const cancelBtn = modalContent.querySelector('#confirm-cancel');
    const confirmBtn = modalContent.querySelector('#confirm-ok');

    const closeModal = () => {
        modalContainer.style.opacity = '0';
        modalContent.style.transform = 'scale(0.8)';
        setTimeout(() => {
            modalContainer.remove();
        }, 300);
    };

    cancelBtn.addEventListener('click', closeModal);
    confirmBtn.addEventListener('click', () => {
        if (onConfirm) onConfirm();
        closeModal();
    });

    // Close on backdrop click
    modalContainer.addEventListener('click', (e) => {
        if (e.target === modalContainer) {
            closeModal();
        }
    });
}

// Hệ thống thông báo
function showNotification(message, type = 'info') {
    // Tạo container nếu chưa có
    let notificationContainer = document.getElementById('notification-container');
    if (!notificationContainer) {
        notificationContainer = document.createElement('div');
        notificationContainer.id = 'notification-container';
        notificationContainer.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
            max-width: 400px;
        `;
        document.body.appendChild(notificationContainer);
    }

    // Tạo notification
    const notification = document.createElement('div');
    notification.className = 'notification';
    
    // Xác định icon và màu sắc
    let icon, bgColor, textColor, borderColor;
    switch (type) {
        case 'success':
            icon = 'fa-check-circle';
            bgColor = '#d4edda';
            textColor = '#155724';
            borderColor = '#c3e6cb';
            break;
        case 'error':
            icon = 'fa-exclamation-circle';
            bgColor = '#f8d7da';
            textColor = '#721c24';
            borderColor = '#f5c6cb';
            break;
        case 'warning':
            icon = 'fa-exclamation-triangle';
            bgColor = '#fff3cd';
            textColor = '#856404';
            borderColor = '#ffeaa7';
            break;
        default:
            icon = 'fa-info-circle';
            bgColor = '#d1ecf1';
            textColor = '#0c5460';
            borderColor = '#bee5eb';
    }

    notification.style.cssText = `
        background: ${bgColor};
        color: ${textColor};
        border: 1px solid ${borderColor};
        border-radius: 8px;
        padding: 15px 20px;
        margin-bottom: 10px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        display: flex;
        align-items: center;
        gap: 12px;
        font-size: 14px;
        font-weight: 500;
        animation: slideInRight 0.3s ease;
        position: relative;
        overflow: hidden;
    `;

    notification.innerHTML = `
        <i class="fas ${icon}" style="font-size: 18px; flex-shrink: 0;"></i>
        <span style="flex: 1;">${message}</span>
        <button onclick="this.parentElement.remove()" style="
            background: none;
            border: none;
            color: ${textColor};
            cursor: pointer;
            font-size: 16px;
            padding: 0;
            margin-left: 10px;
            opacity: 0.7;
            transition: opacity 0.2s;
        " onmouseover="this.style.opacity='1'" onmouseout="this.style.opacity='0.7'">
            <i class="fas fa-times"></i>
        </button>
    `;

    notificationContainer.appendChild(notification);

    // Tự động xóa sau 5 giây
    setTimeout(() => {
        if (notification.parentElement) {
            notification.style.animation = 'slideOutRight 0.3s ease';
            setTimeout(() => {
                if (notification.parentElement) {
                    notification.remove();
                }
            }, 300);
        }
    }, 5000);
}

// Add Topic function
function addTopic() {
    const topicName = document.getElementById('topicName');
    const topicDescription = document.getElementById('topicDescription');
    const addTopicBtn = document.getElementById('addTopicBtn');

    if (!topicName || !topicDescription || !addTopicBtn) return;

    const topicNameValue = topicName.value.trim();
    const topicDescriptionValue = topicDescription.value.trim();
    
    // Get courseID from the page
    const courseID = document.querySelector('[data-course-id]')?.getAttribute('data-course-id') || '';

    // Validation
    if (!topicNameValue) {
        alert('Vui lòng nhập tên topic');
        topicName.focus();
        return;
    }

    if (topicNameValue.length < 3) {
        alert('Tên topic phải có ít nhất 3 ký tự');
        topicName.focus();
        return;
    }

    // Disable button và hiển thị loading
    addTopicBtn.disabled = true;
    addTopicBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang thêm...';

    const formData = new FormData();
    formData.append('action', 'addTopic');
    formData.append('courseID', courseID);
    formData.append('topicName', topicNameValue);
    formData.append('description', topicDescriptionValue);

    // Get the current page context path
    const contextPath = window.location.pathname.split('/').slice(0, -1).join('/') || '';

    fetch(contextPath + '/taskCourse', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            // Hiển thị thông báo thành công
            const modal = bootstrap.Modal.getInstance(document.getElementById('addTopicModal'));
            if (modal) modal.hide();
            
            // Reload trang để hiển thị topic mới
            location.reload();
        } else {
            alert('Lỗi: ' + data.message);
            // Re-enable button
            addTopicBtn.disabled = false;
            addTopicBtn.innerHTML = '<i class="fas fa-save"></i> Thêm Topic';
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('Có lỗi xảy ra khi thêm topic');
        // Re-enable button
        addTopicBtn.disabled = false;
        addTopicBtn.innerHTML = '<i class="fas fa-save"></i> Thêm Topic';
    });
}

// Reset form khi modal đóng
document.addEventListener('DOMContentLoaded', function() {
    const addTopicModal = document.getElementById('addTopicModal');
    if (addTopicModal) {
        addTopicModal.addEventListener('hidden.bs.modal', function () {
            const addTopicForm = document.getElementById('addTopicForm');
            const addTopicBtn = document.getElementById('addTopicBtn');
            
            if (addTopicForm) addTopicForm.reset();
            if (addTopicBtn) {
                addTopicBtn.disabled = false;
                addTopicBtn.innerHTML = '<i class="fas fa-save"></i> Thêm Topic';
            }
        });
    }
    

});

// Thêm CSS animations
if (!document.getElementById('taskcourse-notification-styles')) {
    const style = document.createElement('style');
    style.id = 'taskcourse-notification-styles';
    style.textContent = `
        @keyframes slideInRight {
            from {
                transform: translateX(100%);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }
        
        @keyframes slideOutRight {
            from {
                transform: translateX(0);
                opacity: 1;
            }
            to {
                transform: translateX(100%);
                opacity: 0;
            }
        }
    `;
    document.head.appendChild(style);
}

 