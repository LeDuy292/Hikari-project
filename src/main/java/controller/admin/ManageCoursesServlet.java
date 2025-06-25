package controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Course;
import service.CourseService;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/courses")
public class ManageCoursesServlet extends HttpServlet {
    private final CourseService courseService = new CourseService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String message = req.getParameter("message");
        req.setAttribute("message", message);

        try {
            if ("add".equals(action)) {
                req.getRequestDispatcher("/view/admin/addCourse.jsp").forward(req, resp);
            } else if ("edit".equals(action)) {
                String id = req.getParameter("id");
                Course c = courseService.getCourseById(id);
                req.setAttribute("course", c);
                req.getRequestDispatcher("/view/admin/editCourse.jsp").forward(req, resp);
            } else if ("detail".equals(action)) {
                String id = req.getParameter("id");
                Course c = courseService.getCourseById(id);
                req.setAttribute("course", c);
                req.getRequestDispatcher("/view/admin/courseDetail.jsp").forward(req, resp);
            } else {
                // Danh sách, có thể có tìm kiếm, phân trang, lọc
                String keyword = req.getParameter("keyword");
                String category = req.getParameter("category");
                String pageStr = req.getParameter("page");
                int page = 1;
                if (pageStr != null) {
                    try { page = Integer.parseInt(pageStr); } catch (NumberFormatException ignored) {}
                }
                int pageSize = 10;

                List<Course> courses;
                if (keyword != null && !keyword.isEmpty() && category != null && !category.isEmpty()) {
                    courses = courseService.searchCoursesByCategory(keyword, category);
                } else if (keyword != null && !keyword.isEmpty()) {
                    courses = courseService.searchCourses(keyword);
                } else if (category != null && !category.isEmpty()) {
                    courses = courseService.getCoursesByCategory(category);
                } else {
                    courses = courseService.getCoursesWithPaging(page, pageSize);
                }
                req.setAttribute("courses", courses);
                req.getRequestDispatcher("/view/admin/manageCourses.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/admin/error.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        try {
            if ("add".equals(action)) {
                Course c = new Course();
                c.setCourseID(req.getParameter("courseID"));
                c.setTitle(req.getParameter("title"));
                c.setDescription(req.getParameter("description"));
                c.setFee(Double.parseDouble(req.getParameter("fee")));
                // ... các trường khác
                courseService.addCourse(c);
                resp.sendRedirect(req.getContextPath() + "/admin/courses?message=Thêm thành công");
            } else if ("edit".equals(action)) {
                Course c = new Course();
                c.setCourseID(req.getParameter("courseID"));
                c.setTitle(req.getParameter("title"));
                c.setDescription(req.getParameter("description"));
                c.setFee(Double.parseDouble(req.getParameter("fee")));
                // ... các trường khác
                courseService.editCourse(c);
                resp.sendRedirect(req.getContextPath() + "/admin/courses?message=Cập nhật thành công");
            } else if ("delete".equals(action)) {
                String id = req.getParameter("id");
                courseService.deleteCourse(id);
                resp.sendRedirect(req.getContextPath() + "/admin/courses?message=Xóa thành công");
            } else {
                resp.sendRedirect(req.getContextPath() + "/view/admin/courses");
            }
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/view/admin/error.jsp").forward(req, resp);
        }
    }
}
