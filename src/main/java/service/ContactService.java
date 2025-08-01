package service;

import dao.ContactDAO;
import dao.ContactTemplateDAO;
import dao.ContactTemplateDAO.ContactTemplate;
import model.Contact;
import utils.EmailUtil;
import utils.ValidationUtil;
import java.util.List;

/**
 * Enhanced Service class for Contact management
 * Handles business logic for contact requests and auto-reply system
 */
public class ContactService {
    
    private final ContactDAO contactDAO;
    private final ContactTemplateDAO templateDAO;
    
    public ContactService() {
        this.contactDAO = new ContactDAO();
        this.templateDAO = new ContactTemplateDAO();
    }
    
    /**
     * Submit a new contact request with enhanced validation and auto-reply
     */
    public boolean submitContactRequest(String name, String email, String phone, String issueType, String message) {
        try {
            // Validate inputs first (before sanitizing)
            if (!validateContactData(name, email, phone, issueType, message)) {
                System.err.println("Contact validation failed");
                return false;
            }
            
            // Sanitize inputs after validation
            name = ValidationUtil.sanitizeInput(name);
            email = ValidationUtil.sanitizeInput(email);
            phone = ValidationUtil.sanitizeInput(phone);
            message = ValidationUtil.sanitizeInput(message);
            
            // Generate contact ID
            String contactId = contactDAO.generateNextContactId();
            
            // Create contact object
            Contact contact = new Contact(contactId, name, email, phone, issueType, message);
            
            // Save to database
            boolean saved = contactDAO.insertContact(contact);
            
            if (saved) {
                System.out.println("Contact saved successfully: " + contactId);
                
                // Send auto-reply if applicable
                if (shouldSendAutoReply(issueType)) {
                    boolean autoReplySent = sendAutoReply(contact);
                    if (autoReplySent) {
                        contactDAO.markAutoReplySent(contactId);
                        System.out.println("Auto-reply sent for contact: " + contactId);
                    }
                } else {
                    System.out.println("No auto-reply needed for issue type: " + issueType);
                }
                
                return true;
            }
            
        } catch (Exception e) {
            System.err.println("Error submitting contact request: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Validate contact data
     */
    private boolean validateContactData(String name, String email, String phone, String issueType, String message) {
        if (!ValidationUtil.isValidName(name)) {
            System.err.println("Invalid name: " + name);
            return false;
        }
        
        if (!ValidationUtil.isValidContactEmail(email)) {
            System.err.println("Invalid email: " + email);
            return false;
        }
        
        if (!ValidationUtil.isValidPhone(phone)) {
            System.err.println("Invalid phone: " + phone);
            return false;
        }
        
        if (!ValidationUtil.isValidIssueType(issueType)) {
            System.err.println("Invalid issue type: " + issueType);
            return false;
        }
        
        if (!ValidationUtil.isValidMessage(message)) {
            System.err.println("Invalid message length or content");
            return false;
        }
        
        return true;
    }
    
    /**
     * Get all contacts with filtering and sorting
     */
    public List<Contact> getAllContacts(String statusFilter, String issueTypeFilter, String sortBy) {
        return contactDAO.getAllContacts(statusFilter, issueTypeFilter, sortBy);
    }
    
    /**
     * Get contact by ID
     */
    public Contact getContactById(String contactId) {
        if (!ValidationUtil.isValidContactId(contactId)) {
            return null;
        }
        return contactDAO.getContactById(contactId);
    }
    
    /**
     * Update contact status with validation
     */
    public boolean updateContactStatus(String contactId, String status) {
        if (!ValidationUtil.isValidContactId(contactId)) {
            return false;
        }
        
        String[] validStatuses = {"PENDING", "IN_PROGRESS", "RESPONDED", "CLOSED"};
        boolean validStatus = false;
        for (String validStat : validStatuses) {
            if (validStat.equals(status)) {
                validStatus = true;
                break;
            }
        }
        
        if (!validStatus) {
            return false;
        }
        
        return contactDAO.updateContactStatus(contactId, status);
    }
    
    /**
     * Send coordinator response with enhanced email
     */
    public boolean sendCoordinatorResponse(String contactId, String response, String coordinatorId) {
        try {
            // Validate inputs
            if (!ValidationUtil.isValidContactId(contactId) || 
                ValidationUtil.isEmpty(response) || 
                ValidationUtil.isEmpty(coordinatorId)) {
                return false;
            }
            
            // Sanitize response
            response = ValidationUtil.sanitizeInput(response);
            
            // Update database
            boolean updated = contactDAO.updateCoordinatorResponse(contactId, response, coordinatorId);
            
            if (updated) {
                // Get contact details
                Contact contact = contactDAO.getContactById(contactId);
                if (contact != null) {
                    // Send professional email to user
                    boolean emailSent = EmailUtil.sendCoordinatorResponseEmail(
                        contact.getEmail(), 
                        contact.getName(), 
                        contact.getIssueType(), 
                        response
                    );
                    
                    if (emailSent) {
                        System.out.println("Coordinator response email sent successfully for contact: " + contactId);
                        return true;
                    } else {
                        System.err.println("Failed to send coordinator response email for contact: " + contactId);
                    }
                }
            }
            
        } catch (Exception e) {
            System.err.println("Error sending coordinator response: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Get pending contacts count
     */
    public int getPendingContactsCount() {
        return contactDAO.getPendingContactsCount();
    }
    
    /**
     * Check if auto-reply should be sent for this issue type
     */
    private boolean shouldSendAutoReply(String issueType) {
        // Send auto-reply for all types except "OTHER" which needs human attention
        return !"OTHER".equals(issueType);
    }
    
    /**
     * Send auto-reply email with enhanced template
     */
    private boolean sendAutoReply(Contact contact) {
        try {
            // Get template for this issue type
            ContactTemplate template = templateDAO.getTemplateByIssueType(contact.getIssueType());
            
            if (template != null && template.isActive()) {
                // Process template content with customer name and website URL
                String processedContent = template.getProcessedContent(
                    contact.getName(), 
                    "https://hikari.com"
                );
                
                // Send professional auto-reply email
                boolean emailSent = EmailUtil.sendAutoReplyEmail(
                    contact.getEmail(),
                    contact.getName(),
                    contact.getIssueType(),
                    processedContent
                );
                
                if (emailSent) {
                    System.out.println("Auto-reply sent successfully for contact: " + contact.getContactID());
                    return true;
                } else {
                    System.err.println("Failed to send auto-reply for contact: " + contact.getContactID());
                }
            } else {
                System.out.println("No active template found for issue type: " + contact.getIssueType());
            }
            
        } catch (Exception e) {
            System.err.println("Error sending auto-reply: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
}
