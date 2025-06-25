package controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.admin.Review;
import service.ReviewService;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/reviews")
public class ManageReviewsServlet extends HttpServlet {
    private final ReviewService reviewService = new ReviewService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        
        try {
            if ("view".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                Review review = reviewService.getReviewById(id);
                req.setAttribute("review", review);
                req.getRequestDispatcher("/view/admin/viewReview.jsp").forward(req, resp);
            } else if ("byCourse".equals(action)) {
                String courseID = req.getParameter("courseID");
                List<Review> reviews = reviewService.getReviewsByCourse(courseID);
                req.setAttribute("reviews", reviews);
                req.getRequestDispatcher("/view/admin/manageReviews.jsp").forward(req, resp);
            } else {
                List<Review> reviews = reviewService.getAllReviews();
                req.setAttribute("reviews", reviews);
                req.getRequestDispatcher("/view/admin/manageReviews.jsp").forward(req, resp);
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
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/view/admin/error.jsp").forward(req, resp);
        }
    }
}
