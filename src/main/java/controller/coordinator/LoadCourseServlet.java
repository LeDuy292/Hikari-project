/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.coordinator;

import dao.CourseDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Course;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 *
 * @author LENOVO
 */
public class LoadCourseServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(LoadCourseServlet.class);
    private static final int PAGE_SIZE = 6;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet LoadCourseServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LoadCourseServlet at " + request.getContextPath() + "</h1>");
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
        CourseDAO dao = new CourseDAO();

        
        String pageStr = request.getParameter("page");
        int currentPage = 1;
        try {
            currentPage = Integer.parseInt(pageStr);
            if (currentPage < 1) {
                currentPage = 1;
            }
        } catch (NumberFormatException e) {
            logger.warn("Invalid page parameter: {}. Defaulting to page 1.", pageStr);
            currentPage = 1;
        }

       
        int offset = (currentPage - 1) * PAGE_SIZE;

       
        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");
        String feeFromStr = request.getParameter("feeFrom");
        String feeToStr = request.getParameter("feeTo");
        String startDate = request.getParameter("startDate");
        
        Boolean isActive = null;
        if (status != null && !status.isEmpty()) {
            isActive = Boolean.parseBoolean(status);
        }

        Double feeFrom = null;
        try {
            if (feeFromStr != null && !feeFromStr.isEmpty()) {
                feeFrom = Double.parseDouble(feeFromStr);
            }
        } catch (NumberFormatException e) {
            logger.warn("Invalid feeFrom parameter: {}. Ignoring feeFrom filter.", feeFromStr);
        }

        Double feeTo = null;
        try {
            if (feeToStr != null && !feeToStr.isEmpty()) {
                feeTo = Double.parseDouble(feeToStr);
            }
        } catch (NumberFormatException e) {
            logger.warn("Invalid feeTo parameter: {}. Ignoring feeTo filter.", feeToStr);
        }
        
        int totalCourses = dao.countCoursesWithFilters(keyword, isActive, feeFrom, feeTo, startDate);
        int totalPages = (int) Math.ceil((double) totalCourses / PAGE_SIZE);

        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
            offset = (currentPage - 1) * PAGE_SIZE;
        }
        
        List<Course> listCourse = dao.getCoursesWithFilters(keyword, isActive, feeFrom, feeTo, startDate, offset, PAGE_SIZE);

        request.setAttribute("list", listCourse);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("view/coordinator/course-monitoring.jsp").forward(request, response);

        logger.info("Loaded {} courses for page {} with filters: keyword='{}', status={}, feeFrom={}, feeTo={}, startDate={}",
                listCourse.size(), currentPage, keyword, isActive, feeFrom, feeTo, startDate);
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
