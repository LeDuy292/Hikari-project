/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.coordinator;

import dao.TeacherDAO;
import dao.UserAccountDAO;
import dao.coordinator.CVDAO;
import responsitory.CVRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.io.*;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.mail.Session;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;
import model.Teacher;
import model.UserAccount;
import model.coordinator.CV;

@WebServlet("/cv")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                maxFileSize = 1024 * 1024 * 10,      // 10MB
                maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class CVServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(CVServlet.class);
    private CVDAO cvDAO;
    private TeacherDAO teacherDAO;
    private UserAccountDAO userAccountDAO;
    private CVRepository cvRepository;

    @Override
    public void init() throws ServletException {
        try {
            cvDAO = new CVDAO();
            teacherDAO = new TeacherDAO();
            userAccountDAO = new UserAccountDAO();
            cvRepository = new CVRepository();
            logger.info("CVServlet: Initialized successfully with DAOs and S3 repository.");
        } catch (Exception e) {
            logger.error("CVServlet: Error initializing servlet: {}", e.getMessage(), e);
            throw new ServletException("DAO or S3 initialization error", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            logger.warn("CVServlet: Unauthorized access attempt, redirecting to login.");
            response.sendRedirect(request.getContextPath()+"/loginPage");
            return;
        }

        UserAccount user = (UserAccount) session.getAttribute("user");
        try {
            if ("Coordinator".equals(user.getRole())) {
                List<CV> cvList = cvDAO.getAllCVs();
                request.setAttribute("cvList", cvList);
                request.getRequestDispatcher("view/coordinator/teacher-cv-review.jsp").forward(request, response);
                logger.debug("CVServlet: Coordinator accessed teacher-cv-review.jsp with {} CVs.", cvList.size());
            } else if ("Student".equals(user.getRole()) || "Applicant".equals(user.getRole())) {
                List<CV> cvList = cvDAO.getCVsByUserID(user.getUserID());
                request.setAttribute("cvList", cvList);
                request.getRequestDispatcher("view/coordinator/upload-cv.jsp").forward(request, response);
                logger.debug("CVServlet: User {} accessed upload-cv.jsp with {} CVs.", user.getUserID(), cvList.size());
            } else {
                logger.warn("CVServlet: Unauthorized role {} for user {}, redirecting.", user.getRole(), user.getUserID());
                response.sendRedirect("view/coordinator/upload-cv.jsp?error=unauthorized");
            }
        } catch (Exception e) {
            logger.error("CVServlet: Error retrieving CVs: {}", e.getMessage(), e);
            throw new ServletException("Error retrieving CVs", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            logger.warn("CVServlet: Unauthorized access attempt, redirecting to login.");
            response.sendRedirect(request.getContextPath()+"/loginPage");
            return;
        }

        UserAccount user = (UserAccount) session.getAttribute("user");
        String action = request.getParameter("action");

        if ("upload".equals(action)) {
            if (!"Student".equals(user.getRole()) && !"Applicant".equals(user.getRole())) {
                logger.warn("CVServlet: Unauthorized upload attempt by user {} with role {}.", user.getUserID(), user.getRole());
                response.sendRedirect("view/coordinator/upload-cv.jsp?error=unauthorized");
                return;
            }

            Part filePart = request.getPart("cvFile"); // Sử dụng jakarta.servlet.http.Part
            String fileName = filePart.getSubmittedFileName();
            if (!fileName.toLowerCase().endsWith(".pdf")) {
                logger.warn("CVServlet: Invalid file format uploaded by user {}: {}", user.getUserID(), fileName);
                response.sendRedirect("view/coordinator/upload-cv.jsp?error=invalid_file");
                return;
            }

            String fileUrl = cvRepository.saveFile(filePart, "teacher_cvs");
            if (fileUrl == null) {
                logger.error("CVServlet: Failed to upload CV to S3 for user {}.", user.getUserID());
                response.sendRedirect("view/coordinator/upload-cv.jsp?error=upload_failed");
                return;
            }

            CV cv = new CV();
            cv.setUserID(user.getUserID());
            cv.setFullName(user.getFullName());
            cv.setEmail(user.getEmail());
            cv.setPhone(user.getPhone());
            cv.setFileUrl(fileUrl);
            cv.setStatus("Pending");
            cv.setInterviewStatus("Pending"); // CHANGED: Thêm khởi tạo interviewStatus khi upload CV mới

            try {
                cvDAO.addCV(cv);
//                sendEmail(user.getEmail(), "CV Submitted", "Your CV has been submitted successfully and is pending review.");
                logger.info("CVServlet: CV uploaded successfully for user {}.", user.getUserID());
//                response.sendRedirect("view/coordinator/upload-cv.jsp?success=upload");
                response.sendRedirect(request.getContextPath() + "/cv?success=upload");
            } catch (Exception e) {
                cvRepository.deleteFile(fileUrl);
                logger.error("CVServlet: Error uploading CV for user {}: {}", user.getUserID(), e.getMessage(), e);
                throw new ServletException("Error uploading CV", e);
            }
        } else if ("review".equals(action)) {
            if (!"Coordinator".equals(user.getRole())) {
                logger.warn("CVServlet: Unauthorized review attempt by user {} with role {}.", user.getUserID(), user.getRole());
                response.sendRedirect("view/coordinator/teacher-cv-review.jsp?error=unauthorized");
                return;
            }

            int cvID = Integer.parseInt(request.getParameter("cvID"));
            String status = request.getParameter("status");
            String reviewerID = user.getUserID();
            String comments = request.getParameter("comments");
            String interviewStatus = request.getParameter("interviewStatus");

            try {
                CV cv = cvDAO.getCVByID(cvID);
                if (cv == null) {
                    logger.warn("CVServlet: CV with ID {} not found.", cvID);
                    response.sendRedirect("view/coordinator/teacher-cv-review.jsp?error=cv_not_found");
                    return;
                }
                String finalInterviewStatus = interviewStatus != null && 
                    (interviewStatus.equals("Pending") || interviewStatus.equals("Pass") || interviewStatus.equals("Fail")) 
                    ? interviewStatus : cv.getInterviewStatus();
                
                // CHANGED: Cập nhật cả status và interviewStatus
                cvDAO.updateCVStatus(cvID, status, reviewerID, comments);
                cvDAO.updateInterviewStatus(cvID, interviewStatus); // Gọi phương thức mới để cập nhật interviewStatus

                String subject = status.equals("Approved") ? "CV Approved" : "CV Rejected";
                String message = status.equals("Approved") ?
                    "Congratulations! Your CV has been approved. Your interview status is: " + interviewStatus + ". Please contact us for the next steps." : // CHANGED: Thêm thông tin interviewStatus vào email
                    "We regret to inform you that your CV has been rejected. Reason: " + comments;
//                sendEmail(cv.getEmail(), subject, message);

                // CHANGED: Chỉ thêm Teacher nếu cả status là Approved và interviewStatus là Pass
                if (status.equals("Approved") && interviewStatus.equals("Pass")) {
                    String newTeacherID = generateTeacherID();
                    Teacher teacher = new Teacher();
                    teacher.setTeacherID(newTeacherID);
                    teacher.setUserID(cv.getUserID());
                    teacher.setSpecialization("Chưa xác định");
                    teacher.setExperienceYears(0);
                    teacherDAO.addTeacher(teacher);
                    userAccountDAO.updateUserRole(cv.getUserID(), "Teacher");
                    logger.info("CVServlet: CV {} approved with interview status Pass, created teacher {} for user {}.", cvID, newTeacherID, cv.getUserID());
                }

                if (status.equals("Rejected")) {
                    cvRepository.deleteFile(cv.getFileUrl());
                    logger.info("CVServlet: CV {} rejected, deleted file from S3.", cvID);
                }

                response.sendRedirect(request.getContextPath() + "/cv?success=review");
            } catch (Exception e) {
                logger.error("CVServlet: Error reviewing CV {}: {}", cvID, e.getMessage(), e);
                throw new ServletException("Error reviewing CV", e);
            }
        }
    }

//    private void sendEmail(String to, String subject, String message) {
//        Properties props = new Properties();
//        props.put("mail.smtp.auth", "true");
//        props.put("mail.smtp.starttls.enable", "true");
//        props.put("mail.smtp.host", "smtp.gmail.com");
//        props.put("mail.smtp.port", "587");
//
//        String username = "your_email@gmail.com";
//        String password = "your_app_password";
//
//        Session session = Session.getInstance(props, new Authenticator() {
//            @Override
//            protected PasswordAuthentication getPasswordAuthentication() {
//                return new PasswordAuthentication(username, password);
//            }
//        });
//
//        try {
//            Message msg = new MimeMessage(session);
//            msg.setFrom(new InternetAddress(username));
//            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
//            msg.setSubject(subject);
//            msg.setText(message);
//            Transport.send(msg);
//            logger.info("CVServlet: Email sent to {} with subject: {}", to, subject);
//        } catch (MessagingException e) {
//            logger.error("CVServlet: Error sending email to {}: {}", to, e.getMessage(), e);
//        }
//    }

    private String generateTeacherID() {
        return "T" + String.format("%03d", System.currentTimeMillis() % 1000);
    }

    @Override
    public void destroy() {
        if (cvDAO != null) {
            cvDAO.closeConnection();
        }
        if (teacherDAO != null) {
            teacherDAO.closeConnection();
        }
        if (userAccountDAO != null) {
            userAccountDAO.closeConnection();
        }
        logger.info("CVServlet: Servlet destroyed, database connections closed.");
    }
}