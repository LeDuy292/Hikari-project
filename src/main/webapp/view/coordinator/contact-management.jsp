<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý liên hệ - HIKARI JAPAN</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/coordinator_css/header_coordinator.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/coordinator_css/sidebar_coordinator.css">
    <style>
        .main-content { 
            margin-left: 280px; 
            padding: 32px 40px; 
            padding-left: 60px;
            min-height: 100vh;
            background: #f8fafc;
        }
        
        .page-header { 
            background: linear-gradient(135deg, #e67e22 0%, #f39c12 100%); 
            color: white; 
            padding: 32px; 
            border-radius: 16px; 
            margin-bottom: 32px; 
            box-shadow: 0 4px 12px rgba(230, 126, 34, 0.3);
        }
        
        .page-title { 
            font-size: 2.2rem; 
            font-weight: 700; 
            margin-bottom: 12px; 
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .page-title i {
            font-size: 1.8rem;
            opacity: 0.9;
        }
        
        .stats-cards { 
            display: grid; 
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); 
            gap: 20px; 
            margin-bottom: 32px; 
        }
        
        .stat-card { 
            background: white; 
            padding: 24px; 
            border-radius: 16px; 
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08); 
            text-align: center; 
            transition: all 0.3s ease;
            border: 1px solid rgba(0, 0, 0, 0.05);
        }
        
        .stat-card:hover { 
            transform: translateY(-4px); 
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
        }
        
        .stat-number { 
            font-size: 2.5rem; 
            font-weight: 800; 
            margin-bottom: 8px; 
        }
        
        .stat-number.pending { color: #f39c12; }
        .stat-number.total { color: #3498db; }
        .stat-number.responded { color: #27ae60; }
        .stat-number.auto-reply { color: #9b59b6; }
        
        .stat-label {
            font-size: 0.95rem;
            font-weight: 600;
            color: #6b7280;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .filters-section { 
            background: white; 
            padding: 28px; 
            border-radius: 16px; 
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08); 
            margin-bottom: 32px; 
            border: 1px solid rgba(0, 0, 0, 0.05);
        }
        
        .filters-grid { 
            display: grid; 
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); 
            gap: 20px; 
            align-items: end; 
        }
        
        .filter-group { 
            display: flex; 
            flex-direction: column; 
        }
        
        .filter-group label { 
            font-weight: 600; 
            margin-bottom: 10px; 
            color: #374151; 
            font-size: 0.95rem;
        }
        
        .filter-group select { 
            padding: 12px 16px; 
            border: 2px solid #e5e7eb; 
            border-radius: 10px; 
            font-size: 0.95rem; 
            transition: border-color 0.2s ease;
            background: #f9fafb;
        }
        
        .filter-group select:focus {
            outline: none;
            border-color: #e67e22;
            background: white;
        }
        
        .btn { 
            padding: 12px 24px; 
            border: none; 
            border-radius: 10px; 
            font-weight: 600; 
            cursor: pointer; 
            transition: all 0.2s ease; 
            text-decoration: none; 
            display: inline-flex; 
            align-items: center; 
            gap: 8px; 
            font-size: 0.95rem;
        }
        
        .btn-primary { 
            background: linear-gradient(135deg, #e67e22 0%, #f39c12 100%); 
            color: white; 
            box-shadow: 0 2px 8px rgba(230, 126, 34, 0.3);
        }
        
        .btn-primary:hover { 
            background: linear-gradient(135deg, #d35400 0%, #e67e22 100%); 
            transform: translateY(-2px); 
            box-shadow: 0 4px 12px rgba(230, 126, 34, 0.4);
        }
        
        .contacts-table { 
            background: white; 
            border-radius: 16px; 
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08); 
            overflow: hidden; 
            border: 1px solid rgba(0, 0, 0, 0.05);
        }
        
        .table-header { 
            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%); 
            padding: 20px 28px; 
            border-bottom: 2px solid #e5e7eb; 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
        }
        
        .table-title { 
            font-size: 1.3rem; 
            font-weight: 700; 
            color: #374151; 
            margin: 0; 
        }
        
        .table-container { 
            overflow-x: auto; 
        }
        
        table { 
            width: 100%; 
            border-collapse: collapse; 
        }
        
        th, td { 
            padding: 16px 20px; 
            text-align: left; 
            border-bottom: 1px solid #e5e7eb; 
        }
        
        th { 
            background: #f9fafb; 
            font-weight: 600; 
            color: #374151; 
            font-size: 0.9rem; 
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        tr:hover { 
            background: #f8fafc; 
        }
        
        .status-badge { 
            padding: 6px 14px; 
            border-radius: 20px; 
            font-size: 0.8rem; 
            font-weight: 600; 
            text-transform: uppercase; 
            letter-spacing: 0.5px;
        }
        
        .status-pending { background: #fef3c7; color: #92400e; }
        .status-in-progress { background: #dbeafe; color: #1e40af; }
        .status-responded { background: #d1fae5; color: #065f46; }
        .status-closed { background: #f3f4f6; color: #374151; }
        
        .action-buttons { 
            display: flex; 
            gap: 8px; 
        }
        
        .btn-sm { 
            padding: 8px 14px; 
            font-size: 0.8rem; 
            border-radius: 8px;
        }
        
        .btn-view { background: #3b82f6; color: white; }
        .btn-view:hover { background: #2563eb; transform: translateY(-1px); }
        
        .btn-respond { background: #10b981; color: white; }
        .btn-respond:hover { background: #059669; transform: translateY(-1px); }
        
        .btn-close { background: #6b7280; color: white; }
        .btn-close:hover { background: #4b5563; transform: translateY(-1px); }
        
        .modal { 
            display: none; 
            position: fixed; 
            z-index: 1000; 
            left: 0; 
            top: 0; 
            width: 100%; 
            height: 100%; 
            background-color: rgba(0, 0, 0, 0.5); 
        }
        
        .modal-content { 
            background-color: white; 
            margin: 2% auto; 
            padding: 0; 
            border-radius: 16px; 
            width: 90%; 
            max-width: 800px; 
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2); 
            max-height: 90vh; 
            overflow-y: auto; 
        }
        
        .modal-header { 
            background: linear-gradient(135deg, #e67e22 0%, #f39c12 100%); 
            color: white; 
            padding: 24px; 
            border-radius: 16px 16px 0 0; 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
        }
        
        .modal-title { 
            font-size: 1.3rem; 
            font-weight: 700; 
            margin: 0; 
        }
        
        .modal-body { 
            padding: 28px; 
        }
        
        .close { 
            color: white; 
            font-size: 28px; 
            font-weight: bold; 
            cursor: pointer; 
            opacity: 0.8; 
            transition: opacity 0.2s ease;
        }
        
        .close:hover { 
            opacity: 1; 
        }
        
        .contact-details { 
            background: #f8fafc; 
            padding: 24px; 
            border-radius: 12px; 
            margin-bottom: 24px; 
            border: 1px solid #e5e7eb;
        }
        
        .detail-row { 
            display: grid; 
            grid-template-columns: 150px 1fr; 
            gap: 12px; 
            margin-bottom: 12px; 
        }
        
        .detail-label { 
            font-weight: 600; 
            color: #374151; 
        }
        
        .detail-value { 
            color: #6b7280; 
        }
        
        .message-content { 
            background: white; 
            padding: 20px; 
            border-radius: 12px; 
            border-left: 4px solid #e67e22; 
            margin: 12px 0; 
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
        }
        
        .response-form { 
            margin-top: 24px; 
        }
        
        .form-group { 
            margin-bottom: 20px; 
        }
        
        .form-group label { 
            display: block; 
            margin-bottom: 8px; 
            font-weight: 600; 
            color: #374151; 
        }
        
        .form-group textarea { 
            width: 100%; 
            padding: 16px; 
            border: 2px solid #e5e7eb; 
            border-radius: 12px; 
            font-size: 0.95rem; 
            resize: vertical; 
            min-height: 120px; 
            transition: border-color 0.2s ease;
        }
        
        .form-group textarea:focus {
            outline: none;
            border-color: #e67e22;
        }
        
        .notification { 
            position: fixed; 
            top: 20px; 
            right: 20px; 
            padding: 16px 20px; 
            border-radius: 12px; 
            color: white; 
            font-weight: 500; 
            z-index: 1001; 
            transform: translateX(400px); 
            transition: transform 0.3s ease; 
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }
        
        .notification.show { 
            transform: translateX(0); 
        }
        
        .notification.success { background: #10b981; }
        .notification.error { background: #ef4444; }
        .notification.info { background: #3b82f6; }
        
        .auto-reply-badge { 
            background: #9b59b6; 
            color: white; 
            padding: 4px 10px; 
            border-radius: 12px; 
            font-size: 0.7rem; 
            margin-left: 8px; 
            font-weight: 600;
        }
        
        @media (max-width: 768px) { 
            .main-content { 
                margin-left: 0; 
                padding: 20px; 
            } 
            .filters-grid { 
                grid-template-columns: 1fr; 
            } 
            .stats-cards { 
                grid-template-columns: 1fr; 
            }
            .modal-content { 
                width: 95%; 
                margin: 5% auto; 
            }
            .detail-row { 
                grid-template-columns: 1fr; 
                gap: 5px; 
            }
            .page-header {
                padding: 24px;
            }
            .page-title {
                font-size: 1.8rem;
            }
        }
    </style>
</head>
<body>
    <%@ include file="headerCoordinator.jsp" %>
    <%@ include file="sidebarCoordinator.jsp" %>
    
    <div class="main-content">
        <div class="page-header">
            <h1 class="page-title"><i class="fas fa-headset"></i> Trung tâm hỗ trợ khách hàng</h1>
            <p>Quản lý và phản hồi các yêu cầu liên hệ từ người dùng một cách chuyên nghiệp</p>
        </div>
        
        <div class="stats-cards">
            <div class="stat-card">
                <div class="stat-number pending">${pendingCount}</div>
                <div class="stat-label">Chờ xử lý</div>
            </div>
            <div class="stat-card">
                <div class="stat-number total">${contacts.size()}</div>
                <div class="stat-label">Tổng yêu cầu</div>
            </div>
            <div class="stat-card">
                <div class="stat-number responded">
                    <c:set var="respondedCount" value="0"/>
                    <c:forEach var="contact" items="${contacts}">
                        <c:if test="${contact.status == 'RESPONDED'}">
                            <c:set var="respondedCount" value="${respondedCount + 1}"/>
                        </c:if>
                    </c:forEach>
                    ${respondedCount}
                </div>
                <div class="stat-label">Đã phản hồi</div>
            </div>
            <div class="stat-card">
                <div class="stat-number auto-reply">
                    <c:set var="autoReplyCount" value="0"/>
                    <c:forEach var="contact" items="${contacts}">
                        <c:if test="${contact.autoReplySent}">
                            <c:set var="autoReplyCount" value="${autoReplyCount + 1}"/>
                        </c:if>
                    </c:forEach>
                    ${autoReplyCount}
                </div>
                <div class="stat-label">Phản hồi tự động</div>
            </div>
        </div>
        
        <div class="filters-section">
            <form method="GET" action="${pageContext.request.contextPath}/coordinator/contact-management">
                <div class="filters-grid">
                    <div class="filter-group">
                        <label for="status">Trạng thái:</label>
                        <select name="status" id="status">
                            <option value="">Tất cả</option>
                            <option value="PENDING" ${statusFilter == 'PENDING' ? 'selected' : ''}>Chờ xử lý</option>
                            <option value="IN_PROGRESS" ${statusFilter == 'IN_PROGRESS' ? 'selected' : ''}>Đang xử lý</option>
                            <option value="RESPONDED" ${statusFilter == 'RESPONDED' ? 'selected' : ''}>Đã phản hồi</option>
                            <option value="CLOSED" ${statusFilter == 'CLOSED' ? 'selected' : ''}>Đã đóng</option>
                        </select>
                    </div>
                    
                    <div class="filter-group">
                        <label for="issueType">Loại yêu cầu:</label>
                        <select name="issueType" id="issueType">
                            <option value="">Tất cả</option>
                            <option value="COURSE_ADVICE" ${issueTypeFilter == 'COURSE_ADVICE' ? 'selected' : ''}>Tư vấn khóa học</option>
                            <option value="TECHNICAL_ISSUE" ${issueTypeFilter == 'TECHNICAL_ISSUE' ? 'selected' : ''}>Lỗi kỹ thuật</option>
                            <option value="TUITION_SCHEDULE" ${issueTypeFilter == 'TUITION_SCHEDULE' ? 'selected' : ''}>Học phí/Lịch học</option>
                            <option value="PAYMENT_SUPPORT" ${issueTypeFilter == 'PAYMENT_SUPPORT' ? 'selected' : ''}>Hỗ trợ thanh toán</option>
                            <option value="OTHER" ${issueTypeFilter == 'OTHER' ? 'selected' : ''}>Khác</option>
                        </select>
                    </div>
                    
                    <div class="filter-group">
                        <label for="sort">Sắp xếp:</label>
                        <select name="sort" id="sort">
                            <option value="newest" ${sortBy == 'newest' ? 'selected' : ''}>Mới nhất</option>
                            <option value="oldest" ${sortBy == 'oldest' ? 'selected' : ''}>Cũ nhất</option>
                        </select>
                    </div>
                    
                    <div class="filter-group">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-filter"></i> Lọc
                        </button>
                    </div>
                </div>
            </form>
        </div>
        
        <div class="contacts-table">
            <div class="table-header">
                <h3 class="table-title">Danh sách yêu cầu liên hệ</h3>
                <button class="btn btn-primary" onclick="refreshData()">
                    <i class="fas fa-sync-alt"></i> Làm mới
                </button>
            </div>
            
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Họ tên</th>
                            <th>Email</th>
                            <th>Điện thoại</th>
                            <th>Loại yêu cầu</th>
                            <th>Trạng thái</th>
                            <th>Ngày gửi</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="contact" items="${contacts}">
                            <tr>
                                <td>
                                    ${contact.contactID}
                                    <c:if test="${contact.autoReplySent}">
                                        <span class="auto-reply-badge" title="Đã gửi phản hồi tự động">AUTO</span>
                                    </c:if>
                                </td>
                                <td>${contact.name}</td>
                                <td>${contact.email}</td>
                                <td>${contact.phone}</td>
                                <td>${contact.issueTypeDisplayName}</td>
                                <td>
                                    <span class="status-badge status-${contact.status.toLowerCase().replace('_', '-')}">
                                        ${contact.statusDisplayName}
                                    </span>
                                </td>
                                <td>
                                    <fmt:formatDate value="${contact.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <button class="btn btn-sm btn-view" onclick="viewContact('${contact.contactID}')" title="Xem chi tiết">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                        <c:if test="${contact.status == 'PENDING' || contact.status == 'IN_PROGRESS'}">
                                            <button class="btn btn-sm btn-respond" onclick="respondToContact('${contact.contactID}')" title="Phản hồi">
                                                <i class="fas fa-reply"></i>
                                            </button>
                                        </c:if>
                                        <c:if test="${contact.status != 'CLOSED'}">
                                            <button class="btn btn-sm btn-close" onclick="closeContact('${contact.contactID}')" title="Đóng yêu cầu">
                                                <i class="fas fa-times"></i>
                                            </button>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty contacts}">
                            <tr>
                                <td colspan="8" style="text-align: center; padding: 40px; color: #6b7280;">
                                    <i class="fas fa-inbox" style="font-size: 3rem; margin-bottom: 16px; opacity: 0.5;"></i>
                                    <br>Không có yêu cầu liên hệ nào
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    
    <!-- Contact Details Modal -->
    <div id="contactModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 class="modal-title">Chi tiết yêu cầu liên hệ</h2>
                <span class="close" onclick="closeModal('contactModal')">&times;</span>
            </div>
            <div class="modal-body" id="contactModalBody">
                <!-- Content will be loaded here -->
            </div>
        </div>
    </div>
    
    <!-- Response Modal -->
    <div id="responseModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 class="modal-title">Phản hồi yêu cầu</h2>
                <span class="close" onclick="closeModal('responseModal')">&times;</span>
            </div>
            <div class="modal-body">
                <div id="responseContactInfo"></div>
                <form id="responseForm" class="response-form">
                    <input type="hidden" id="responseContactId" name="contactId">
                    <div class="form-group">
                        <label for="responseText">Nội dung phản hồi:</label>
                        <textarea id="responseText" name="response" placeholder="Nhập nội dung phản hồi chi tiết cho khách hàng..." required></textarea>
                    </div>
                    <div style="display: flex; gap: 10px; justify-content: flex-end;">
                        <button type="button" class="btn" style="background: #6b7280; color: white;" onclick="closeModal('responseModal')">Hủy</button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-paper-plane"></i> Gửi phản hồi
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Confirmation Modal -->
    <div id="confirmModal" class="modal">
        <div class="modal-content" style="max-width: 500px;">
            <div class="modal-header">
                <h2 class="modal-title">
                    <i class="fas fa-exclamation-triangle" style="color: #f39c12; margin-right: 12px;"></i>
                    Xác nhận đóng yêu cầu
                </h2>
                <span class="close" onclick="closeModal('confirmModal')">&times;</span>
            </div>
            <div class="modal-body">
                <div style="text-align: center; margin-bottom: 24px;">
                    <i class="fas fa-question-circle" style="font-size: 3rem; color: #e67e22; margin-bottom: 16px;"></i>
                    <h3 style="color: #374151; margin-bottom: 12px;">Bạn có chắc chắn muốn đóng yêu cầu này?</h3>
                    <p style="color: #6b7280; line-height: 1.6;">
                        Hành động này sẽ chuyển trạng thái yêu cầu sang "Đã đóng" và không thể hoàn tác. 
                        Khách hàng sẽ không thể gửi thêm thông tin cho yêu cầu này.
                    </p>
                </div>
                
                <div id="confirmContactInfo" style="background: #f8fafc; padding: 16px; border-radius: 8px; margin-bottom: 24px; border-left: 4px solid #e67e22;">
                    <!-- Contact info will be loaded here -->
                </div>
                
                <div style="display: flex; gap: 12px; justify-content: center;">
                    <button type="button" class="btn" style="background: #6b7280; color: white; min-width: 120px;" onclick="closeModal('confirmModal')">
                        <i class="fas fa-times"></i> Hủy bỏ
                    </button>
                    <button type="button" class="btn btn-primary" id="confirmCloseBtn" style="min-width: 120px;">
                        <i class="fas fa-check"></i> Xác nhận đóng
                    </button>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        // Context path for AJAX calls
        var contextPath = '${pageContext.request.contextPath}';
        
        function showNotification(message, type) {
            type = type || 'success';
            var notification = document.createElement('div');
            notification.className = 'notification ' + type;
            
            var iconClass = 'fas fa-check-circle';
            if (type === 'error') {
                iconClass = 'fas fa-exclamation-circle';
            } else if (type === 'info') {
                iconClass = 'fas fa-info-circle';
            }
            
            notification.innerHTML = '<i class="' + iconClass + '"></i> ' + message;
            document.body.appendChild(notification);
            
            setTimeout(function() {
                notification.classList.add('show');
            }, 100);
            
            setTimeout(function() {
                notification.classList.remove('show');
                setTimeout(function() {
                    if (notification.parentNode) {
                        notification.parentNode.removeChild(notification);
                    }
                }, 300);
            }, 4000);
        }
        
        function refreshData() {
            location.reload();
        }
        
        function viewContact(contactId) {
            fetch(contextPath + '/coordinator/contact-management', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: 'action=getContactDetails&contactId=' + encodeURIComponent(contactId)
            })
            .then(function(response) {
                return response.json();
            })
            .then(function(data) {
                if (data.success) {
                    displayContactDetails(data);
                    document.getElementById('contactModal').style.display = 'block';
                } else {
                    showNotification(data.message, 'error');
                }
            })
            .catch(function(error) {
                console.error('Error:', error);
                showNotification('Có lỗi xảy ra khi tải thông tin!', 'error');
            });
        }
        
        function displayContactDetails(data) {
            var modalBody = document.getElementById('contactModalBody');
            var autoReplyBadge = data.autoReplySent ? '<span class="auto-reply-badge" title="Đã gửi phản hồi tự động">Đã gửi phản hồi tự động</span>' : '';
            var coordinatorResponseSection = '';
            
            if (data.coordinatorResponse) {
                coordinatorResponseSection = '<div>' +
                    '<h4 style="color: #27ae60; margin-bottom: 10px;">Phản hồi của coordinator:</h4>' +
                    '<div class="message-content" style="border-left-color: #27ae60;">' + 
                    data.coordinatorResponse.replace(/\n/g, '<br>') + 
                    '</div>' +
                    '</div>';
            }
            
            modalBody.innerHTML = 
                '<div class="contact-details">' +
                    '<div class="detail-row">' +
                        '<div class="detail-label">Mã yêu cầu:</div>' +
                        '<div class="detail-value">' + data.contactId + '</div>' +
                    '</div>' +
                    '<div class="detail-row">' +
                        '<div class="detail-label">Họ tên:</div>' +
                        '<div class="detail-value">' + data.name + '</div>' +
                    '</div>' +
                    '<div class="detail-row">' +
                        '<div class="detail-label">Email:</div>' +
                        '<div class="detail-value">' + data.email + '</div>' +
                    '</div>' +
                    '<div class="detail-row">' +
                        '<div class="detail-label">Điện thoại:</div>' +
                        '<div class="detail-value">' + data.phone + '</div>' +
                    '</div>' +
                    '<div class="detail-row">' +
                        '<div class="detail-label">Loại yêu cầu:</div>' +
                        '<div class="detail-value">' + data.issueTypeDisplay + '</div>' +
                    '</div>' +
                    '<div class="detail-row">' +
                        '<div class="detail-label">Trạng thái:</div>' +
                        '<div class="detail-value">' +
                            '<span class="status-badge status-' + data.status.toLowerCase().replace('_', '-') + '">' + data.statusDisplay + '</span>' +
                            autoReplyBadge +
                        '</div>' +
                    '</div>' +
                    '<div class="detail-row">' +
                        '<div class="detail-label">Thời gian gửi:</div>' +
                        '<div class="detail-value">' + data.createdAt + '</div>' +
                    '</div>' +
                '</div>' +
                '<div>' +
                    '<h4 style="color: #e67e22; margin-bottom: 10px;">Nội dung yêu cầu:</h4>' +
                    '<div class="message-content">' + data.message.replace(/\n/g, '<br>') + '</div>' +
                '</div>' +
                coordinatorResponseSection;
        }
        
        function respondToContact(contactId) {
            // First get contact details
            fetch(contextPath + '/coordinator/contact-management', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: 'action=getContactDetails&contactId=' + encodeURIComponent(contactId)
            })
            .then(function(response) {
                return response.json();
            })
            .then(function(data) {
                if (data.success) {
                    document.getElementById('responseContactId').value = contactId;
                    document.getElementById('responseContactInfo').innerHTML = 
                        '<div class="contact-details" style="margin-bottom: 20px;">' +
                            '<h4 style="color: #e67e22; margin-bottom: 15px;">Thông tin khách hàng:</h4>' +
                            '<div class="detail-row">' +
                                '<div class="detail-label">Họ tên:</div>' +
                                '<div class="detail-value">' + data.name + '</div>' +
                            '</div>' +
                            '<div class="detail-row">' +
                                '<div class="detail-label">Email:</div>' +
                                '<div class="detail-value">' + data.email + '</div>' +
                            '</div>' +
                            '<div class="detail-row">' +
                                '<div class="detail-label">Loại yêu cầu:</div>' +
                                '<div class="detail-value">' + data.issueTypeDisplay + '</div>' +
                            '</div>' +
                            '<div>' +
                                '<div class="detail-label" style="margin-bottom: 10px;">Nội dung yêu cầu:</div>' +
                                '<div class="message-content">' + data.message.replace(/\n/g, '<br>') + '</div>' +
                            '</div>' +
                        '</div>';
                    document.getElementById('responseText').value = '';
                    document.getElementById('responseModal').style.display = 'block';
                } else {
                    showNotification(data.message, 'error');
                }
            })
            .catch(function(error) {
                console.error('Error:', error);
                showNotification('Có lỗi xảy ra!', 'error');
            });
        }
        
        function closeContact(contactId) {
            // First get contact details to display in confirmation modal
            fetch(contextPath + '/coordinator/contact-management', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: 'action=getContactDetails&contactId=' + encodeURIComponent(contactId)
            })
            .then(function(response) {
                return response.json();
            })
            .then(function(data) {
                if (data.success) {
                    // Display contact info in confirmation modal
                    document.getElementById('confirmContactInfo').innerHTML = 
                        '<div class="detail-row">' +
                            '<div class="detail-label">Mã yêu cầu:</div>' +
                            '<div class="detail-value">' + data.contactId + '</div>' +
                        '</div>' +
                        '<div class="detail-row">' +
                            '<div class="detail-label">Họ tên:</div>' +
                            '<div class="detail-value">' + data.name + '</div>' +
                        '</div>' +
                        '<div class="detail-row">' +
                            '<div class="detail-label">Email:</div>' +
                            '<div class="detail-value">' + data.email + '</div>' +
                        '</div>' +
                        '<div class="detail-row">' +
                            '<div class="detail-label">Loại yêu cầu:</div>' +
                            '<div class="detail-value">' + data.issueTypeDisplay + '</div>' +
                        '</div>' +
                        '<div class="detail-row">' +
                            '<div class="detail-label">Nội dung yêu cầu:</div>' +
                            '<div class="detail-value" style="max-height: 100px; overflow-y: auto;">' + 
                                data.message.replace(/\n/g, '<br>') + 
                            '</div>' +
                        '</div>';
                    
                    // Store contactId for confirmation
                    document.getElementById('confirmCloseBtn').setAttribute('data-contact-id', contactId);
                    
                    // Show confirmation modal
                    document.getElementById('confirmModal').style.display = 'block';
                } else {
                    showNotification(data.message, 'error');
                }
            })
            .catch(function(error) {
                console.error('Error:', error);
                showNotification('Có lỗi xảy ra!', 'error');
            });
        }
        
        function closeModal(modalId) {
            document.getElementById(modalId).style.display = 'none';
        }
        
        // Close modal when clicking outside
        window.onclick = function(event) {
            var modals = document.querySelectorAll('.modal');
            for (var i = 0; i < modals.length; i++) {
                if (event.target === modals[i]) {
                    modals[i].style.display = 'none';
                }
            }
        };
        
        // Handle response form submission
        document.getElementById('responseForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            var contactId = document.getElementById('responseContactId').value;
            var response = document.getElementById('responseText').value.trim();
            
            if (!response) {
                showNotification('Vui lòng nhập nội dung phản hồi!', 'error');
                return;
            }
            
            // Disable submit button
            var submitBtn = this.querySelector('button[type="submit"]');
            var originalText = submitBtn.innerHTML;
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang gửi...';
            
            fetch(contextPath + '/coordinator/contact-management', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: 'action=sendResponse&contactId=' + encodeURIComponent(contactId) + '&response=' + encodeURIComponent(response)
            })
            .then(function(response) {
                return response.json();
            })
            .then(function(data) {
                if (data.success) {
                    showNotification('Đã gửi phản hồi thành công! Email đã được gửi đến khách hàng.', 'success');
                    closeModal('responseModal');
                    setTimeout(function() {
                        location.reload();
                    }, 1500);
                } else {
                    showNotification(data.message, 'error');
                }
            })
            .catch(function(error) {
                console.error('Error:', error);
                showNotification('Có lỗi xảy ra khi gửi phản hồi!', 'error');
            })
            .finally(function() {
                // Re-enable submit button
                submitBtn.disabled = false;
                submitBtn.innerHTML = originalText;
            });
        });

        // Handle confirmation modal close button
        document.getElementById('confirmCloseBtn').addEventListener('click', function() {
            var contactId = this.getAttribute('data-contact-id');
            
            // Disable button to prevent double-click
            this.disabled = true;
            this.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
            
            fetch(contextPath + '/coordinator/contact-management', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: 'action=updateStatus&contactId=' + encodeURIComponent(contactId) + '&status=CLOSED'
            })
            .then(function(response) {
                return response.json();
            })
            .then(function(data) {
                if (data.success) {
                    showNotification('Đã đóng yêu cầu thành công!', 'success');
                    closeModal('confirmModal');
                    setTimeout(function() {
                        location.reload();
                    }, 1500);
                } else {
                    showNotification(data.message, 'error');
                }
            })
            .catch(function(error) {
                console.error('Error:', error);
                showNotification('Có lỗi xảy ra khi đóng yêu cầu!', 'error');
            })
            .finally(function() {
                // Re-enable button
                var btn = document.getElementById('confirmCloseBtn');
                btn.disabled = false;
                btn.innerHTML = '<i class="fas fa-check"></i> Xác nhận đóng';
            });
        });
        
        // Auto-refresh every 5 minutes to check for new contacts
        setInterval(function() {
            var currentPendingCount = ${pendingCount};
            fetch(contextPath + '/coordinator/contact-management?ajax=true')
            .then(function(response) {
                return response.text();
            })
            .then(function(html) {
                var parser = new DOMParser();
                var doc = parser.parseFromString(html, 'text/html');
                var newPendingElement = doc.querySelector('.stat-number.pending');
                if (newPendingElement) {
                    var newPendingCount = parseInt(newPendingElement.textContent);
                    if (newPendingCount > currentPendingCount) {
                        showNotification('Có ' + (newPendingCount - currentPendingCount) + ' yêu cầu mới!', 'info');
                        // Update the pending count display
                        document.querySelector('.stat-number.pending').textContent = newPendingCount;
                    }
                }
            })
            .catch(function(error) {
                console.log('Auto-refresh failed:', error);
            });
        }, 300000); // 5 minutes
    </script>
</body>
</html>
