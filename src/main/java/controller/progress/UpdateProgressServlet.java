/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.progress;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import dao.ProgressDAO;
import dao.UserAccountDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Date;
import model.Progress;
import model.UserAccount;

/**
 *
 * @author ADMIN
 */
public class UpdateProgressServlet extends HttpServlet {

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
            out.println("<title>Servlet UpdateProgressServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UpdateProgressServlet at " + request.getContextPath() + "</h1>");
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
    private final ProgressDAO progressDAO = new ProgressDAO();
    private final Gson gson = new Gson();
    private final UserAccountDAO userDAO = new UserAccountDAO();

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
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();

        try {
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = request.getReader().readLine()) != null) {
                sb.append(line);
            }
            String jsonString = sb.toString();
            System.out.println("Received JSON for progress update: " + jsonString);

            ProgressUpdateData data = gson.fromJson(jsonString, ProgressUpdateData.class);

            HttpSession session = request.getSession();
            UserAccount currentUser = (UserAccount) session.getAttribute("user"); // Giả sử User model có getUserID()

            if (currentUser == null || currentUser.getUserID() == null) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Người dùng chưa đăng nhập hoặc không có ID.");
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                out.print(gson.toJson(jsonResponse));
                return;
            }

            String userID = currentUser.getUserID();
            String studentId = userDAO.getStudentByUserID(userID).getStudentID();

            String enrollmentId = data.getEnrollmentId();
            int lessonId = data.getLessonId();
            int assignmentId = data.getAssignmentId();
            String completionStatus = data.getCompletionStatus();
            int score = data.getScore();

            Progress progress = new Progress();
            progress.setStudentID(studentId);
            progress.setEnrollmentID(enrollmentId);
            progress.setLessonID(lessonId);
            progress.setAssignmentID(assignmentId);
            progress.setCompletionStatus(completionStatus);
            progress.setScore(score);

            Progress existingProgress = null;
            if ("lesson".equals(data.getType())) {
                existingProgress = progressDAO.getProgressByLesson(enrollmentId, lessonId);
            } else if ("assignment".equals(data.getType())) {
                existingProgress = progressDAO.getProgressByAssignment(enrollmentId, assignmentId);
            }

            boolean updateSuccess;
            if (existingProgress != null) {
                progress.setProgressID(existingProgress.getProgressID());
                if ("complete".equalsIgnoreCase(completionStatus) && existingProgress.getEndDate() == null) {
                    progress.setEndDate(new Date(System.currentTimeMillis()));
                } else {
                    progress.setEndDate(existingProgress.getEndDate());
                }
                if (existingProgress.getStartDate() == null) {
                    progress.setStartDate(new Date(System.currentTimeMillis()));
                } else {
                    progress.setStartDate(existingProgress.getStartDate());
                }

                if ("assignment".equals(data.getType())) {
                    progress.setScore(score);
                } else {
                    progress.setScore(existingProgress.getScore());
                }

                updateSuccess = progressDAO.updateProgress(progress);
                System.out.println("Updating existing progress: " + progress);
            } else {
                progress.setStartDate((java.sql.Date) new Date(System.currentTimeMillis()));
                if ("complete".equalsIgnoreCase(completionStatus)) {
                    progress.setEndDate((java.sql.Date) new Date(System.currentTimeMillis()));
                }
                updateSuccess = progressDAO.insertProgress(progress);
                System.out.println("Inserting new progress: " + progress);
            }

            if (updateSuccess) {
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Cập nhật tiến độ thành công.");
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Không thể cập nhật tiến độ.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Lỗi server: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // 500 Internal Server Error
        } finally {
            out.print(gson.toJson(jsonResponse));
            out.flush();
        }
    }

    private static class ProgressUpdateData {

        private String studentId;
        private String enrollmentId;
        private int lessonId;
        private int assignmentId;
        private String completionStatus;
        private int score;
        private String type;

        // Getters
        public String getStudentId() {
            return studentId;
        }

        public String getEnrollmentId() {
            return enrollmentId;
        }

        public int getLessonId() {
            return lessonId;
        }

        public int getAssignmentId() {
            return assignmentId;
        }

        public String getCompletionStatus() {
            return completionStatus;
        }

        public int getScore() {
            return score;
        }

        public String getType() {
            return type;
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
