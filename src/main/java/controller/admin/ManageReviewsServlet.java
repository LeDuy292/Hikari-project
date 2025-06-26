package controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.admin.Review;
import model.UserAccount;
import service.ReviewService;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

@WebServlet("/admin/reviews")
public class ManageReviewsServlet extends HttpServlet {
    private final ReviewService reviewService = new ReviewService();

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
                Review review = reviewService.getReviewById(id);
                
                if (review == null) {
                    resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    return;
                }
                
                // Return JSON response for AJAX
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                
                StringBuilder json = new StringBuilder();
                json.append("{");
                json.append("\"id\":").append(review.getId()).append(",");
                json.append("\"reviewerName\":\"").append(review.getReviewerName()).append("\",");
                json.append("\"courseName\":\"").append(review.getCourseName()).append("\",");
                json.append("\"rating\":").append(review.getRating()).append(",");
                json.append("\"reviewText\":\"").append(review.getReviewText().replace("\"", "\\\"")).append("\",");
                json.append("\"reviewDate\":\"").append(review.getReviewDate()).append("\"");
                json.append("}");
                
                resp.getWriter().write(json.toString());
                return;
            } else if ("byCourse".equals(action)) {
                String courseID = req.getParameter("courseID");
                List<Review> reviews = reviewService.getReviewsByCourse(courseID);
                req.setAttribute("reviews", reviews);
                req.getRequestDispatcher("/view/admin/manageReviews.jsp").forward(req, resp);
            } else {
                // Get filter parameters
                String courseID = req.getParameter("courseID");
                String ratingStr = req.getParameter("rating");
                String search = req.getParameter("search");
                String pageStr = req.getParameter("page");
                
                int page = 1;
                if (pageStr != null) {
                    try { 
                        page = Integer.parseInt(pageStr); 
                        if (page < 1) page = 1;
                    } catch (NumberFormatException ignored) {}
                }
                
                List<Review> reviews;
                if (courseID != null && !courseID.trim().isEmpty()) {
                    reviews = reviewService.getReviewsByCourse(courseID);
                } else {
                    reviews = reviewService.getAllReviews();
                }
                
                // Apply rating filter if provided
                if (ratingStr != null && !ratingStr.trim().isEmpty()) {
                    try {
                        int rating = Integer.parseInt(ratingStr);
                        reviews = reviews.stream()
                            .filter(r -> r.getRating() == rating)
                            .collect(java.util.stream.Collectors.toList());
                    } catch (NumberFormatException ignored) {}
                }
                
                // Apply search filter if provided
                if (search != null && !search.trim().isEmpty()) {
                    reviews = reviews.stream()
                        .filter(r -> r.getReviewerName().toLowerCase().contains(search.toLowerCase()) ||
                                   String.valueOf(r.getId()).contains(search))
                        .collect(java.util.stream.Collectors.toList());
                }
                
                // Pagination
                int pageSize = 10;
                int totalReviews = reviews.size();
                int totalPages = (int) Math.ceil((double) totalReviews / pageSize);
                
                int startIndex = (page - 1) * pageSize;
                int endIndex = Math.min(startIndex + pageSize, totalReviews);
                
                if (startIndex < totalReviews) {
                    reviews = reviews.subList(startIndex, endIndex);
                } else {
                    reviews = new ArrayList<>();
                }
                
                req.setAttribute("reviews", reviews);
                req.setAttribute("currentPage", page);
                req.setAttribute("totalPages", totalPages);
                req.setAttribute("totalReviews", totalReviews);
                req.setAttribute("courseID", courseID);
                req.setAttribute("rating", ratingStr);
                req.setAttribute("search", search);
                
                req.getRequestDispatcher("/view/admin/manageReviews.jsp").forward(req, resp);
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
            if ("edit".equals(action)) {
                int id = Integer.parseInt(req.getParameter("reviewId"));
                Review review = new Review();
                review.setId(id);
                review.setRating(Integer.parseInt(req.getParameter("rating")));
                review.setReviewText(req.getParameter("reviewText"));
                
                reviewService.updateReview(review);
                resp.sendRedirect(req.getContextPath() + "/admin/reviews?message=Cập nhật thành công");
                
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("reviewId"));
                reviewService.deleteReview(id);
                resp.sendRedirect(req.getContextPath() + "/admin/reviews?message=Xóa thành công");
            }
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/admin/reviews?error=" + e.getMessage());
        }
    }
}
