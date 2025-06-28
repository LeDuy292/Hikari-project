package controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Course;
import model.UserAccount;
import service.CourseService;
import java.io.IOException;
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
            if ("add".equals(action)) {
                req.getRequestDispatcher("/view/admin/addCourse.jsp").forward(req, resp);
            } else if ("edit".equals(action)) {
                String id = req.getParameter("id");
                if (id == null || id.trim().isEmpty()) {
                    resp.sendRedirect(req.getContextPath() + "/admin/courses?error=ID khóa học không hợp lệ");
                    return;
                }
                Course c = courseService.getCourseById(id);
                if (c == null) {
                    resp.sendRedirect(req.getContextPath() + "/admin/courses?error=Không tìm thấy khóa học");
                    return;
                }
                req.setAttribute("course", c);
                req.getRequestDispatcher("/view/admin/editCourse.jsp").forward(req, resp);
            } else if ("detail".equals(action)) {
                String id = req.getParameter("id");
                if (id == null || id.trim().isEmpty()) {
                    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    return;
                }
                Course c = courseService.getCourseById(id);
                if (c == null) {
                    resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    return;
                }
            
                // Return JSON response for AJAX
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
            
                StringBuilder json = new StringBuilder();
                json.append("{");
                json.append("\"courseID\":\"").append(c.getCourseID()).append("\",");
                json.append("\"title\":\"").append(c.getTitle()).append("\",");
                json.append("\"description\":\"").append(c.getDescription() != null ? c.getDescription() : "").append("\",");
                json.append("\"fee\":").append(c.getFee()).append(",");
                json.append("\"duration\":").append(c.getDuration()).append(",");
                json.append("\"startDate\":\"").append(c.getStartDate()).append("\",");
                json.append("\"endDate\":\"").append(c.getEndDate()).append("\",");
                json.append("\"isActive\":").append(c.isIsActive()).append(",");
                json.append("\"imageUrl\":\"").append(c.getImageUrl() != null ? c.getImageUrl() : "").append("\"");
                json.append("}");
            
                resp.getWriter().write(json.toString());
                return;
            } else {
                // List courses with search, pagination, filter
                String keyword = req.getParameter("keyword");
                String category = req.getParameter("category");
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
                int totalCourses = 0;
                
                if (keyword != null && !keyword.trim().isEmpty() && category != null && !category.trim().isEmpty()) {
                    courses = courseService.searchCoursesByCategory(keyword.trim(), category.trim());
                    totalCourses = courses.size();
                } else if (keyword != null && !keyword.trim().isEmpty()) {
                    courses = courseService.searchCourses(keyword.trim());
                    totalCourses = courses.size();
                } else if (category != null && !category.trim().isEmpty()) {
                    courses = courseService.getCoursesByCategory(category.trim());
                    totalCourses = courses.size();
                } else {
                    courses = courseService.getCoursesWithPaging(page, pageSize);
                    totalCourses = courseService.countAllCourses();
                }
                
                int totalPages = (int) Math.ceil((double) totalCourses / pageSize);
                
                req.setAttribute("courses", courses);
                req.setAttribute("currentPage", page);
                req.setAttribute("totalPages", totalPages);
                req.setAttribute("totalCourses", totalCourses);
                req.setAttribute("keyword", keyword);
                req.setAttribute("category", category);
                
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
            if ("add".equals(action)) {
                Course c = new Course();
                c.setCourseID(req.getParameter("courseID"));
                c.setTitle(req.getParameter("title"));
                c.setDescription(req.getParameter("description"));
                
                String feeStr = req.getParameter("fee");
                if (feeStr != null && !feeStr.trim().isEmpty()) {
                    c.setFee(Double.parseDouble(feeStr));
                }
                
                String durationStr = req.getParameter("duration");
                if (durationStr != null && !durationStr.trim().isEmpty()) {
                    c.setDuration(Integer.parseInt(durationStr));
                }
                
                String startDateStr = req.getParameter("startDate");
                if (startDateStr != null && !startDateStr.trim().isEmpty()) {
                    c.setStartDate(java.sql.Date.valueOf(startDateStr));
                }
                
                String endDateStr = req.getParameter("endDate");
                if (endDateStr != null && !endDateStr.trim().isEmpty()) {
                    c.setEndDate(java.sql.Date.valueOf(endDateStr));
                }
                
                c.setIsActive("true".equals(req.getParameter("isActive")));
                c.setImageUrl(req.getParameter("imageUrl"));
                
                courseService.addCourse(c);
                resp.sendRedirect(req.getContextPath() + "/admin/courses?message=Thêm khóa học thành công");
                
            } else if ("edit".equals(action)) {
                Course c = new Course();
                c.setCourseID(req.getParameter("courseID"));
                c.setTitle(req.getParameter("title"));
                c.setDescription(req.getParameter("description"));
                
                String feeStr = req.getParameter("fee");
                if (feeStr != null && !feeStr.trim().isEmpty()) {
                    c.setFee(Double.parseDouble(feeStr));
                }
                
                String durationStr = req.getParameter("duration");
                if (durationStr != null && !durationStr.trim().isEmpty()) {
                    c.setDuration(Integer.parseInt(durationStr));
                }
                
                String startDateStr = req.getParameter("startDate");
                if (startDateStr != null && !startDateStr.trim().isEmpty()) {
                    c.setStartDate(java.sql.Date.valueOf(startDateStr));
                }
                
                String endDateStr = req.getParameter("endDate");
                if (endDateStr != null && !endDateStr.trim().isEmpty()) {
                    c.setEndDate(java.sql.Date.valueOf(endDateStr));
                }
                
                c.setIsActive("true".equals(req.getParameter("isActive")));
                c.setImageUrl(req.getParameter("imageUrl"));
                
                courseService.editCourse(c);
                resp.sendRedirect(req.getContextPath() + "/admin/courses?message=Cập nhật khóa học thành công");
                
            } else if ("delete".equals(action)) {
                String id = req.getParameter("id");
                if (id == null || id.trim().isEmpty()) {
                    resp.sendRedirect(req.getContextPath() + "/admin/courses?error=ID khóa học không hợp lệ");
                    return;
                }
                courseService.deleteCourse(id);
                resp.sendRedirect(req.getContextPath() + "/admin/courses?message=Xóa khóa học thành công");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/courses");
            }
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/admin/courses?error=Dữ liệu số không hợp lệ");
        } catch (IllegalArgumentException e) {
            resp.sendRedirect(req.getContextPath() + "/admin/courses?error=" + e.getMessage());
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/admin/courses?error=Lỗi hệ thống: " + e.getMessage());
        }
    }
}
