package controller.admin;

import model.UserAccount;
import model.admin.Payment;
import service.PaymentService;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import java.util.logging.Level;

@WebServlet("/admin/payments")
public class ManagePaymentsServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ManagePaymentsServlet.class.getName());
    private final PaymentService paymentService = new PaymentService();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        UserAccount currentUser = (UserAccount) req.getSession().getAttribute("user");
        if (currentUser == null || !currentUser.getRole().equals("Admin")) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");

        try {
            if ("view".equals(action)) {
                int id = parseIntOrDefault(req.getParameter("id"), -1);
                if (id == -1) {
                    resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid payment ID");
                    return;
                }
                Payment payment = paymentService.getPaymentById(id);
                if (payment == null) {
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Payment not found");
                    return;
                }
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                resp.getWriter().write(gson.toJson(payment));
                return;
            }

            String status = req.getParameter("status");
            String search = req.getParameter("search");
            String date = req.getParameter("date");
            String minAmountStr = req.getParameter("minAmount");
            String maxAmountStr = req.getParameter("maxAmount");
            String sortBy = req.getParameter("sortBy");
            int page = parseIntOrDefault(req.getParameter("page"), 1);
            int pageSize = 9; // Fixed to 9 payments per page

            double minAmount = parseDoubleOrDefault(minAmountStr, 0.0);
            double maxAmount = parseDoubleOrDefault(maxAmountStr, Double.MAX_VALUE);
            if (minAmount < 0 || maxAmount < minAmount) {
                resp.sendRedirect(req.getContextPath() + "/admin/payments?error=Invalid amount range");
                return;
            }

            List<Payment> payments = paymentService.getPaymentsWithFilters(status, search, date, minAmountStr, maxAmountStr, sortBy, page, pageSize);
            int totalPayments = paymentService.countPaymentsWithFilters(status, search, date, minAmountStr, maxAmountStr);
            int totalPages = (int) Math.ceil((double) totalPayments / pageSize);
            page = Math.max(1, Math.min(page, totalPages));

            req.setAttribute("payments", payments);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("totalPayments", totalPayments);
            req.setAttribute("status", status);
            req.setAttribute("search", search);
            req.setAttribute("date", date);
            req.setAttribute("minAmount", minAmountStr);
            req.setAttribute("maxAmount", maxAmountStr);
            req.setAttribute("sortBy", sortBy);

            req.getRequestDispatcher("/view/admin/managePayments.jsp").forward(req, resp);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in GET request: " + e.getMessage(), e);
            req.setAttribute("error", "An error occurred while processing your request.");
            req.getRequestDispatcher("/view/admin/error.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        UserAccount currentUser = (UserAccount) req.getSession().getAttribute("user");
        if (currentUser == null || !currentUser.getRole().equals("Admin")) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");

        try {
            if ("updateStatus".equals(action)) {
                int paymentId = parseIntOrDefault(req.getParameter("paymentId"), -1);
                String status = req.getParameter("status");
                if (paymentId == -1 || status == null || status.trim().isEmpty()) {
                    resp.sendRedirect(req.getContextPath() + "/admin/payments?error=Invalid parameters");
                    return;
                }
                paymentService.updatePaymentStatus(paymentId, status);
                resp.sendRedirect(req.getContextPath() + "/admin/payments?message=Cập nhật trạng thái thành công");
            } else if ("bulkUpdateStatus".equals(action)) {
                String[] paymentIds = req.getParameterValues("paymentIds");
                String status = req.getParameter("bulkStatus");
                if (paymentIds == null || paymentIds.length == 0 || status == null || status.trim().isEmpty()) {
                    resp.sendRedirect(req.getContextPath() + "/admin/payments?error=Invalid parameters");
                    return;
                }
                for (String idStr : paymentIds) {
                    int paymentId = parseIntOrDefault(idStr, -1);
                    if (paymentId != -1) {
                        paymentService.updatePaymentStatus(paymentId, status);
                    }
                }
                resp.sendRedirect(req.getContextPath() + "/admin/payments?message=Cập nhật hàng loạt thành công");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/payments?error=Invalid action");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in POST request: " + e.getMessage(), e);
            resp.sendRedirect(req.getContextPath() + "/admin/payments?error=An error occurred");
        }
    }

    private int parseIntOrDefault(String value, int defaultValue) {
        try {
            return value != null && !value.trim().isEmpty() ? Integer.parseInt(value) : defaultValue;
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid number format: " + value, e);
            return defaultValue;
        }
    }

    private double parseDoubleOrDefault(String value, double defaultValue) {
        try {
            return value != null && !value.trim().isEmpty() ? Double.parseDouble(value) : defaultValue;
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid number format: " + value, e);
            return defaultValue;
        }
    }
}