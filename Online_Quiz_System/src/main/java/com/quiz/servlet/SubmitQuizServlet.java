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
        
        // User submit kar raha hai, toh monitoring se hata do
        QuizSessionManager.remove(session);
        
        User user = (User) session.getAttribute("loggedInUser");
        Quiz quiz = (Quiz) session.getAttribute("currentQuiz");
        List<Question> questions = (List<Question>) session.getAttribute("quizQuestions");

        // Security check
        if (user == null || quiz == null || questions == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int score = 0;
        // Hum naye Map<Integer, String> ka istemaal karenge
        Map<Integer, String> userAnswersMap = new HashMap<>();

        // Loop through all questions to grade them
        for (int i = 0; i < questions.size(); i++) {
            Question q = questions.get(i);
            int questionId = q.getQuestionId();
            String correctAnswer = q.getCorrectAnswer(); // DB se (MCQ: "1", FIB: "Ayush")
            
            // Form se answer (MCQ: "1", FIB: "ayush")
            String userAnswer = request.getParameter("answer_" + i); 
            
            if (userAnswer == null || userAnswer.isEmpty()) {
                userAnswer = "[Not Answered]"; // Agar user ne blank submit kiya
            }

            // Answer ko review ke liye save karein
            userAnswersMap.put(questionId, userAnswer);

            // --- YEH HAI NAYA HYBRID GRADING LOGIC ---
            if ("MCQ".equals(q.getQuestionType())) {
                // MCQ: Option value (e.g., "1") ko correct answer (e.g., "1") se match karein
                if (userAnswer.equals(correctAnswer)) {
                    score++;
                }
            } else {
                // FIB: User ke text ko correct answer text se (case-insensitive) match karein
                if (userAnswer.trim().equalsIgnoreCase(correctAnswer.trim())) {
                    score++;
                }
            }
        }
        
        // Calculate final score percentage
        int totalQuestions = questions.size();
        int finalScore = (int) (((double) score / totalQuestions) * 100);

        // Naya Result object banayein
        Result result = new Result();
        result.setUserId(user.getUserId());
        result.setQuizId(quiz.getQuizId());
        result.setScore(finalScore);
        
        // Result aur saare answers database mein save karein
        resultDAO.saveResult(result, userAnswersMap); 

        // Quiz session ko clear karein
        session.removeAttribute("currentQuiz");
        session.removeAttribute("quizQuestions");
        session.removeAttribute("startTime");
        session.removeAttribute("questionIndex");
        session.removeAttribute("userAnswers");
        session.removeAttribute("TIME_UP"); // Server-side timer flag bhi clear karein

        // Result page par score bhejein
        session.setAttribute("finalScore", finalScore);
        session.setAttribute("totalQuestions", totalQuestions);
        session.setAttribute("correctAnswers", score);
        
        // Result page par redirect karein
        response.sendRedirect("result.jsp");
    }
}

