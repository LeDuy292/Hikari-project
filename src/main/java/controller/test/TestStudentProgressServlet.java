package controller.test;

import dao.student.StudentProgressDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;

@WebServlet("/test/studentProgress")
public class TestStudentProgressServlet extends HttpServlet {
    
    private static final Logger logger = LoggerFactory.getLogger(TestStudentProgressServlet.class);
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        String userID = request.getParameter("userID");
        if (userID == null || userID.trim().isEmpty()) {
            userID = "U001"; // Default test user
        }
        
        StudentProgressDAO progressDAO = new StudentProgressDAO();
        
        try {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Test Student Progress</title>");
            out.println("<style>");
            out.println("body { font-family: Arial, sans-serif; margin: 20px; }");
            out.println(".stats { background: #f0f0f0; padding: 15px; margin: 10px 0; border-radius: 5px; }");
            out.println(".course { background: #e0f0ff; padding: 10px; margin: 5px 0; border-left: 4px solid #007bff; }");
            out.println("</style>");
            out.println("</head>");
            out.println("<body>");
            
            out.println("<h1>Test Student Progress for User: " + userID + "</h1>");
            
            // Test student stats
            out.println("<h2>Student Statistics</h2>");
            Map<String, Object> stats = progressDAO.getStudentStats(userID);
            out.println("<div class='stats'>");
            out.println("<p><strong>Total Courses:</strong> " + stats.get("totalCourses") + "</p>");
            out.println("<p><strong>Completed Courses:</strong> " + stats.get("completedCourses") + "</p>");
            out.println("<p><strong>Average Progress:</strong> " + stats.get("averageProgress") + "%</p>");
            out.println("<p><strong>Total Hours:</strong> " + stats.get("totalHours") + "</p>");
            out.println("</div>");
            
            // Test individual course progress
            out.println("<h2>Individual Course Progress</h2>");
            Map<String, Double> allProgress = progressDAO.getAllCourseProgressByUser(userID);
            
            if (allProgress.isEmpty()) {
                out.println("<p>No courses found for this user.</p>");
            } else {
                for (Map.Entry<String, Double> entry : allProgress.entrySet()) {
                    out.println("<div class='course'>");
                    out.println("<p><strong>Course:</strong> " + entry.getKey() + "</p>");
                    out.println("<p><strong>Progress:</strong> " + entry.getValue() + "%</p>");
                    
                    // Get detailed progress
                    Map<String, Integer> details = progressDAO.getDetailedProgressByUserAndCourse(userID, entry.getKey());
                    out.println("<p><strong>Lessons:</strong> " + details.get("completedLessons") + "/" + details.get("totalLessons") + "</p>");
                    out.println("<p><strong>Assignments:</strong> " + details.get("completedAssignments") + "/" + details.get("totalAssignments") + "</p>");
                    out.println("</div>");
                }
            }
            
            out.println("<h2>Test Other Users</h2>");
            out.println("<p><a href='?userID=U001'>Test U001</a> | <a href='?userID=U002'>Test U002</a> | <a href='?userID=U003'>Test U003</a></p>");
            
            out.println("</body>");
            out.println("</html>");
            
        } catch (Exception e) {
            logger.error("Error testing student progress for user {}: {}", userID, e.getMessage(), e);
            out.println("<h2>Error occurred:</h2>");
            out.println("<p>" + e.getMessage() + "</p>");
        } finally {
            progressDAO.closeConnection();
        }
    }
}
