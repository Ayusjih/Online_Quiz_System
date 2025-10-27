package com.quiz.servlet;

import java.io.IOException;

import com.quiz.dao.QuestionDAO;
import com.quiz.model.Question;
import com.quiz.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet to handle admin actions for managing questions (Add, Delete).
 */
@WebServlet("/adminQuestion")
public class AdminQuestionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private QuestionDAO questionDAO;

    public void init() {
        questionDAO = new QuestionDAO();
    }

    /**
     * Handles the "Add Question" form submission (POST request).
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Check if user is an admin
        if (!isAdmin(request, response)) {
            return; // Security check failed, redirect already handled
        }

        // This is the quizId we need to redirect back to
        String quizId = request.getParameter("quizId");
        
        try {
            // 2. Get all form data
            String questionText = request.getParameter("questionText");
            String option1 = request.getParameter("option1");
            String option2 = request.getParameter("option2");
            String option3 = request.getParameter("option3");
            String option4 = request.getParameter("option4");
            int correctAnswer = Integer.parseInt(request.getParameter("correctAnswer"));
            int quizIdInt = Integer.parseInt(quizId);

            // 3. Create a new Question object
            Question newQuestion = new Question();
            newQuestion.setQuizId(quizIdInt);
            newQuestion.setQuestionText(questionText);
            newQuestion.setOption1(option1);
            newQuestion.setOption2(option2);
            newQuestion.setOption3(option3);
            newQuestion.setOption4(option4);
            newQuestion.setCorrectAnswer(correctAnswer);

            // 4. Save to database
            questionDAO.addQuestion(newQuestion);

        } catch (NumberFormatException e) {
            System.out.println("Error parsing number in AdminQuestionServlet: " + e.getMessage());
            e.printStackTrace();
        }
        
        // 5. Redirect back to the same page to show the new question
        response.sendRedirect("manage_questions.jsp?quizId=" + quizId);
    }

    /**
     * Handles the "Delete Question" link click (GET request).
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Check if user is an admin
        if (!isAdmin(request, response)) {
            return; 
        }

        // This is the quizId we need to redirect back to
        String quizId = request.getParameter("quizId");
        
        try {
            // 2. Get the questionId to delete
            int questionId = Integer.parseInt(request.getParameter("questionId"));
            
            // 3. Delete from database
            questionDAO.deleteQuestion(questionId);
            
        } catch (NumberFormatException e) {
            System.out.println("Error parsing number in AdminQuestionServlet: " + e.getMessage());
            e.printStackTrace();
        }
        
        // 4. Redirect back to the same page to show the updated list
        response.sendRedirect("manage_questions.jsp?quizId=" + quizId);
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

