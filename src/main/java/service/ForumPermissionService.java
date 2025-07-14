package service;

import constant.ForumPermissions;
import static constant.ForumPermissions.PERM_FULL_ADMIN;
import model.UserAccount;
import model.forum.ForumPost;
import java.util.Arrays;
import java.util.List;
import java.util.logging.Logger;

/**
 * Service class to handle forum permissions based on user roles
 */
public class ForumPermissionService {
    
    private static final Logger LOGGER = Logger.getLogger(ForumPermissionService.class.getName());
    
    /**
     * Check if user has specific permission
     */
    public static boolean hasPermission(UserAccount user, String permission) {
        if (user == null || user.getRole() == null) {
            return false;
        }
        
        String role = user.getRole().trim();
        LOGGER.info("Checking permission: " + permission + " for role: " + role);
        
        switch (permission) {
            case ForumPermissions.PERM_READ_POSTS:
                // All authenticated users can read posts
                return true;
                
            case ForumPermissions.PERM_CREATE_POSTS:
            case ForumPermissions.PERM_EDIT_OWN_POSTS:
            case ForumPermissions.PERM_DELETE_OWN_POSTS:
            case ForumPermissions.PERM_COMMENT:
                // All roles have these basic permissions
                return isStudent(role) || isTeacher(role) || isCoordinator(role) || isAdmin(role);
                
            case ForumPermissions.PERM_MODERATE_CONTENT:
            case ForumPermissions.PERM_EDIT_OTHERS_POSTS:
                // Teacher and above can moderate content in their subject areas
                return isTeacher(role) || isCoordinator(role) || isAdmin(role);
                
            case ForumPermissions.PERM_DELETE_OTHERS_POSTS:
            case ForumPermissions.PERM_PIN_POSTS:
            case ForumPermissions.PERM_HIDE_POSTS:
                // Coordinator and Admin can delete others' posts
                return isCoordinator(role) || isAdmin(role);
                
            case ForumPermissions.PERM_MANAGE_CATEGORIES:
            case ForumPermissions.PERM_HANDLE_COMPLAINTS:
                // Only Coordinator and Admin
                return isCoordinator(role) || isAdmin(role);
                
            case ForumPermissions.PERM_MANAGE_USERS:
            case ForumPermissions.PERM_FULL_ADMIN:
                // Only Admin
                return isAdmin(role);
                
            default:
                LOGGER.warning("Unknown permission: " + permission);
                return false;
        }
    }
    
    /**
     * Check if user can edit specific post
     */
    public static boolean canEditPost(UserAccount user, ForumPost post) {
        if (user == null || post == null) {
            return false;
        }
        
        // User can edit their own posts
        if (post.getPostedBy().equals(user.getUserID())) {
            return hasPermission(user, ForumPermissions.PERM_EDIT_OWN_POSTS);
        }
        
        // Teachers can edit posts in educational categories
        if (isTeacher(user.getRole()) && canTeacherModerateCategory(post.getCategory())) {
            return true;
        }
        
        // Higher roles can edit others' posts
        return hasPermission(user, ForumPermissions.PERM_EDIT_OTHERS_POSTS);
    }
    
    /**
     * Check if user can delete specific post
     */
    public static boolean canDeletePost(UserAccount user, ForumPost post) {
        if (user == null || post == null) {
            return false;
        }
        
        // User can delete their own posts
        if (post.getPostedBy().equals(user.getUserID())) {
            return hasPermission(user, ForumPermissions.PERM_DELETE_OWN_POSTS);
        }
        
        // Teachers can delete inappropriate posts in their subject areas
        if (isTeacher(user.getRole()) && canTeacherModerateCategory(post.getCategory())) {
            return true;
        }
        
        // Higher roles can delete others' posts
        return hasPermission(user, ForumPermissions.PERM_DELETE_OTHERS_POSTS);
    }
    
    /**
     * Check if user can moderate content in specific category
     */
    public static boolean canModerateCategory(UserAccount user, String category) {
        if (user == null || category == null) {
            return false;
        }
        
        String role = user.getRole();
        
        // Admin can moderate all categories
        if (isAdmin(role)) {
            return true;
        }
        
        // Coordinator can moderate all categories
        if (isCoordinator(role)) {
            return true;
        }
        
        // Teacher can moderate content in educational categories
        if (isTeacher(role)) {
            return canTeacherModerateCategory(category);
        }
        
        return false;
    }
    
    /**
     * Get allowed categories for user to post
     */
    public static List<String> getAllowedCategories(UserAccount user) {
        if (user == null) {
            return Arrays.asList();
        }
        
        String role = user.getRole();
        
        if (isAdmin(role)) {
            // Admin can post in all categories including announcements
            return Arrays.asList(
                ForumPermissions.CATEGORY_GENERAL,
                ForumPermissions.CATEGORY_N5,
                ForumPermissions.CATEGORY_N4,
                ForumPermissions.CATEGORY_N3,
                ForumPermissions.CATEGORY_N2,
                ForumPermissions.CATEGORY_N1,
                ForumPermissions.CATEGORY_GRAMMAR,
                ForumPermissions.CATEGORY_EXPERIENCE,
                ForumPermissions.CATEGORY_MATERIALS,
                ForumPermissions.CATEGORY_TOOLS,
                ForumPermissions.CATEGORY_ANNOUNCEMENT
            );
        } else if (isCoordinator(role)) {
            // Coordinator can post in all categories except announcements
            return Arrays.asList(
                ForumPermissions.CATEGORY_GENERAL,
                ForumPermissions.CATEGORY_N5,
                ForumPermissions.CATEGORY_N4,
                ForumPermissions.CATEGORY_N3,
                ForumPermissions.CATEGORY_N2,
                ForumPermissions.CATEGORY_N1,
                ForumPermissions.CATEGORY_GRAMMAR,
                ForumPermissions.CATEGORY_EXPERIENCE,
                ForumPermissions.CATEGORY_MATERIALS,
                ForumPermissions.CATEGORY_TOOLS
            );
        } else if (isTeacher(role)) {
            // Teacher can post in educational categories
            return Arrays.asList(
                ForumPermissions.CATEGORY_GENERAL,
                ForumPermissions.CATEGORY_N5,
                ForumPermissions.CATEGORY_N4,
                ForumPermissions.CATEGORY_N3,
                ForumPermissions.CATEGORY_N2,
                ForumPermissions.CATEGORY_N1,
                ForumPermissions.CATEGORY_GRAMMAR,
                ForumPermissions.CATEGORY_EXPERIENCE,
                ForumPermissions.CATEGORY_MATERIALS,
                ForumPermissions.CATEGORY_TOOLS
            );
        } else {
            // Student can post in basic categories
            return Arrays.asList(
                ForumPermissions.CATEGORY_GENERAL,
                ForumPermissions.CATEGORY_N5,
                ForumPermissions.CATEGORY_N4,
                ForumPermissions.CATEGORY_N3,
                ForumPermissions.CATEGORY_N2,
                ForumPermissions.CATEGORY_N1,
                ForumPermissions.CATEGORY_GRAMMAR,
                ForumPermissions.CATEGORY_EXPERIENCE,
                ForumPermissions.CATEGORY_MATERIALS,
                ForumPermissions.CATEGORY_TOOLS
            );
        }
    }
    
    /**
     * Check if user can create posts in specific category
     */
    public static boolean canPostInCategory(UserAccount user, String category) {
        return getAllowedCategories(user).contains(category);
    }
    
    /**
     * Check if user can pin posts
     */
    public static boolean canPinPost(UserAccount user) {
    if (user == null) {
        return false;
    }
    return hasPermission(user, PERM_FULL_ADMIN);
}
    /**
     * Check if user can hide posts
     */
    public static boolean canHidePost(UserAccount user) {
        return hasPermission(user, ForumPermissions.PERM_HIDE_POSTS);
    }
    
    // Helper methods for role checking
    private static boolean isStudent(String role) {
        return ForumPermissions.ROLE_STUDENT.equalsIgnoreCase(role);
    }
    
    private static boolean isTeacher(String role) {
        return ForumPermissions.ROLE_TEACHER.equalsIgnoreCase(role);
    }
    
    private static boolean isCoordinator(String role) {
        return ForumPermissions.ROLE_COORDINATOR.equalsIgnoreCase(role);
    }
    
    private static boolean isAdmin(String role) {
        return ForumPermissions.ROLE_ADMIN.equalsIgnoreCase(role);
    }
    
    private static boolean canTeacherModerateCategory(String category) {
        // Teachers can moderate educational content categories
        return Arrays.asList(
            ForumPermissions.CATEGORY_N5,
            ForumPermissions.CATEGORY_N4,
            ForumPermissions.CATEGORY_N3,
            ForumPermissions.CATEGORY_N2,
            ForumPermissions.CATEGORY_N1,
            ForumPermissions.CATEGORY_GRAMMAR,
            ForumPermissions.CATEGORY_EXPERIENCE,
            ForumPermissions.CATEGORY_MATERIALS,
            ForumPermissions.CATEGORY_TOOLS
        ).contains(category);
    }
    
    /**
     * Get role display name in Vietnamese
     */
    public static String getRoleDisplayName(String role) {
        if (role == null) return "Không xác định";
        
        switch (role.toLowerCase()) {
            case "student":
                return "Học viên";
            case "teacher":
                return "Giảng viên";
            case "coordinator":
                return "Điều phối viên";
            case "admin":
                return "Quản trị viên";
            default:
                return role;
        }
    }
    
    /**
     * Get role badge class for UI styling
     */
    public static String getRoleBadgeClass(String role) {
        if (role == null) return "badge-secondary";
        
        switch (role.toLowerCase()) {
            case "student":
                return "badge-primary";
            case "teacher":
                return "badge-success";
            case "coordinator":
                return "badge-warning";
            case "admin":
                return "badge-danger";
            default:
                return "badge-secondary";
        }
    }
    
    /**
     * Get role priority for sorting (higher number = higher priority)
     */
    public static int getRolePriority(String role) {
        if (role == null) return 0;
        
        switch (role.toLowerCase()) {
            case "admin":
                return 4;
            case "coordinator":
                return 3;
            case "teacher":
                return 2;
            case "student":
                return 1;
            default:
                return 0;
        }
    }
}
