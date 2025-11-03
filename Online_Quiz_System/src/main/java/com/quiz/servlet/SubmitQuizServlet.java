package com.quiz.servlet;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import com.quiz.dao.ResultDAO;
import com.quiz.model.Question;
import com.quiz.model.Quiz;
import com.quiz.model.Result;
import com.quiz.model.User;
import com.quiz.util.QuizSessionManager;
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
        QuizSessionManager.remove(session); // Monitor se hatao
        
        User user = (User) session.getAttribute("loggedInUser");
        Quiz quiz = (Quiz) session.getAttribute("currentQuiz");
        List<Question> questions = (List<Question>) session.getAttribute("quizQuestions");

        if (user == null || quiz == null || questions == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int score = 0;
        // Map ab String values store karega
        Map<Integer, String> userAnswersMap = new HashMap<>();

        // --- Nayi Grading Logic ---
        for (int i = 0; i < questions.size(); i++) {
            Question q = questions.get(i);
            int questionId = q.getQuestionId();
            String correctAnswer = q.getCorrectAnswer();
            
            // User ka answer (chahe woh text ho ya radio value) hamesha String hoga
            String userAnswer = request.getParameter("answer_" + i);
            
            if (userAnswer == null) {
                userAnswer = ""; // Khali submit
            }

            // Map mein String answer save karo
            userAnswersMap.put(questionId, userAnswer);

            // Grading: Case-insensitive aur trim karke check karo
            // Taaki " 41 " aur "41" dono sahi maane jaayein
            if (userAnswer.trim().equalsIgnoreCase(correctAnswer.trim())) {
                score++;
            }
        }
        
        int totalQuestions = questions.size();
        int finalScore = (int) (((double) score / totalQuestions) * 100);

        // Result aur (String) Answers ko save karo
        Result result = new Result();
        result.setUserId(user.getUserId());
        result.setQuizId(quiz.getQuizId());
        result.setScore(finalScore);
        
        resultDAO.saveResult(result, userAnswersMap); 

        // Session cleanup (ismein koi change nahi)
        session.removeAttribute("currentQuiz");
        session.removeAttribute("quizQuestions");
        session.removeAttribute("startTime");
        session.removeAttribute("questionIndex");
        session.removeAttribute("userAnswers");
        session.removeAttribute("TIME_UP");

        session.setAttribute("finalScore", finalScore);
        session.setAttribute("totalQuestions", totalQuestions);
        session.setAttribute("correctAnswers", score);
        
        response.sendRedirect("result.jsp");
    }
}

