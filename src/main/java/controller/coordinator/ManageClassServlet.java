package controller.coordinator;

import dao.coordinator.ClassManagementDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Class;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

@WebServlet(name = "ManageClassServlet", urlPatterns = {"/ManageClass"})
public class ManageClassServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(ManageClassServlet.class);
    
    private ClassManagementDAO classDAO;

    @Override
    public void init() throws ServletException {
        classDAO = new ClassManagementDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        String courseID = request.getParameter("courseID");
        
        // Validate required parameters
        if (action == null || action.trim().isEmpty()) {
            setErrorMessage(request, "Yêu cầu không hợp lệ: Thiếu hành động");
            redirectToClassList(response, courseID);
            return;
        }
        
        if (courseID == null || courseID.trim().isEmpty()) {
            setErrorMessage(request, "Vui lòng chọn một khóa học trước khi thực hiện thao tác.");
            response.sendRedirect(request.getContextPath() + "/LoadCourse");
            return;
        }

        try {
            switch (action) {
                case "add":
                    handleAddClass(request, courseID);
                    break;
                case "update":
                    handleUpdateClass(request, courseID);
                    break;
                case "delete":
                    handleDeleteClass(request, courseID);
                    break;
                default:
                    setErrorMessage(request, "Hành động không hợp lệ: " + action);
                    break;
            }
        } catch (Exception e) {
            logger.error("Error in ManageClassServlet: {}", e.getMessage(), e);
            setErrorMessage(request, "Có lỗi xảy ra: " + e.getMessage());
        }
        
        // Redirect back to the class list for the current course
        redirectToClassList(response, courseID);
    }

    private void handleAddClass(HttpServletRequest request, String courseID) throws Exception {
        String className = request.getParameter("className");
        String teacherID = request.getParameter("teacherID");
        
        // Validate input
        if (className == null || className.trim().isEmpty()) {
            throw new IllegalArgumentException("Tên lớp không được để trống");
        }
        
        if (teacherID == null || teacherID.trim().isEmpty()) {
            throw new IllegalArgumentException("Vui lòng chọn giảng viên");
        }
        
        // Check if teacher exists
        if (!classDAO.isTeacherExists(teacherID)) {
            throw new IllegalArgumentException("Giảng viên không tồn tại trong hệ thống");
        }
        
        // Check if class name already exists in the course
        if (classDAO.isClassNameExists(courseID, className.trim(), null)) {
            throw new IllegalArgumentException("Tên lớp đã tồn tại trong khóa học này. Vui lòng chọn tên khác.");
        }
        
        // Generate new ClassID
        String newClassID = classDAO.generateNewClassID();
        
        // Create new class object
        Class newClass = new Class();
        newClass.setClassID(newClassID);
        newClass.setCourseID(courseID);
        newClass.setName(className.trim());
        newClass.setTeacherID(teacherID);
        newClass.setNumberOfStudents(0); // Default to 0
        
        // Add class to database
        boolean success = classDAO.addClass(newClass);
        if (!success) {
            throw new Exception("Không thể thêm lớp học. Vui lòng thử lại.");
        }
        
        setSuccessMessage(request, "Thêm lớp học '" + className + "' thành công!");
        logger.info("Successfully added class {} for course {}", newClassID, courseID);
    }

    private void handleUpdateClass(HttpServletRequest request, String courseID) throws Exception {
        String classID = request.getParameter("classID");
        String className = request.getParameter("className");
        String teacherID = request.getParameter("teacherID");
        
        // Validate input
        if (classID == null || classID.trim().isEmpty()) {
            throw new IllegalArgumentException("Thiếu mã lớp");
        }
        
        if (className == null || className.trim().isEmpty()) {
            throw new IllegalArgumentException("Tên lớp không được để trống");
        }
        
        if (teacherID == null || teacherID.trim().isEmpty()) {
            throw new IllegalArgumentException("Vui lòng chọn giảng viên");
        }
        
        // Check if class exists
        Class existingClass = classDAO.getClassByID(classID);
        if (existingClass == null) {
            throw new IllegalArgumentException("Lớp học không tồn tại");
        }
        
        // Check if class belongs to the current course
        if (!existingClass.getCourseID().equals(courseID)) {
            throw new IllegalArgumentException("Lớp học không thuộc khóa học hiện tại");
        }
        
        // Check if teacher exists
        if (!classDAO.isTeacherExists(teacherID)) {
            throw new IllegalArgumentException("Giảng viên không tồn tại trong hệ thống");
        }
        
        // Check if class name already exists (excluding current class)
        if (classDAO.isClassNameExists(courseID, className.trim(), classID)) {
            throw new IllegalArgumentException("Tên lớp đã tồn tại trong khóa học này. Vui lòng chọn tên khác.");
        }
        
        // Update class information
        Class updatedClass = new Class();
        updatedClass.setClassID(classID);
        updatedClass.setCourseID(courseID);
        updatedClass.setName(className.trim());
        updatedClass.setTeacherID(teacherID);
        updatedClass.setNumberOfStudents(existingClass.getNumberOfStudents()); // Keep existing student count
        
        boolean success = classDAO.updateClass(updatedClass);
        if (!success) {
            throw new Exception("Cập nhật thông tin lớp học thất bại. Vui lòng thử lại.");
        }
        
        setSuccessMessage(request, "Cập nhật thông tin lớp học '" + className + "' thành công!");
        logger.info("Successfully updated class {} for course {}", classID, courseID);
    }

    private void handleDeleteClass(HttpServletRequest request, String courseID) throws Exception {
        String classID = request.getParameter("classID");
        
        // Validate input
        if (classID == null || classID.trim().isEmpty()) {
            throw new IllegalArgumentException("Thiếu mã lớp");
        }
        
        // Check if class exists
        Class existingClass = classDAO.getClassByID(classID);
        if (existingClass == null) {
            throw new IllegalArgumentException("Lớp học không tồn tại");
        }
        
        // Check if class belongs to the current course
        if (!existingClass.getCourseID().equals(courseID)) {
            throw new IllegalArgumentException("Lớp học không thuộc khóa học hiện tại");
        }
        
        // Check if class has students (optional - you can remove this check if you want to allow deletion)
        if (existingClass.getNumberOfStudents() > 0) {
            throw new IllegalStateException("Không thể xóa lớp học đã có " + existingClass.getNumberOfStudents() + " học viên đăng ký");
        }
        
        // Delete the class
        boolean success = classDAO.deleteClass(classID);
        if (!success) {
            throw new Exception("Không thể xóa lớp học. Vui lòng thử lại.");
        }
        
        setSuccessMessage(request, "Xóa lớp học '" + existingClass.getName() + "' thành công!");
        logger.info("Successfully deleted class {} from course {}", classID, courseID);
    }

    private void setSuccessMessage(HttpServletRequest request, String message) {
        request.getSession().setAttribute("successMessage", message);
    }

    private void setErrorMessage(HttpServletRequest request, String message) {
        request.getSession().setAttribute("errorMessage", message);
    }

    private void redirectToClassList(HttpServletResponse response, String courseID) throws IOException {
        if (courseID != null && !courseID.trim().isEmpty()) {
            response.sendRedirect("LoadClass?courseID=" + courseID);
        } else {
            response.sendRedirect("LoadCourse");
        }
    }

    @Override
    public void destroy() {
        if (classDAO != null) {
            classDAO.closeConnection();
        }
    }
}
