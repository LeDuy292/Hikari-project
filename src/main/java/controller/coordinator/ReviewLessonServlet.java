/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.coordinator;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.coordinator.Lesson;
import model.coordinator.LessonReviews;
import dao.coordinator.LessonDAO;
import dao.coordinator.LessonReviewsDAO;
import java.io.IOException;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@WebServlet("/ReviewLessonServlet")
public class ReviewLessonServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(ReviewLessonServlet.class);
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String lessonID = request.getParameter("lessonID");

        if ("view".equals(action) && lessonID != null) {
            LessonDAO lessonDAO = new LessonDAO();
            Lesson lesson = lessonDAO.getLessonByID(Integer.parseInt(lessonID));
            lessonDAO.closeConnection();
            request.setAttribute("lesson", lesson);
            request.getRequestDispatcher("view/coordinator/course-approval.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String lessonID = request.getParameter("lessonID");
        String reviewerID = (String) request.getSession().getAttribute("userId");
        int rating = Integer.parseInt(request.getParameter("rating"));
        String reviewText = request.getParameter("reviewText");
        String reviewStatus = request.getParameter("reviewStatus");
        Timestamp reviewDate = new Timestamp(System.currentTimeMillis());

        LessonReviews review = new LessonReviews(0, Integer.parseInt(lessonID), reviewerID, rating, reviewText, reviewStatus, reviewDate);
        LessonReviewsDAO reviewDAO = new LessonReviewsDAO();

        List<LessonReviews> existingReviews = reviewDAO.getReviewsByLessonID(Integer.parseInt(lessonID));
        if (existingReviews.isEmpty()) {
            int affectedRows = reviewDAO.addReviewWithReturn(review);
            logger.info("ReviewLessonServlet: Added new review for lessonID: {}, affected rows: {}", lessonID, affectedRows);
        } else {
            reviewDAO.updateReviewByLessonID(review);
            logger.info("ReviewLessonServlet: Updated reviews for lessonID: {}", lessonID);
        }
        reviewDAO.closeConnection();

        response.sendRedirect("LessonApprovalServlet?courseID=" + request.getParameter("courseID"));
    }
}
