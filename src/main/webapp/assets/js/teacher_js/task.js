// Task Management JavaScript

// Pagination variables for tasks
let currentPage = {
    incomplete: 1,
    completed: 1,
    reviews: 1
};
const pageSize = 3;
let totalTasks = {
    incomplete: 0,
    completed: 0,
    reviews: 0
};
let totalPages = {
    incomplete: 1,
    completed: 1,
    reviews: 1
};

// Initialize pagination when page loads
document.addEventListener('DOMContentLoaded', function() {
    initializeTaskPagination();
});

function initializeTaskPagination() {
    // Count incomplete tasks
    const incompleteTasks = document.querySelectorAll('#incomplete-tab .task-card');
    totalTasks.incomplete = incompleteTasks.length;
    totalPages.incomplete = Math.max(1, Math.ceil(totalTasks.incomplete / pageSize));
    
    // Count completed tasks
    const completedTasks = document.querySelectorAll('#completed-tab .task-card');
    totalTasks.completed = completedTasks.length;
    totalPages.completed = Math.max(1, Math.ceil(totalTasks.completed / pageSize));
    
    // Count reviews
    const reviewCards = document.querySelectorAll('#reviews-tab .review-card');
    totalTasks.reviews = reviewCards.length;
    totalPages.reviews = Math.max(1, Math.ceil(totalTasks.reviews / pageSize));
    
    // Initialize pagination for each tab
    if (totalTasks.incomplete > 0) {
        initializePagination('incomplete');
        showCurrentPage('incomplete');
    }
    
    if (totalTasks.completed > 0) {
        initializePagination('completed');
        showCurrentPage('completed');
    }
    
    if (totalTasks.reviews > 0) {
        initializePagination('reviews');
        showCurrentPage('reviews');
    }
}

function initializePagination(tabType) {
    const paginationContainer = document.getElementById(tabType + '-pagination');
    
    if (paginationContainer && totalTasks[tabType] > 0) {
        paginationContainer.style.display = 'flex';
        createPageNumbers(tabType);
        updateNavigationButtons(tabType);
        updatePaginationInfo(tabType);
    }
}

function showCurrentPage(tabType) {
    let items;
    if (tabType === 'reviews') {
        items = document.querySelectorAll(`#${tabType}-tab .review-card`);
    } else {
        items = document.querySelectorAll(`#${tabType}-tab .task-card`);
    }
    
    const startIndex = (currentPage[tabType] - 1) * pageSize;
    const endIndex = Math.min(startIndex + pageSize, totalTasks[tabType]);

    items.forEach((item, index) => {
        if (index >= startIndex && index < endIndex) {
            item.style.display = 'block';
        } else {
            item.style.display = 'none';
        }
    });
}

function createPageNumbers(tabType) {
    const pageNumbersContainer = document.getElementById(tabType + '-page-numbers');
    if (!pageNumbersContainer) return;
    
    pageNumbersContainer.innerHTML = '';

    if (totalPages[tabType] <= 7) {
        // Show all page numbers
        for (let i = 1; i <= totalPages[tabType]; i++) {
            const pageBtn = createPageButton(tabType, i);
            pageNumbersContainer.appendChild(pageBtn);
        }
    } else {
        // Show smart pagination
        if (currentPage[tabType] > 3) {
            pageNumbersContainer.appendChild(createPageButton(tabType, 1));
            pageNumbersContainer.appendChild(createDots());
        }

        const start = Math.max(1, currentPage[tabType] - 2);
        const end = Math.min(totalPages[tabType], currentPage[tabType] + 2);
        
        for (let i = start; i <= end; i++) {
            const pageBtn = createPageButton(tabType, i);
            pageNumbersContainer.appendChild(pageBtn);
        }

        if (currentPage[tabType] < totalPages[tabType] - 2) {
            pageNumbersContainer.appendChild(createDots());
            pageNumbersContainer.appendChild(createPageButton(tabType, totalPages[tabType]));
        }
    }
}

function createPageButton(tabType, pageNum) {
    const button = document.createElement('button');
    button.className = `page-number ${pageNum === currentPage[tabType] ? 'active' : ''}`;
    button.textContent = pageNum;
    button.onclick = () => goToPage(tabType, pageNum);
    return button;
}

function createDots() {
    const dots = document.createElement('span');
    dots.className = 'page-dots';
    dots.textContent = '...';
    return dots;
}

function updateNavigationButtons(tabType) {
    const prevBtn = document.getElementById(tabType + '-prev');
    const nextBtn = document.getElementById(tabType + '-next');

    if (prevBtn) {
        prevBtn.disabled = currentPage[tabType] <= 1;
        prevBtn.style.opacity = currentPage[tabType] <= 1 ? '0.5' : '1';
    }
    if (nextBtn) {
        nextBtn.disabled = currentPage[tabType] >= totalPages[tabType];
        nextBtn.style.opacity = currentPage[tabType] >= totalPages[tabType] ? '0.5' : '1';
    }
}

function updatePaginationInfo(tabType) {
    const startElement = document.getElementById(tabType + '-start');
    const endElement = document.getElementById(tabType + '-end');
    const totalElement = document.getElementById(tabType + '-total');
    
    if (startElement && endElement && totalElement) {
        const start = (currentPage[tabType] - 1) * pageSize + 1;
        const end = Math.min(currentPage[tabType] * pageSize, totalTasks[tabType]);
        
        startElement.textContent = start;
        endElement.textContent = end;
        totalElement.textContent = totalTasks[tabType];
    }
}

function changePage(tabType, direction) {
    const newPage = currentPage[tabType] + direction;
    if (newPage >= 1 && newPage <= totalPages[tabType]) {
        goToPage(tabType, newPage);
    }
}

function goToPage(tabType, pageNum) {
    currentPage[tabType] = pageNum;
    showCurrentPage(tabType);
    createPageNumbers(tabType);
    updateNavigationButtons(tabType);
    updatePaginationInfo(tabType);
}

// Show tab function with pagination
function showTab(tabName) {
    // Hide all tab contents
    const tabContents = document.querySelectorAll('.tab-content');
    tabContents.forEach(content => {
        content.style.display = 'none';
    });

    // Remove active class from all tab buttons
    const tabButtons = document.querySelectorAll('.tab-button');
    tabButtons.forEach(button => {
        button.classList.remove('active');
    });

    // Show selected tab content
    const selectedTab = document.getElementById(tabName + '-tab');
    if (selectedTab) {
        selectedTab.style.display = 'block';
        
        // Initialize pagination for the selected tab if it has items
        if (tabName === 'incomplete' && totalTasks.incomplete > 0) {
            initializePagination('incomplete');
            showCurrentPage('incomplete');
        } else if (tabName === 'completed' && totalTasks.completed > 0) {
            initializePagination('completed');
            showCurrentPage('completed');
        } else if (tabName === 'reviews' && totalTasks.reviews > 0) {
            initializePagination('reviews');
            showCurrentPage('reviews');
        }
    }

    // Add active class to selected tab button
    const selectedButton = document.querySelector(`[onclick="showTab('${tabName}')"]`);
    if (selectedButton) {
        selectedButton.classList.add('active');
    }
}

// Start task với modal xác nhận đẹp hơn
function startTask(taskId, entityType) {
    showConfirmModal(
        'Bắt đầu nhiệm vụ',
        'Bạn có chắc chắn muốn bắt đầu nhiệm vụ này?',
        'Bắt đầu',
        'Hủy',
        () => {
            // Callback khi xác nhận
        updateTaskStatus(taskId, 'In Progress').then(success => {
            if (success) {
                    showNotification('Đang chuyển hướng...', 'info');
                    setTimeout(() => {
                if (entityType === 'course') {
                    window.location.href = `/Hikari/taskCourse?taskID=${taskId}`;
                } else if (entityType === 'test') {
                    window.location.href = `/Hikari/taskTest?taskID=${taskId}`;
                }
                    }, 1000);
            }
        });
    }
    );
}

// Continue task
function continueTask(taskId, entityType) {
    showNotification('Đang chuyển hướng...', 'info');
    setTimeout(() => {
    if (entityType === 'course') {
        window.location.href = `/Hikari/taskCourse?taskID=${taskId}`;
    } else if (entityType === 'test') {
        window.location.href = `/Hikari/taskTest?taskID=${taskId}`;
    }
    }, 500);
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

// Modal xác nhận đẹp hơn
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
            <i class="fas fa-question-circle" style="font-size: 3rem; color: #4a90e2; margin-bottom: 1rem;"></i>
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
                background: #4a90e2;
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

// Hệ thống thông báo đẹp hơn
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

// Thêm CSS animations
if (!document.getElementById('task-notification-styles')) {
    const style = document.createElement('style');
    style.id = 'task-notification-styles';
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

// Add topic functionality
async function addTopic(courseId) {
    const topicName = document.getElementById('topic-name').value;
    const description = document.getElementById('topic-description').value;
    
    if (!topicName || !description) {
        showNotification('Vui lòng điền đầy đủ thông tin!', 'warning');
        return;
    }
    
    try {
        const response = await fetch('/Hikari/tasks', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: `action=addTopic&courseID=${courseId}&topicName=${encodeURIComponent(topicName)}&description=${encodeURIComponent(description)}`
        });
        
        if (response.ok) {
            const result = await response.json();
            if (result.success) {
                showNotification('Thêm topic thành công!', 'success');
                // Reload page to show new topic
                setTimeout(() => {
                    window.location.reload();
                }, 1500);
            } else {
                showNotification(result.message || 'Có lỗi xảy ra khi thêm topic!', 'error');
            }
        } else {
            showNotification('Có lỗi xảy ra khi thêm topic!', 'error');
        }
    } catch (error) {
        console.error('Error adding topic:', error);
        showNotification('Có lỗi xảy ra khi thêm topic!', 'error');
    }
}

// Calculate days until deadline
function getDaysUntilDeadline(deadlineStr) {
    const deadline = new Date(deadlineStr);
    const today = new Date();
    const diffTime = deadline.getTime() - today.getTime();
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    return diffDays;
}

// Format date
function formatDate(dateStr) {
    const date = new Date(dateStr);
    return date.toLocaleDateString('vi-VN');
}

// Initialize page
document.addEventListener('DOMContentLoaded', function() {
    // Add event listeners for dynamic content
    
    // Auto-refresh task status every 30 seconds
    setInterval(() => {
        // Only refresh if user is on tasks page
        if (window.location.pathname.includes('/tasks')) {
            // Could implement auto-refresh logic here
        }
    }, 30000);
    
    // Add keyboard shortcuts
    document.addEventListener('keydown', function(e) {
        // Ctrl/Cmd + R to refresh
        if ((e.ctrlKey || e.metaKey) && e.key === 'r') {
            e.preventDefault();
            window.location.reload();
        }
        
        // Escape to close modals
        if (e.key === 'Escape') {
            const modals = document.querySelectorAll('.modal.show');
            modals.forEach(modal => {
                const bsModal = bootstrap.Modal.getInstance(modal);
                if (bsModal) {
                    bsModal.hide();
                }
            });
        }
    });
});

// Utility functions
const TaskUtils = {
    // Get status color class
    getStatusColorClass: function(status) {
        switch (status) {
            case 'Assigned': return 'status-assigned';
            case 'In Progress': return 'status-progress';
            case 'Submitted': return 'status-submitted';
            case 'Reviewed': return 'status-reviewed';
            default: return 'status-assigned';
        }
    },
    
    // Get entity type icon
    getEntityTypeIcon: function(entityType) {
        switch (entityType) {
            case 'course': return 'fas fa-book-open';
            case 'test': return 'fas fa-clipboard-check';
            case 'lesson': return 'fas fa-video';
            case 'assignment': return 'fas fa-file-alt';
            default: return 'fas fa-question-circle';
        }
    },
    
    // Calculate completion percentage
    calculateCompletionPercentage: function(completed, total) {
        return total > 0 ? Math.round((completed / total) * 100) : 0;
    }
};

// Export for use in other scripts
window.TaskUtils = TaskUtils;
window.showNotification = showNotification;
window.startTask = startTask;
window.continueTask = continueTask;
window.showTab = showTab;

