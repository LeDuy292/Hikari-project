/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.coordinator;

import dao.TeacherDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
 * Servlet to handle teacher assignment to classes.
 */
public class TeacherAssignmentServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(TeacherAssignmentServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        // Check session and user role
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null || !"Coordinator".equals(session.getAttribute("role"))) {
            LOGGER.log(Level.WARNING, "Unauthorized access attempt");
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Please log in as a Coordinator to perform this action.");
            return;
        }

        // Get parameters
        String action = request.getParameter("action");
        String classID = request.getParameter("classID");
        String teacherID = request.getParameter("teacherID");

        // Validate inputs
        if (!"assign".equals(action) || classID == null || classID.trim().isEmpty()) {
            LOGGER.log(Level.WARNING, "Invalid action or classID: action={0}, classID={1}", new Object[]{action, classID});
            response.sendRedirect("LoadTeacher?error=Invalid request parameters");
            return;
        }

        TeacherDAO teacherDAO = new TeacherDAO();
        String redirectUrl;

        try {
            if ("assign".equals(action)) {
                if (teacherID == null || teacherID.trim().isEmpty()) {
                    LOGGER.log(Level.WARNING, "No teacher selected for classID: {0}", classID);
                    redirectUrl = "LoadTeacher?error=Please select a teacher";
                } else {
                    boolean success = teacherDAO.assignTeacherToClass(classID, teacherID);
                    if (success) {
                        LOGGER.log(Level.INFO, "Assigned teacher {0} to class {1}", new Object[]{teacherID, classID});
                        redirectUrl = "LoadTeacher?message=Assigned teacher successfully";
                    } else {
                        LOGGER.log(Level.SEVERE, "Failed to assign teacher {0} to class {1}", new Object[]{teacherID, classID});
                        redirectUrl = "LoadTeacher?error=Failed to assign teacher";
                    }
                }
            } else {
                LOGGER.log(Level.WARNING, "Unsupported action: {0}", action);
                redirectUrl = "LoadTeacher?error=Unsupported action";
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Database error during teacher assignment", e);
            redirectUrl = "LoadTeacher?error=Database error: " + e.getMessage();
        }

        response.sendRedirect(redirectUrl);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.log(Level.WARNING, "GET request not supported for TeacherAssignmentServlet");
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "GET method is not supported. Please use POST.");
    }

    @Override
    public String getServletInfo() {
        return "Handles teacher assignment to classes";
    }
}