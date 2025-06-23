/*
 * Click nbfs://SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.coordinator;

import dao.CourseDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.sql.Date;
import model.Course;

/**
 *
 * @author LENOVO
 */
public class AddCourseServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AddCourseServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddCourseServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy các tham số từ request
            String courseID = request.getParameter("courseID");
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            BigDecimal fee = new BigDecimal(request.getParameter("fee"));
            int duration = Integer.parseInt(request.getParameter("duration"));

            // Phân tích startDate
            String startDateString = request.getParameter("startDate");
            SimpleDateFormat formatDate = new SimpleDateFormat("yyyy-MM-dd");
            java.sql.Date startDate;
            try {
                java.util.Date parsedStartDate = formatDate.parse(startDateString);
                startDate = new java.sql.Date(parsedStartDate.getTime());
            } catch (Exception e) {
                response.getWriter().print("error parsing startDate: " + e);
                return;
            }

            // Phân tích endDate
            String endDateString = request.getParameter("endDate"); // Sửa lỗi từ "startDate" thành "endDate"
            java.sql.Date endDate;
            try {
                java.util.Date parsedEndDate = formatDate.parse(endDateString);
                endDate = new java.sql.Date(parsedEndDate.getTime());
            } catch (Exception e) {
                response.getWriter().print("error parsing endDate: " + e);
                return;
            }

            boolean isActive = Boolean.parseBoolean(request.getParameter("isActive"));

            // Lấy các trường mới (imageUrl, progress, classCount)
            String imageUrl = request.getParameter("imageUrl");
            BigDecimal progress = request.getParameter("progress") != null ? new BigDecimal(request.getParameter("progress")) : null;
            int classCount = request.getParameter("classCount") != null ? Integer.parseInt(request.getParameter("classCount")) : 0;

            // Tạo đối tượng Course
            Course course = new Course(-1, courseID, title, description, fee, duration, startDate, endDate, isActive, imageUrl);
            course.setProgress(progress);
            course.setClassCount(classCount);

            // Gọi DAO để thêm khóa học
            CourseDAO dao = new CourseDAO();
            dao.addCourse(course);

            // Chuyển hướng đến LoadCourse
            response.sendRedirect("LoadCourse");
        } catch (NumberFormatException e) {
            response.getWriter().print("error parsing number: " + e);
        } catch (Exception e) {
            response.getWriter().print("error: " + e);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }
}