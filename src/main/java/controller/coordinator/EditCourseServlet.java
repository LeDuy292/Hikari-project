/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.coordinator;

import dao.CourseDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import model.Course;
import responsitory.DocumentResponsitory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@MultipartConfig(maxFileSize = 5 * 1024 * 1024, maxRequestSize = 10 * 1024 * 1024)
public class EditCourseServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(EditCourseServlet.class);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Không xử lý GET, chuyển hướng về LoadCourse hoặc để NextEditCourseServlet xử lý
        response.sendRedirect("LoadCourse");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Thiết lập UTF-8
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        try {
            // Lấy courseNum từ form (thay vì courseID) - Thay đổi
            String courseID = request.getParameter("courseNum");
            if (courseID == null || courseID.trim().isEmpty()) {
                throw new IllegalArgumentException("Course ID is required");
            }

            // Validate input
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

            // Xử lý file ảnh - Thay đổi: Giữ ảnh cũ nếu không tải ảnh mới
            String imageUrl = "";
            CourseDAO dao = new CourseDAO();
            Course existingCourse = dao.getCourseByID(courseID); // Lấy khóa học hiện tại
            if (existingCourse != null && existingCourse.getImageUrl() != null) {
                imageUrl = existingCourse.getImageUrl(); // Giữ ảnh cũ nếu không có ảnh mới
            }

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
                String s3SubFolder = "courses";
                imageUrl = documentRepo.saveFile(filePart, s3SubFolder);

                if (imageUrl == null) {
                    throw new RuntimeException("Upload to S3 failed");
                }
            }

            // Tạo đối tượng Course
            Course course = new Course(courseID, title, description, fee, duration, startDate, endDate, isActive, imageUrl);

            // Cập nhật khóa học
            dao.editCourse(course);

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

    @Override
    public String getServletInfo() {
        return "Servlet for editing course information";
    }
}