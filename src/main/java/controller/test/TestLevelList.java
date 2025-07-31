/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.test;

import dao.TestDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Test;
import model.UserAccount;

/**
 *
 * @author LENOVO
 */
@WebServlet(name = "TestLevelList", urlPatterns = {"/TestLevel"})
public class TestLevelList extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(TestListServlet.class.getName());
    private final TestDAO testDAO = new TestDAO();

    private boolean checkAuthentication(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);

        if (session == null) {
            redirectToLogin(request, response);
            return false;
        }

        String userId = (String) session.getAttribute("userId");
        String username = (String) session.getAttribute("username");
        UserAccount user = (UserAccount) session.getAttribute("user");

        if (userId == null || username == null || user == null) {
            LOGGER.info("User not authenticated, redirecting to login");
            redirectToLogin(request, response);
            return false;
        }

        return true;
    }

    private void redirectToLogin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String originalUrl = request.getRequestURI();
        if (request.getQueryString() != null) {
            originalUrl += "?" + request.getQueryString();
        }

        HttpSession newSession = request.getSession(true);
        newSession.setAttribute("redirectUrl", originalUrl);

        response.sendRedirect(request.getContextPath() + "/loginPage");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            if (!checkAuthentication(request, response)) {
                return;
            }
            // Fetch all active tests from the database
            List<Test> tests = testDAO.getAllActiveTests();
            LOGGER.log(Level.INFO, "Total active tests found: {0}", tests.size());

            // Group tests by JLPT level
            List<Test> levelTests = tests.stream()
                    .filter(t -> t.getJlptLevel() != null && t.getJlptLevel().equalsIgnoreCase("level"))
                    .toList();

            LOGGER.log(Level.INFO, "Level tests found: {0}", levelTests.size());
            levelTests.forEach(test
                    -> LOGGER.log(Level.INFO, "Test found - ID: {0}, Title: {1}, Level: {2}",
                            new Object[]{test.getId(), test.getTitle(), test.getJlptLevel()})
            );

            // Set attributes for JSP
            request.setAttribute("levelTests", levelTests);

            // Log request attributes for debugging
            LOGGER.log(Level.INFO, "Request attributes before forward: {0}", request.getAttributeNames());

            // Forward to JSP
            request.getRequestDispatcher("/view/student/level-test.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in TestLevelList: " + e.getMessage(), e);
            throw new ServletException("Error processing test list", e);
        }
    }
}
