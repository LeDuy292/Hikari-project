<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Lịch sử mua hàng - Học Tiếng Nhật Online</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: #f5f5f5; padding: 20px; }
        .container { max-width: 1400px; margin: 0 auto; }
        .back-btn { display: inline-flex; align-items: center; gap: 8px; padding: 10px 16px; background: #ff6b35; color: white; text-decoration: none; border-radius: 8px; font-weight: 500; margin-bottom: 20px; font-size: 14px; transition: background 0.2s ease; }
        .back-btn:hover { background: #e55a2b; }
        .tab-navigation { display: flex; background: white; border-radius: 12px; box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1); margin-bottom: 20px; overflow: hidden; }
        .tab-btn { flex: 1; padding: 16px 20px; background: none; border: none; font-size: 14px; font-weight: 500; color: #666; cursor: pointer; transition: all 0.2s ease; display: flex; align-items: center; justify-content: center; gap: 8px; }
        .tab-btn.active { background: #ff6b35; color: white; }
        .tab-btn:hover:not(.active) { background: #f8f9fa; color: #333; }
        .main-grid { display: grid; grid-template-columns: 1fr 350px; gap: 20px; }
        @media (max-width: 1024px) { .main-grid { grid-template-columns: 1fr; } }
        .profile-card { background: white; border-radius: 12px; box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1); overflow: hidden; }
        .profile-header { background: #ff6b35; padding: 30px; text-align: center; color: white; }
        .profile-title { font-size: 20px; font-weight: 600; margin: 0; }
        .profile-content { padding: 20px; }
        .filter-section { margin-bottom: 20px; }
        .filter-form { display: flex; gap: 10px; flex-wrap: wrap; }
        .filter-input { padding: 8px; border: 1px solid #e9ecef; border-radius: 8px; font-size: 14px; }
        .filter-btn { padding: 8px 16px; background: #ff6b35; color: white; border: none; border-radius: 8px; cursor: pointer; transition: background 0.2s ease; }
        .filter-btn:hover { background: #e55a2b; }
        .payment-table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
        .payment-table th, .payment-table td { padding: 12px; text-align: left; border-bottom: 1px solid #e9ecef; }
        .payment-table th { background: #f8f9fa; font-weight: 600; color: #333; }
        .payment-table td { color: #666; }
        .payment-table .status { padding: 4px 8px; border-radius: 12px; font-size: 12px; font-weight: 500; }
        .payment-table .status.Pending { background: #fff3cd; color: #856404; }
        .payment-table .status.Complete { background: #d4edda; color: #155724; }
        .payment-table .status.Cancel { background: #f8d7da; color: #721c24; }
        .pagination { display: flex; justify-content: center; gap: 8px; margin-top: 20px; }
        .pagination-btn { padding: 8px 12px; border: 1px solid #e9ecef; background: white; border-radius: 8px; cursor: pointer; transition: all 0.2s ease; }
        .pagination-btn.active, .pagination-btn:hover { background: #ff6b35; color: white; border-color: #ff6b35; }
        .sidebar { display: flex; flex-direction: column; gap: 16px; }
        .sidebar-card { background: white; border-radius: 12px; box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1); overflow: hidden; }
        .card-header { padding: 16px; color: white; display: flex; align-items: center; gap: 8px; }
        .card-header.stats { background: #ff6b35; }
        .card-header h3 { font-size: 16px; font-weight: 600; margin: 0; }
        .card-content { padding: 16px; }
        .stat-item { text-align: center; padding: 12px; background: #f8f9fa; border-radius: 8px; margin-bottom: 12px; }
        .stat-number { font-size: 24px; font-weight: 700; margin-bottom: 4px; color: #ff6b35; }
        .stat-label { font-size: 12px; color: #666; }
        .message { margin-top: 12px; padding: 12px; border-radius: 6px; text-align: center; font-size: 14px; font-weight: 500; }
        .message.error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
    </style>
</head>
<body>
    <div class="container">
        <a href="${pageContext.request.contextPath}/view/student/home.jsp" class="back-btn">
            <i class="fas fa-arrow-left"></i>
            Trang chủ
        </a>

        <div class="tab-navigation">
            <button class="tab-btn active" onclick="window.location.href='${pageContext.request.contextPath}/view/authentication/profile.jsp'">
                <i class="fas fa-user"></i>
                Thông tin cá nhân
            </button>
            <button class="tab-btn" onclick="window.location.href='${pageContext.request.contextPath}/profile/myCourses'">
                <i class="fas fa-book"></i>
                Khóa học của tôi 
            </button>
            <button class="tab-btn" onclick="window.location.href='${pageContext.request.contextPath}/profile/paymentHistory'">
                <i class="fas fa-credit-card"></i>
                Lịch sử mua hàng
            </button>
        </div>

        <div class="main-grid">
            <div class="profile-card">
                <div class="profile-header">
                    <h1 class="profile-title">Lịch sử mua hàng</h1>
                </div>
                <div class="profile-content">
                    <c:if test="${not empty error}">
                        <div class="message error">${error}</div>
                    </c:if>

                    <c:if test="${empty error}">
                        <div class="filter-section">
                            <form class="filter-form" action="${pageContext.request.contextPath}/profile/paymentHistory" method="get">
                                <select name="status" class="filter-input">
                                    <option value="" ${empty status ? 'selected' : ''}>Tất cả trạng thái</option>
                                    <option value="Complete" ${status == 'Complete' ? 'selected' : ''}>Hoàn thành</option>
                                    <option value="Pending" ${status == 'Pending' ? 'selected' : ''}>Đang chờ</option>
                                    <option value="Cancel" ${status == 'Cancel' ? 'selected' : ''}>Hủy</option>
                                </select>
                                <input type="date" name="date" class="filter-input" value="${not empty date ? date : ''}">
                                <input type="number" name="minAmount" class="filter-input" placeholder="Số tiền tối thiểu" value="${not empty minAmount ? minAmount : ''}">
                                <input type="number" name="maxAmount" class="filter-input" placeholder="Số tiền tối đa" value="${not empty maxAmount ? maxAmount : ''}">
                                <select name="sortBy" class="filter-input">
                                    <option value="date_DESC" ${sortBy == 'date_DESC' ? 'selected' : ''}>Ngày (mới nhất)</option>
                                    <option value="date_ASC" ${sortBy == 'date_ASC' ? 'selected' : ''}>Ngày (cũ nhất)</option>
                                    <option value="amount_ASC" ${sortBy == 'amount_ASC' ? 'selected' : ''}>Số tiền (tăng dần)</option>
                                    <option value="amount_DESC" ${sortBy == 'amount_DESC' ? 'selected' : ''}>Số tiền (giảm dần)</option>
                                </select>
                                <button type="submit" class="filter-btn">Lọc</button>
                                <button type="button" class="filter-btn" onclick="window.location.href='${pageContext.request.contextPath}/profile/paymentHistory'">Đặt lại</button>
                            </form>
                        </div>

                        <table class="payment-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Khóa học</th>
                                    <th>Số tiền</th>
                                    <th>Phương thức</th>
                                    <th>Trạng thái</th>
                                    <th>Ngày thanh toán</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty payments}">
                                        <tr>
                                            <td colspan="6" style="text-align: center;">Không có thanh toán nào.</td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="payment" items="${payments}">
                                            <tr>
                                                <td>${payment.id}</td>
                                                <td>${payment.courseName != null ? payment.courseName : 'Chưa xác định'}</td>
                                                <td><fmt:formatNumber value="${payment.amount}" type="currency" currencyCode="VND" minFractionDigits="0"/></td>
                                                <td>${payment.paymentMethod != null ? payment.paymentMethod : 'Chưa xác định'}</td>
                                                <td><span class="status ${payment.paymentStatus}">${payment.paymentStatus}</span></td>
                                                <td><fmt:formatDate value="${payment.paymentDate}" pattern="dd/MM/yyyy" /></td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>

                        <div class="pagination">
                            <c:if test="${currentPage > 1}">
                                <button class="pagination-btn" onclick="window.location.href='${pageContext.request.contextPath}/profile/paymentHistory?page=${currentPage - 1}&status=${not empty status ? status : ''}&date=${not empty date ? date : ''}&minAmount=${not empty minAmount ? minAmount : ''}&maxAmount=${not empty maxAmount ? maxAmount : ''}&sortBy=${not empty sortBy ? sortBy : 'date_DESC'}'">Trước</button>
                            </c:if>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <button class="pagination-btn ${currentPage == i ? 'active' : ''}" onclick="window.location.href='${pageContext.request.contextPath}/profile/paymentHistory?page=${i}&status=${not empty status ? status : ''}&date=${not empty date ? date : ''}&minAmount=${not empty minAmount ? minAmount : ''}&maxAmount=${not empty maxAmount ? maxAmount : ''}&sortBy=${not empty sortBy ? sortBy : 'date_DESC'}'">${i}</button>
                            </c:forEach>
                            <c:if test="${currentPage < totalPages}">
                                <button class="pagination-btn" onclick="window.location.href='${pageContext.request.contextPath}/profile/paymentHistory?page=${currentPage + 1}&status=${not empty status ? status : ''}&date=${not empty date ? date : ''}&minAmount=${not empty minAmount ? minAmount : ''}&maxAmount=${not empty maxAmount ? maxAmount : ''}&sortBy=${not empty sortBy ? sortBy : 'date_DESC'}'">Sau</button>
                            </c:if>
                        </div>
                    </c:if>
                </div>
            </div>

            <div class="sidebar">
                <div class="sidebar-card">
                    <div class="card-header stats">
                        <i class="fas fa-credit-card"></i>
                        <div>
                            <h3>Thống kê thanh toán</h3>
                        </div>
                    </div>
                    <div class="card-content">
                        <div class="stat-item">
                            <div class="stat-number">${totalPayments}</div>
                            <div class="stat-label">Tổng số thanh toán</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-number"><fmt:formatNumber value="${totalSpent}" type="currency" currencyCode="VND" minFractionDigits="0"/></div>
                            <div class="stat-label">Tổng tiền đã thanh toán</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>