package controller.shopping;

import com.google.gson.Gson;
import dao.*;
import model.*;
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

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

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
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Bạn cần đăng nhập để thực hiện chức năng này.");
            out.print(gson.toJson(jsonResponse));
            return;
        }

        String userID = user.getUserID();
        String action = request.getParameter("action");

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
                default:
                    jsonResponse.put("success", false);
                    jsonResponse.put("message", "Hành động không hợp lệ.");
                    break;
            }
        } catch (Exception e) {
            System.err.println("Error in CartServlet: " + e.getMessage());
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Đã xảy ra lỗi hệ thống: " + e.getMessage());
        } finally {
            out.print(gson.toJson(jsonResponse));
            out.close();
        }
    }

    private void addToCart(HttpServletRequest request, Map<String, Object> jsonResponse, String userID) {
        String courseID = request.getParameter("courseID");
        System.out.println("Received courseID: " + courseID);

        if (courseID == null || courseID.trim().isEmpty()) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Mã khóa học không hợp lệ.");
            return;
        }

        if (!courseID.matches("^CO\\d+$")) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Định dạng mã khóa học không hợp lệ.");
            return;
        }

        int courseNum;
        try {
            courseNum = Integer.parseInt(courseID.substring(2));
        } catch (NumberFormatException e) {
            System.err.println("Invalid courseID format: " + courseID);
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Mã khóa học không hợp lệ.");
            return;
        }

        Course course = courseDAO.getCourseByID(courseNum);
        if (course == null) {
            System.err.println("Course not found for courseNum: " + courseNum);
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Khóa học không tồn tại.");
            return;
        }

        if (!course.isActive()) {
            System.err.println("Course is not active: " + courseNum);
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Khóa học không còn hoạt động.");
            return;
        }

        if (course.getEndDate().before(Date.valueOf(LocalDate.now()))) {
            System.err.println("Course has expired: " + courseNum);
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
        if (userCart == null) {
            int newCartID = cartDAO.createCart(userID);
            if (newCartID == -1) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Không thể tạo giỏ hàng mới.");
                return;
            }
            userCart = cartDAO.getCartByUserID(userID);
        }

        CartItem existingItem = cartItemDAO.getCartItemByCartIdAndCourseId(userCart.getCartID(), course.getCourseID());
        if (existingItem != null) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Khóa học đã có trong giỏ hàng của bạn.");
            return;
        }

        CartItem newItem = new CartItem();
        newItem.setCartID(userCart.getCartID());
        newItem.setCourseID(course.getCourseID());
        newItem.setQuantity(1);
        newItem.setPriceAtTime(course.getFee());
        newItem.setDiscountApplied(BigDecimal.ZERO);

        if (cartItemDAO.addCartItem(newItem)) {
            recalculateCartTotals(userID);
            jsonResponse.put("success", true);
            jsonResponse.put("message", "Đã thêm khóa học vào giỏ hàng.");
            jsonResponse.put("cart", cartDAO.getCartByUserID(userID));
        } else {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Không thể thêm khóa học vào giỏ hàng.");
        }
    }

    private void getCartData(Map<String, Object> jsonResponse, String userID) {
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

        items.removeIf(item -> {
            Course course = courseDAO.getCourseByID(Integer.parseInt(item.getCourseID().substring(2)));
            boolean invalid = (course == null || !course.isActive() || course.getEndDate().before(Date.valueOf(LocalDate.now())) || courseEnrollmentDAO.isCourseEnrolled(userID, item.getCourseID()));
            return invalid;
        });

        // Enrich cart items with course details
        for (CartItem item : items) {
            Course course = courseDAO.getCourseByID(Integer.parseInt(item.getCourseID().substring(2)));
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
    }

    private void updateQuantity(HttpServletRequest request, Map<String, Object> jsonResponse, String userID) {
        try {
            int cartItemID = Integer.parseInt(request.getParameter("cartItemID"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            if (quantity < 1) {
                removeItem(request, jsonResponse, userID);
                return;
            }

            if (cartItemDAO.updateCartItemQuantity(cartItemID, quantity)) {
                recalculateCartTotals(userID);
                jsonResponse.put("success", true);
                jsonResponse.put("message", "Đã cập nhật số lượng.");
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Không thể cập nhật số lượng.");
            }
        } catch (NumberFormatException e) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Dữ liệu không hợp lệ.");
        }
    }

    private void removeItem(HttpServletRequest request, Map<String, Object> jsonResponse, String userID) {
        try {
            int cartItemID = Integer.parseInt(request.getParameter("cartItemID"));

            if (cartItemDAO.removeCartItem(cartItemID)) {
                Cart userCart = cartDAO.getCartByUserID(userID);
                if (userCart != null) {
                    recalculateCartTotals(userID);
                }
                jsonResponse.put("success", true);
                jsonResponse.put("message", "Đã xóa khóa học khỏi giỏ hàng.");
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Không thể xóa khóa học.");
            }
        } catch (NumberFormatException e) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Dữ liệu không hợp lệ.");
        }
    }

    private void applyDiscount(HttpServletRequest request, Map<String, Object> jsonResponse, String userID) {
        String discountCode = request.getParameter("discountCode");

        if (discountCode == null || discountCode.trim().isEmpty()) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Vui lòng nhập mã giảm giá.");
            return;
        }

        Discount discount = discountDAO.getDiscountByCode(discountCode);
        if (discount == null || discount.getEndDate().before(Date.valueOf(LocalDate.now()))) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Mã giảm giá không hợp lệ hoặc đã hết hạn.");
            return;
        }

        Cart userCart = cartDAO.getCartByUserID(userID);
        if (userCart == null || userCart.getItemCount() == 0) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Giỏ hàng của bạn đang trống.");
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
                }
            }
        }

        if (discountApplied) {
            BigDecimal newTotal = calculateCurrentTotal(userCart.getCartID()).subtract(totalDiscount);
            if (cartDAO.updateCartTotals(userCart.getCartID(), newTotal, totalDiscount, discountCode)) {
                jsonResponse.put("success", true);
                jsonResponse.put("message", "Đã áp dụng mã giảm giá '" + discountCode + "' thành công!");
                jsonResponse.put("discountPercent", discount.getDiscountPercent());
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Không thể cập nhật tổng giỏ hàng sau khi áp dụng giảm giá.");
            }
        } else {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Mã giảm giá không áp dụng cho bất kỳ khóa học nào trong giỏ hàng.");
        }
    }

    private void recalculateCartTotals(String userID) {
        Cart userCart = cartDAO.getCartByUserID(userID);
        if (userCart == null) {
            return;
        }

        List<CartItem> items = cartItemDAO.getCartItemsByCartID(userCart.getCartID());
        BigDecimal total = BigDecimal.ZERO;
        BigDecimal discount = BigDecimal.ZERO; // Corrected line

        for (CartItem item : items) {
            total = total.add(item.getPriceAtTime().multiply(BigDecimal.valueOf(item.getQuantity())));
            discount = discount.add(item.getDiscountApplied());
        }

        BigDecimal finalTotal = total.subtract(discount);
        cartDAO.updateCartTotals(userCart.getCartID(), finalTotal, discount, userCart.getDiscountCodeApplied());
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
        cartDAO.closeConnection();
        cartItemDAO.closeConnection();
        courseDAO.closeConnection();
        discountDAO.closeConnection();
        courseEnrollmentDAO.closeConnection();
    }
}
