package com.quiz.servlet;
import com.quiz.util.QuizSessionManager;
import java.io.IOException;
import java.util.Collections;
import java.util.List;

import com.quiz.dao.QuestionDAO;
import com.quiz.dao.QuizDAO;
import com.quiz.model.Question;
import com.quiz.model.Quiz;
import com.quiz.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/startQuiz")
public class StartQuizServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private QuizDAO quizDAO;
    private QuestionDAO questionDAO;

    public void init() {
        quizDAO = new QuizDAO();
        questionDAO = new QuestionDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedInUser");

        // --- Security Check ---
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // 1. Get the quizId from the URL
            int quizId = Integer.parseInt(request.getParameter("quizId"));

            // 2. Fetch the quiz and its questions
            Quiz quiz = quizDAO.getQuizById(quizId);
            List<Question> questions = questionDAO.getQuestionsForQuiz(quizId);
            
            Collections.shuffle(questions);

            // 3. Set up the quiz in the user's session
            session.setAttribute("currentQuiz", quiz);
            session.setAttribute("quizQuestions", questions);
            session.setAttribute("questionIndex", 0); 
            session.setAttribute("userAnswers", new int[questions.size()]);
            session.setAttribute("startTime", System.currentTimeMillis()); 

            // 4. --- THIS IS THE FIX ---
            // Add to the monitor *before* you redirect
            QuizSessionManager.add(session);
            
            // 5. Redirect ONCE to the quiz page
            response.sendRedirect("quiz.jsp");

        } catch (NumberFormatException e) {
            // Handle cases where quizId is not a number
            response.sendRedirect("dashboard.jsp");
        }
        
        // --- DO NOT PUT ANY CODE HERE ---
    }
}