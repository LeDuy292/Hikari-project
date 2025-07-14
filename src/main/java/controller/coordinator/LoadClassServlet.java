/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.coordinator;

import dao.TeacherDAO;
import model.Class;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "LoadClassServlet", urlPatterns = {"/LoadClass"})
public class LoadClassServlet extends HttpServlet {
    private TeacherDAO teacherDAO;

    @Override
    public void init() throws ServletException {
//        teacherDAO = new TeacherDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        teacherDAO = new TeacherDAO();
        String teacherID = request.getParameter("teacherID");
        String courseID = request.getParameter("courseID");

        try {
            // Fetch classes using TeacherDAO with courseID filter
            List<Class> classList = teacherDAO.getClassesByCourseID(courseID);

            // Apply teacherID filtering if provided
            if (teacherID != null && !teacherID.trim().isEmpty()) {
                classList = classList.stream()
                        .filter(c -> teacherID.equals(c.getTeacherID()))
                        .collect(Collectors.toList());
            }

            // Set the class list as a request attribute
            request.setAttribute("listClass", classList);
        } catch (Exception e) {
            System.err.println("Error in LoadClassServlet: " + e.getMessage());
            request.setAttribute("error", "Không thể tải danh sách lớp học: " + e.getMessage());
        } finally {
            // Close the database connection
            teacherDAO.closeConnection();
        }

        // Forward to the JSP
        request.getRequestDispatcher("view/coordinator/course-classes.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public void destroy() {
        // Ensure connection is closed when servlet is destroyed
        teacherDAO.closeConnection();
    }
}