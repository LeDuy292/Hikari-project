package controller.message;

import com.google.gson.Gson;
import dao.MessageDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Message;
import model.UserAccount;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

public class ChatUserServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ChatUserServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ChatUserServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        UserAccount currentUser = (UserAccount) request.getSession().getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/view/authentication/login.jsp");
            return;
        }
        String userID = currentUser.getUserID();
        if (userID == null || userID.isEmpty()) {
            System.out.println("Invalid userID for currentUser: " + currentUser);
            response.sendRedirect(request.getContextPath() + "/view/authentication/login.jsp");
            return;
        }

        String acceptHeader = request.getHeader("Accept");
        String jsonParam = request.getParameter("json");
        String receiverID = request.getParameter("receiverID");

        MessageDAO dao = new MessageDAO();
        boolean isJsonRequest = (acceptHeader != null && acceptHeader.contains("application/json")) 
                             || "true".equalsIgnoreCase(jsonParam);

        if (isJsonRequest) {
            // Trả JSON cho JavaScript
            List<String> users = dao.getChatPartners(userID);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            out.print(new Gson().toJson(users));
            out.flush();
        } else {
            // Xử lý yêu cầu giao diện
            if (receiverID != null && !receiverID.isEmpty() && !receiverID.equals(userID) && dao.isValidUser(receiverID)) {
                // Kiểm tra xem có cuộc hội thoại nào chưa
                List<Message> chatHistory = dao.getChatHistory(userID, receiverID);
                if (chatHistory.isEmpty()) {
                    // Tạo cuộc trò chuyện mới (bản ghi rỗng)
                    Message newConversation = new Message();
                    newConversation.setSender(userID);
                    newConversation.setReceiver(receiverID);
                    newConversation.setContent(""); // Nội dung rỗng
                    newConversation.setTimestamp(new java.util.Date());
                    dao.saveMessage(newConversation);
                    System.out.println("Created new conversation between " + userID + " and " + receiverID);
                }
                // Thiết lập receiverID để tự động chọn trong messages.jsp
                request.setAttribute("receiverID", receiverID);
            } else if (receiverID != null && (!dao.isValidUser(receiverID) || receiverID.equals(userID))) {
                System.out.println("Invalid receiverID: " + receiverID);
                request.setAttribute("error", "Người nhận không hợp lệ hoặc không tồn tại");
            }
            request.setAttribute("userID", userID);
            request.getRequestDispatcher("/view/notification/messages.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}