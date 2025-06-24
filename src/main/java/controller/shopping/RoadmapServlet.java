package controller.shopping;

import dao.CourseDAO;
import dao.student.RoadmapDAO;
import model.Course;
import model.student.Roadmap;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/roadmap")
public class RoadmapServlet extends HttpServlet {
    private CourseDAO courseDAO;
    private RoadmapDAO roadmapDAO;
    
    @Override
    public void init() throws ServletException {
        courseDAO = new CourseDAO();
        roadmapDAO = new RoadmapDAO();
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
            List<Roadmap> roadmaps = roadmapDAO.getRoadmapByCourseId(courseId); // Pass String directly
            
            if (course != null) {
                request.setAttribute("course", course);
                request.setAttribute("roadmaps", roadmaps);
                request.getRequestDispatcher("/view/student/roadmap.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/courses?error=no_data");
            }
        } catch (Exception e) { // Catch generic Exception for robustness
            System.err.println("Error in RoadmapServlet: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/courses?error=system_error");
        }
    }
}
