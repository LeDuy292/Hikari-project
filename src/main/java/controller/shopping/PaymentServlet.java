package controller.shopping;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.payos.PayOS;
import vn.payos.type.CheckoutResponseData;
import vn.payos.type.ItemData;
import vn.payos.type.PaymentData;
import dao.CourseDAO;
import model.Course;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

public class PaymentServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(PaymentServlet.class);
    private static final String WEBHOOK_URL = "http://localhost:8080/Hikari/payment/webhook";
    private static final String CLIENT_ID = "d8046a78-6eb4-4b20-b174-47a68bdff64d";
    private static final String API_KEY = "e54d74e1-c43e-491c-afef-bb1bab8686af";
    private static final String CHECKSUM_KEY = "47c986022ec21429d1b9791b0f53b19412e69107d52a0f8d631331af6b805093";
    private static final PayOS payOS;

    static {
        if (CLIENT_ID == null || CLIENT_ID.isEmpty()) {
            logger.error("PayOS CLIENT_ID is missing or empty");
            throw new ExceptionInInitializerError("Missing PayOS configuration: CLIENT_ID is null or empty");
        }
        if (API_KEY == null || API_KEY.isEmpty()) {
            logger.error("PayOS API_KEY is missing or empty");
            throw new ExceptionInInitializerError("Missing PayOS configuration: API_KEY is null or empty");
        }
        if (CHECKSUM_KEY == null || CHECKSUM_KEY.isEmpty()) {
            logger.error("PayOS CHECKSUM_KEY is missing or empty");
            throw new ExceptionInInitializerError("Missing PayOS configuration: CHECKSUM_KEY is null or empty");
        }

        try {
            logger.info("PayOS Configuration loaded: CLIENT_ID={}, API_KEY=****, CHECKSUM_KEY=****", CLIENT_ID);
            payOS = new PayOS(CLIENT_ID, API_KEY, CHECKSUM_KEY);
        } catch (Exception e) {
            logger.error("Failed to initialize PayOS: {}", e.getMessage(), e);
            throw new ExceptionInInitializerError("Failed to initialize PayOS: " + e.getMessage());
        }
    }

    private CourseDAO courseDAO;

    @Override
    public void init() throws ServletException {
        courseDAO = new CourseDAO();
        logger.info("PaymentServlet initialized.");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            String userID = null;
            try {
                HttpSession session = request.getSession();
                if (session.getAttribute("user") != null) {
                    userID = ((model.UserAccount) session.getAttribute("user")).getUserID();
                }
                if (userID == null) {
                    logger.warn("PaymentServlet: No user found in session");
                    out.println("{\"success\": false, \"message\": \"Không tìm thấy người dùng trong session.\"}");
                    response.sendRedirect(request.getContextPath() + "/view/student/shopping_cart.jsp?error=invalid_session");
                    return;
                }

                Integer cartID = (Integer) session.getAttribute("cartID");
                if (cartID == null) {
                    logger.warn("PaymentServlet: Cart ID not found in session for userID: {}", userID);
                    out.println("{\"success\": false, \"message\": \"Không tìm thấy giỏ hàng.\"}");
                    response.sendRedirect(request.getContextPath() + "/view/student/shopping_cart.jsp?error=invalid_session");
                    return;
                }

                String[] courseIds = request.getParameterValues("courseIds");
                if (courseIds == null || courseIds.length == 0) {
                    logger.warn("PaymentServlet: No courses provided in request for userID: {}", userID);
                    out.println("{\"success\": false, \"message\": \"Không có khóa học nào trong đơn hàng.\"}");
                    response.sendRedirect(request.getContextPath() + "/view/student/shopping_cart.jsp?error=empty_cart");
                    return;
                }

                String totalAmountStr = request.getParameter("totalAmount");
                if (totalAmountStr == null || totalAmountStr.trim().isEmpty()) {
                    logger.warn("PaymentServlet: Total amount is missing or empty for userID: {}", userID);
                    out.println("{\"success\": false, \"message\": \"Tổng số tiền không hợp lệ.\"}");
                    response.sendRedirect(request.getContextPath() + "/view/student/shopping_cart.jsp?error=invalid_request");
                    return;
                }

                int totalAmount;
                try {
                    totalAmount = Integer.parseInt(totalAmountStr);
                    if (totalAmount <= 0) {
                        logger.warn("PaymentServlet: Total amount must be greater than 0, received: {} for userID: {}", totalAmount, userID);
                        out.println("{\"success\": false, \"message\": \"Tổng số tiền phải lớn hơn 0.\"}");
                        response.sendRedirect(request.getContextPath() + "/view/student/shopping_cart.jsp?error=invalid_request");
                        return;
                    }
                } catch (NumberFormatException e) {
                    logger.error("PaymentServlet: Invalid total amount format: {} for userID: {}", totalAmountStr, userID);
                    out.println("{\"success\": false, \"message\": \"Dữ liệu số tiền không hợp lệ.\"}");
                    response.sendRedirect(request.getContextPath() + "/view/student/shopping_cart.jsp?error=invalid_request");
                    return;
                }

                List<ItemData> items = new ArrayList<>();
                for (String courseId : courseIds) {
                    Course course = courseDAO.getCourseByID(courseId);
                    if (course == null) {
                        logger.warn("PaymentServlet: Course not found for ID: {} for userID: {}", courseId, userID);
                        out.println("{\"success\": false, \"message\": \"Khóa học không tồn tại: " + courseId + "\"}");
                        response.sendRedirect(request.getContextPath() + "/view/student/shopping_cart.jsp?error=invalid_request");
                        return;
                    }
                    String courseName = course.getTitle();
                    if (courseName.length() > 200) {
                        courseName = courseName.substring(0, 197) + "...";
                    }
                    ItemData itemData = ItemData.builder()
                            .name(courseName)
                            .quantity(1)
                            .price((int) course.getFee())
                            .build();
                    items.add(itemData);
                }

                String description = "Thanh toán khóa học";
                if (description.length() > 255) {
                    description = description.substring(0, 252) + "...";
                }

                Long orderCode = System.currentTimeMillis() / 1000;

                PaymentData paymentData = PaymentData.builder()
                        .orderCode(orderCode)
                        .amount(totalAmount)
                        .description(description)
                        .returnUrl(WEBHOOK_URL)
                        .cancelUrl(WEBHOOK_URL + "?cancel=true")
                        .items(items)
                        .build();

                logger.info("Creating payment link for cartID: {}, userID: {}, orderCode: {}, totalAmount: {}, items: {}", 
                            cartID, userID, orderCode, totalAmount, items);
                CheckoutResponseData result = payOS.createPaymentLink(paymentData);
                if (result != null && result.getCheckoutUrl() != null) {
                    session.setAttribute("orderCode", orderCode.toString());
                    logger.info("Payment link created successfully: {} for userID: {}", result.getCheckoutUrl(), userID);
                    response.sendRedirect(result.getCheckoutUrl());
                } else {
                    logger.error("PaymentServlet: Failed to create payment link for orderCode: {}, userID: {}", orderCode, userID);
                    out.println("{\"success\": false, \"message\": \"Không thể tạo liên kết thanh toán. Kiểm tra cấu hình PayOS.\"}");
                    response.sendRedirect(request.getContextPath() + "/view/student/shopping_cart.jsp?error=payment_error");
                }
            } catch (Exception ex) {
                String errorMessage = "Không thể tạo liên kết thanh toán: " + ex.getMessage();
                logger.error("PaymentServlet: Failed to create payment link for userID: {}: {}", userID != null ? userID : "unknown", ex.getMessage(), ex);
                out.println("{\"success\": false, \"message\": \"" + errorMessage.replace("\"", "'") + "\"}");
                response.sendRedirect(request.getContextPath() + "/view/student/shopping_cart.jsp?error=payment_error");
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet Thanh Toán</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet Thanh Toán tại " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet xử lý thanh toán qua PayOS";
    }
}