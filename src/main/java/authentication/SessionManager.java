package authentication;

import jakarta.servlet.http.HttpSession;
import dao.UserDAO;
import model.UserAccount;

public class SessionManager {
    private UserDAO userDAO = new UserDAO();

    public void updateSession(UserAccount user, HttpSession session) throws Exception {
        String currentSessionId = userDAO.getSessionIdByUsername(user.getUsername());
        user.setSessionId(session.getId());
        userDAO.updateSessionId(user.getUserNum(), session.getId());
        System.out.println("Updated sessionId for " + user.getUsername() + " to: " + session.getId() + ", Previous: " + (currentSessionId != null ? currentSessionId : "null"));
    }

    public boolean validateSession(UserAccount user, HttpSession session) throws Exception {
        String dbSessionId = userDAO.getSessionIdByUsername(user.getUsername());
        System.out.println("Validating session for " + user.getUsername() + ": DB SessionId=" + (dbSessionId != null ? dbSessionId : "null") + ", Current SessionId=" + session.getId());
        if (dbSessionId == null) {
            updateSession(user, session);
            return true;
        }
        boolean isValid = dbSessionId.equals(session.getId());
        if (!isValid) {
            System.out.println("Session invalidated for " + user.getUsername() + " due to mismatch");
        }
        return isValid;
    }

    public String getSessionIdFromDAO(String username) throws Exception {
        return userDAO.getSessionIdByUsername(username);
    }
}