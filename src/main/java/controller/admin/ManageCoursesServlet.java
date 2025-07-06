package controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Course;
import model.UserAccount;
import service.CourseService;

import java.io.IOException;
import java.net.URLEncoder;
import java.sql.Date;
import java.util.List;

@WebServlet("/admin/courses")
public class ManageCoursesServlet extends HttpServlet {
    private final CourseService courseService = new CourseService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Check admin permission
        UserAccount currentUser = (UserAccount) req.getSession().getAttribute("user");
        if (currentUser == null || !"Admin".equals(currentUser.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        String message = req.getParameter("message");
        String error = req.getParameter("error");

        req.setAttribute("message", message);
        req.setAttribute("error", error);

        try {
            if ("detail".equals(action)) {
                String id = req.getParameter("id");
                if (id == null || id.trim().isEmpty()) {
                    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    resp.getWriter().write("{\"error\": \"ID khóa học không hợp lệ\"}");
                    return;
                }
                Course c = courseService.getCourseById(id);
                if (c == null) {
                    resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    resp.getWriter().write("{\"error\": \"Không tìm thấy khóa học\"}");
                    return;
                }

                // Return JSON response for AJAX
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");

                StringBuilder json = new StringBuilder();
                json.append("{");
                json.append("\"courseID\":\"").append(c.getCourseID()).append("\",");
                json.append("\"title\":\"").append(c.getTitle().replace("\"", "\\\"")).append("\",");
                json.append("\"description\":\"").append(c.getDescription() != null ? c.getDescription().replace("\"", "\\\"") : "").append("\",");
                json.append("\"fee\":").append(c.getFee()).append(",");
                json.append("\"duration\":").append(c.getDuration()).append(",");
                json.append("\"startDate\":\"").append(c.getStartDate() != null ? c.getStartDate().toString() : "").append("\",");
                json.append("\"endDate\":\"").append(c.getEndDate() != null ? c.getEndDate().toString() : "").append("\",");
                json.append("\"isActive\":").append(c.isIsActive()).append(",");
                json.append("\"imageUrl\":\"").append(c.getImageUrl() != null ? c.getImageUrl() : "").append("\"");
                json.append("}");

                resp.getWriter().write(json.toString());
                return;
            } else {
                // List courses with search, pagination, filter
                String keyword = req.getParameter("keyword");
                String status = req.getParameter("status");
                String feeFromStr = req.getParameter("feeFrom");
                String feeToStr = req.getParameter("feeTo");
                String startDate = req.getParameter("startDate");
                String pageStr = req.getParameter("page");

                int page = 1;
                if (pageStr != null) {
                    try {
                        page = Integer.parseInt(pageStr);
                        if (page < 1) page = 1;
                    } catch (NumberFormatException ignored) {}
                }
                int pageSize = 10;

                List<Course> courses;
                int totalCourses;

                // Apply filters
                Double feeFrom = null;
                Double feeTo = null;
                Boolean isActive = null;

                if (feeFromStr != null && !feeFromStr.trim().isEmpty()) {
                    try {
                        feeFrom = Double.parseDouble(feeFromStr);
                    } catch (NumberFormatException ignored) {}
                }

                if (feeToStr != null && !feeToStr.trim().isEmpty()) {
                    try {
                        feeTo = Double.parseDouble(feeToStr);
                    } catch (NumberFormatException ignored) {}
                }

                if (status != null && !status.trim().isEmpty()) {
                    isActive = Boolean.parseBoolean(status);
                }

                courses = courseService.getCoursesWithFilters(keyword, isActive, feeFrom, feeTo, startDate, page, pageSize);
                totalCourses = courseService.countCoursesWithFilters(keyword, isActive, feeFrom, feeTo, startDate);

                int totalPages = (int) Math.ceil((double) totalCourses / pageSize);

                req.setAttribute("courses", courses);
                req.setAttribute("currentPage", page);
                req.setAttribute("totalPages", totalPages);
                req.setAttribute("totalCourses", totalCourses);
                req.setAttribute("keyword", keyword);
                req.setAttribute("status", status);
                req.setAttribute("feeFrom", feeFromStr);
                req.setAttribute("feeTo", feeToStr);
                req.setAttribute("startDate", startDate);

                req.getRequestDispatcher("/view/admin/manageCourses.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            req.getRequestDispatcher("/view/admin/error.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Check admin permission
        UserAccount currentUser = (UserAccount) req.getSession().getAttribute("user");
        if (currentUser == null || !"Admin".equals(currentUser.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        try {
            if ("edit".equals(action)) {
                Course c = new Course();
                c.setCourseID(req.getParameter("courseID"));
                c.setTitle(req.getParameter("title"));
                c.setDescription(req.getParameter("description"));

                String feeStr = req.getParameter("fee");
                if (feeStr != null && !feeStr.trim().isEmpty()) {
                    try {
                        c.setFee(Double.parseDouble(feeStr));
                    } catch (NumberFormatException e) {
                        throw new IllegalArgumentException("Học phí không hợp lệ");
                    }
                } else {
                    c.setFee(0.0);
                }

                String durationStr = req.getParameter("duration");
                if (durationStr != null && !durationStr.trim().isEmpty()) {
                    try {
                        c.setDuration(Integer.parseInt(durationStr));
                    } catch (NumberFormatException e) {
                        throw new IllegalArgumentException("Thời lượng không hợp lệ");
                    }
                } else {
                    c.setDuration(0);
                }

                String startDateStr = req.getParameter("startDate");
                if (startDateStr != null && !startDateStr.trim().isEmpty()) {
                    try {
                        c.setStartDate(Date.valueOf(startDateStr));
                    } catch (IllegalArgumentException e) {
                        throw new IllegalArgumentException("Ngày bắt đầu không hợp lệ");
                    }
                }

                String endDateStr = req.getParameter("endDate");
                if (endDateStr != null && !endDateStr.trim().isEmpty()) {
                    try {
                        c.setEndDate(Date.valueOf(endDateStr));
                    } catch (IllegalArgumentException e) {
                        throw new IllegalArgumentException("Ngày kết thúc không hợp lệ");
                    }
                }

                // Validate date range
                if (c.getStartDate() != null && c.getEndDate() != null && c.getEndDate().before(c.getStartDate())) {
                    throw new IllegalArgumentException("Ngày kết thúc phải sau ngày bắt đầu");
                }

                c.setIsActive("true".equals(req.getParameter("isActive")));
                c.setImageUrl(req.getParameter("imageUrl"));

                courseService.editCourse(c);
                resp.sendRedirect(req.getContextPath() + "/admin/courses?message=" + URLEncoder.encode("Cập nhật khóa học thành công", "UTF-8"));
            } else if ("add".equals(action)) {
                Course c = new Course();
                c.setCourseID(req.getParameter("courseID"));
                c.setTitle(req.getParameter("title"));
                c.setDescription(req.getParameter("description"));

                String feeStr = req.getParameter("fee");
                if (feeStr != null && !feeStr.trim().isEmpty()) {
                    try {
                        c.setFee(Double.parseDouble(feeStr));
                    } catch (NumberFormatException e) {
                        throw new IllegalArgumentException("Học phí không hợp lệ");
                    }
                } else {
                    c.setFee(0.0);
                }

                String durationStr = req.getParameter("duration");
                if (durationStr != null && !durationStr.trim().isEmpty()) {
                    try {
                        c.setDuration(Integer.parseInt(durationStr));
                    } catch (NumberFormatException e) {
                        throw new IllegalArgumentException("Thời lượng không hợp lệ");
                    }
                } else {
                    c.setDuration(0);
                }

                String startDateStr = req.getParameter("startDate");
                if (startDateStr != null && !startDateStr.trim().isEmpty()) {
                    try {
                        c.setStartDate(Date.valueOf(startDateStr));
                    } catch (IllegalArgumentException e) {
                        throw new IllegalArgumentException("Ngày bắt đầu không hợp lệ");
                    }
                }

                String endDateStr = req.getParameter("endDate");
                if (endDateStr != null && !endDateStr.trim().isEmpty()) {
                    try {
                        c.setEndDate(Date.valueOf(endDateStr));
                    } catch (IllegalArgumentException e) {
                        throw new IllegalArgumentException("Ngày kết thúc không hợp lệ");
                    }
                }

                // Validate date range
                if (c.getStartDate() != null && c.getEndDate() != null && c.getEndDate().before(c.getStartDate())) {
                    throw new IllegalArgumentException("Ngày kết thúc phải sau ngày bắt đầu");
                    }

                    c.setIsActive("true".equals(req.getParameter("isActive")));
                    c.setImageUrl(req.getParameter("imageUrl"));

                    courseService.addCourse(c);
                    resp.sendRedirect(req.getContextPath() + "/admin/courses?message=" + URLEncoder.encode("Thêm khóa học thành công", "UTF-8"));
                } else if ("block".equals(action)) {
                    String id = req.getParameter("id");
                    String isActiveStr = req.getParameter("isActive");

                    if (id == null || id.trim().isEmpty()) {
                        resp.sendRedirect(req.getContextPath() + "/admin/courses?error=" + URLEncoder.encode("ID khóa học không hợp lệ", "UTF-8"));
                        return;
                    }

                    boolean isActive = Boolean.parseBoolean(isActiveStr);
                    Course course = courseService.getCourseById(id);
                    if (course == null) {
                        resp.sendRedirect(req.getContextPath() + "/admin/courses?error=" + URLEncoder.encode("Không tìm thấy khóa học", "UTF-8"));
                        return;
                    }

                    course.setIsActive(isActive);
                    courseService.editCourse(course);

                    String message = isActive ? "Mở khóa khóa học thành công" : "Khóa khóa học thành công";
                    resp.sendRedirect(req.getContextPath() + "/admin/courses?message=" + URLEncoder.encode(message, "UTF-8"));
                } else {
                    resp.sendRedirect(req.getContextPath() + "/admin/courses?error=" + URLEncoder.encode("Hành động không hợp lệ", "UTF-8"));
                }
            } catch (IllegalArgumentException e) {
                resp.sendRedirect(req.getContextPath() + "/admin/courses?error=" + URLEncoder.encode(e.getMessage(), "UTF-8"));
            } catch (Exception e) {
                e.printStackTrace(); // Log the exception for debugging
                resp.sendRedirect(req.getContextPath() + "/admin/courses?error=" + URLEncoder.encode("Lỗi hệ thống: " + e.getMessage(), "UTF-8"));
            }
        }
    }