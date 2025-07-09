
package controller.coordinator;

import responsitory.DocumentResponsitory;

import dao.CourseDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import model.Course;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 *
 * @author LENOVO
 */
@MultipartConfig(maxFileSize = 5 * 1024 * 1024, maxRequestSize = 10 * 1024 * 1024) // Giới hạn file tối đa 5MB, yêu cầu tối đa 10MB
public class AddCourseServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(AddCourseServlet.class);
    private static final String UPLOAD_DIR = "uploads/images"; // Thư mục lưu ảnh

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
            out.println("<title>Servlet AddCourseServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddCourseServlet at " + request.getContextPath() + "</h1>");
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
//        String courseID = request.getParameter("courseID");
//        String title = request.getParameter("title");
//        String description = request.getParameter("description");
//        double fee = Double.parseDouble(request.getParameter("fee"));
//        int duration = Integer.parseInt(request.getParameter("duration"));
//        
//        
////        Date startDate = Date.valueOf(request.getParameter("startDate"));
//        String startDateString = request.getParameter("startDate");
//        SimpleDateFormat formatDate = new SimpleDateFormat("yyyy-MM-dd");
//        Date startDate = new Date();
//        try {
//            startDate = formatDate.parse(startDateString);
//        } catch (Exception e) {
//            response.getWriter().print("error: "+ e);
//            return;
//        }
////        Date endDate = Date.valueOf(request.getParameter("endDate"));
//         String endDateString = request.getParameter("startDate");
//        Date endDate = new Date();
//        try {
//            endDate = formatDate.parse(startDateString);
//        } catch (Exception e) {
//            response.getWriter().print("error: "+ e);
//            return;
//        }
//
//        boolean isActive = Boolean.parseBoolean(request.getParameter("isActive"));
//        
//        Course course = new Course(courseID, title, description, fee, duration, startDate, endDate, isActive);
//        CourseDAO dao = new CourseDAO();
//        dao.addCourse(course);
//
//        response.sendRedirect("LoadCourse");
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
        // Thiết lập UTF-8
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        try {
            // Validate input
            String courseID = request.getParameter("courseID");
            if (courseID == null || courseID.trim().isEmpty()) {
                throw new IllegalArgumentException("Course ID is required");
            }

            String title = request.getParameter("title");
            if (title == null || title.trim().isEmpty()) {
                throw new IllegalArgumentException("Title is required");
            }

            String description = request.getParameter("description");
            if (description == null) {
                description = "";
            }

            String feeStr = request.getParameter("fee");
            double fee;
            try {
                fee = feeStr != null ? Double.parseDouble(feeStr) : 0.0;
                if (fee < 0) {
                    throw new IllegalArgumentException("Fee cannot be negative");
                }
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("Invalid fee format");
            }

            String durationStr = request.getParameter("duration");
            int duration;
            try {
                duration = durationStr != null ? Integer.parseInt(durationStr) : 0;
                if (duration <= 0) {
                    throw new IllegalArgumentException("Duration must be positive");
                }
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("Invalid duration format");
            }

            String startDateString = request.getParameter("startDate");
            String endDateString = request.getParameter("endDate");
            SimpleDateFormat formatDate = new SimpleDateFormat("yyyy-MM-dd");
            formatDate.setLenient(false);

            Date startDate = null;
            if (startDateString != null && !startDateString.trim().isEmpty()) {
                try {
                    startDate = formatDate.parse(startDateString);
                } catch (Exception e) {
                    throw new IllegalArgumentException("Invalid start date format");
                }
            }

            Date endDate = null;
            if (endDateString != null && !endDateString.trim().isEmpty()) {
                try {
                    endDate = formatDate.parse(endDateString);
                } catch (Exception e) {
                    throw new IllegalArgumentException("Invalid end date format");
                }
            }

            if (startDate != null && endDate != null && startDate.after(endDate)) {
                throw new IllegalArgumentException("Start date must be before end date");
            }

            String isActiveStr = request.getParameter("isActive");
            boolean isActive = isActiveStr != null && Boolean.parseBoolean(isActiveStr);

            // Xử lý file ảnh
            String imageUrl = "";
            Part filePart = request.getPart("imageUrl");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = filePart.getSubmittedFileName();
                String contentType = filePart.getContentType();
                // Kiểm tra định dạng file
                if (!contentType.equals("image/png") && !contentType.equals("image/jpeg") && !contentType.equals("image/jpg")) {
                    throw new IllegalArgumentException("Only PNG, JPG, JPEG files are allowed");
                }
                // Kiểm tra kích thước file (tối đa 5MB)
                if (filePart.getSize() > 5 * 1024 * 1024) {
                    throw new IllegalArgumentException("Image file size must not exceed 5MB");
                }

                // Upload file ảnh lên AWS S3
                DocumentResponsitory documentRepo = new DocumentResponsitory();
                String s3SubFolder = "courses"; // tùy theo loại đối tượng muốn lưu trong S3
                imageUrl = documentRepo.saveFile(filePart, s3SubFolder);

                if (imageUrl == null) {
                    throw new RuntimeException("Upload to S3 failed");
                }
            }

            // Tạo đối tượng Course
            Course course = new Course(courseID, title, description, fee, duration, startDate, endDate, isActive, imageUrl);

            // Gọi DAO để thêm khóa học
            CourseDAO dao = new CourseDAO();
            dao.addCourse(course);

            // Chuyển hướng về trang LoadCourse
            response.sendRedirect("LoadCourse");

        } catch (IllegalArgumentException e) {
            logger.error("Validation error: {}", e.getMessage());
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        } catch (Exception e) {
            logger.error("Unexpected error: {}", e.getMessage(), e);
            request.setAttribute("errorMessage", "An unexpected error occurred");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
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
