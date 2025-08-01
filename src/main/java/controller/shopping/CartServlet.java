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
import vn.payos.PayOS;
import vn.payos.type.CheckoutResponseData;
import vn.payos.type.ItemData;
import vn.payos.type.PaymentData;
import model.Course;
import model.UserAccount;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDate;
import java.util.*;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(CartServlet.class);
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

    private CartDAO cartDAO;
    private CartItemDAO cartItemDAO;
    private CourseDAO courseDAO;
    private DiscountDAO discountDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO();
        cartItemDAO = new CartItemDAO();
        courseDAO = new CourseDAO();
        discountDAO = new DiscountDAO();
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
            logger.warn("CartServlet: User not logged in.");
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Bạn cần đăng nhập để thực hiện chức năng này.");
            out.print(gson.toJson(jsonResponse));
            return;
        }

        String userID = user.getUserID();
        if (userID == null || userID.trim().isEmpty()) {
            logger.error("CartServlet: User ID is null or empty.");
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Thông tin người dùng không hợp lệ.");
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
                    checkout(request, response, jsonResponse, userID);
                    return;
                default:
                    jsonResponse.put("success", false);
                    jsonResponse.put("message", "Hành động không hợp lệ.");
                    break;
            }
        } catch (Exception e) {
            logger.error("Error in CartServlet for user {}: {}", userID, e.getMessage(), e);
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Đã xảy ra lỗi: " + e.getMessage());
        } finally {
            out.print(gson.toJson(jsonResponse));
            out.close();
        }
    }

    private void addToCart(HttpServletRequest request, Map<String, Object> jsonResponse, String userID) {
        String courseID = request.getParameter("courseID");
        logger.info("addToCart: Adding courseID {} for user {}", courseID, userID);

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
            logger.warn("addToCart: Course not found: {}", courseID);
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

        Cart userCart = cartDAO.getCartByUserID(userID);
        if (userCart == null) {
            logger.info("addToCart: Creating new cart for user {}", userID);
            int cartID = cartDAO.createCart(userID);
            if (cartID == -1) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Không thể tạo giỏ hàng.");
                logger.error("addToCart: Failed to create cart for user {}", userID);
                return;
            }
            userCart = cartDAO.getCartByUserID(userID);
        }

        CartItem existingItem = cartItemDAO.getCartItemByCartIdAndCourseId(userCart.getCartID(), course.getCourseID());
        if (existingItem != null) {
            logger.warn("addToCart: Course {} already in cart {}", courseID, userCart.getCartID());
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Khóa học đã có trong giỏ hàng.");
            return;
        }

        CartItem newItem = new CartItem();
        newItem.setCartID(userCart.getCartID());
        newItem.setCourseID(course.getCourseID());
        newItem.setQuantity(1);
        newItem.setPriceAtTime(BigDecimal.valueOf(course.getFee()));
        newItem.setDiscountApplied(BigDecimal.ZERO);

        if (cartItemDAO.addCartItem(newItem)) {
            recalculateCartTotals(userID);
            jsonResponse.put("success", true);
            jsonResponse.put("message", "Đã thêm khóa học vào giỏ hàng.");
        } else {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Không thể thêm khóa học vào giỏ hàng.");
            logger.error("addToCart: Failed to add course {} to cart {}", courseID, userCart.getCartID());
        }
    }

    private void getCartData(Map<String, Object> jsonResponse, String userID) {
        logger.info("getCartData: Fetching cart for user {}", userID);
        Cart userCart = cartDAO.getCartByUserID(userID);
        if (userCart == null) {
            jsonResponse.put("success", true);
            jsonResponse.put("cart", null);
            jsonResponse.put("items", new ArrayList<>());
            jsonResponse.put("message", "Giỏ hàng trống.");
            return;
        }

        List<CartItem> items = cartItemDAO.getCartItemsByCartID(userCart.getCartID());
        List<Map<String, Object>> enrichedItems = new ArrayList<>();

        Iterator<CartItem> iterator = items.iterator();
        while (iterator.hasNext()) {
            CartItem item = iterator.next();
            Course course = courseDAO.getCourseByID(item.getCourseID());
            if (course == null || !course.isIsActive() || course.getEndDate().before(Date.valueOf(LocalDate.now()))) {
                logger.warn("getCartData: Removing invalid item: courseID {}", item.getCourseID());
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
                // Use imageUrl from CartItem first (which comes from database JOIN), then fallback to Course object
                String imageUrl = item.getCourseImageUrl();
                if (imageUrl == null || imageUrl.trim().isEmpty()) {
                    imageUrl = course.getImageUrl();
                }
                enrichedItem.put("courseImageUrl", imageUrl != null ? imageUrl : "");
                logger.info("CartServlet: Course {} imageUrl: {} (from CartItem: {}, from Course: {})", 
                    course.getCourseID(), imageUrl, item.getCourseImageUrl(), course.getImageUrl());
                enrichedItems.add(enrichedItem);
            }
        }

        recalculateCartTotals(userID);
        userCart = cartDAO.getCartByUserID(userID);

        jsonResponse.put("success", true);
        jsonResponse.put("cart", userCart);
        jsonResponse.put("items", enrichedItems);
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
                
            } 
        } catch (NumberFormatException e) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Dữ liệu không hợp lệ.");
            logger.error("updateQuantity: Invalid input: {}", e.getMessage());
        }
    }

    private void removeItem(HttpServletRequest request, Map<String, Object> jsonResponse, String userID) {
        try {
            int cartItemID = Integer.parseInt(request.getParameter("cartItemID"));
            logger.info("removeItem: User {} removing cartItemID {}", userID, cartItemID);

            if (cartItemDAO.removeCartItem(cartItemID)) {
                recalculateCartTotals(userID);
                jsonResponse.put("success", true);
                jsonResponse.put("message", "Đã xóa khóa học khỏi giỏ hàng.");
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Không thể xóa khóa học.");
                logger.warn("removeItem: Failed for cartItemID {}", cartItemID);
            }
        } catch (NumberFormatException e) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Dữ liệu không hợp lệ.");
            logger.error("removeItem: Invalid input: {}", e.getMessage());
        }
    }

    private void applyDiscount(HttpServletRequest request, Map<String, Object> jsonResponse, String userID) {
        String discountCode = request.getParameter("discountCode");
        logger.info("applyDiscount: User {} applying code {}", userID, discountCode);

        if (discountCode == null || discountCode.trim().isEmpty()) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Vui lòng nhập mã giảm giá.");
            return;
        }

        Cart userCart = cartDAO.getCartByUserID(userID);
        if (userCart == null || userCart.getItemCount() == 0) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Giỏ hàng trống.");
            logger.warn("applyDiscount: Cart empty for user {}", userID);
            return;
        }

        if (discountCode.equals(userCart.getDiscountCodeApplied())) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Mã giảm giá này đã được áp dụng.");
            logger.warn("applyDiscount: Code {} already applied for user {}", discountCode, userID);
            return;
        }

        Discount discount = discountDAO.getDiscountByCode(discountCode);
        if (discount == null || discount.getEndDate().before(Date.valueOf(LocalDate.now()))) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Mã giảm giá không hợp lệ hoặc đã hết hạn.");
            logger.warn("applyDiscount: Invalid code: {}", discountCode);
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
                    logger.info("applyDiscount: Applied discount to cartItemID {}, amount: {}", item.getCartItemID(), itemDiscount);
                }
            }
        }

        if (discountApplied) {
            BigDecimal newTotal = calculateCurrentTotal(userCart.getCartID()).subtract(totalDiscount);
            if (cartDAO.updateCartTotals(userCart.getCartID(), newTotal, totalDiscount, discountCode)) {
                jsonResponse.put("success", true);
                jsonResponse.put("message", "Áp dụng mã giảm giá thành công!");
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Không thể cập nhật giỏ hàng.");
                logger.error("applyDiscount: Failed to update cart totals for user {}", userID);
            }
        } else {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Mã giảm giá không áp dụng được.");
            logger.warn("applyDiscount: Code {} not applicable for user {}", discountCode, userID);
        }
    }

    private void checkout(HttpServletRequest request, HttpServletResponse response, Map<String, Object> jsonResponse, String userID) throws IOException {
        logger.info("checkout: Initiating for user {}", userID);
        Cart userCart = cartDAO.getCartByUserID(userID);

        if (userCart == null || userCart.getItemCount() == 0) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Giỏ hàng trống. Không thể thanh toán.");
            logger.warn("checkout: Cart empty for user {}", userID);
            return;
        }

        try {
            List<CartItem> cartItems = cartItemDAO.getCartItemsByCartID(userCart.getCartID());
            if (cartItems.isEmpty()) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Giỏ hàng trống.");
                logger.warn("checkout: No items in cart for user {}", userID);
                return;
            }

            List<ItemData> items = new ArrayList<>();
            for (CartItem item : cartItems) {
                Course course = courseDAO.getCourseByID(item.getCourseID());
                if (course == null) {
                    logger.warn("checkout: Course {} not found for cartItemID {}", item.getCourseID(), item.getCartItemID());
                    continue;
                }
                String courseTitle = course.getTitle();
                if (courseTitle.length() > 200) {
                    courseTitle = courseTitle.substring(0, 197) + "...";
                }
                BigDecimal itemPrice = item.getPriceAtTime().subtract(item.getDiscountApplied());
                ItemData itemData = ItemData.builder()
                        .name(courseTitle)
                        .quantity(item.getQuantity())
                        .price(itemPrice.intValue())
                        .build();
                items.add(itemData);
            }

            if (items.isEmpty()) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Không có khóa học hợp lệ để thanh toán.");
                logger.warn("checkout: No valid items for user {}", userID);
                return;
            }

            int totalAmount = userCart.getTotalAmount().intValue();
            if (totalAmount <= 0) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Tổng số tiền không hợp lệ.");
                logger.warn("checkout: Invalid total amount {} for user {}", totalAmount, userID);
                return;
            }

            Long orderCode = System.currentTimeMillis() / 1000;
            String description = "Thanh toán khóa học";
            if (description.length() > 255) {
                description = description.substring(0, 252) + "...";
            }

            PaymentData paymentData = PaymentData.builder()
                    .orderCode(orderCode)
                    .amount(totalAmount)
                    .description(description)
                    .items(items)
                    .returnUrl(WEBHOOK_URL)
                    .cancelUrl(WEBHOOK_URL + "?cancel=true")
                    .build();

            logger.info("checkout: Creating PayOS payment link for user {}, cartID {}, amount {}, items: {}", 
                        userID, userCart.getCartID(), totalAmount, items);
            CheckoutResponseData result = payOS.createPaymentLink(paymentData);

            HttpSession session = request.getSession();
            session.setAttribute("cartID", userCart.getCartID());

            jsonResponse.put("success", true);
            jsonResponse.put("redirectUrl", result.getCheckoutUrl());
            logger.info("checkout: Payment link created: {}", result.getCheckoutUrl());
        } catch (Exception ex) {
            logger.error("checkout: Failed for user {}: {}", userID, ex.getMessage(), ex);
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Không thể tạo liên kết thanh toán: " + ex.getMessage());
        }
    }

    private void recalculateCartTotals(String userID) {
        Cart userCart = cartDAO.getCartByUserID(userID);
        if (userCart == null) {
            logger.warn("recalculateCartTotals: No cart for user {}", userID);
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
        logger.info("recalculateCartTotals: Cart {} updated. Total: {}, Discount: {}", userCart.getCartID(), total, discount);
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
        logger.info("CartServlet destroyed.");
    }
}