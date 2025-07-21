<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:if test="${not empty requestScope.success}">
    <div class="message success">
        <c:choose>
            <c:when test="${requestScope.success == 'payment_completed'}">
                Thanh to�n th�nh c�ng! C�c kh�a h?c ?� ???c ghi danh th�nh c�ng. C?m ?n b?n! M� giao d?ch: ${requestScope.transactionID}
            </c:when>
            <c:otherwise>
                Thanh to�n th�nh c�ng! C�c kh�a h?c ?� ???c th�m v�o t�i kho?n c?a b?n.
            </c:otherwise>
        </c:choose>
    </div>
</c:if>
<c:if test="${not empty requestScope.error}">
    <div class="message error">
        <c:choose>
            <c:when test="${requestScope.error == 'empty_cart'}">
                Gi? h�ng tr?ng. Vui l�ng th�m kh�a h?c tr??c khi thanh to�n.
            </c:when>
            <c:when test="${requestScope.error == 'payment_failed'}">
                Thanh to�n that b?i do l?i h? th?ng : ${requestScope.errorMessage}. M� giao dich: ${requestScope.transactionID}. Vui l�ng th?  l?i ho?c li�n h? h? tr?.
            </c:when>
            <c:when test="${requestScope.error == 'payment_cancelled'}">
                Thanh to�n ?� b? h?y. Vui l�ng ki?m tra l?i ho?c th? thanh to�n m?i. M� giao d?ch: ${requestScope.transactionID}
            </c:when>
            <c:when test="${requestScope.error == 'partial_enrollment'}">
                <c:choose>
                    <c:when test="${not empty requestScope.failedCourses}">
                        Kh�ng th? ??ng k� c�c kh�a h?c: ${requestScope.failedCourses}. Vui l�ng li�n h? h? tr?. M� giao d?ch: ${requestScope.transactionID}
                    </c:when>
                    <c:otherwise>
                        C� l?i khi ??ng k� m?t s? kh�a h?c. Vui l�ng li�n h? h? tr?. M� giao d?ch: ${requestScope.transactionID}
                    </c:otherwise>
                </c:choose>
            </c:when>
            <c:when test="${requestScope.error == 'invalid_session'}">
                Phi�n ??ng nh?p kh�ng h?p l?. Vui l�ng ??ng nh?p l?i.
            </c:when>
            <c:when test="${requestScope.error == 'payment_error'}">
                ?� x?y ra l?i trong qu� tr�nh thanh to�n. M� giao d?ch: ${requestScope.transactionID}. Vui l�ng th? l?i sau.
            </c:when>
            <c:when test="${requestScope.error == 'invalid_request'}">
                Y�u c?u kh�ng h?p l?. Vui l�ng ki?m tra l?i th�ng tin.
            </c:when>
            <c:when test="${requestScope.error == 'unknown_status'}">
                Tr?ng th�i thanh to�n kh�ng x�c ??nh: ${requestScope.errorMessage}. Vui l�ng li�n h? h? tr?. M� giao d?ch: ${requestScope.transactionID}
            </c:when>
            <c:when test="${requestScope.error == 'cart_clear_failed'}">
                Thanh to�n th�nh c�ng nh?ng kh�ng th? x�a gi? h�ng. Vui l�ng li�n h? h? tr?. M� giao d?ch: ${requestScope.transactionID}
            </c:when>
            <c:when test="${requestScope.error == 'database_error'}">
                L?i c? s? d? li?u: ${requestScope.errorMessage}. Vui l�ng li�n h? h? tr?. M� giao d?ch: ${requestScope.transactionID}
            </c:when>
            <c:otherwise>
                C� l?i x?y ra: ${requestScope.errorMessage}. Vui l�ng li�n h? h? tr?. M� giao d?ch: ${requestScope.transactionID}
            </c:otherwise>
        </c:choose>
    </div>
</c:if>