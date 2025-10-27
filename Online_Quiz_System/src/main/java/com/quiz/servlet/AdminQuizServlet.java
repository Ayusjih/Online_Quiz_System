package com.quiz.servlet;

import java.io.IOException;
import com.quiz.dao.QuizDAO;
import com.quiz.model.Quiz;
import com.quiz.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/adminQuiz")
public class AdminQuizServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private QuizDAO quizDAO;

    public void init() {
        quizDAO = new QuizDAO();
    }

    // This method handles the "Add Quiz" form submission
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // First, run the security check
        if (!isAdmin(request, response)) {
            return;
        }

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            try {
                String title = request.getParameter("title");
                int duration = Integer.parseInt(request.getParameter("duration"));
                
                Quiz newQuiz = new Quiz();
                newQuiz.setTitle(title);
                newQuiz.setDurationMinutes(duration);
                
                quizDAO.addQuiz(newQuiz);
                
            } catch (NumberFormatException e) {
                // Handle bad number input
                System.out.println("Invalid duration format: " + e.getMessage());
            }
        }
        
        // After adding, always redirect back to the manage page to see the new list
        response.sendRedirect("manage_quizzes.jsp");
    }

    // This method handles the "Delete Quiz" link clicks
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // First, run the security check
        if (!isAdmin(request, response)) {
            return;
        }

        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            try {
                int quizId = Integer.parseInt(request.getParameter("quizId"));
                quizDAO.deleteQuiz(quizId);
                
            } catch (NumberFormatException e) {
                // Handle bad ID input
                System.out.println("Invalid quizId format: " + e.getMessage());
            }
        }
        
        // After deleting, always redirect back to the manage page
        response.sendRedirect("manage_quizzes.jsp");
    }

    /**
     * A private helper method to check for admin status.
     * This prevents code duplication and secures our servlet.
     */
    private boolean isAdmin(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        HttpSession session = request.getSession(false); // false = don't create new session
        
        if (session == null) {
            response.sendRedirect("login.jsp");
            return false;
        }
        
        User adminUser = (User) session.getAttribute("loggedInUser");
        
        if (adminUser == null || !adminUser.isAdmin()) {
            response.sendRedirect("login.jsp");
            return false;
        }
        
        // If we get here, the user is a valid admin
        return true;
    }
}