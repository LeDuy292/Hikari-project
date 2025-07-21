package controller.forum;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import authentication.UserAuthentication;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import model.UserAccount;

/**
 * Authentication filter specifically for forum and other protected resources
 * Works with existing UserAuthentication system
 */
@WebFilter(filterName = "ForumAuthenticationFilter", urlPatterns = {"/forum/*"})
public class ForumAuthenticationFilter implements Filter {

    // URLs that don't require authentication (relative to context path)
    private static final List<String> EXCLUDED_PATHS = Arrays.asList(
        "/login", "/register", "/loginPage", "/assets/", "/auth/google", "/view/student/home.jsp"
    );

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("ForumAuthenticationFilter initialized");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        
        // Remove context path from URI for comparison
        String path = requestURI.substring(contextPath.length());
        
        System.out.println("ForumAuthenticationFilter: Checking path: " + path);
        
        // Check if the path should be excluded from authentication
        boolean isExcluded = EXCLUDED_PATHS.stream().anyMatch(path::startsWith);
        
        if (isExcluded) {
            System.out.println("ForumAuthenticationFilter: Path excluded, allowing access");
            chain.doFilter(request, response);
            return;
        }
        
        // Replace the authentication check section with:
        // Check authentication using session attributes directly
        HttpSession session = httpRequest.getSession(false);
        boolean isAuthenticated = false;

        if (session != null) {
            String userId = (String) session.getAttribute("userId");
            String username = (String) session.getAttribute("username");
            UserAccount user = (UserAccount) session.getAttribute("user");
            isAuthenticated = (userId != null && username != null && user != null);
        }

        System.out.println("ForumAuthenticationFilter: User authenticated: " + isAuthenticated);

        if (isAuthenticated) {
            String userId = (String) session.getAttribute("userId");
            UserAccount user = (UserAccount) session.getAttribute("user");
            System.out.println("ForumAuthenticationFilter: User ID: " + userId + ", Username: " + user.getUsername());
            chain.doFilter(request, response);
        } else {
            // User is not authenticated, redirect to login
            String originalUrl = requestURI;
            if (httpRequest.getQueryString() != null) {
                originalUrl += "?" + httpRequest.getQueryString();
            }
            
            System.out.println("ForumAuthenticationFilter: User not authenticated, redirecting to login");
            System.out.println("ForumAuthenticationFilter: Original URL: " + originalUrl);
            
            // Store the original URL in session for redirect after login
            HttpSession newSession = httpRequest.getSession(true);
            newSession.setAttribute("redirectUrl", originalUrl);
            
            httpResponse.sendRedirect(contextPath + "/loginPage");
        }
    }

    @Override
    public void destroy() {
        System.out.println("ForumAuthenticationFilter destroyed");
    }
}
