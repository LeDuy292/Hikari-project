package constant;

/**
 * Forum permissions constants for Role-Based Access Control
 */
public class ForumPermissions {
    
    // Role constants
    public static final String ROLE_STUDENT = "Student";
    public static final String ROLE_TEACHER = "Teacher";
    public static final String ROLE_COORDINATOR = "Coordinator";
    public static final String ROLE_ADMIN = "Admin";
    
    // Permission constants
    public static final String PERM_READ_POSTS = "READ_POSTS";
    public static final String PERM_CREATE_POSTS = "CREATE_POSTS";
    public static final String PERM_EDIT_OWN_POSTS = "EDIT_OWN_POSTS";
    public static final String PERM_DELETE_OWN_POSTS = "DELETE_OWN_POSTS";
    public static final String PERM_COMMENT = "COMMENT";
    public static final String PERM_EDIT_OTHERS_POSTS = "EDIT_OTHERS_POSTS";
    public static final String PERM_DELETE_OTHERS_POSTS = "DELETE_OTHERS_POSTS";
    public static final String PERM_MODERATE_CONTENT = "MODERATE_CONTENT";
    public static final String PERM_MANAGE_CATEGORIES = "MANAGE_CATEGORIES";
    public static final String PERM_HANDLE_COMPLAINTS = "HANDLE_COMPLAINTS";
    public static final String PERM_MANAGE_USERS = "MANAGE_USERS";
    public static final String PERM_FULL_ADMIN = "FULL_ADMIN";
    public static final String PERM_PIN_POSTS = "PIN_POSTS";
    public static final String PERM_HIDE_POSTS = "HIDE_POSTS";
    
    // Category permissions
    public static final String CATEGORY_GENERAL = "General";
    public static final String CATEGORY_N5 = "N5";
    public static final String CATEGORY_N4 = "N4";
    public static final String CATEGORY_N3 = "N3";
    public static final String CATEGORY_N2 = "N2";
    public static final String CATEGORY_N1 = "N1";
    public static final String CATEGORY_GRAMMAR = "Ngữ pháp";
    public static final String CATEGORY_EXPERIENCE = "Kinh nghiệm thi";
    public static final String CATEGORY_MATERIALS = "Tài liệu";
    public static final String CATEGORY_TOOLS = "Công cụ";
    public static final String CATEGORY_ANNOUNCEMENT = "Thông báo";
    
    // Post status
    public static final String STATUS_ACTIVE = "ACTIVE";
    public static final String STATUS_HIDDEN = "HIDDEN";
    public static final String STATUS_DELETED = "DELETED";
    public static final String STATUS_PINNED = "PINNED";
}
