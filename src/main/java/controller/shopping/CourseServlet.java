package controller.shopping;

import dao.CourseDAO;
import dao.student.CourseInfoDAO;
import model.Course;
import model.student.CourseInfo;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/courses")
public class CourseServlet extends HttpServlet {
    private CourseDAO courseDAO;
    private CourseInfoDAO courseInfoDAO;

    @Override
    public void init() throws ServletException {
        courseDAO = new CourseDAO();
        courseInfoDAO = new CourseInfoDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String category = request.getParameter("category");
        String search = request.getParameter("search");

        if (action == null) action = "list";

        switch (action) {
            case "list":
                listCourses(request, response, category, search);
                break;
            case "detail":
                showCourseDetail(request, response);
                break;
            default:
                listCourses(request, response, category, search);
                break;
        }
    }

    private void listCourses(HttpServletRequest request, HttpServletResponse response,
                             String category, String search) throws ServletException, IOException {
        List<Course> courses;

        if (search != null && !search.trim().isEmpty()) {
            // Assuming "paid" is a default category or means all categories if not specified
            if (category == null || category.isEmpty() || category.equals("paid")) {
                courses = courseDAO.searchCoursesAllCategories(search);
            } else {
                courses = courseDAO.searchCourses(search, category);
            }
        } else {
            if (category == null || category.isEmpty() || category.equals("paid")) {
                courses = courseDAO.getAll();
            } else {
                courses = courseDAO.getAllCoursesByCategory(category);
            }
        }

        request.setAttribute("courses", courses);
        request.setAttribute("category", category != null ? category : "paid");
        request.setAttribute("search", search);
        request.getRequestDispatcher("/view/student/online.jsp").forward(request, response);
    }

    private void showCourseDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/courses?error=invalid_id");
            return;
        }

        try {
            String courseId = idParam; // Use String directly, no parsing
            Course course = courseDAO.getCourseByID(courseId); // Pass String directly
            CourseInfo courseInfo = courseInfoDAO.getCourseInfoByCourseId(courseId); // Pass String directly

            if (course != null) {
                request.setAttribute("course", course);
                request.setAttribute("courseInfo", courseInfo);
                request.getRequestDispatcher("/view/student/courseInfo.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/courses?error=no_data");
            }
        } catch (Exception e) { // Catch generic Exception for robustness
            System.err.println("Error in CourseServlet showCourseDetail: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/courses?error=system_error");
        }
    }

    @Override
    public void destroy() {
        courseDAO.closeConnection();
    }
}
