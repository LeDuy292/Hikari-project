<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Kết quả thanh toán</title>
</head>
<body>
    <h2>Kết quả thanh toán</h2>
    <%@ include file="payment_messages.jsp" %>
    <a href="${pageContext.request.contextPath}/view/student/shopping_cart.jsp">Quay lại giỏ hàng</a>
</body>
</html>