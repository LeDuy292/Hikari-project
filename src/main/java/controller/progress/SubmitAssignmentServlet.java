/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.progress;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonSyntaxException;
import com.google.gson.annotations.SerializedName;
import dao.AssignmentDAO;
import dao.ProgressDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Date;
import java.util.List;
import model.Assignment;
import model.Progress;
import model.Question;
import model.UserAccount;

/**
 *
 * @author ADMIN
 */
public class SubmitAssignmentServlet extends HttpServlet {

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
            out.println("<title>Servlet SubmitAssignmentServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SubmitAssignmentServlet at " + request.getContextPath() + "</h1>");
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
      private AssignmentDAO assignmentDAO = new AssignmentDAO();
    private ProgressDAO progressDAO = new ProgressDAO();
    private Gson gson = new Gson();
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
            // Đọc dữ liệu JSON từ request body
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = request.getReader().readLine()) != null) {
                sb.append(line);
            }
            String jsonString = sb.toString();
            System.out.println("Received JSON for assignment submission: " + jsonString);

            // Parse JSON thành đối tượng SubmitAssignmentData
            SubmitAssignmentData submitData = gson.fromJson(jsonString, SubmitAssignmentData.class);

            // Lấy studentID từ session
            HttpSession session = request.getSession();
            UserAccount currentUser = (UserAccount) session.getAttribute("user");
            
            if (currentUser == null || currentUser.getUserID() == null) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("error", "Người dùng chưa đăng nhập hoặc không có ID.");
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                out.print(gson.toJson(jsonResponse));
                return;
            }
            
            String studentId = currentUser.getUserID();
            String enrollmentId = submitData.getEnrollmentId(); 
            int assignmentId = submitData.getAssignmentId();

            Assignment assignment = assignmentDAO.getAssignmentById(assignmentId);
            if (assignment == null) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("error", "Không tìm thấy bài tập với ID: " + assignmentId);
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(gson.toJson(jsonResponse));
                return;
            }

            List<Question> correctQuestions = assignment.getQuestions(); 

            double score = 0;
            JsonArray resultsArray = new JsonArray(); 

            if (correctQuestions != null && !correctQuestions.isEmpty()) {
                int totalCorrectAnswers = 0;
                for (SubmitAnswer userAnswer : submitData.getAnswers()) {
                    JsonObject questionResult = new JsonObject();
                    
                    if (userAnswer.getQuestionIndex() < correctQuestions.size()) {
                        Question correctQ = correctQuestions.get(userAnswer.getQuestionIndex());
                        
                        questionResult.addProperty("questionText", correctQ.getQuestionText());
                        questionResult.addProperty("userAnswer", userAnswer.getAnswer());
                        questionResult.addProperty("correctOption", correctQ.getCorrectOption());

                        if (correctQ.getCorrectOption() != null && correctQ.getCorrectOption().equalsIgnoreCase(userAnswer.getAnswer())) {
                            totalCorrectAnswers++;
                            questionResult.addProperty("isCorrect", true);
                        } else {
                            questionResult.addProperty("isCorrect", false);
                        }
                    } else {
                        questionResult.addProperty("questionText", "Không tìm thấy câu hỏi này.");
                        questionResult.addProperty("userAnswer", userAnswer.getAnswer());
                        questionResult.addProperty("isCorrect", false);
                    }
                    resultsArray.add(questionResult);
                }

                // Tính điểm (ví dụ: mỗi câu đúng 1 điểm, hoặc phân bổ đều)
                score =  ((double) totalCorrectAnswers / correctQuestions.size() * assignment.getTotalMark());
            } else {
                 jsonResponse.addProperty("message", "Bài tập này không có câu hỏi nào để chấm điểm.");
                 score = 0; // Nếu không có câu hỏi, điểm là 0
            }
            
            Progress progress = progressDAO.getProgressByAssignment(enrollmentId, assignmentId);
            if (progress == null) {
                progress = new Progress();
                progress.setStudentID(studentId);
                progress.setEnrollmentID(enrollmentId);
                progress.setAssignmentID(assignmentId);
                progress.setLessonID(0); 
                progress.setCompletionStatus("complete"); 
                progress.setScore(score);
                progress.setStartDate(new Date(System.currentTimeMillis()));
                progress.setEndDate(new Date(System.currentTimeMillis()));
                progressDAO.insertProgress(progress);
                System.out.println("Inserted new progress for assignment: " + progress);

            } else {
                progress.setCompletionStatus("complete");
                progress.setScore(score);
                progress.setEndDate(new Date(System.currentTimeMillis()));
                if (progress.getStartDate() == null) {
                    progress.setStartDate(new Date(System.currentTimeMillis()));
                }
                progressDAO.updateProgress(progress);
                System.out.println("Updated existing progress for assignment: " + progress);
            }

            jsonResponse.addProperty("success", true);
            jsonResponse.addProperty("message", "Nộp bài thành công!");
            jsonResponse.addProperty("score", score);
            jsonResponse.add("results", resultsArray); // Gửi chi tiết kết quả về frontend

        } catch (JsonSyntaxException | IOException e) {
            e.printStackTrace();
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("error", "Lỗi server khi nộp bài: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        } finally {
            out.print(gson.toJson(jsonResponse));
            out.flush();
        }
    }

    
    
    
    
     private static class SubmitAssignmentData {
        private int assignmentId;
        private String courseId; 
        private String enrollmentId; 
        private List<SubmitAnswer> answers;

        public int getAssignmentId() { return assignmentId; }
        public String getCourseId() { return courseId; }
        public String getEnrollmentId() { return enrollmentId; } // Getter cho enrollmentId
        public List<SubmitAnswer> getAnswers() { return answers; }
    }

    private static class SubmitAnswer {
        @SerializedName("questionIndex")
        private int questionIndex;
        @SerializedName("answer")
        private String answer;

        public int getQuestionIndex() { return questionIndex; }
        public String getAnswer() { return answer; }
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
