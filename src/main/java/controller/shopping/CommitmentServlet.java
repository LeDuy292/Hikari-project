package controller.shopping;

import dao.CourseDAO;
import dao.student.CommitmentDAO;
import model.Course;
import model.student.Commitment;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/commitments")
public class CommitmentServlet extends HttpServlet {
    private CourseDAO courseDAO;
    private CommitmentDAO commitmentDAO;
    
    @Override
    public void init() throws ServletException {
        courseDAO = new CourseDAO();
        commitmentDAO = new CommitmentDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String courseId = request.getParameter("id"); // Changed to String
            
            if (courseId == null || courseId.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/courses?error=invalid_id");
                return;
            }

            Course course = courseDAO.getCourseByID(courseId); // Pass String directly
            List<Commitment> commitments = commitmentDAO.getCommitmentsByCourseId(courseId); // Pass String directly
            
            if (course != null) {
                request.setAttribute("course", course);
                request.setAttribute("commitments", commitments);
                request.getRequestDispatcher("/view/student/commitments.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/courses?error=no_data");
            }
        } catch (Exception e) { // Catch generic Exception for robustness
            System.err.println("Error in CommitmentServlet: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/courses?error=system_error");
        }
    }
}
