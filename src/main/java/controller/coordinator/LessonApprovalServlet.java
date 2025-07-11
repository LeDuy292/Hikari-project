/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.coordinator;

import dao.TeacherDAO;
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
import java.util.List;
import java.util.stream.Collectors;
import model.Teacher;

@WebServlet("/LessonApprovalServlet")
public class LessonApprovalServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String courseID = request.getParameter("courseID");
        String search = request.getParameter("search");
        
        int page = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
        int pageSize = request.getParameter("pageSize") != null ? Integer.parseInt(request.getParameter("pageSize")) : 10;

        LessonDAO lessonDAO = new LessonDAO();
        LessonReviewsDAO reviewDAO = new LessonReviewsDAO();
        TeacherDAO teacherDAO = new TeacherDAO();
        List<Teacher> teachers = teacherDAO.getAllTeachers();
        List<Lesson> lessons;
        List<LessonReviews> reviews;

        if (courseID != null && !courseID.isEmpty()) {
            lessons = lessonDAO.getLessonsByCourseID(courseID);
            reviews = reviewDAO.getReviewsByCourseID(courseID);
        } else {
            lessons = lessonDAO.getLessonsByCourseID(""); 
            reviews = reviewDAO.getReviewsByCourseID(""); 
        }
        
        for(Lesson l : lessons){
            for(Teacher t : teachers ){
                if(l.getTeacherID().equals(t.getTeacherID())){
                    l.setTeacherName(t.getFullName());
                }
            }
        }
        
        int totalLessons = lessons.size();
        int totalPages = (int) Math.ceil((double) totalLessons / pageSize);
        page = Math.max(1, Math.min(page, totalPages)); // Đảm bảo page trong phạm vi hợp lệ
        int start = (page - 1) * pageSize;
        int end = Math.min(start + pageSize, totalLessons);
        List<Lesson> paginatedLessons = lessons.subList(start, end);

        request.setAttribute("lessons", paginatedLessons);
        request.setAttribute("reviews", reviews);
        request.setAttribute("courseID", courseID);
        request.setAttribute("pendingCount", reviews.stream().filter(r -> "Pending".equals(r.getReviewStatus())).count());
        request.setAttribute("approvedCount", reviews.stream().filter(r -> "Approved".equals(r.getReviewStatus())).count());
        request.setAttribute("rejectedCount", reviews.stream().filter(r -> "Rejected".equals(r.getReviewStatus())).count());
        
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", pageSize);
        
        lessonDAO.closeConnection();
        reviewDAO.closeConnection();
        teacherDAO.closeConnection();
        request.getRequestDispatcher("view/coordinator/course-approval.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response); 
    }
}