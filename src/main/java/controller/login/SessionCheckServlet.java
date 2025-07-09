package controller.login;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.google.gson.Gson;
import authentication.SessionManager;
import model.UserAccount;

@WebServlet("/checkSession")
public class SessionCheckServlet extends HttpServlet {
    private SessionManager sessionManager = new SessionManager();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (session == null || session.getAttribute("user") == null) {
            System.out.println("No session or user found in checkSession");
            response.getWriter().write(new Gson().toJson(new SessionStatus(false)));
            return;
        }

        UserAccount user = (UserAccount) session.getAttribute("user");
        try {
            boolean isValid = sessionManager.validateSession(user, session);
            if (!isValid) {
                session.invalidate(); // Tự động đăng xuất nếu không hợp lệ
                System.out.println("Session invalidated for " + user.getUsername() + " due to new login");
            }
            System.out.println("Session check for " + user.getUsername() + ": Valid = " + isValid + ", DB SessionId = " + (sessionManager.getSessionIdFromDAO(user.getUsername()) != null ? sessionManager.getSessionIdFromDAO(user.getUsername()) : "null") + ", SessionId = " + session.getId());
            response.getWriter().write(new Gson().toJson(new SessionStatus(isValid)));
        } catch (Exception e) {
            System.out.println("Session validation error: " + e.getMessage());
            response.getWriter().write(new Gson().toJson(new SessionStatus(false)));
        }
    }

    private class SessionStatus {
        private boolean valid;

        public SessionStatus(boolean valid) {
            this.valid = valid;
        }

        public boolean isValid() {
            return valid;
        }
    }
}