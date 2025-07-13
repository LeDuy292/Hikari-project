package authentication;

import jakarta.servlet.http.HttpSession;
import model.UserAccount;
import java.util.HashMap;
import java.util.Map;

public class UserAuthentication {
    public static boolean isAuthenticated(HttpSession session) {
        if (session == null) {
            return false;
        }
        
        // Check both methods for compatibility
        Object userObj = session.getAttribute("user");
        if (userObj instanceof UserAccount) {
            return true;
        } else if (userObj instanceof Map) {
            return true;
        }
        
        return false;
    }

    public static String getUserRole(HttpSession session) {
        if (session == null) {
            return null;
        }
        
        Object userObj = session.getAttribute("user");
        if (userObj instanceof UserAccount) {
            return ((UserAccount) userObj).getRole();
        } else if (userObj instanceof Map) {
            @SuppressWarnings("unchecked")
            Map<String, Object> user = (Map<String, Object>) userObj;
            return (String) user.get("role");
        }
        
        return null;
    }

    public static String getUserID(HttpSession session) {
        if (session == null) {
            return null;
        }
        
        Object userObj = session.getAttribute("user");
        if (userObj instanceof UserAccount) {
            return ((UserAccount) userObj).getUserID();
        } else if (userObj instanceof Map) {
            @SuppressWarnings("unchecked")
            Map<String, Object> user = (Map<String, Object>) userObj;
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
