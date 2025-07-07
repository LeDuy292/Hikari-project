package controller.coordinator;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.CourseDAO;
import dao.DashboardDAO;
import dao.TeacherDAO;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.List;
import model.Announcement;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
/**
 *
 * @author LENOVO
 */
public class LoadDashboardServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(LoadDashboardServlet.class);

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
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet LoadDashboardServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LoadDashboardServlet at " + request.getContextPath() + "</h1>");
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
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Khởi tạo DAO
            CourseDAO courseDAO = new CourseDAO();
            TeacherDAO teacherDAO = new TeacherDAO();
            DashboardDAO dashboardDAO = new DashboardDAO();
            
            // Lấy dữ liệu tổng quan khóa học
            int totalCourses = courseDAO.countAllCourses();
            int activeCourses = courseDAO.countAllCoursesActive();
            int draftCourses = totalCourses - activeCourses;

            // Lấy dữ liệu tổng quan giảng viên
            int totalTeachers = teacherDAO.countAllTeachers();
            int inactiveTeachers = 0; // Giả sử không có dữ liệu về giảng viên nghỉ

            // Lấy dữ liệu thẻ thống kê
            int totalClasses = dashboardDAO.countAllClasses();
            int lowEnrollmentClasses = dashboardDAO.countClassesLowEnrollment();
            int teachingTeachers = dashboardDAO.countTeachingTeachers();
            int classesEndingSoon = dashboardDAO.countClassesEndingSoon();
            

            // Get pagination parameters
            int page = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
            int itemsPerPage = 5; // Define items per page

            // Get paginated course titles
            List<String> courseTitles = dashboardDAO.getPaginatedCourseTitles(page, itemsPerPage);
            int totalCourseTitles = dashboardDAO.countCourseTitles();
            int totalPages = (int) Math.ceil((double) totalCourseTitles / itemsPerPage);


            // Lấy hoạt động gần đây
            List<Announcement> recentActivities = dashboardDAO.getRecentActivities();

            // Đặt thuộc tính vào request
            request.setAttribute("totalCourses", totalCourses);
            request.setAttribute("activeCourses", activeCourses);
            request.setAttribute("draftCourses", draftCourses);
            request.setAttribute("totalTeachers", totalTeachers);
            request.setAttribute("inactiveTeachers", inactiveTeachers);
            request.setAttribute("totalClasses", totalClasses);
            request.setAttribute("lowEnrollmentClasses", lowEnrollmentClasses);
            request.setAttribute("teachingTeachers", teachingTeachers);
            request.setAttribute("classesEndingSoon", classesEndingSoon);
            request.setAttribute("courseTitles", courseTitles);
            request.setAttribute("recentActivities", recentActivities);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);

            // Đóng kết nối
            courseDAO.closeConnection();
            teacherDAO.closeConnection();
            dashboardDAO.closeConnection();

            // Chuyển tiếp đến home.jsp
            request.getRequestDispatcher("view/coordinator/home.jsp").forward(request, response);
            logger.info("LoadDashboardServlet: Successfully loaded dashboard data.");

        } catch (Exception e) {
            logger.error("LoadDashboardServlet: Error loading dashboard data: {}", e.getMessage(), e);
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("<script>alert('Lỗi khi tải dữ liệu dashboard: " + e.getMessage().replace("'", "\\'") + "'); window.location.href='/coordinator/home.jsp';</script>");
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
    }// </editor-fold>

}
