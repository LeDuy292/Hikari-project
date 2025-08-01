package dao;

import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Contact Template entity
 * Handles email template operations for auto-reply system
 */
public class ContactTemplateDAO {
    
    private final DBContext dbContext;
    
    public ContactTemplateDAO() {
        this.dbContext = new DBContext();
    }
    
    /**
     * Get template by issue type
     */
    public ContactTemplate getTemplateByIssueType(String issueType) {
        String sql = "SELECT * FROM contact_templates WHERE issue_type = ? AND is_active = TRUE";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, issueType);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToTemplate(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting template by issue type: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get all templates
     */
    public List<ContactTemplate> getAllTemplates() {
        List<ContactTemplate> templates = new ArrayList<>();
        String sql = "SELECT * FROM contact_templates ORDER BY issue_type";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                ContactTemplate template = mapResultSetToTemplate(rs);
                templates.add(template);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting all templates: " + e.getMessage());
            e.printStackTrace();
        }
        
        return templates;
    }
    
    /**
     * Update template
     */
    public boolean updateTemplate(ContactTemplate template) {
        String sql = "UPDATE contact_templates SET template_name = ?, subject = ?, content = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, template.getTemplateName());
            ps.setString(2, template.getSubject());
            ps.setString(3, template.getContent());
            ps.setInt(4, template.getId());
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating template: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Toggle template active status
     */
    public boolean toggleTemplateStatus(int templateId, boolean isActive) {
        String sql = "UPDATE contact_templates SET is_active = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setBoolean(1, isActive);
            ps.setInt(2, templateId);
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error toggling template status: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Map ResultSet to ContactTemplate object
     */
    private ContactTemplate mapResultSetToTemplate(ResultSet rs) throws SQLException {
        ContactTemplate template = new ContactTemplate();
        template.setId(rs.getInt("id"));
        template.setIssueType(rs.getString("issue_type"));
        template.setTemplateName(rs.getString("template_name"));
        template.setSubject(rs.getString("subject"));
        template.setContent(rs.getString("content"));
        template.setActive(rs.getBoolean("is_active"));
        template.setCreatedAt(rs.getTimestamp("created_at"));
        template.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        return template;
    }
    
    /**
     * Inner class for ContactTemplate
     */
    public static class ContactTemplate {
        private int id;
        private String issueType;
        private String templateName;
        private String subject;
        private String content;
        private boolean active;
        private Timestamp createdAt;
        private Timestamp updatedAt;
        
        // Constructors
        public ContactTemplate() {}
        
        public ContactTemplate(int id, String issueType, String templateName, String subject, String content, boolean active) {
            this.id = id;
            this.issueType = issueType;
            this.templateName = templateName;
            this.subject = subject;
            this.content = content;
            this.active = active;
        }
        
        // Getters and Setters
        public int getId() { return id; }
        public void setId(int id) { this.id = id; }
        
        public String getIssueType() { return issueType; }
        public void setIssueType(String issueType) { this.issueType = issueType; }
        
        public String getTemplateName() { return templateName; }
        public void setTemplateName(String templateName) { this.templateName = templateName; }
        
        public String getSubject() { return subject; }
        public void setSubject(String subject) { this.subject = subject; }
        
        public String getContent() { return content; }
        public void setContent(String content) { this.content = content; }
        
        public boolean isActive() { return active; }
        public void setActive(boolean active) { this.active = active; }
        
        public Timestamp getCreatedAt() { return createdAt; }
        public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
        
        public Timestamp getUpdatedAt() { return updatedAt; }
        public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
        
        /**
         * Replace placeholders in template content
         */
        public String getProcessedContent(String name, String websiteUrl) {
            String processedContent = this.content;
            processedContent = processedContent.replace("{name}", name != null ? name : "");
            processedContent = processedContent.replace("{website_url}", websiteUrl != null ? websiteUrl : "");
            return processedContent;
        }
        
        /**
         * Get display name for issue type
         */
        public String getIssueTypeDisplayName() {
            switch (issueType) {
                case "COURSE_ADVICE":
                    return "Tư vấn khóa học";
                case "TECHNICAL_ISSUE":
                    return "Lỗi kỹ thuật";
                case "TUITION_SCHEDULE":
                    return "Học phí/Lịch học";
                case "PAYMENT_SUPPORT":
                    return "Hỗ trợ thanh toán";
                case "OTHER":
                    return "Khác";
                default:
                    return issueType;
            }
        }
    }
} 