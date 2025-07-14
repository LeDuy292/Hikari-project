/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.coordinator;

import dao.TeacherDAO;
import model.Class;
import model.coordinator.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "ClassDetailsServlet", urlPatterns = {"/ClassDetails"})
public class ClassDetailsServlet extends HttpServlet {
    private TeacherDAO teacherDAO;

    @Override
    public void init() throws ServletException {
//        teacherDAO = new TeacherDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        teacherDAO = new TeacherDAO();
        String classID = request.getParameter("classID");
        String search = request.getParameter("search");

        if (classID == null || classID.trim().isEmpty()) {
            request.setAttribute("error", "Mã lớp học không hợp lệ.");
            request.getRequestDispatcher("class-students.jsp").forward(request, response);
            return;
        }

        try {
            // Fetch class details to get class name
            List<Class> classList = teacherDAO.getClassesByCourseID(null);
            Class classInfo = classList.stream()
                    .filter(c -> classID.equals(c.getClassID()))
                    .findFirst()
                    .orElse(null);
            if (classInfo == null) {
                request.setAttribute("error", "Lớp học không tồn tại.");
                request.getRequestDispatcher("class-students.jsp").forward(request, response);
                return;
            }

            // Fetch students for the given classID
            List<Student> studentList = teacherDAO.getStudentsByClassID(classID);

            // Apply search filter if provided
            if (search != null && !search.trim().isEmpty()) {
                String searchLower = search.toLowerCase();
                studentList = studentList.stream()
                        .filter(s -> s.getStudentID().toLowerCase().contains(searchLower) ||
                                     s.getStudentName().toLowerCase().contains(searchLower))
                        .collect(Collectors.toList());
            }

            request.setAttribute("listStudentOfClass", studentList);
            request.setAttribute("classID", classID);
            request.setAttribute("className", classInfo.getName());
        } catch (Exception e) {
            System.err.println("Error in ClassDetailsServlet: " + e.getMessage());
            request.setAttribute("error", "Không thể tải danh sách học viên: " + e.getMessage());
        } finally {
            teacherDAO.closeConnection();
        }

        request.getRequestDispatcher("view/coordinator/class-students.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public void destroy() {
        teacherDAO.closeConnection();
    }
}