package com.stockpulse.controller;

import com.stockpulse.dao.UserDAO;
import com.stockpulse.model.User;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * User Controller
 * Handles User Management (Admin only feature)
 * Allows creating, editing, and deleting staff accounts
 */
public class UserController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Admin only check
        HttpSession session = request.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/dashboard?error=Access denied. Admin only.");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            if ("delete".equals(action)) {
                deleteUser(request, response);
            } else {
                listUsers(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
            try { listUsers(request, response); } catch (Exception ex) { throw new ServletException(ex); }
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Admin only check
        HttpSession session = request.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/dashboard?error=Access denied. Admin only.");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            if ("update".equals(action)) {
                updateUser(request, response);
            } else {
                createUser(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
            try { listUsers(request, response); } catch (Exception ex) { throw new ServletException(ex); }
        }
    }
    
    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        UserDAO userDAO = new UserDAO();
        List<User> users = userDAO.getAllUsers();
        request.setAttribute("users", users);
        request.getRequestDispatcher("/users.jsp").forward(request, response);
    }
    
    private void createUser(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String role = request.getParameter("role");
        
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty() ||
            fullName == null || fullName.trim().isEmpty()) {
            request.setAttribute("error", "All fields are required");
            listUsers(request, response);
            return;
        }
        
        // Hash password using BCrypt
        String passwordHash = BCrypt.hashpw(password, BCrypt.gensalt());
        
        User user = new User();
        user.setUsername(username.trim());
        user.setPasswordHash(passwordHash);
        user.setFullName(fullName.trim());
        user.setRole(role != null ? role : "STAFF");
        
        UserDAO userDAO = new UserDAO();
        if (userDAO.createUser(user)) {
            response.sendRedirect(request.getContextPath() + "/users?message=User created successfully&messageType=success");
        } else {
            request.setAttribute("error", "Failed to create user. Username may already exist.");
            listUsers(request, response);
        }
    }
    
    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));
        String fullName = request.getParameter("fullName");
        String role = request.getParameter("role");
        String newPassword = request.getParameter("newPassword");
        
        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUserById(id);
        
        if (user == null) {
            request.setAttribute("error", "User not found");
            listUsers(request, response);
            return;
        }
        
        user.setFullName(fullName);
        user.setRole(role);
        
        // Update password only if provided
        if (newPassword != null && !newPassword.trim().isEmpty()) {
            user.setPasswordHash(BCrypt.hashpw(newPassword, BCrypt.gensalt()));
        }
        
        if (userDAO.updateUser(user)) {
            response.sendRedirect(request.getContextPath() + "/users?message=User updated successfully&messageType=success");
        } else {
            request.setAttribute("error", "Failed to update user");
            listUsers(request, response);
        }
    }
    
    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));
        
        // Cannot delete yourself
        HttpSession session = request.getSession(false);
        Integer currentUserId = (Integer) session.getAttribute("userId");
        if (currentUserId != null && currentUserId == id) {
            response.sendRedirect(request.getContextPath() + "/users?message=Cannot delete yourself&messageType=danger");
            return;
        }
        
        UserDAO userDAO = new UserDAO();
        if (userDAO.deleteUser(id)) {
            response.sendRedirect(request.getContextPath() + "/users?message=User deleted successfully&messageType=success");
        } else {
            response.sendRedirect(request.getContextPath() + "/users?message=Failed to delete user&messageType=danger");
        }
    }
}
