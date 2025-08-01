package dao;

import model.Contact;
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

// Import ContactTemplate inner class
import dao.ContactTemplateDAO.ContactTemplate;

/**
 * Data Access Object for Contact entity
 * Handles all database operations for contact requests
 */
public class ContactDAO {
    
    private final DBContext dbContext;
    
    public ContactDAO() {
        this.dbContext = new DBContext();
    }
    
    /**
     * Insert a new contact request
     */
    public boolean insertContact(Contact contact) {
        String sql = "INSERT INTO Contact (contactID, name, email, phone, issue_type, message, status, auto_reply_sent) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, contact.getContactID());
            ps.setString(2, contact.getName());
            ps.setString(3, contact.getEmail());
            ps.setString(4, contact.getPhone());
            ps.setString(5, contact.getIssueType());
            ps.setString(6, contact.getMessage());
            ps.setString(7, contact.getStatus());
            ps.setBoolean(8, contact.isAutoReplySent());
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error inserting contact: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get all contacts with optional filtering
     */
    public List<Contact> getAllContacts(String statusFilter, String issueTypeFilter, String sortBy) {
        List<Contact> contacts = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Contact WHERE 1=1");
        
        // Add filters
        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append(" AND status = ?");
        }
        if (issueTypeFilter != null && !issueTypeFilter.isEmpty()) {
            sql.append(" AND issue_type = ?");
        }
        
        // Add sorting
        if ("newest".equals(sortBy)) {
            sql.append(" ORDER BY created_at DESC");
        } else if ("oldest".equals(sortBy)) {
            sql.append(" ORDER BY created_at ASC");
        } else {
            sql.append(" ORDER BY created_at DESC"); // Default
        }
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            if (statusFilter != null && !statusFilter.isEmpty()) {
                ps.setString(paramIndex++, statusFilter);
            }
            if (issueTypeFilter != null && !issueTypeFilter.isEmpty()) {
                ps.setString(paramIndex, issueTypeFilter);
            }
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Contact contact = mapResultSetToContact(rs);
                contacts.add(contact);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting contacts: " + e.getMessage());
            e.printStackTrace();
        }
        
        return contacts;
    }
    
    /**
     * Get contact by ID
     */
    public Contact getContactById(String contactId) {
        String sql = "SELECT * FROM Contact WHERE contactID = ?";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, contactId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToContact(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting contact by ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Update contact status
     */
    public boolean updateContactStatus(String contactId, String status) {
        String sql = "UPDATE Contact SET status = ?, updated_at = CURRENT_TIMESTAMP WHERE contactID = ?";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setString(2, contactId);
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating contact status: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update coordinator response
     */
    public boolean updateCoordinatorResponse(String contactId, String response, String coordinatorId) {
        String sql = "UPDATE Contact SET coordinator_response = ?, coordinator_id = ?, status = 'RESPONDED', updated_at = CURRENT_TIMESTAMP WHERE contactID = ?";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, response);
            ps.setString(2, coordinatorId);
            ps.setString(3, contactId);
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating coordinator response: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Mark auto-reply as sent
     */
    public boolean markAutoReplySent(String contactId) {
        String sql = "UPDATE Contact SET auto_reply_sent = TRUE, updated_at = CURRENT_TIMESTAMP WHERE contactID = ?";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, contactId);
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error marking auto-reply sent: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get pending contacts count
     */
    public int getPendingContactsCount() {
        String sql = "SELECT COUNT(*) FROM Contact WHERE status = 'PENDING'";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting pending contacts count: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Generate next contact ID
     */
    public String generateNextContactId() {
        String sql = "SELECT COUNT(*) FROM Contact";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                int count = rs.getInt(1) + 1;
                return String.format("C%03d", count);
            }
            
        } catch (SQLException e) {
            System.err.println("Error generating contact ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return "C001"; // Fallback
    }
    
    /**
     * Map ResultSet to Contact object
     */
    private Contact mapResultSetToContact(ResultSet rs) throws SQLException {
        Contact contact = new Contact();
        contact.setContactID(rs.getString("contactID"));
        contact.setName(rs.getString("name"));
        contact.setEmail(rs.getString("email"));
        contact.setPhone(rs.getString("phone"));
        contact.setIssueType(rs.getString("issue_type"));
        contact.setMessage(rs.getString("message"));
        contact.setStatus(rs.getString("status"));
        contact.setAutoReplySent(rs.getBoolean("auto_reply_sent"));
        contact.setCoordinatorResponse(rs.getString("coordinator_response"));
        contact.setCoordinatorId(rs.getString("coordinator_id"));
        contact.setCreatedAt(rs.getTimestamp("created_at"));
        contact.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        return contact;
    }
} 