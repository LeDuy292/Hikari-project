/**
 * Notification System Utility
 * Cung cấp các hàm thông báo đẹp và modal xác nhận
 */

class NotificationUtils {
    constructor() {
        this.initStyles();
    }

    // Khởi tạo CSS styles
    initStyles() {
        if (!document.getElementById('notification-utils-styles')) {
            const style = document.createElement('style');
            style.id = 'notification-utils-styles';
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
                
                @keyframes fadeIn {
                    from { opacity: 0; }
                    to { opacity: 1; }
                }
                
                @keyframes fadeOut {
                    from { opacity: 1; }
                    to { opacity: 0; }
                }
                
                @keyframes slideIn {
                    from {
                        transform: translateY(-50px);
                        opacity: 0;
                    }
                    to {
                        transform: translateY(0);
                        opacity: 1;
                    }
                }
                
                @keyframes slideOut {
                    from {
                        transform: translateY(0);
                        opacity: 1;
                    }
                    to {
                        transform: translateY(-50px);
                        opacity: 0;
                    }
                }
            `;
            document.head.appendChild(style);
        }
    }

    // Hiển thị thông báo
    showNotification(message, type = 'info', duration = 5000) {
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

        // Tự động xóa sau thời gian chỉ định
        setTimeout(() => {
            if (notification.parentElement) {
                notification.style.animation = 'slideOutRight 0.3s ease';
                setTimeout(() => {
                    if (notification.parentElement) {
                        notification.remove();
                    }
                }, 300);
            }
        }, duration);
    }

    // Hiển thị modal xác nhận
    showConfirmModal(title, message, confirmText = 'Xác nhận', cancelText = 'Hủy', onConfirm) {
        // Tạo modal container
        const modalContainer = document.createElement('div');
        modalContainer.id = 'confirm-modal';
        modalContainer.style.cssText = `
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 10000;
            animation: fadeIn 0.3s ease;
        `;

        // Tạo modal content
        const modalContent = document.createElement('div');
        modalContent.style.cssText = `
            background: white;
            border-radius: 12px;
            padding: 30px;
            max-width: 400px;
            width: 90%;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
            animation: slideIn 0.3s ease;
        `;

        modalContent.innerHTML = `
            <div style="text-align: center; margin-bottom: 20px;">
                <i class="fas fa-question-circle" style="font-size: 48px; color: #007bff; margin-bottom: 15px;"></i>
                <h3 style="margin: 0 0 10px 0; color: #333; font-size: 20px;">${title}</h3>
                <p style="margin: 0; color: #666; line-height: 1.5;">${message}</p>
            </div>
            <div style="display: flex; gap: 10px; justify-content: center;">
                <button id="confirm-btn" style="
                    background: #007bff;
                    color: white;
                    border: none;
                    padding: 10px 20px;
                    border-radius: 6px;
                    cursor: pointer;
                    font-weight: 500;
                    transition: background 0.2s;
                " onmouseover="this.style.background='#0056b3'" onmouseout="this.style.background='#007bff'">
                    ${confirmText}
                </button>
                <button id="cancel-btn" style="
                    background: #6c757d;
                    color: white;
                    border: none;
                    padding: 10px 20px;
                    border-radius: 6px;
                    cursor: pointer;
                    font-weight: 500;
                    transition: background 0.2s;
                " onmouseover="this.style.background='#545b62'" onmouseout="this.style.background='#6c757d'">
                    ${cancelText}
                </button>
            </div>
        `;

        modalContainer.appendChild(modalContent);
        document.body.appendChild(modalContainer);

        // Event listeners
        const confirmBtn = document.getElementById('confirm-btn');
        const cancelBtn = document.getElementById('cancel-btn');

        confirmBtn.addEventListener('click', () => {
            closeModal();
            if (onConfirm) onConfirm();
        });

        cancelBtn.addEventListener('click', closeModal);
        modalContainer.addEventListener('click', (e) => {
            if (e.target === modalContainer) closeModal();
        });

        function closeModal() {
            modalContainer.style.animation = 'fadeOut 0.3s ease';
            modalContent.style.animation = 'slideOut 0.3s ease';
            setTimeout(() => {
                if (modalContainer.parentElement) {
                    modalContainer.remove();
                }
            }, 300);
        }
    }

    // Hiển thị loading spinner
    showLoading(message = 'Đang xử lý...') {
        const loadingContainer = document.createElement('div');
        loadingContainer.id = 'loading-overlay';
        loadingContainer.style.cssText = `
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 10001;
            animation: fadeIn 0.3s ease;
        `;

        loadingContainer.innerHTML = `
            <div style="
                background: white;
                padding: 30px;
                border-radius: 12px;
                text-align: center;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
            ">
                <div class="loading-spinner" style="
                    display: inline-block;
                    width: 40px;
                    height: 40px;
                    border: 4px solid #f3f3f3;
                    border-top: 4px solid #007bff;
                    border-radius: 50%;
                    animation: spin 1s linear infinite;
                    margin-bottom: 15px;
                "></div>
                <p style="margin: 0; color: #333; font-weight: 500;">${message}</p>
            </div>
        `;

        document.body.appendChild(loadingContainer);

        // Thêm CSS cho spinner nếu chưa có
        if (!document.getElementById('loading-spinner-styles')) {
            const style = document.createElement('style');
            style.id = 'loading-spinner-styles';
            style.textContent = `
                @keyframes spin {
                    0% { transform: rotate(0deg); }
                    100% { transform: rotate(360deg); }
                }
            `;
            document.head.appendChild(style);
        }
    }

    // Ẩn loading spinner
    hideLoading() {
        const loadingContainer = document.getElementById('loading-overlay');
        if (loadingContainer) {
            loadingContainer.style.animation = 'fadeOut 0.3s ease';
            setTimeout(() => {
                if (loadingContainer.parentElement) {
                    loadingContainer.remove();
                }
            }, 300);
        }
    }

    // Hiển thị thông báo thành công
    showSuccess(message, duration = 3000) {
        this.showNotification(message, 'success', duration);
    }

    // Hiển thị thông báo lỗi
    showError(message, duration = 5000) {
        this.showNotification(message, 'error', duration);
    }

    // Hiển thị thông báo cảnh báo
    showWarning(message, duration = 4000) {
        this.showNotification(message, 'warning', duration);
    }

    // Hiển thị thông báo thông tin
    showInfo(message, duration = 3000) {
        this.showNotification(message, 'info', duration);
    }
}

// Khởi tạo instance toàn cục
const notificationUtils = new NotificationUtils();

// Export các hàm để sử dụng
window.showNotification = (message, type, duration) => notificationUtils.showNotification(message, type, duration);
window.showConfirmModal = (title, message, confirmText, cancelText, onConfirm) => 
    notificationUtils.showConfirmModal(title, message, confirmText, cancelText, onConfirm);
window.showLoading = (message) => notificationUtils.showLoading(message);
window.hideLoading = () => notificationUtils.hideLoading();
window.showSuccess = (message, duration) => notificationUtils.showSuccess(message, duration);
window.showError = (message, duration) => notificationUtils.showError(message, duration);
window.showWarning = (message, duration) => notificationUtils.showWarning(message, duration);
window.showInfo = (message, duration) => notificationUtils.showInfo(message, duration); 