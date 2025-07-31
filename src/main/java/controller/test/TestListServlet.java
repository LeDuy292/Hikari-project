package controller.test;

import dao.TestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Test;
import model.UserAccount;

@WebServlet(name = "TestListServlet", urlPatterns = {"/test-list"})
public class TestListServlet extends HttpServlet {
    
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
        if (!checkAuthentication(request, response)) {
            return;
        }
        // Fetch all active tests from the database
        List<Test> tests = testDAO.getAllActiveTests();
        // Group tests by JLPT level
        List<Test> n5Tests = tests.stream()
                .filter(t -> t.getJlptLevel().equalsIgnoreCase("N5"))
                .toList();
        List<Test> n4Tests = tests.stream()
                .filter(t -> t.getJlptLevel().equalsIgnoreCase("N4"))
                .toList();
        List<Test> n3Tests = tests.stream()
                .filter(t -> t.getJlptLevel().equalsIgnoreCase("N3"))
                .toList();
        List<Test> n2Tests = tests.stream()
                .filter(t -> t.getJlptLevel().equalsIgnoreCase("N2"))
                .toList();
        List<Test> n1Tests = tests.stream()
                .filter(t -> t.getJlptLevel().equalsIgnoreCase("N1"))
                .toList();
        // Set attributes for JSP
        request.setAttribute("n5Tests", n5Tests);
        request.setAttribute("n4Tests", n4Tests);
        request.setAttribute("n3Tests", n3Tests);
        request.setAttribute("n2Tests", n2Tests);
        request.setAttribute("n1Tests", n1Tests);
        // Forward to JSP
        request.getRequestDispatcher("/view/student/jlpt-test.jsp").forward(request, response);
    }
}
