package controller.shopping;

import dao.CourseDAO;
import dao.CourseInfoDAO;
import model.Course;
import model.CourseInfo;
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
        try {
            int courseId = Integer.parseInt(request.getParameter("id"));
            Course course = courseDAO.getCourseById(courseId);
            CourseInfo courseInfo = courseInfoDAO.getCourseInfoByCourseId(courseId);

            if (course != null) {
                request.setAttribute("course", course);
                request.setAttribute("courseInfo", courseInfo);
                request.getRequestDispatcher("/view/student/courseInfo.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/courses?error=no_data");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/courses?error=invalid_id");
        }
    }

    @Override
    public void destroy() {
        courseDAO.closeConnection();
    }
}