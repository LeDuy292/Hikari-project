package utils;

import jakarta.servlet.http.HttpSession;
import model.UserAccount;

/**
 * Utility class for session management
 */
public class SessionUtil {
    
    /**
     * Check if user is authenticated
     */
    public static boolean isAuthenticated(HttpSession session) {
        if (session == null) {
            return false;
        }
        
        String userId = (String) session.getAttribute("userId");
        String username = (String) session.getAttribute("username");
        
        return userId != null && username != null;
    }
    
    /**
     * Get current user from session
     */
    public static UserAccount getCurrentUser(HttpSession session) {
        if (session == null) {
            return null;
        }
        
        return (UserAccount) session.getAttribute("user");
    }
    
    /**
     * Get current user ID from session
     */
    public static String getCurrentUserId(HttpSession session) {
        if (session == null) {
            return null;
        }
        
        return (String) session.getAttribute("userId");
    }
    
    /**
     * Get current username from session
     */
    public static String getCurrentUsername(HttpSession session) {
        if (session == null) {
            return null;
        }
        
        return (String) session.getAttribute("username");
    }
    
    /**
     * Clear session data
     */
    public static void clearSession(HttpSession session) {
        if (session != null) {
            session.invalidate();
        }
    }
}
