package com.stockpulse.filter;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Authentication Filter
 * Protects pages that require login.
 * Redirects to login page if user is not authenticated.
 */
public class AuthenticationFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        // Get the session (don't create if doesn't exist)
        HttpSession session = httpRequest.getSession(false);
        
        // Check if user is logged in
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);
        
        // Get the requested URI
        String requestURI = httpRequest.getRequestURI();
        
        // Allow access to login page and static resources
        boolean isLoginPage = requestURI.endsWith("login.jsp") || requestURI.endsWith("/login");
        boolean isStaticResource = requestURI.contains("/css/") || 
                                   requestURI.contains("/js/") || 
                                   requestURI.contains("/images/");
        
        if (isLoggedIn || isLoginPage || isStaticResource) {
            // User is logged in or accessing public resources - allow request
            chain.doFilter(request, response);
        } else {
            // User is not logged in - redirect to login
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
        }
    }
    
    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}
