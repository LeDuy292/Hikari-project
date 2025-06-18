package utils;

import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import authentication.SessionManager;
import model.UserAccount;

public class SessionFilter implements Filter {
    private SessionManager sessionManager = new SessionManager();

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        String requestURI = httpRequest.getRequestURI();

        if (requestURI.endsWith("/view/login.jsp")) {
            chain.doFilter(request, response);
            return;
        }

        if (session == null || session.getAttribute("user") == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/view/login.jsp?error=Phiên+làm+việc+hết+hạn");
            return;
        }

        UserAccount user = (UserAccount) session.getAttribute("user");
        if (user != null) {
            try {
                if (!sessionManager.validateSession(user, session)) {
                    System.out.println("Invalid session for user: " + user.getUsername());
                    session.invalidate();
                    httpResponse.sendRedirect(httpRequest.getContextPath() + "/view/login.jsp?error=Phiên+làm+việc+hết+hạn+do+đăng+nhập+từ+thiết+bị+khác");
                    return;
                }
            } catch (Exception e) {
                System.out.println("Session validation error: " + e.getMessage());
                session.invalidate();
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/view/login.jsp?error=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
                return;
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}