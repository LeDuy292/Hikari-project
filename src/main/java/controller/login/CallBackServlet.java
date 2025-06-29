/*
 * Click .nb://SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click .nb://SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.login;

import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.Random;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.GoogleAccount;
import model.UserAccount;

/**
 *
 * @author LENOVO
 */
public class CallBackServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        System.out.println("CallbackServlet invoked for: " + request.getRequestURI());
        String code = request.getParameter("code");
        System.out.println("Received code: " + code);
        if (code != null) {
            GoogleLogin gg = new GoogleLogin();
            try {
                String accessToken = gg.getToken(code);
                System.out.println("Access token: " + accessToken);
                if (accessToken != null) {
                    GoogleAccount googleAcc = gg.getUserInfo(accessToken);
                    System.out.println("User info: " + googleAcc);
                    if (googleAcc != null) {
                        UserDAO userDAO = new UserDAO();
                        UserAccount user = userDAO.getUserByEmail(googleAcc.getEmail());

                        if (user != null) {
                            // Case 1: User exists in database
                            request.getSession().setAttribute("user", user);
                            response.sendRedirect(request.getContextPath() + "/view/student/home.jsp");
                        } else {
                            // Case 2: User does not exist, create partial user record
                            UserAccount newUser = new UserAccount();
                            Random random = new Random();
                            int randomNum = random.nextInt(1000);
                            String userID = String.format("U%03d", randomNum);
                            newUser.setUserID(userID);
                            newUser.setEmail(googleAcc.getEmail());
                            newUser.setFullName(googleAcc.getName());
                            newUser.setProfilePicture(googleAcc.getPicture()); // If available
                            newUser.setRole("Student");
                            String tempUsername = googleAcc.getEmail().split("@")[0].replaceAll("[^a-zA-Z0-9]", "_");
                            newUser.setUsername(tempUsername.length() > 50 ? tempUsername.substring(0, 50) : tempUsername);
                            newUser.setPassword(""); // Set empty string as placeholder

                            // Add user to database
                            userDAO.addUser(newUser);
                            request.getSession().setAttribute("user", newUser);
                            response.sendRedirect(request.getContextPath() + "/view/student/complete_profile.jsp");
                        }
                    } else {
                        response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Failed to get user info");
                    }
                } else {
                    response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Failed to get access token");
                }
            } catch (IOException e) {
                System.out.println("IOException: " + e.getMessage());
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing token");
            } catch (ClassNotFoundException ex) {
                Logger.getLogger(CallBackServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "No authorization code provided");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(CallBackServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(CallBackServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public String getServletInfo() {
        return "Handles Google OAuth callback and processes login";
    }
}
