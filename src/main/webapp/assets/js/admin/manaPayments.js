/* 
 * Payment Management JavaScript
 * Enhanced functionality for payment viewing and downloading
 */

// Get context path from page
const contextPath = document.querySelector('meta[name="contextPath"]')?.getAttribute('content') || '';

// View payment details with enhanced modal
function viewPayment(paymentId) {
    fetch(contextPath + '/admin/payments?action=view&id=' + encodeURIComponent(paymentId))
        .then(response => {
            if (!response.ok) {
                throw new Error('Payment not found');
            }
            return response.json();
        })
        .then(data => {
            // Populate payment information
            document.getElementById('viewPaymentId').textContent = 'PAY' + String(data.id).padStart(3, '0');
            document.getElementById('viewTransactionID').textContent = data.transactionID || 'Chưa có';
            document.getElementById('viewAmount').textContent = new Intl.NumberFormat('vi-VN', {
                style: 'currency', 
                currency: 'VND'
            }).format(data.amount);
            
            // Payment status with styling
            let statusHtml = '';
            switch (data.paymentStatus) {
                case 'Complete':
                    statusHtml = '<span class="badge bg-success"><i class="fas fa-check-circle"></i> Hoàn Thành</span>';
                    break;
                case 'Cancel':
                    statusHtml = '<span class="badge bg-danger"><i class="fas fa-times-circle"></i> Đã Hủy</span>';
                    break;
                default:
                    statusHtml = '<span class="badge bg-warning"><i class="fas fa-clock"></i> Đang Xử Lý</span>';
            }
            document.getElementById('viewStatus').innerHTML = statusHtml;
            
            // Payment method with icon
            let methodHtml = '';
            switch (data.paymentMethod) {
                case 'Credit Card':
                    methodHtml = '<i class="fas fa-credit-card text-primary"></i> Thẻ tín dụng';
                    break;
                case 'Bank Transfer':
                    methodHtml = '<i class="fas fa-university text-info"></i> Chuyển khoản';
                    break;
                case 'E-Wallet':
                    methodHtml = '<i class="fas fa-wallet text-success"></i> Ví điện tử';
                    break;
                default:
                    methodHtml = '<i class="fas fa-money-bill text-secondary"></i> ' + (data.paymentMethod || 'Không xác định');
            }
            document.getElementById('viewPaymentMethod').innerHTML = methodHtml;
            
            document.getElementById('viewPaymentDate').textContent = data.paymentDate
                ? new Date(data.paymentDate).toLocaleString('vi-VN', { 
                    day: '2-digit', month: '2-digit', year: 'numeric',
                    hour: '2-digit', minute: '2-digit' 
                })
                : 'Chưa có';
            
            // Student information
            document.getElementById('viewStudentName').textContent = data.studentName || 'Chưa có';
            document.getElementById('viewStudentID').textContent = data.studentID || 'Chưa có';
            
            // Course information
            document.getElementById('viewCourseName').textContent = data.courseNames || 'Chưa có khóa học';
            document.getElementById('viewCourseIDs').textContent = data.courseIDs || 'Chưa có';
            
            // Store payment ID for download functions
            window.currentPaymentId = paymentId;
            
            var modal = new bootstrap.Modal(document.getElementById('viewPaymentModal'));
            modal.show();
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Có lỗi xảy ra khi tải thông tin thanh toán: ' + error.message);
        });
}

// Export individual payment
function exportPayment(paymentId) {
    window.open(contextPath + '/admin/payments?action=export&id=' + paymentId, '_blank');
}

// Download payment invoice from modal
function downloadPaymentInvoice() {
    if (window.currentPaymentId) {
        exportPayment(window.currentPaymentId);
    }
}

// Print payment details
function printPaymentDetails() {
    const printContent = document.querySelector('#viewPaymentModal .modal-body').innerHTML;
    const printWindow = window.open('', '_blank');
    printWindow.document.write(`
        <html>
            <head>
                <title>Chi Tiết Thanh Toán - HIKARI</title>
                <style>
                    body { font-family: Arial, sans-serif; padding: 20px; line-height: 1.6; }
                    .section { margin-bottom: 20px; padding: 15px; border: 1px solid #ddd; border-radius: 5px; }
                    .section-title { font-weight: bold; color: #333; margin-bottom: 10px; font-size: 1.1em; }
                    .info-item { margin-bottom: 8px; display: flex; }
                    .info-label { font-weight: bold; width: 150px; flex-shrink: 0; }
                    .info-value { flex: 1; }
                    .badge { padding: 4px 8px; border-radius: 4px; color: white; font-size: 0.9em; }
                    .bg-success { background-color: #28a745; }
                    .bg-danger { background-color: #dc3545; }
                    .bg-warning { background-color: #ffc107; color: black; }
                    h2 { color: #4a90e2; text-align: center; margin-bottom: 30px; }
                    .row { display: flex; gap: 20px; }
                    .col-md-6 { flex: 1; }
                </style>
            </head>
            <body>
                <h2>Chi Tiết Thanh Toán - HIKARI</h2>
                ${printContent}
                <div style="text-align: center; margin-top: 30px; font-size: 0.9em; color: #666;">
                    Được in vào: ${new Date().toLocaleString('vi-VN')}
                </div>
            </body>
        </html>
    `);
    printWindow.document.close();
    printWindow.print();
}

// Bulk export function
function exportSelected() {
    const checkedBoxes = document.querySelectorAll('.payment-checkbox:checked');
    if (checkedBoxes.length === 0) {
        alert('Vui lòng chọn ít nhất một thanh toán để xuất');
        return;
    }
    
    const paymentIds = Array.from(checkedBoxes).map(cb => cb.value);
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = contextPath + '/admin/payments';
    
    const actionInput = document.createElement('input');
    actionInput.type = 'hidden';
    actionInput.name = 'action';
    actionInput.value = 'bulkExport';
    form.appendChild(actionInput);
    
    paymentIds.forEach(id => {
        const idInput = document.createElement('input');
        idInput.type = 'hidden';
        idInput.name = 'paymentIds';
        idInput.value = id;
        form.appendChild(idInput);
    });
    
    document.body.appendChild(form);
    form.submit();
    document.body.removeChild(form);
}

// Update payment status
function updatePaymentStatus(paymentId, status) {
    const statusText = status === 'Complete' ? 'duyệt' : 'từ chối';
    if (confirm(`Bạn có chắc chắn muốn ${statusText} thanh toán này?`)) {
        const formData = new FormData();
        formData.append('action', 'updateStatus');
        formData.append('paymentId', paymentId);
        formData.append('status', status);
        fetch(contextPath + '/admin/payments', {
            method: 'POST',
            body: formData
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Failed to update status');
            }
            window.location.href = contextPath + '/admin/payments?message=Cập nhật trạng thái thành công';
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Có lỗi xảy ra khi cập nhật trạng thái');
        });
    }
}

// Pagination
function goToPage(page) {
    const urlParams = new URLSearchParams(window.location.search);
    urlParams.set('page', page);
    window.location.href = contextPath + '/admin/payments?' + urlParams.toString();
}

// Clear selection
function clearSelection() {
    document.getElementById('selectAll').checked = false;
    document.querySelectorAll('.payment-checkbox').forEach(checkbox => {
        checkbox.checked = false;
    });
    toggleBulkActions();
}

// Toggle bulk actions visibility
function toggleBulkActions() {
    const checkedBoxes = document.querySelectorAll('.payment-checkbox:checked');
    const bulkActions = document.getElementById('bulkActionsBar');
    const selectedCount = document.getElementById('selectedCount');
    
    if (checkedBoxes.length > 0) {
        bulkActions.style.display = 'block';
        selectedCount.textContent = checkedBoxes.length;
    } else {
        bulkActions.style.display = 'none';
        selectedCount.textContent = '0';
    }
}

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    // Select all functionality
    const selectAllCheckbox = document.getElementById('selectAll');
    if (selectAllCheckbox) {
        selectAllCheckbox.addEventListener('change', function() {
            const checkboxes = document.querySelectorAll('.payment-checkbox');
            checkboxes.forEach(checkbox => {
                checkbox.checked = this.checked;
            });
            toggleBulkActions();
        });
    }

    // Individual checkbox change
    document.querySelectorAll('.payment-checkbox').forEach(checkbox => {
        checkbox.addEventListener('change', toggleBulkActions);
    });

    // Auto-dismiss alerts after 5 seconds
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alert => {
        setTimeout(() => {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        }, 5000);
    });

    // Enhanced search functionality
    const searchInput = document.getElementById('searchFilter');
    if (searchInput) {
        let searchTimeout;
        searchInput.addEventListener('input', function() {
            clearTimeout(searchTimeout);
            
            // Delay search to avoid too many requests
            searchTimeout = setTimeout(() => {
                // Submit the form for server-side search
                this.form.submit();
            }, 800);
        });
    }

    // Table sorting
    const sortableHeaders = document.querySelectorAll('.sortable');
    sortableHeaders.forEach(header => {
        header.addEventListener('click', function() {
            const sortBy = this.getAttribute('data-sort');
            const currentUrl = new URL(window.location);
            const currentSort = currentUrl.searchParams.get('sortBy');
            
            let newSort = sortBy + '_asc';
            if (currentSort === sortBy + '_asc') {
                newSort = sortBy + '_desc';
            }
            
            currentUrl.searchParams.set('sortBy', newSort);
            window.location.href = currentUrl.toString();
        });
    });
});
