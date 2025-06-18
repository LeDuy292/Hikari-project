package authentication;

import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

public class UserAuthentication {
    public static boolean isAuthenticated(HttpSession session) {
        return session != null && session.getAttribute("user") != null;
    }

    public static String getUserRole(HttpSession session) {
        if (session != null && session.getAttribute("user") != null) {
            @SuppressWarnings("unchecked")
            Map<String, Object> user = (Map<String, Object>) session.getAttribute("user");
            return (String) user.get("role");
        }
        return null;
    }

    public static String getUserID(HttpSession session) {
        if (session != null && session.getAttribute("user") != null) {
            @SuppressWarnings("unchecked")
            Map<String, Object> user = (Map<String, Object>) session.getAttribute("user");
            return (String) user.get("userID");
        }
        return null;
    }

    public static void setUserSession(HttpSession session, String userID, String role) {
        if (session != null) {
            Map<String, Object> user = new HashMap<>();
            user.put("userID", userID);
            user.put("role", role);
            session.setAttribute("user", user);
        }
    }

    public static void invalidateSession(HttpSession session) {
        if (session != null) {
            session.invalidate();
        }
    }
}