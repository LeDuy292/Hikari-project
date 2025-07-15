package controller.login;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dao.UserDAO;
import model.UserAccount;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            UserAccount user = (UserAccount) session.getAttribute("user");
            if (user != null) {
                try {
                    UserDAO userDAO = new UserDAO();
                    userDAO.updateSessionId(user.getUserID(), null);
                    System.out.println("SessionId updated to null for userNum: " + user.getUserID() + " at " + new java.util.Date());
                } catch (Exception e) {
                    System.err.println("Error updating sessionId for userNum " + user.getUserID() + ": " + e.getMessage());
                    e.printStackTrace();
                }
                session.invalidate();
                System.out.println("Session invalidated successfully for userNum: " + user.getUserID() + " at " + new java.util.Date());
            } else {
                System.out.println("No user found in session during logout at " + new java.util.Date());
            }
        } else {
            System.out.println("No active session found during logout at " + new java.util.Date());
        }
        response.sendRedirect(request.getContextPath() + "/");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
