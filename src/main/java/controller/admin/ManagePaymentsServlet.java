package controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.admin.Payment;
import model.UserAccount;
import service.PaymentService;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

@WebServlet("/admin/payments")
public class ManagePaymentsServlet extends HttpServlet {
    private final PaymentService paymentService = new PaymentService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Check admin permission
        UserAccount currentUser = (UserAccount) req.getSession().getAttribute("user");
        if (currentUser == null || !"Admin".equals(currentUser.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        
        try {
            if ("view".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                Payment payment = paymentService.getPaymentById(id);
                
                if (payment == null) {
                    resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    return;
                }
                
                // Return JSON response for AJAX
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                
                StringBuilder json = new StringBuilder();
                json.append("{");
                json.append("\"id\":").append(payment.getId()).append(",");
                json.append("\"studentName\":\"").append(payment.getStudentName()).append("\",");
                json.append("\"courseName\":\"").append(payment.getCourseName()).append("\",");
                json.append("\"amount\":").append(payment.getAmount()).append(",");
                json.append("\"paymentStatus\":\"").append(payment.getPaymentStatus()).append("\",");
                json.append("\"paymentMethod\":\"").append(payment.getPaymentMethod()).append("\",");
                json.append("\"paymentDate\":\"").append(payment.getPaymentDate()).append("\",");
                json.append("\"transactionID\":\"").append(payment.getTransactionID() != null ? payment.getTransactionID() : "").append("\"");
                json.append("}");
                
                resp.getWriter().write(json.toString());
                return;
            } else if ("filter".equals(action)) {
                String status = req.getParameter("status");
                List<Payment> payments = paymentService.getPaymentsByStatus(status);
                req.setAttribute("payments", payments);
                req.getRequestDispatcher("/view/admin/managePayments.jsp").forward(req, resp);
            } else {
                // Get filter parameters
                String status = req.getParameter("status");
                String search = req.getParameter("search");
                String pageStr = req.getParameter("page");
                
                int page = 1;
                if (pageStr != null) {
                    try { 
                        page = Integer.parseInt(pageStr); 
                        if (page < 1) page = 1;
                    } catch (NumberFormatException ignored) {}
                }
                
                List<Payment> payments;
                if (status != null && !status.trim().isEmpty()) {
                    payments = paymentService.getPaymentsByStatus(status);
                } else {
                    payments = paymentService.getAllPayments();
                }
                
                // Apply search filter if provided
                if (search != null && !search.trim().isEmpty()) {
                    payments = payments.stream()
                        .filter(p -> p.getStudentName().toLowerCase().contains(search.toLowerCase()) ||
                               String.valueOf(p.getId()).contains(search))
                        .collect(java.util.stream.Collectors.toList());
                }
                
                // Pagination
                int pageSize = 10;
                int totalPayments = payments.size();
                int totalPages = (int) Math.ceil((double) totalPayments / pageSize);
                
                int startIndex = (page - 1) * pageSize;
                int endIndex = Math.min(startIndex + pageSize, totalPayments);
                
                if (startIndex < totalPayments) {
                    payments = payments.subList(startIndex, endIndex);
                } else {
                    payments = new ArrayList<>();
                }
                
                req.setAttribute("payments", payments);
                req.setAttribute("currentPage", page);
                req.setAttribute("totalPages", totalPages);
                req.setAttribute("totalPayments", totalPayments);
                req.setAttribute("status", status);
                req.setAttribute("search", search);
                
                req.getRequestDispatcher("/view/admin/managePayments.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/view/admin/error.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Check admin permission
        UserAccount currentUser = (UserAccount) req.getSession().getAttribute("user");
        if (currentUser == null || !"Admin".equals(currentUser.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        
        try {
            if ("updateStatus".equals(action)) {
                int paymentId = Integer.parseInt(req.getParameter("paymentId"));
                String status = req.getParameter("status");
                
                paymentService.updatePaymentStatus(paymentId, status);
                resp.sendRedirect(req.getContextPath() + "/admin/payments?message=Cập nhật thành công");
            }
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/admin/payments?error=" + e.getMessage());
        }
    }
}
