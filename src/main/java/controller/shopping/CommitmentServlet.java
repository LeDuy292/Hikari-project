package controller.shopping;

import dao.CourseDAO;
import dao.CommitmentDAO;
import model.Course;
import model.Commitment;
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
            int courseId = Integer.parseInt(request.getParameter("id"));
            
            Course course = courseDAO.getCourseById(courseId);
            List<Commitment> commitments = commitmentDAO.getCommitmentsByCourseId(courseId);
            
            if (course != null) {
                request.setAttribute("course", course);
                request.setAttribute("commitments", commitments);
                request.getRequestDispatcher("/view/student/commitments.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/courses");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/courses");
        }
    }
}