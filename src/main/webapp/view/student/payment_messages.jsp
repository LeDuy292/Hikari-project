<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:if test="${not empty requestScope.success}">
    <div class="message success">
        <c:choose>
            <c:when test="${requestScope.success == 'payment_completed'}">
                Thanh toán thành công! Các khóa h?c ?ã ???c ghi danh thành công. C?m ?n b?n! Mã giao d?ch: ${requestScope.transactionID}
            </c:when>
            <c:otherwise>
                Thanh toán thành công! Các khóa h?c ?ã ???c thêm vào tài kho?n c?a b?n.
            </c:otherwise>
        </c:choose>
    </div>
</c:if>
<c:if test="${not empty requestScope.error}">
    <div class="message error">
        <c:choose>
            <c:when test="${requestScope.error == 'empty_cart'}">
                Gi? hàng tr?ng. Vui lòng thêm khóa h?c tr??c khi thanh toán.
            </c:when>
            <c:when test="${requestScope.error == 'payment_failed'}">
                Thanh toán that b?i do l?i h? th?ng : ${requestScope.errorMessage}. Mã giao dich: ${requestScope.transactionID}. Vui lòng th?  l?i ho?c liên h? h? tr?.
            </c:when>
            <c:when test="${requestScope.error == 'payment_cancelled'}">
                Thanh toán ?ã b? h?y. Vui lòng ki?m tra l?i ho?c th? thanh toán m?i. Mã giao d?ch: ${requestScope.transactionID}
            </c:when>
            <c:when test="${requestScope.error == 'partial_enrollment'}">
                <c:choose>
                    <c:when test="${not empty requestScope.failedCourses}">
                        Không th? ??ng ký các khóa h?c: ${requestScope.failedCourses}. Vui lòng liên h? h? tr?. Mã giao d?ch: ${requestScope.transactionID}
                    </c:when>
                    <c:otherwise>
                        Có l?i khi ??ng ký m?t s? khóa h?c. Vui lòng liên h? h? tr?. Mã giao d?ch: ${requestScope.transactionID}
                    </c:otherwise>
                </c:choose>
            </c:when>
            <c:when test="${requestScope.error == 'invalid_session'}">
                Phiên ??ng nh?p không h?p l?. Vui lòng ??ng nh?p l?i.
            </c:when>
            <c:when test="${requestScope.error == 'payment_error'}">
                ?ã x?y ra l?i trong quá trình thanh toán. Mã giao d?ch: ${requestScope.transactionID}. Vui lòng th? l?i sau.
            </c:when>
            <c:when test="${requestScope.error == 'invalid_request'}">
                Yêu c?u không h?p l?. Vui lòng ki?m tra l?i thông tin.
            </c:when>
            <c:when test="${requestScope.error == 'unknown_status'}">
                Tr?ng thái thanh toán không xác ??nh: ${requestScope.errorMessage}. Vui lòng liên h? h? tr?. Mã giao d?ch: ${requestScope.transactionID}
            </c:when>
            <c:when test="${requestScope.error == 'cart_clear_failed'}">
                Thanh toán thành công nh?ng không th? xóa gi? hàng. Vui lòng liên h? h? tr?. Mã giao d?ch: ${requestScope.transactionID}
            </c:when>
            <c:when test="${requestScope.error == 'database_error'}">
                L?i c? s? d? li?u: ${requestScope.errorMessage}. Vui lòng liên h? h? tr?. Mã giao d?ch: ${requestScope.transactionID}
            </c:when>
            <c:otherwise>
                Có l?i x?y ra: ${requestScope.errorMessage}. Vui lòng liên h? h? tr?. Mã giao d?ch: ${requestScope.transactionID}
            </c:otherwise>
        </c:choose>
    </div>
</c:if>