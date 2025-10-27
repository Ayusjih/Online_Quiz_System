package com.quiz.servlet;
import java.util.Map;
import java.util.HashMap;
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
import com.quiz.util.QuizSessionManager;

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
        
        // --- Stop monitoring this session (user is submitting) ---
        QuizSessionManager.remove(session);
        
        User user = (User) session.getAttribute("loggedInUser");
        Quiz quiz = (Quiz) session.getAttribute("currentQuiz");
        List<Question> questions = (List<Question>) session.getAttribute("quizQuestions");

        if (user == null || quiz == null || questions == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int score = 0;
        // --- This Map will hold all our answers ---
        Map<Integer, Integer> userAnswersMap = new HashMap<>();

        // --- Grading Logic & Answer Gathering ---
        for (int i = 0; i < questions.size(); i++) {
            Question q = questions.get(i);
            int questionId = q.getQuestionId();
            int correctAnswer = q.getCorrectAnswer();
            
            String userAnswerParam = request.getParameter("answer_" + i);
            int userAnswer = 0; 
            
            if (userAnswerParam != null) {
                userAnswer = Integer.parseInt(userAnswerParam);
            }
            
            // Add the answer to our map (questionId -> userAnswer)
            userAnswersMap.put(questionId, userAnswer);

            if (userAnswer == correctAnswer) {
                score++;
            }
        }
        
        int totalQuestions = questions.size();
        int finalScore = (int) (((double) score / totalQuestions) * 100);

        // --- Save the Result AND the Answers ---
        Result result = new Result();
        result.setUserId(user.getUserId());
        result.setQuizId(quiz.getQuizId());
        result.setScore(finalScore);
        
        // Call our new, powerful DAO method
        resultDAO.saveResult(result, userAnswersMap); 

        // --- Clean Up Session ---
        session.removeAttribute("currentQuiz");
        session.removeAttribute("quizQuestions");
        // ... (keep all your other removeAttribute lines) ...

        // --- Redirect to Results Page ---
        session.setAttribute("finalScore", finalScore);
        session.setAttribute("totalQuestions", totalQuestions);
        session.setAttribute("correctAnswers", score);
        
        response.sendRedirect("result.jsp");
    }
}