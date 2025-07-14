/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.test;

import dao.TestDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Test;
import model.UserAccount;

public class GetTestsServlet extends HttpServlet {
    
    private final TestDAO testDAO = new TestDAO();


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra teacherID trong session
       UserAccount currentUser = (UserAccount) request.getSession().getAttribute("user");
        System.out.println("ID " + currentUser);
        if (currentUser == null || !"Teacher".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        try {
            // Lấy danh sách bài test
            List<Test> testList = testDAO.getAllActiveTests();
            request.setAttribute("testList", testList);
            System.out.println("Forwarding to /view/teacher/manageTest.jsp");
            request.getRequestDispatcher("/view/teacher/manageTest.jsp").forward(request, response);
        } catch (ServletException | IOException e) {
            System.out.println(e);
            request.setAttribute("errorMessage", "Lỗi khi lấy danh sách bài test: " + e.getMessage());          
        }
    }
}