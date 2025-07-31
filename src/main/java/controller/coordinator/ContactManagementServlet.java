package controller.coordinator;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.ContactService;
import model.Contact;
import model.UserAccount;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * Servlet for coordinator to manage contact requests
 */
@WebServlet("/coordinator/contact-management")
public class ContactManagementServlet extends HttpServlet {
    
    private final ContactService contactService;
    private final Gson gson;
    
    public ContactManagementServlet() {
        this.contactService = new ContactService();
        this.gson = new Gson();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is coordinator
        HttpSession session = request.getSession();
        UserAccount user = (UserAccount) session.getAttribute("user");
        
        if (user == null || !"Coordinator".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get filter parameters
        String statusFilter = request.getParameter("status");
        String issueTypeFilter = request.getParameter("issueType");
        String sortBy = request.getParameter("sort");
        
        // Get contacts
        List<Contact> contacts = contactService.getAllContacts(statusFilter, issueTypeFilter, sortBy);
        
        // Set attributes for JSP
        request.setAttribute("contacts", contacts);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("issueTypeFilter", issueTypeFilter);
        request.setAttribute("sortBy", sortBy);
        
        // Get pending count
        int pendingCount = contactService.getPendingContactsCount();
        request.setAttribute("pendingCount", pendingCount);
        
        // Forward to JSP
        request.getRequestDispatcher("/view/coordinator/contact-management.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();
        
        try {
            // Check if user is coordinator
            HttpSession session = request.getSession();
            UserAccount user = (UserAccount) session.getAttribute("user");
            
            if (user == null || !"Coordinator".equals(user.getRole())) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Không có quyền truy cập!");
                out.print(gson.toJson(jsonResponse));
                return;
            }
            
            String action = request.getParameter("action");
            
            if ("updateStatus".equals(action)) {
                handleUpdateStatus(request, jsonResponse);
            } else if ("sendResponse".equals(action)) {
                handleSendResponse(request, jsonResponse, user.getUserID());
            } else if ("getContactDetails".equals(action)) {
                handleGetContactDetails(request, jsonResponse);
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Hành động không hợp lệ!");
            }
            
        } catch (Exception e) {
            System.err.println("Error in ContactManagementServlet: " + e.getMessage());
            e.printStackTrace();
            
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Có lỗi hệ thống! Vui lòng thử lại sau.");
            jsonResponse.addProperty("debug", e.getMessage());
        }
        
        out.print(gson.toJson(jsonResponse));
    }
    
    /**
     * Handle status update
     */
    private void handleUpdateStatus(HttpServletRequest request, JsonObject jsonResponse) {
        String contactId = request.getParameter("contactId");
        String status = request.getParameter("status");
        
        if (contactId == null || status == null) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Thiếu thông tin cần thiết!");
            return;
        }
        
        boolean success = contactService.updateContactStatus(contactId, status);
        
        if (success) {
            jsonResponse.addProperty("success", true);
            jsonResponse.addProperty("message", "Cập nhật trạng thái thành công!");
        } else {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Có lỗi khi cập nhật trạng thái!");
        }
    }
    
    /**
     * Handle sending coordinator response
     */
    private void handleSendResponse(HttpServletRequest request, JsonObject jsonResponse, String coordinatorId) {
        String contactId = request.getParameter("contactId");
        String response = request.getParameter("response");
        
        if (contactId == null || response == null || response.trim().isEmpty()) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Vui lòng nhập nội dung phản hồi!");
            return;
        }
        
        boolean success = contactService.sendCoordinatorResponse(contactId, response.trim(), coordinatorId);
        
        if (success) {
            jsonResponse.addProperty("success", true);
            jsonResponse.addProperty("message", "Đã gửi phản hồi thành công!");
        } else {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Có lỗi khi gửi phản hồi!");
        }
    }
    
    /**
     * Handle getting contact details
     */
    private void handleGetContactDetails(HttpServletRequest request, JsonObject jsonResponse) {
        String contactId = request.getParameter("contactId");
        
        if (contactId == null) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Thiếu ID liên hệ!");
            return;
        }
        
        Contact contact = contactService.getContactById(contactId);
        
        if (contact != null) {
            jsonResponse.addProperty("success", true);
            jsonResponse.addProperty("contactId", contact.getContactID());
            jsonResponse.addProperty("name", contact.getName());
            jsonResponse.addProperty("email", contact.getEmail());
            jsonResponse.addProperty("phone", contact.getPhone());
            jsonResponse.addProperty("issueType", contact.getIssueType());
            jsonResponse.addProperty("issueTypeDisplay", contact.getIssueTypeDisplayName());
            jsonResponse.addProperty("message", contact.getMessage());
            jsonResponse.addProperty("status", contact.getStatus());
            jsonResponse.addProperty("statusDisplay", contact.getStatusDisplayName());
            jsonResponse.addProperty("autoReplySent", contact.isAutoReplySent());
            jsonResponse.addProperty("coordinatorResponse", contact.getCoordinatorResponse() != null ? contact.getCoordinatorResponse() : "");
            jsonResponse.addProperty("createdAt", contact.getCreatedAt().toString());
        } else {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Không tìm thấy thông tin liên hệ!");
        }
    }
} 