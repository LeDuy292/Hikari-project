package controller.shopping;

import dao.student.CourseEnrollmentDAO;
import model.Course;
import model.UserAccount;
import model.admin.Payment;
import service.PaymentService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/myCourses")
public class MyCourseServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(MyCourseServlet.class);
    private CourseEnrollmentDAO courseEnrollmentDAO;
    private PaymentService paymentService;

    @Override
    public void init() throws ServletException {
        courseEnrollmentDAO = new CourseEnrollmentDAO();
        paymentService = new PaymentService();
        logger.info("MyCourseServlet initialized.");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        UserAccount user = session != null ? (UserAccount) session.getAttribute("user") : null;

        if (user == null) {
            logger.warn("MyCourseServlet: User not logged in. Redirecting to login.");
            response.sendRedirect(request.getContextPath() + "/view/login.jsp");
            return;
        }

        String userID = user.getUserID();
        String tab = request.getParameter("tab") != null ? request.getParameter("tab") : "courses";
        logger.info("MyCourseServlet: Processing tab '{}' for user: {}", tab, userID);

        try {
            // Fetch enrolled courses
            List<Course> enrolledCourses = courseEnrollmentDAO.getEnrolledCoursesByUserID(userID);
            request.setAttribute("courses", enrolledCourses);
            request.setAttribute("category", "my-courses");
            request.setAttribute("pageTitle", tab.equals("payments") ? "Lịch sử thanh toán" : "Khóa học của tôi");
            request.setAttribute("totalCourses", enrolledCourses.size());
            request.setAttribute("tab", tab);

            if ("payments".equals(tab)) {
                // Fetch payment history with filters
                String search = request.getParameter("search");
                String status = request.getParameter("status");
                String date = request.getParameter("date");
                String minAmountStr = request.getParameter("minAmount");
                String maxAmountStr = request.getParameter("maxAmount");
                String sortBy = request.getParameter("sortBy");
                int page = parseIntOrDefault(request.getParameter("page"), 1);
                int pageSize = 9;

                List<Payment> payments = paymentService.getPaymentsWithFilters(
                    status, search, date, minAmountStr, maxAmountStr, sortBy, page, pageSize
                );
                // Filter payments by userID
                List<Payment> userPayments = new ArrayList<>();
                for (Payment payment : payments) {
                    if (payment.getStudentID().equals(userID)) {
                        userPayments.add(payment);
                    }
                }
                int totalPayments = paymentService.countPaymentsWithFilters(status, search, date, minAmountStr, maxAmountStr);
                int totalUserPayments = (int) userPayments.stream().filter(p -> p.getStudentID().equals(userID)).count();
                int totalPages = (int) Math.ceil((double) totalUserPayments / pageSize);
                page = Math.max(1, Math.min(page, totalPages));

                request.setAttribute("paymentHistory", userPayments);
                request.setAttribute("currentPage", page);
                request.setAttribute("totalPages", totalPages);
                request.setAttribute("totalPayments", totalUserPayments);
                request.setAttribute("status", status);
                request.setAttribute("search", search);
                request.setAttribute("date", date);
                request.setAttribute("minAmount", minAmountStr);
                request.setAttribute("maxAmount", maxAmountStr);
                request.setAttribute("sortBy", sortBy);
            }

            logger.info("MyCourseServlet: Found {} enrolled courses and {} payments for user {}", 
                enrolledCourses.size(), request.getAttribute("totalPayments"), userID);

            request.getRequestDispatcher("/view/student/online.jsp").forward(request, response);

        } catch (Exception e) {
            logger.error("Error in MyCourseServlet for user {}: {}", userID, e.getMessage(), e);
            request.setAttribute("error", "Không thể tải dữ liệu. Vui lòng thử lại.");
            request.getRequestDispatcher("/view/student/online.jsp").forward(request, response);
        }
    }

    private int parseIntOrDefault(String value, int defaultValue) {
        try {
            return value != null && !value.trim().isEmpty() ? Integer.parseInt(value) : defaultValue;
        } catch (NumberFormatException e) {
            logger.warn("Invalid number format: {}", value, e);
            return defaultValue;
        }
    }

    @Override
    public void destroy() {
        if (courseEnrollmentDAO != null) {
            courseEnrollmentDAO.closeConnection();
        }
        logger.info("MyCourseServlet destroyed.");
    }
}