package controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.admin.Payment;
import service.PaymentService;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/payments")
public class ManagePaymentsServlet extends HttpServlet {
    private final PaymentService paymentService = new PaymentService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        
        try {
            if ("view".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                Payment payment = paymentService.getPaymentById(id);
                req.setAttribute("payment", payment);
                req.getRequestDispatcher("/view/admin/viewPayment.jsp").forward(req, resp);
            } else if ("filter".equals(action)) {
                String status = req.getParameter("status");
                List<Payment> payments = paymentService.getPaymentsByStatus(status);
                req.setAttribute("payments", payments);
                req.getRequestDispatcher("/view/admin/managePayments.jsp").forward(req, resp);
            } else {
                List<Payment> payments = paymentService.getAllPayments();
                req.setAttribute("payments", payments);
                req.getRequestDispatcher("/view/admin/managePayments.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/view/admin/error.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        
        try {
            if ("updateStatus".equals(action)) {
                int paymentId = Integer.parseInt(req.getParameter("paymentId"));
                String status = req.getParameter("status");
                
                paymentService.updatePaymentStatus(paymentId, status);
                resp.sendRedirect(req.getContextPath() + "/admin/payments?message=Cập nhật thành công");
            }
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/view/admin/error.jsp").forward(req, resp);
        }
    }
}
