<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lỗi - Admin Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/mainDashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .error-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            text-align: center;
            padding: 20px;
        }
        
        .error-icon {
            font-size: 5rem;
            color: #e74c3c;
            margin-bottom: 20px;
        }
        
        .error-title {
            font-size: 2rem;
            color: #34495e;
            margin-bottom: 15px;
        }
        
        .error-message {
            font-size: 1.1rem;
            color: #666;
            margin-bottom: 30px;
            max-width: 600px;
        }
        
        .error-actions {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            justify-content: center;
        }
        
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .btn-primary {
            background: #4a90e2;
            color: white;
        }
        
        .btn-primary:hover {
            background: #357abd;
            color: white;
        }
        
        .btn-secondary {
            background: #95a5a6;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #7f8c8d;
            color: white;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <i class="fas fa-exclamation-triangle error-icon"></i>
        <h1 class="error-title">Đã xảy ra lỗi</h1>
        <p class="error-message">
            <c:choose>
                <c:when test="${not empty error}">
                    ${error}
                </c:when>
                <c:otherwise>
                    Xin lỗi, đã xảy ra lỗi không mong muốn. Vui lòng thử lại sau.
                </c:otherwise>
            </c:choose>
        </p>
        
        <div class="error-actions">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-primary">
                <i class="fas fa-home"></i> Về Dashboard
            </a>
            <button onclick="history.back()" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> Quay lại
            </button>
            <button onclick="location.reload()" class="btn btn-secondary">
                <i class="fas fa-refresh"></i> Tải lại
            </button>
        </div>
    </div>
</body>
</html>
