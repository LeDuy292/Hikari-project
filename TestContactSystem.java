import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class TestContactSystem {
    public static void main(String[] args) {
        System.out.println("=== Testing Contact System ===");
        
        // Test database connection
        testDatabaseConnection();
        
        // Test Contact model
        testContactModel();
        
        // Test ContactDAO
        testContactDAO();
        
        System.out.println("=== Test completed ===");
    }
    
    private static void testDatabaseConnection() {
        System.out.println("Testing database connection...");
        try {
            // Test connection using DBContext
            utils.DBContext dbContext = new utils.DBContext();
            Connection conn = dbContext.getConnection();
            System.out.println("✅ Database connection successful!");
            conn.close();
        } catch (Exception e) {
            System.out.println("❌ Database connection failed: " + e.getMessage());
        }
    }
    
    private static void testContactModel() {
        System.out.println("Testing Contact model...");
        try {
            model.Contact contact = new model.Contact("C001", "Test User", "test@example.com", "0123456789", "COURSE_ADVICE", "Test message");
            System.out.println("✅ Contact model created successfully!");
            System.out.println("   - ID: " + contact.getContactID());
            System.out.println("   - Name: " + contact.getName());
            System.out.println("   - Issue Type: " + contact.getIssueTypeDisplayName());
            System.out.println("   - Status: " + contact.getStatusDisplayName());
        } catch (Exception e) {
            System.out.println("❌ Contact model test failed: " + e.getMessage());
        }
    }
    
    private static void testContactDAO() {
        System.out.println("Testing ContactDAO...");
        try {
            dao.ContactDAO contactDAO = new dao.ContactDAO();
            String nextId = contactDAO.generateNextContactId();
            System.out.println("✅ ContactDAO created successfully!");
            System.out.println("   - Next Contact ID: " + nextId);
            
            int pendingCount = contactDAO.getPendingContactsCount();
            System.out.println("   - Pending contacts: " + pendingCount);
        } catch (Exception e) {
            System.out.println("❌ ContactDAO test failed: " + e.getMessage());
        }
    }
} 