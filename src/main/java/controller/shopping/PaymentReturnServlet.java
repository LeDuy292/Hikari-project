package controller.shopping;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
@WebServlet("/payment/return")
public class PaymentReturnServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(PaymentReturnServlet.class);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String code = request.getParameter("code");
        String id = request.getParameter("id");
        String cancel = request.getParameter("cancel");
        String status = request.getParameter("status");
        String orderCode = request.getParameter("orderCode");

        logger.info("Return request: code={}, id={}, cancel={}, status={}, orderCode={}",
                    code, id, cancel, status, orderCode);

        // Map PAID to Complete
        String normalizedStatus = "PAID".equalsIgnoreCase(status) ? "Complete" : status;

        if (status == null || orderCode == null) {
            request.setAttribute("error", "invalid_request");
        } else if ("Complete".equalsIgnoreCase(normalizedStatus) && "00".equals(code)) {
            request.setAttribute("success", "payment_completed");
            request.setAttribute("db_updated", "true");
        } else if ("CANCELLED".equalsIgnoreCase(normalizedStatus) || "true".equalsIgnoreCase(cancel)) {
            request.setAttribute("error", "payment_cancelled");
            request.setAttribute("transactionID", id);
        } else {
            request.setAttribute("error", "unknown_status");
            request.setAttribute("transactionID", id);
        }

        request.getRequestDispatcher("/view/student/shopping_cart.jsp").forward(request, response);
    }
}