/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.course;

import dao.AssignmentDAO;
import dao.ExerciseDAO;
import dao.QuestionDAO;
import dao.TestDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.List;
import model.Assignment;
import model.Exercise;
import model.Question;
import model.Test;

/**
 *
 * @author ADMIN
 */
@MultipartConfig
public class SaveQuestionServlet extends HttpServlet {

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
            out.println("<title>Servlet SaveQuestionServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SaveQuestionServlet at " + request.getContextPath() + "</h1>");
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
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private final QuestionDAO questionDAO = new QuestionDAO();
    private final AssignmentDAO assignmentDAO = new AssignmentDAO();
    private final ExerciseDAO exerciseDAO = new ExerciseDAO();
    private final TestDAO testDAO = new TestDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8"); // Set JSON content type
        String type = request.getParameter("type"); // assignment | exercise | test
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String duration = request.getParameter("duration");
        String topicID = request.getParameter("topicId");
        String lessonID = request.getParameter("lessonId");
        String jlptLevel = request.getParameter("jlptLevel");
        int totalQuestions = 0;
        double totalMarks = 100;
        List<Question> uploadedQuestions = (List<Question>) request.getSession().getAttribute("uploadedQuestions");
        if (uploadedQuestions != null) {
            totalQuestions = uploadedQuestions.size();
            System.out.println("totalQuestions" + totalQuestions);

        }
        System.out.println("totalQuestions" + totalQuestions);

        try {
            if (type == null || !List.of("assignment", "exercise", "test").contains(type)) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"status\":\"error\",\"message\":\"Loại không hợp lệ.\"}");
                return;
            }
            if (title == null || title.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"status\":\"error\",\"message\":\"Tiêu đề không được để trống.\"}");
                return;
            }

            if (uploadedQuestions == null || uploadedQuestions.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"status\":\"error\",\"message\":\"Không có câu hỏi nào được tải lên.\"}");
                return;
            }
            int id = -1;
            switch (type) {
                case "assignment":
                    if (duration == null || !duration.matches("\\d+")) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        response.getWriter().write("{\"status\":\"error\",\"message\":\"Thời lượng phải là số nguyên dương.\"}");
                        return;
                    }
                    if (topicID == null || topicID.trim().isEmpty()) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        response.getWriter().write("{\"status\":\"error\",\"message\":\"Chủ đề không được để trống.\"}");
                        return;
                    }
                    Assignment a = new Assignment();
                    a.setTopicID(topicID);
                    a.setTitle(title);
                    a.setDescription(description);
                    a.setDuration(Integer.parseInt(duration));
                    a.setTotalMark(totalMarks);
                    a.setTotalQuestions(totalQuestions);
                    a.setIsActive(true);
                    id = assignmentDAO.insertAndReturnId(a);
                    for (Question q : uploadedQuestions) {
                        q.setEntityID(id);
                        q.setEntityType("assignment");
                        questionDAO.insertQuestion(q);
                    }
                    break;

                case "exercise":
                    Exercise e = new Exercise();
                    e.setLessonID(Integer.parseInt(lessonID));
                    e.setTitle(title);
                    e.setDescription(description);
                    e.setActive(true);
                    id = exerciseDAO.insertAndReturnId(e);
                    for (Question q : uploadedQuestions) {
                        q.setEntityID(id);
                        q.setEntityType("exercise");
                        questionDAO.insertQuestion(q);
                    }
                    break;

                case "test":
                    if (duration == null || !duration.matches("\\d+")) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        response.getWriter().write("{\"status\":\"error\",\"message\":\"Thời lượng phải là số nguyên dương.\"}");
                        return;
                    }
                    if (jlptLevel == null || jlptLevel.trim().isEmpty()) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        response.getWriter().write("{\"status\":\"error\",\"message\":\"JLPT Level không được để trống.\"}");
                        return;
                    }
                    Test t = new Test();
                    t.setJlptLevel(jlptLevel);
                    t.setTitle(title);
                    t.setDescription(description);
                    t.setDuration(Integer.parseInt(duration));
                    t.setTotalMarks(totalMarks);
                    t.setTotalQuestions(totalQuestions);
                    t.setActive(true);
                    id = testDAO.insertAndReturnId(t);
                    for (Question q : uploadedQuestions) {
                        q.setEntityID(id);
                        q.setEntityType("test");
                        questionDAO.insertQuestion(q);
                    }
                    break;

                default:
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"status\":\"error\",\"message\":\"Loại type không hợp lệ.\"}");
                    return;
            }

            // Clear questions from session after successful save
            request.getSession().removeAttribute("uploadedQuestions");
            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("{\"status\":\"success\",\"message\":\"Lưu thành công với ID = " + id + "\"}");
        } catch (IOException | NumberFormatException | SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"status\":\"error\",\"message\":\"Lỗi khi lưu câu hỏi: " + e.getMessage() + "\"}");
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
