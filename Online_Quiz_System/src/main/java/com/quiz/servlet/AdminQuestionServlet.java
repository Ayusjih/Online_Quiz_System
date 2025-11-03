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

@WebServlet("/adminQuestion")
public class AdminQuestionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private QuestionDAO questionDAO;

    public void init() {
        questionDAO = new QuestionDAO();
    }

    // (doPost) - Naya form handle karne ke liye updated
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Security check
        if (!isAdmin(request, response)) {
            return;
        }

        // Common data for both question types
        int quizId = Integer.parseInt(request.getParameter("quizId"));
        String questionType = request.getParameter("questionType");
        String questionText = request.getParameter("questionText");
        String correctAnswer = request.getParameter("correctAnswer");
        
        Question newQuestion = new Question();
        newQuestion.setQuizId(quizId);
        newQuestion.setQuestionType(questionType);
        newQuestion.setQuestionText(questionText);
        newQuestion.setCorrectAnswer(correctAnswer.trim()); // Answer ko trim karna zaroori hai

        // Agar MCQ hai, toh options ko combine karo
        if ("MCQ".equals(questionType)) {
            String opt1 = request.getParameter("option1");
            String opt2 = request.getParameter("option2");
            String opt3 = request.getParameter("option3");
            String opt4 = request.getParameter("option4");
            
            // Hum options ko "|" (pipe) character se jod rahe hain
            String options = String.join("|", opt1, opt2, opt3, opt4);
            newQuestion.setOptions(options);
            
        } else {
            // "FIB" ke liye koi options nahi
            newQuestion.setOptions(null); 
        }
        
        // 4. Save to database
        questionDAO.addQuestion(newQuestion);
        
        // 5. User ko usi quiz ke page par vaapas bhejo
        response.sendRedirect("manage_questions.jsp?quizId=" + quizId);
    }

    // (doGet) - Ismein koi change nahi hai
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Security check
        if (!isAdmin(request, response)) {
            return;
        }
        
        // Get parameters
        int questionId = Integer.parseInt(request.getParameter("questionId"));
        // quizId ko vaapas redirect URL mein daalna zaroori hai
        int quizId = Integer.parseInt(request.getParameter("quizId")); 
        
        // Delete the question
        questionDAO.deleteQuestion(questionId);
        
        // Redirect back to the same quiz management page
        response.sendRedirect("manage_questions.jsp?quizId=" + quizId);
    }

    /**
     * Private helper method for security check
     */
    private boolean isAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("login.jsp");
            return false;
        }
        
        User adminUser = (User) session.getAttribute("loggedInUser");
        if (adminUser == null || !adminUser.isAdmin()) {
            // Agar user logged in nahi hai, ya admin nahi hai, toh login par bhejo
            response.sendRedirect("login.jsp");
            return false;
        }
        
        // User admin hai
        return true;
    }
}

