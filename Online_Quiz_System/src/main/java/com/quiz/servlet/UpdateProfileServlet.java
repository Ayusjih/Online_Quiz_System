package com.quiz.servlet;

import java.io.IOException;

import com.quiz.dao.UserDAO;
import com.quiz.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/updateProfile")
public class UpdateProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private UserDAO userDAO;

    public void init() {
        userDAO = new UserDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false); // Don't create new session

        // --- Security Check ---
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 1. Get current user from session
        User currentUser = (User) session.getAttribute("loggedInUser");

        // 2. Get new data from the form
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // 3. Simple Validation
        if (password == null || password.isEmpty() || !password.equals(confirmPassword)) {
            // Passwords don't match or are empty
            request.setAttribute("errorMessage", "Passwords do not match or are empty.");
            request.getRequestDispatcher("edit_profile.jsp").forward(request, response);
            return;
        }
        
        // 4. Create an updated User object
        User updatedUser = new User();
        updatedUser.setUserId(currentUser.getUserId());
        updatedUser.setEmail(email);
        updatedUser.setPassword(password); // Save the new password
        
        // Also update non-changed fields, just in case
        updatedUser.setUsername(currentUser.getUsername());
        updatedUser.setAdmin(currentUser.isAdmin());
        updatedUser.setCreatedAt(currentUser.getCreatedAt());


        // 5. Save to database
        boolean success = userDAO.updateUser(updatedUser);

        if (success) {
            // 6. IMPORTANT: Update the user in the SESSION
            // If we don't do this, the sidebar will show old info
            session.setAttribute("loggedInUser", updatedUser);
            
            // Redirect back to dashboard
            if (updatedUser.isAdmin()) {
                response.sendRedirect("admin_dashboard.jsp");
            } else {
                response.sendRedirect("dashboard.jsp");
            }
        } else {
            // Handle database error
            request.setAttribute("errorMessage", "Error updating profile. Please try again.");
            request.getRequestDispatcher("edit_profile.jsp").forward(request, response);
        }
    }
}

