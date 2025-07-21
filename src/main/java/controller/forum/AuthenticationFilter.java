package controller.forum;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

/**
 * Authentication filter to protect secured resources
 */
@WebFilter(filterName = "AuthenticationFilter", urlPatterns = {"/forum/*", "/profile/*", "/test/*"})
public class AuthenticationFilter implements Filter {

    // URLs that don't require authentication
    private static final List<String> EXCLUDED_PATHS = Arrays.asList(
        "/login", "/register", "/loginPage", "/assets/", "/auth/google"
    );

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
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
        
        // Check if the path should be excluded from authentication
        boolean isExcluded = EXCLUDED_PATHS.stream().anyMatch(path::startsWith);
        
        if (isExcluded) {
            chain.doFilter(request, response);
            return;
        }
        
        // Check authentication
        HttpSession session = httpRequest.getSession(false);
        boolean isAuthenticated = false;
        
        if (session != null) {
            String userId = (String) session.getAttribute("userId");
            String username = (String) session.getAttribute("username");
            isAuthenticated = (userId != null && username != null);
        }
        
        if (isAuthenticated) {
            // User is authenticated, continue with the request
            chain.doFilter(request, response);
        } else {
            // User is not authenticated, redirect to login
            String originalUrl = requestURI;
            if (httpRequest.getQueryString() != null) {
                originalUrl += "?" + httpRequest.getQueryString();
            }
            
            // Store the original URL in session for redirect after login
            HttpSession newSession = httpRequest.getSession(true);
            newSession.setAttribute("redirectUrl", originalUrl);
            
            httpResponse.sendRedirect(contextPath + "/loginPage");
        }
    }

    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}
