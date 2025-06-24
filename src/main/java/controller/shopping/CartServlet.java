package controller.shopping;

import com.google.gson.Gson;
import dao.CourseDAO;
import dao.student.*;
import model.student.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDate;
import java.util.*;
import model.Course;
import model.UserAccount;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(CartServlet.class);

    private CartDAO cartDAO;
    private CartItemDAO cartItemDAO;
    private CourseDAO courseDAO;
    private DiscountDAO discountDAO;
    private CourseEnrollmentDAO courseEnrollmentDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO();
        cartItemDAO = new CartItemDAO();
        courseDAO = new CourseDAO();
        discountDAO = new DiscountDAO();
        courseEnrollmentDAO = new CourseEnrollmentDAO();
        gson = new Gson();
        logger.info("CartServlet initialized.");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        Map<String, Object> jsonResponse = new HashMap<>();

        HttpSession session = request.getSession();
        UserAccount user = (UserAccount) session.getAttribute("user");

        if (user == null) {
            logger.warn("CartServlet: User not logged in. Redirecting to login.");
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Bạn cần đăng nhập để thực hiện chức năng này.");
            out.print(gson.toJson(jsonResponse));
            return;
        }

        String userID = user.getUserID();
        if (userID == null || userID.trim().isEmpty()) {
            logger.error("CartServlet: User ID is null or empty for logged-in user.");
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Thông tin người dùng không hợp lệ. Vui lòng đăng nhập lại.");
            out.print(gson.toJson(jsonResponse));
            return;
        }

        String action = request.getParameter("action");
        logger.info("CartServlet: User {} performing action: {}", userID, action);

        try {
            switch (action) {
                case "addToCart":
                    addToCart(request, jsonResponse, userID);
                    break;
                case "getCartData":
                    getCartData(jsonResponse, userID);
                    break;
                case "updateQuantity":
                    updateQuantity(request, jsonResponse, userID);
                    break;
                case "removeItem":
                    removeItem(request, jsonResponse, userID);
                    break;
                case "applyDiscount":
                    applyDiscount(request, jsonResponse, userID);
                    break;
                case "checkout":
                    checkout(request, jsonResponse, userID);
                    break;
                default:
                    jsonResponse.put("success", false);
                    jsonResponse.put("message", "Hành động không hợp lệ.");
                    break;
            }
        } catch (Exception e) {
            logger.error("Error in CartServlet for user {}: {}", userID, e.getMessage(), e);
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Đã xảy ra lỗi hệ thống: " + e.getMessage());
        } finally {
            out.print(gson.toJson(jsonResponse));
            out.close();
        }
    }

    private void addToCart(HttpServletRequest request, Map<String, Object> jsonResponse, String userID) {
        String courseID = request.getParameter("courseID");
        logger.info("addToCart: Received courseID: {} for user: {}", courseID, userID);

        if (courseID == null || courseID.trim().isEmpty()) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Mã khóa học không hợp lệ.");
            logger.warn("addToCart: Invalid courseID: {}", courseID);
            return;
        }

        if (!courseID.matches("^CO\\d{3}$")) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Định dạng mã khóa học không hợp lệ.");
            logger.warn("addToCart: CourseID format mismatch: {}", courseID);
            return;
        }

        Course course = courseDAO.getCourseByID(courseID);
        if (course == null) {
            logger.warn("addToCart: Course not found for courseID: {}", courseID);
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Khóa học không tồn tại.");
            return;
        }

        if (!course.isIsActive()) {
            logger.warn("addToCart: Course is not active: {}", courseID);
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Khóa học không còn hoạt động.");
            return;
        }

        if (course.getEndDate().before(Date.valueOf(LocalDate.now()))) {
            logger.warn("addToCart: Course has expired: {}", courseID);
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Khóa học đã hết hạn đăng ký.");
            return;
        }

        if (courseEnrollmentDAO.isCourseEnrolled(userID, course.getCourseID())) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Bạn đã đăng ký khóa học này rồi.");
            return;
        }

        Cart userCart = cartDAO.getCartByUserID(userID);
        logger.info("addToCart: Existing cart for user {}: {}", userID, userCart != null ? userCart.getCartID() : "None");

        if (userCart == null) {
            logger.info("addToCart: Creating new cart for user: {}", userID);
            int cartID = -1;
            int maxRetries = 3;
            for (int attempt = 1; attempt <= maxRetries; attempt++) {
                cartID = cartDAO.createCart(userID);
                if (cartID != -1) {
                    break;
                }
                logger.warn("addToCart: Attempt {} failed to create cart for user: {}", attempt, userID);
                if (attempt < maxRetries) {
                    try {
                        Thread.sleep(100);
                    } catch (InterruptedException ie) {
                        Thread.currentThread().interrupt();
                        break;
                    }
                }
            }

            if (cartID == -1) {
                userCart = cartDAO.getCartByUserID(userID);
                if (userCart == null) {
                    jsonResponse.put("success", false);
                    jsonResponse.put("message", "Không thể tạo hoặc truy xuất giỏ hàng. Vui lòng thử lại.");
                    jsonResponse.put("errorCode", "CART_CREATION_FAILED");
                    logger.error("addToCart: Failed to create or retrieve cart for user: {}", userID);
                    return;
                } else {
                    logger.info("addToCart: Found existing cart {} for user {} on retry", userCart.getCartID(), userID);
                }
            } else {
                userCart = cartDAO.getCartByUserID(userID);
                if (userCart == null) {
                    jsonResponse.put("success", false);
                    jsonResponse.put("message", "Không thể truy xuất giỏ hàng sau khi tạo. Vui lòng thử lại.");
                    logger.error("addToCart: Failed to retrieve cart after creation for user: {}", userID);
                    return;
                }
                logger.info("addToCart: Cart created successfully with ID: {}", userCart.getCartID());
            }
        }

        CartItem existingItem = cartItemDAO.getCartItemByCartIdAndCourseId(userCart.getCartID(), course.getCourseID());
        if (existingItem != null) {
            logger.warn("addToCart: Course {} already in cart {} for user {}", courseID, userCart.getCartID(), userID);
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Khóa học đã có trong giỏ hàng của bạn.");
            return;
        }

        CartItem newItem = new CartItem();
        newItem.setCartID(userCart.getCartID());
        newItem.setCourseID(course.getCourseID());
        newItem.setQuantity(1);
        newItem.setPriceAtTime(BigDecimal.valueOf(course.getFee()));
        newItem.setDiscountApplied(BigDecimal.ZERO);

        if (cartItemDAO.addCartItem(newItem)) {
            logger.info("addToCart: Added course {} to cart {}", courseID, userCart.getCartID());
            recalculateCartTotals(userID);
            jsonResponse.put("success", true);
            jsonResponse.put("message", "Đã thêm khóa học vào giỏ hàng.");
            jsonResponse.put("cart", cartDAO.getCartByUserID(userID));
        } else {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Không thể thêm khóa học vào giỏ hàng.");
            logger.error("addToCart: Failed to add cart item for course {} to cart {}", courseID, userCart.getCartID());
        }
    }

    private void getCartData(Map<String, Object> jsonResponse, String userID) {
        logger.info("getCartData: Fetching cart data for user: {}", userID);
        Cart userCart = cartDAO.getCartByUserID(userID);
        if (userCart == null) {
            jsonResponse.put("success", true);
            jsonResponse.put("cart", null);
            jsonResponse.put("items", new ArrayList<>());
            jsonResponse.put("message", "Giỏ hàng trống.");
            logger.info("getCartData: Cart is empty for user: {}", userID);
            return;
        }

        List<CartItem> items = cartItemDAO.getCartItemsByCartID(userCart.getCartID());
        List<Map<String, Object>> enrichedItems = new ArrayList<>();

        Iterator<CartItem> iterator = items.iterator();
        while (iterator.hasNext()) {
            CartItem item = iterator.next();
            Course course = courseDAO.getCourseByID(item.getCourseID());
            boolean invalid = (course == null || !course.isIsActive() || course.getEndDate().before(Date.valueOf(LocalDate.now())) || courseEnrollmentDAO.isCourseEnrolled(userID, item.getCourseID()));
            if (invalid) {
                logger.warn("getCartData: Removing invalid item from cart: courseID={}, reason={}", item.getCourseID(), 
                            (course == null ? "Course not found" : (!course.isIsActive() ? "Not active" : (course.getEndDate().before(Date.valueOf(LocalDate.now())) ? "Expired" : "Already enrolled"))));
                cartItemDAO.removeCartItem(item.getCartItemID());
                iterator.remove();
            }
        }

        for (CartItem item : items) {
            Course course = courseDAO.getCourseByID(item.getCourseID());
            if (course != null) {
                Map<String, Object> enrichedItem = new HashMap<>();
                enrichedItem.put("cartItemID", item.getCartItemID());
                enrichedItem.put("cartID", item.getCartID());
                enrichedItem.put("courseID", item.getCourseID());
                enrichedItem.put("quantity", item.getQuantity());
                enrichedItem.put("priceAtTime", item.getPriceAtTime());
                enrichedItem.put("discountApplied", item.getDiscountApplied());
                enrichedItem.put("totalPrice", item.getPriceAtTime().multiply(BigDecimal.valueOf(item.getQuantity())));
                enrichedItem.put("courseTitle", course.getTitle());
                enrichedItem.put("courseDescription", course.getDescription());
                enrichedItem.put("courseImageUrl", course.getImageUrl() != null ? course.getImageUrl() : "");
                enrichedItems.add(enrichedItem);
            }
        }

        recalculateCartTotals(userID);
        userCart = cartDAO.getCartByUserID(userID);

        jsonResponse.put("success", true);
        jsonResponse.put("cart", userCart);
        jsonResponse.put("items", enrichedItems);
        logger.info("getCartData: Successfully fetched cart data for user: {}", userID);
    }

    private void updateQuantity(HttpServletRequest request, Map<String, Object> jsonResponse, String userID) {
        try {
            int cartItemID = Integer.parseInt(request.getParameter("cartItemID"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            logger.info("updateQuantity: User {} updating cartItemID {} to quantity {}", userID, cartItemID, quantity);

            if (quantity < 1) {
                removeItem(request, jsonResponse, userID);
                return;
            }

            if (cartItemDAO.updateCartItemQuantity(cartItemID, quantity)) {
                recalculateCartTotals(userID);
                jsonResponse.put("success", true);
                jsonResponse.put("message", "Đã cập nhật số lượng.");
                logger.info("updateQuantity: Quantity updated successfully for cartItemID {}", cartItemID);
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Không thể cập nhật số lượng.");
                logger.warn("updateQuantity: Failed to update quantity for cartItemID {}", cartItemID);
            }
        } catch (NumberFormatException e) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Dữ liệu không hợp lệ.");
            logger.error("updateQuantity: Invalid number format: {}", e.getMessage());
        }
    }

    private void removeItem(HttpServletRequest request, Map<String, Object> jsonResponse, String userID) {
        try {
            int cartItemID = Integer.parseInt(request.getParameter("cartItemID"));
            logger.info("removeItem: User {} removing cartItemID {}", userID, cartItemID);

            if (cartItemDAO.removeCartItem(cartItemID)) {
                Cart userCart = cartDAO.getCartByUserID(userID);
                if (userCart != null) {
                    recalculateCartTotals(userID);
                }
                jsonResponse.put("success", true);
                jsonResponse.put("message", "Đã xóa khóa học khỏi giỏ hàng.");
                logger.info("removeItem: Cart item {} removed successfully.", cartItemID);
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Không thể xóa khóa học.");
                logger.warn("removeItem: Failed to remove cart item {}.", cartItemID);
            }
        } catch (NumberFormatException e) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Dữ liệu không hợp lệ.");
            logger.error("removeItem: Invalid number format: {}", e.getMessage());
        }
    }

    private void applyDiscount(HttpServletRequest request, Map<String, Object> jsonResponse, String userID) {
        String discountCode = request.getParameter("discountCode");
        logger.info("applyDiscount: User {} applying discount code: {}", userID, discountCode);

        if (discountCode == null || discountCode.trim().isEmpty()) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Vui lòng nhập mã giảm giá.");
            return;
        }

        Discount discount = discountDAO.getDiscountByCode(discountCode);
        if (discount == null || discount.getEndDate().before(Date.valueOf(LocalDate.now()))) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Mã giảm giá không hợp lệ hoặc đã hết hạn.");
            logger.warn("applyDiscount: Invalid or expired discount code: {}", discountCode);
            return;
        }

        Cart userCart = cartDAO.getCartByUserID(userID);
        if (userCart == null || userCart.getItemCount() == 0) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Giỏ hàng của bạn đang trống.");
            logger.warn("applyDiscount: Cart is empty for user {}.", userID);
            return;
        }

        List<CartItem> items = cartItemDAO.getCartItemsByCartID(userCart.getCartID());
        boolean discountApplied = false;
        BigDecimal totalDiscount = BigDecimal.ZERO;

        for (CartItem item : items) {
            if (discount.getCourseID() == null || discount.getCourseID().isEmpty() || discount.getCourseID().equals(item.getCourseID())) {
                BigDecimal itemPrice = item.getPriceAtTime().multiply(BigDecimal.valueOf(item.getQuantity()));
                BigDecimal itemDiscount = itemPrice
                        .multiply(BigDecimal.valueOf(discount.getDiscountPercent()))
                        .divide(BigDecimal.valueOf(100), 2, BigDecimal.ROUND_HALF_UP);
                if (cartItemDAO.updateCartItemDiscount(item.getCartItemID(), itemDiscount)) {
                    totalDiscount = totalDiscount.add(itemDiscount);
                    discountApplied = true;
                    logger.info("applyDiscount: Applied discount to cart item {}. Discount amount: {}", item.getCartItemID(), itemDiscount);
                }
            }
        }

        if (discountApplied) {
            BigDecimal newTotal = calculateCurrentTotal(userCart.getCartID()).subtract(totalDiscount);
            if (cartDAO.updateCartTotals(userCart.getCartID(), newTotal, totalDiscount, discountCode)) {
                jsonResponse.put("success", true);
                jsonResponse.put("message", "Đã áp dụng mã giảm giá '" + discountCode + "' thành công!");
                jsonResponse.put("discountPercent", discount.getDiscountPercent());
                logger.info("applyDiscount: Discount code {} applied successfully for user {}. New total: {}", discountCode, userID, newTotal);
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Không thể cập nhật tổng giỏ hàng sau khi áp dụng giảm giá.");
                logger.error("applyDiscount: Failed to update cart totals after discount for user {}.", userID);
            }
        } else {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Mã giảm giá không áp dụng cho bất kỳ khóa học nào trong giỏ hàng.");
            logger.warn("applyDiscount: Discount code {} did not apply to any items in cart for user {}.", discountCode, userID);
        }
    }

    private void checkout(HttpServletRequest request, Map<String, Object> jsonResponse, String userID) {
        logger.info("checkout: User {} initiating checkout process.", userID);
        Cart userCart = cartDAO.getCartByUserID(userID);

        if (userCart == null || userCart.getItemCount() == 0) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Giỏ hàng của bạn đang trống. Không thể thanh toán.");
            logger.warn("checkout: Cart is empty for user {}. Cannot proceed with checkout.", userID);
            return;
        }

        List<CartItem> items = cartItemDAO.getCartItemsByCartID(userCart.getCartID());
        boolean allEnrolled = true;
        for (CartItem item : items) {
            if (!courseEnrollmentDAO.enrollCourse(userID, item.getCourseID())) {
                allEnrolled = false;
                logger.error("checkout: Failed to enroll user {} in course {}.", userID, item.getCourseID());
            } else {
                logger.info("checkout: User {} successfully enrolled in course {}.", userID, item.getCourseID());
            }
        }

        if (allEnrolled) {
            if (cartDAO.clearCart(userCart.getCartID())) {
                jsonResponse.put("success", true);
                jsonResponse.put("message", "Thanh toán thành công! Các khóa học đã được thêm vào tài khoản của bạn.");
                logger.info("checkout: Checkout successful for user {}. Cart cleared.", userID);
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Thanh toán thành công nhưng không thể xóa giỏ hàng. Vui lòng liên hệ hỗ trợ.");
                logger.error("checkout: Checkout successful for user {} but failed to clear cart {}.", userID, userCart.getCartID());
            }
        } else {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Có lỗi xảy ra khi đăng ký một số khóa học. Vui lòng thử lại hoặc liên hệ hỗ trợ.");
            logger.error("checkout: Partial enrollment failure for user {}.", userID);
        }
    }

    private void recalculateCartTotals(String userID) {
        logger.info("recalculateCartTotals: Recalculating totals for user: {}", userID);
        Cart userCart = cartDAO.getCartByUserID(userID);
        if (userCart == null) {
            logger.warn("recalculateCartTotals: No cart found for user {}. Cannot recalculate.", userID);
            return;
        }

        List<CartItem> items = cartItemDAO.getCartItemsByCartID(userCart.getCartID());
        BigDecimal total = BigDecimal.ZERO;
        BigDecimal discount = BigDecimal.ZERO;

        for (CartItem item : items) {
            total = total.add(item.getPriceAtTime().multiply(BigDecimal.valueOf(item.getQuantity())));
            discount = discount.add(item.getDiscountApplied());
        }

        BigDecimal finalTotal = total.subtract(discount);
        cartDAO.updateCartTotals(userCart.getCartID(), finalTotal, discount, userCart.getDiscountCodeApplied());
        logger.info("recalculateCartTotals: Recalculated totals for cart {}. Total: {}, Discount: {}, Final: {}", userCart.getCartID(), total, discount, finalTotal);
    }

    private BigDecimal calculateCurrentTotal(int cartID) {
        List<CartItem> items = cartItemDAO.getCartItemsByCartID(cartID);
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem item : items) {
            total = total.add(item.getPriceAtTime().multiply(BigDecimal.valueOf(item.getQuantity())));
        }
        return total;
    }

    @Override
    public void destroy() {
        if (cartDAO != null) cartDAO.closeConnection();
        if (cartItemDAO != null) cartItemDAO.closeConnection();
        if (courseDAO != null) courseDAO.closeConnection();
        if (discountDAO != null) discountDAO.closeConnection();
        if (courseEnrollmentDAO != null) courseEnrollmentDAO.closeConnection();
        logger.info("CartServlet destroyed. All DAO connections closed.");
    }
}