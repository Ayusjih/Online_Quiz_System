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

/**
 * Servlet that handles user login.
 */
@WebServlet("/login") // This annotation maps this servlet to the /login URL
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private UserDAO userDAO;

    // This is called once when the servlet is first loaded
    public void init() {
        userDAO = new UserDAO(); // Create one DAO instance for this servlet
    }

    /**
     * This method handles the POST request from the login.jsp form.
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Get the data from the HTML form
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // 2. Call the DAO to validate the user
        User user = userDAO.validateUser(username, password);

        // 3. Check if the login was successful
        if (user != null) {
            // --- SUCCESS ---
            HttpSession session = request.getSession();
            session.setAttribute("loggedInUser", user);

            // --- NEW: Admin vs. Student Check ---
            if (user.isAdmin()) {
                // It's an admin! Send to admin dashboard.
                response.sendRedirect("admin_dashboard.jsp");
            } else {
                // It's a regular student. Send to student dashboard.
                response.sendRedirect("dashboard.jsp");
            }

        } else {   // --- FAILURE ---
            
            // 3d. Set an error message
            request.setAttribute("errorMessage", "Invalid username or password. Please try again.");
            
            // 3e. Forward the user back to the login page to show the error
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    /**
     * This method handles GET requests (e.g., if someone just types /login in the URL)
     * We'll just redirect them to the login page.
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.sendRedirect("login.jsp");
    }
}