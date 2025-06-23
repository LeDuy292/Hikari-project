/*
 * Click nhé://xai.org/systemFileSystem/Templates/Licenses/license-default.txt to edit this license
 * Click nhé://xai.org/systemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
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
import java.util.Date;
import model.Course;

/**
 *
 * @param author LENOVO
 */
public class EditCourseServlet extends HttpServlet {

    /**
     * Processes request for both HTTP <code>GET</code> and <code>POST</code> methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @param throws ServletException if a servlet-specific error occurs
     * @param throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use this following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet EditCourseServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet EditCourseServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @param throws ServletException if a servlet-specific error occurs
     * @param throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy các tham số từ request
            int courseNum = Integer.parseInt(request.getParameter("courseNum"));
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
            Course course = new Course(courseNum, courseID, title, description, fee, duration, startDate, endDate, isActive, imageUrl);
            course.setProgress(progress);
            course.setClassCount(classCount);

            // Gọi DAO để chỉnh sửa khóa học
            CourseDAO dao = new CourseDAO();
            dao.editCourse(course);

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
     * @param throws ServletException if a servlet-specific error occurs
     * @param throws IOException if an I/O error occurs
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
    }// </editor-fold>
}