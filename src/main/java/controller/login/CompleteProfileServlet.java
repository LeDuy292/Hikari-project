package controller.login;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.UserAccount;
import dao.UserDAO;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet(name = "CompleteProfileServlet", urlPatterns = {"/completeProfile"})
public class CompleteProfileServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get user from session
        UserAccount user = (UserAccount) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not logged in");
            return;
        }

        // Get form parameters
        String fullName = request.getParameter("fullName");
        String username = request.getParameter("username");
        String phone = request.getParameter("phone");
        String birthDateString = request.getParameter("birthDate");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate password match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match!");
            request.getRequestDispatcher("/view/student/complete_profile.jsp").forward(request, response);
            return;
        }
        // Update user object
        user.setFullName(fullName);
        user.setUsername(username);
        user.setPhone(phone);

        SimpleDateFormat formatDate = new SimpleDateFormat("yyyy-MM-dd");
        Date birthDate = new Date();
        try {
            birthDate = formatDate.parse(birthDateString);
        } catch (Exception e) {
            response.getWriter().print("error: " + e);
            return;
        }
        user.setBirthDate(birthDate);
        user.setPassword(password); // Set the password

        // Update user in database
        UserDAO userDAO = new UserDAO();
        userDAO.updateUserProfileGG(user);

        // Redirect to student home page
        response.sendRedirect(request.getContextPath() + "/view/student/home.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
