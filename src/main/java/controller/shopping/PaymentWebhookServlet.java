package controller.shopping;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import dao.admin.PaymentDAO;
import dao.student.CartDAO;
import dao.student.CartItemDAO;
import dao.student.CourseEnrollmentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.payos.PayOS;
import vn.payos.type.Webhook;
import vn.payos.type.WebhookData;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.admin.Payment;

@WebServlet("/payment/webhook")
public class PaymentWebhookServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(PaymentWebhookServlet.class);
    private static final String CLIENT_ID = "d8046a78-6eb4-4b20-b174-47a68bdff64d";
    private static final String API_KEY = "e54d74e1-c43e-491c-afef-bb1bab8686af";
    private static final String CHECKSUM_KEY = "47c986022ec21429d1b9791b0f53b19412e69107d52a0f8d631331af6b805093";
    private static final PayOS payOS;
    private static final String REDIRECT_URL = "/view/student/shopping_cart.jsp";

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

    private CartDAO cartDAO;
    private CartItemDAO cartItemDAO;
    private PaymentDAO paymentDAO;
    private CourseEnrollmentDAO courseEnrollmentDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO();
        cartItemDAO = new CartItemDAO();
        paymentDAO = new PaymentDAO();
        courseEnrollmentDAO = new CourseEnrollmentDAO();
        gson = new Gson();
        logger.info("PaymentWebhookServlet initialized.");
    }

    private String getStudentIDFromUserID(String userID, Connection conn) throws SQLException {
        String sql = "SELECT studentID FROM Student WHERE userID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, userID);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("studentID");
                }
            }
        }
        return null;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            // Read webhook data from body
            StringBuilder jb = new StringBuilder();
            String line;
            try (BufferedReader reader = request.getReader()) {
                while ((line = reader.readLine()) != null) {
                    jb.append(line);
                }
            }
            logger.info("Webhook received: {}", jb.toString());

            // Parse JSON webhook
            JsonObject jsonObject = gson.fromJson(jb.toString(), JsonObject.class);
            Webhook webhook = gson.fromJson(jsonObject, Webhook.class);

            // Verify webhook
            try {
                payOS.verifyPaymentWebhookData(webhook);
            } catch (Exception e) {
                logger.error("Webhook verification failed: {}", e.getMessage(), e);
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.println(gson.toJson(new JsonResponse(false, "Webhook verification failed: " + e.getMessage())));
                return;
            }

            WebhookData webhookData = webhook.getData();
            String transactionID = webhookData.getPaymentLinkId();
            String status = webhook.getDesc();
            String code = webhook.getCode();

            // Map PAID to Complete
            String normalizedStatus = "PAID".equalsIgnoreCase(status) ? "Complete" : status;

            logger.info("Processing webhook: status={}, normalizedStatus={}, transactionID={}", status, normalizedStatus, transactionID);

            // Get userID from session
            HttpSession session = request.getSession(false);
            String userID = null;
            if (session != null && session.getAttribute("user") != null) {
                userID = ((model.UserAccount) session.getAttribute("user")).getUserID();
            }

            if (userID == null) {
                logger.error("No userID found in session for transactionID: {}", transactionID);
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.println(gson.toJson(new JsonResponse(false, "Không tìm thấy người dùng trong session")));
                return;
            }

            // Get cartID from userID
            model.student.Cart cart = cartDAO.getCartByUserID(userID);
            if (cart == null) {
                logger.error("No cart found for userID: {}, transactionID: {}", userID, transactionID);
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.println(gson.toJson(new JsonResponse(false, "Không tìm thấy giỏ hàng cho người dùng")));
                return;
            }
            Integer cartID = cart.getCartID();

            // Get studentID from userID
            try (Connection conn = cartDAO.getConnection()) {
                String studentID = getStudentIDFromUserID(userID, conn);
                if (studentID == null) {
                    logger.error("No studentID found for userID: {}, transactionID: {}", userID, transactionID);
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.println(gson.toJson(new JsonResponse(false, "Không tìm thấy studentID cho người dùng")));
                    return;
                }

                // Process payment status
                if ("00".equals(code) && "Complete".equalsIgnoreCase(normalizedStatus)) {
                    conn.setAutoCommit(false);
                    try {
                        List<String> courseIds = cartItemDAO.getCourseIdsByCartId(cartID);
                        if (courseIds.isEmpty()) {
                            logger.error("No courses found for cartID: {}, studentID: {}, transactionID: {}", cartID, studentID, transactionID);
                            throw new SQLException("Giỏ hàng trống.");
                        }

                        // Save payment record
                        Payment payment = new Payment();
                        payment.setCartID(cartID);
                        payment.setStudentID(studentID);
                        payment.setCourseIDs(courseIds);
                        payment.setAmount(cart.getTotalAmount().doubleValue());
                        payment.setPaymentMethod("PayOS");
                        payment.setPaymentStatus("Complete");
                        payment.setPaymentDate(new Timestamp(System.currentTimeMillis()));
                        payment.setTransactionID(transactionID);

                        boolean paymentSaved = paymentDAO.savePayment(payment, conn);
                        if (!paymentSaved) {
                            logger.error("Failed to save payment for cartID: {}, studentID: {}, transactionID: {}", cartID, studentID, transactionID);
                            throw new SQLException("Không thể lưu thông tin thanh toán vào cơ sở dữ liệu.");
                        }

                        // Create enrollments for each course
                        List<String> failedCourses = new ArrayList<>();
                        for (String courseID : courseIds) {
                            try {
                                // Kiểm tra xem khóa học có tồn tại và hợp lệ
                                String checkCourseSql = "SELECT isActive, endDate FROM Courses WHERE courseID = ?";
                                try (PreparedStatement checkStmt = conn.prepareStatement(checkCourseSql)) {
                                    checkStmt.setString(1, courseID);
                                    try (ResultSet rs = checkStmt.executeQuery()) {
                                        if (rs.next()) {
                                            boolean isActive = rs.getBoolean("isActive");
                                            Timestamp endDate = rs.getTimestamp("endDate");
                                            if (!isActive || (endDate != null && endDate.before(new Timestamp(System.currentTimeMillis())))) {
                                                logger.warn("Course {} is not active or expired for userID: {}, cartID: {}, transactionID: {}", courseID, userID, cartID, transactionID);
                                                failedCourses.add(courseID);
                                                continue;
                                            }
                                        } else {
                                            logger.warn("Course {} not found for userID: {}, cartID: {}, transactionID: {}", courseID, userID, cartID, transactionID);
                                            failedCourses.add(courseID);
                                            continue;
                                        }
                                    }
                                }

                                boolean enrolled = courseEnrollmentDAO.enrollCourse(userID, courseID, conn);
                                if (!enrolled) {
                                    logger.warn("Failed to enroll userID: {} for courseID: {}, cartID: {}, transactionID: {}", userID, courseID, cartID, transactionID);
                                    failedCourses.add(courseID);
                                }
                            } catch (SQLException e) {
                                logger.error("Error enrolling userID: {} for courseID: {}, cartID: {}, transactionID: {}", userID, courseID, cartID, transactionID, e);
                                failedCourses.add(courseID);
                            }
                        }

                        if (!failedCourses.isEmpty()) {
                            logger.warn("Partial enrollment failure for cartID: {}, studentID: {}, transactionID: {}, failed courses: {}", cartID, studentID, transactionID, failedCourses);
                            throw new SQLException("Thất bại trong việc đăng ký một số khóa học: " + String.join(", ", failedCourses));
                        }

                        if (cartItemDAO.clearCartItems(cartID, conn) && cartDAO.clearCart(cartID, conn)) {
                            logger.info("Cart cleared successfully for cartID: {}, studentID: {}, transactionID: {}", cartID, studentID, transactionID);
                            out.println(gson.toJson(new JsonResponse(true, "Thanh toán hoàn tất và giỏ hàng đã được xóa")));
                            if (session != null) {
                                session.removeAttribute("cartID");
                            }
                        } else {
                            logger.error("Failed to clear cart for cartID: {}, studentID: {}, transactionID: {}", cartID, studentID, transactionID);
                            throw new SQLException("Không thể xóa giỏ hàng.");
                        }

                        conn.commit();
                    } catch (SQLException e) {
                        try {
                            conn.rollback();
                            logger.error("Rolled back transaction for cartID: {}, studentID: {}, transactionID: {}", cartID, studentID, transactionID, e);
                        } catch (SQLException ex) {
                            logger.error("Failed to rollback transaction for cartID: {}, studentID: {}, transactionID: {}", cartID, studentID, transactionID, ex);
                        }
                        logger.error("Transaction rolled back due to error for cartID: {}, studentID: {}, transactionID: {}: {}", cartID, studentID, transactionID, e.getMessage(), e);
                        out.println(gson.toJson(new JsonResponse(false, "Thanh toán thất bại: " + e.getMessage())));
                    }
                } else if ("CANCELLED".equalsIgnoreCase(normalizedStatus)) {
                    logger.info("Payment cancelled for transactionID: {}, studentID: {}", transactionID, studentID);
                    out.println(gson.toJson(new JsonResponse(true, "Thanh toán đã bị hủy")));
                } else {
                    logger.warn("Unknown payment status: {} for transactionID: {}, studentID: {}", status, transactionID, studentID);
                    out.println(gson.toJson(new JsonResponse(false, "Trạng thái thanh toán không xác định: " + status)));
                }
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            try (PrintWriter out = response.getWriter()) {
                out.println(gson.toJson(new JsonResponse(false, "Lỗi xử lý webhook: " + e.getMessage())));
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String code = request.getParameter("code");
        String id = request.getParameter("id");
        String cancel = request.getParameter("cancel");
        String status = request.getParameter("status");

        logger.debug("GET request parameters: code={}, id={}, cancel={}, status={}",
                code != null ? code : "null",
                id != null ? id : "null",
                cancel != null ? cancel : "null",
                status != null ? status : "null");

        logger.info("GET request to webhook: code={}, id={}, cancel={}, status={}", code, id, cancel, status);

        // Validate parameters
        if (status == null) {
            logger.warn("Missing status in GET request");
            request.setAttribute("error", "invalid_request");
            request.setAttribute("errorMessage", "Thiếu tham số status.");
            request.getRequestDispatcher(REDIRECT_URL).forward(request, response);
            return;
        }

        // Get userID from session
        HttpSession session = request.getSession(false);
        String userID = null;
        if (session != null && session.getAttribute("user") != null) {
            userID = ((model.UserAccount) session.getAttribute("user")).getUserID();
        }

        if (userID == null) {
            logger.error("No userID found in session for transactionID: {}", id);
            request.setAttribute("error", "invalid_session");
            request.setAttribute("errorMessage", "Không tìm thấy người dùng trong session.");
            request.getRequestDispatcher(REDIRECT_URL).forward(request, response);
            return;
        }

        // Get cartID from userID
        model.student.Cart cart = cartDAO.getCartByUserID(userID);
        Integer cartID = null;
        if (cart != null) {
            cartID = cart.getCartID();
        }

        if (cart == null) {
            logger.error("No cart found for userID: {}, transactionID: {}", userID, id);
            request.setAttribute("error", "invalid_session");
            request.setAttribute("errorMessage", "Không tìm thấy giỏ hàng cho người dùng.");
            request.getRequestDispatcher(REDIRECT_URL).forward(request, response);
            return;
        }

        // Get studentID from userID
        try (Connection conn = cartDAO.getConnection()) {
            String studentID = getStudentIDFromUserID(userID, conn);
            if (studentID == null) {
                logger.error("No studentID found for userID: {}, transactionID: {}", userID, id);
                request.setAttribute("error", "invalid_user");
                request.setAttribute("errorMessage", "Không tìm thấy studentID cho người dùng.");
                request.getRequestDispatcher(REDIRECT_URL).forward(request, response);
                return;
            }

            // Map PAID to Complete
            String normalizedStatus = "PAID".equalsIgnoreCase(status) ? "Complete" : status;
            logger.info("Normalized status: {} for transactionID: {}, studentID: {}", normalizedStatus, id, studentID);

            // Process payment status
            if ("00".equals(code) && "Complete".equalsIgnoreCase(normalizedStatus)) {
                conn.setAutoCommit(false);
                try {
                    List<String> courseIds = cartItemDAO.getCourseIdsByCartId(cartID);
                    if (courseIds.isEmpty()) {
                        logger.error("No courses found for cartID: {}, userID: {}, transactionID: {}", cartID, userID, id);
                        throw new SQLException("Giỏ hàng trống.");
                    }

                    // Save payment record
                    Payment payment = new Payment();
                    payment.setCartID(cartID);
                    payment.setStudentID(studentID);
                    payment.setCourseIDs(courseIds);
                    payment.setAmount(cart.getTotalAmount().doubleValue());
                    payment.setPaymentMethod("PayOS");
                    payment.setPaymentStatus("Complete");
                    payment.setPaymentDate(new Timestamp(System.currentTimeMillis()));
                    payment.setTransactionID(id);

                    boolean paymentSaved = paymentDAO.savePayment(payment, conn);
                    if (!paymentSaved) {
                        logger.error("Failed to save payment for cartID: {}, studentID: {}, transactionID: {}", cartID, studentID, id);
                        throw new SQLException("Không thể lưu thông tin thanh toán vào cơ sở dữ liệu.");
                    }

                    // Create enrollments for each course
                    List<String> failedCourses = new ArrayList<>();
                    for (String courseID : courseIds) {
                        try {
                            // Kiểm tra xem khóa học có tồn tại và hợp lệ
                            String checkCourseSql = "SELECT isActive, endDate FROM Courses WHERE courseID = ?";
                            try (PreparedStatement checkStmt = conn.prepareStatement(checkCourseSql)) {
                                checkStmt.setString(1, courseID);
                                try (ResultSet rs = checkStmt.executeQuery()) {
                                    if (rs.next()) {
                                        boolean isActive = rs.getBoolean("isActive");
                                        Timestamp endDate = rs.getTimestamp("endDate");
                                        if (!isActive || (endDate != null && endDate.before(new Timestamp(System.currentTimeMillis())))) {
                                            logger.warn("Course {} is not active or expired for userID: {}, cartID: {}, transactionID: {}", courseID, userID, cartID, id);
                                            failedCourses.add(courseID);
                                            continue;
                                        }
                                    } else {
                                        logger.warn("Course {} not found for userID: {}, cartID: {}, transactionID: {}", courseID, userID, cartID, id);
                                        failedCourses.add(courseID);
                                        continue;
                                    }
                                }
                            }

                            boolean enrolled = courseEnrollmentDAO.enrollCourse(userID, courseID, conn);
                            if (!enrolled) {
                                logger.warn("Failed to enroll userID: {} for courseID: {}, cartID: {}, transactionID: {}", userID, courseID, cartID, id);
                                failedCourses.add(courseID);
                            }
                        } catch (SQLException e) {
                            logger.error("Error enrolling userID: {} for courseID: {}, cartID: {}, transactionID: {}", userID, courseID, cartID, id, e);
                            failedCourses.add(courseID);
                        }
                    }

                    if (!failedCourses.isEmpty()) {
                        logger.warn("Partial enrollment failure for cartID: {}, studentID: {}, transactionID: {}, failed courses: {}", cartID, studentID, id, failedCourses);
                        throw new SQLException("Thất bại trong việc đăng ký một số khóa học: " + String.join(", ", failedCourses));
                    }

                    boolean cartItemsCleared = cartItemDAO.clearCartItems(cartID, conn);
                    boolean cartCleared = cartDAO.clearCart(cartID, conn);
                    if (cartItemsCleared && cartCleared) {
                        logger.info("Cart cleared successfully for cartID: {}, studentID: {}, transactionID: {}", cartID, studentID, id);
                        request.setAttribute("success", "payment_completed");
                        request.setAttribute("transactionID", id);
                        if (session != null) {
                            session.removeAttribute("cartID");
                        }
                    } else {
                        logger.error("Failed to clear cart for cartID: {}, studentID: {}, transactionID: {}", cartID, studentID, id);
                        throw new SQLException("Không thể xóa giỏ hàng.");
                    }

                    conn.commit();
                } catch (SQLException e) {
                    try {
                        conn.rollback();
                        logger.error("Rolled back transaction for cartID: {}, studentID: {}, transactionID: {}", cartID, studentID, id, e);
                    } catch (SQLException ex) {
                        logger.error("Failed to rollback transaction for cartID: {}, studentID: {}, transactionID: {}", cartID, studentID, id, ex);
                    }
                    logger.error("Transaction rolled back due to error for cartID: {}, studentID: {}, transactionID: {}: {}", cartID, studentID, id, e.getMessage(), e);
                    String errorCode = e.getMessage().contains("Thất bại trong việc đăng ký") ? "partial_enrollment" : "payment_failed";
                    request.setAttribute("error", errorCode);
                    request.setAttribute("errorMessage", "Thanh toán thất bại: " + e.getMessage());
                    request.setAttribute("transactionID", id);
                    if (errorCode.equals("partial_enrollment")) {
                        request.setAttribute("failedCourses", e.getMessage().replace("Thất bại trong việc đăng ký một số khóa học: ", ""));
                    }
                }
            } else if ("CANCELLED".equalsIgnoreCase(normalizedStatus) || "true".equalsIgnoreCase(cancel)) {
                logger.info("Payment cancelled for transactionID: {}, studentID: {}", id, studentID);
                request.setAttribute("error", "payment_cancelled");
                request.setAttribute("transactionID", id);
            } else {
                logger.warn("Unknown payment status: {} for transactionID: {}, studentID: {}", status, id, studentID);
                request.setAttribute("error", "unknown_status");
                request.setAttribute("errorMessage", "Trạng thái thanh toán không xác định: " + status);
                request.setAttribute("transactionID", id);
            }
        } catch (SQLException e) {
            logger.error("Database error for transactionID: {}: {}", id, e.getMessage(), e);
            request.setAttribute("error", "database_error");
            request.setAttribute("errorMessage", "Lỗi cơ sở dữ liệu: " + e.getMessage());
            request.setAttribute("transactionID", id);
        }

        request.getRequestDispatcher(REDIRECT_URL).forward(request, response);
    }

    private static class JsonResponse {
        boolean success;
        String message;

        JsonResponse(boolean success, String message) {
            this.success = success;
            this.message = message;
        }
    }

    @Override
    public void destroy() {
        if (cartDAO != null) {
            cartDAO.closeConnection();
        }
        if (cartItemDAO != null) {
            cartItemDAO.closeConnection();
        }
        if (paymentDAO != null) {
            paymentDAO.closeConnection();
        }
        if (courseEnrollmentDAO != null) {
            courseEnrollmentDAO.closeConnection();
        }
        logger.info("PaymentWebhookServlet destroyed.");
    }
}