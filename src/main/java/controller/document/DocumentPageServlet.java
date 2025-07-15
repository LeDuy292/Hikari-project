/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.document;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.UserAccount;

/**
 *
 * @author ASUS
 */
@WebServlet(name = "DocumentPageServlet", urlPatterns = {"/documents"})
public class DocumentPageServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Kiểm tra đăng nhập
        HttpSession session = request.getSession(false);
        UserAccount currentUser = (session != null) ? (UserAccount) session.getAttribute("user") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/view/authentication/login.jsp");
            return;
        }

        // Bạn có thể load thêm danh sách lớp học tại đây nếu cần
        // request.setAttribute("classes", classList);
        request.setAttribute("userRole", currentUser.getRole());
        request.setAttribute("userID", currentUser.getUserID());

        request.getRequestDispatcher("/view/student/index.jsp").forward(request, response);
    }
}
