package controller.shopping;

import dao.CourseDAO;
import dao.RoadmapDAO;
import model.Course;
import model.Roadmap;
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
            int courseId = Integer.parseInt(request.getParameter("id"));
            
            Course course = courseDAO.getCourseById(courseId);
            List<Roadmap> roadmaps = roadmapDAO.getRoadmapByCourseId(courseId);
            
            if (course != null) {
                request.setAttribute("course", course);
                request.setAttribute("roadmaps", roadmaps);
                request.getRequestDispatcher("/view/student/roadmap.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/courses");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/courses");
        }
    }
}