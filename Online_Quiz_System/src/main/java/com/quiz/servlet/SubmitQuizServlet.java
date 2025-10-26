package com.quiz.servlet;

import java.io.IOException;
import java.util.List;

import com.quiz.dao.ResultDAO;
import com.quiz.model.Question;
import com.quiz.model.Quiz;
import com.quiz.model.Result;
import com.quiz.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/submitQuiz")
public class SubmitQuizServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ResultDAO resultDAO;

    public void init() {
        resultDAO = new ResultDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedInUser");
        Quiz quiz = (Quiz) session.getAttribute("currentQuiz");
        List<Question> questions = (List<Question>) session.getAttribute("quizQuestions");

        // --- Security Check ---
        // If user is not logged in or quiz is not in session, kick them out.
        if (user == null || quiz == null || questions == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int score = 0; // Initialize score

        // --- Grading Logic ---
        for (int i = 0; i < questions.size(); i++) {
            // Get the correct answer from our session list
            int correctAnswer = questions.get(i).getCorrectAnswer(); 
            
            // Get the user's submitted answer from the form
            // The name of the form input was "answer_i"
            String userAnswerParam = request.getParameter("answer_" + i);
            
            int userAnswer = 0; // Default to 0 (wrong) if not answered
            if (userAnswerParam != null) {
                userAnswer = Integer.parseInt(userAnswerParam);
            }

            // Compare and update score
            if (userAnswer == correctAnswer) {
                score++;
            }
        }
        
        // Calculate final percentage score
        int totalQuestions = questions.size();
        int finalScore = (int) (((double) score / totalQuestions) * 100);

        // --- Save the Result ---
        Result result = new Result();
        result.setUserId(user.getUserId());
        result.setQuizId(quiz.getQuizId());
        result.setScore(finalScore);
        
        resultDAO.saveResult(result); // Save to database

        // --- Clean Up Session ---
        // We are done with the quiz, so remove its data from the session
        session.removeAttribute("currentQuiz");
        session.removeAttribute("quizQuestions");
        session.removeAttribute("startTime");
        session.removeAttribute("questionIndex");
        session.removeAttribute("userAnswers");

        // --- Redirect to Results Page ---
        // Pass the score and total to the result.jsp page
        session.setAttribute("finalScore", finalScore);
        session.setAttribute("totalQuestions", totalQuestions);
        session.setAttribute("correctAnswers", score);
        
        response.sendRedirect("result.jsp"); // We'll create this file next
    }
}