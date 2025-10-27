<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%-- Import all classes --%>
<%@ page import="com.quiz.model.User" %>
<%@ page import="com.quiz.dao.QuizDAO" %>
<%@ page import="com.quiz.dao.QuestionDAO" %>
<%@ page import="com.quiz.model.Quiz" %>
<%@ page import="com.quiz.model.Question" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%
    // --- ADMIN SECURITY CHECK ---
    User adminUser = (User) session.getAttribute("loggedInUser");
    if (adminUser == null || !adminUser.isAdmin()) {
        response.sendRedirect("login.jsp");
        return; 
    }
    
    // --- Get Data ---
    QuizDAO quizDAO = new QuizDAO();
    QuestionDAO questionDAO = new QuestionDAO();
    
    // 1. Get ALL quizzes for the dropdown
    List<Quiz> allQuizzes = quizDAO.getAllQuizzes();
    
    // 2. Check if a specific quiz is selected from the URL
    int selectedQuizId = 0;
    List<Question> questions = new ArrayList<>(); // Empty list by default
    
    String quizIdParam = request.getParameter("quizId");
    if (quizIdParam != null && !quizIdParam.isEmpty()) {
        try {
            selectedQuizId = Integer.parseInt(quizIdParam);
            // 3. If a quiz is selected, get its questions
            questions = questionDAO.getQuestionsForQuiz(selectedQuizId);
        } catch (NumberFormatException e) {
            // Handle bad ID
            System.out.println("Invalid quizId parameter.");
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Manage Questions</title>
<style>
    body { 
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif; 
        padding: 20px; 
        background-color: #f0f2f5; 
        color: #333;
    }
    .header { 
        font-size: 28px; 
        font-weight: 700;
        margin-bottom: 10px;
        color: #1a202c;
    }
    .back-link {
        display: inline-block;
        margin-bottom: 20px;
        color: #007bff;
        text-decoration: none;
        font-weight: 500;
    }
    .back-link:hover { text-decoration: underline; }
    
    /* Layout */
    .container {
        display: flex;
        flex-wrap: wrap;
        gap: 30px;
    }
    .questions-list-container { flex: 2; min-width: 400px; }
    .add-question-container { flex: 1; min-width: 300px; }
    
    /* Common Card Style */
    .card {
        background: #ffffff;
        border-radius: 8px;
        box-shadow: 0 4px 8px rgba(0,0,0,0.05);
        padding: 25px;
    }
    .card-header {
        font-size: 20px;
        font-weight: 600;
        margin-bottom: 20px;
        border-bottom: 1px solid #edf2f7;
        padding-bottom: 15px;
    }
    
    /* Quiz Selector Form */
    .form-group { margin-bottom: 15px; }
    .form-group label { display: block; margin-bottom: 8px; font-weight: 600; }
    .form-group select, .form-group input, .form-group textarea {
        width: 95%; 
        padding: 10px; 
        border: 1px solid #ccc; 
        border-radius: 5px;
        font-size: 15px;
    }
    .btn {
        padding: 10px 15px;
        border: none;
        border-radius: 5px;
        font-size: 16px;
        cursor: pointer;
        text-decoration: none;
        display: inline-block;
        text-align: center;
    }
    .btn-primary { background-color: #007bff; color: white; width: 100%; }
    .btn-primary:hover { background-color: #0056b3; }
    .btn-danger { background-color: #dc3545; color: white; font-size: 14px; padding: 6px 12px; }
    .btn-danger:hover { background-color: #c82333; }
    
    /* Question List */
    .question-item {
        padding: 15px;
        border-bottom: 1px solid #f0f2f5;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .question-item:last-child { border-bottom: none; }
    .question-text-list { font-weight: 500; }
    .correct-answer-list { font-size: 14px; color: #28a745; }
    
</style>
</head>
<body>

    <h1 class="header">Manage Questions</h1>
    <a href="admin_dashboard.jsp" class="back-link">&larr; Back to Admin Dashboard</a>

    <!-- 1. Quiz Selector -->
    <div class="card" style="margin-bottom: 30px;">
        <form action="manage_questions.jsp" method="get">
            <div class="form-group">
                <label for="quizId">Select a Quiz to Manage:</label>
                <select id="quizId" name="quizId" required onchange="this.form.submit()">
                    <option value="">-- Please Select a Quiz --</option>
                    <% for (Quiz quiz : allQuizzes) { 
                        // Keep the selected quiz chosen in the dropdown
                        String selected = (quiz.getQuizId() == selectedQuizId) ? "selected" : "";
                    %>
                        <option value="<%= quiz.getQuizId() %>" <%= selected %>>
                            <%= quiz.getTitle() %> (ID: <%= quiz.getQuizId() %>)
                        </option>
                    <% } %>
                </select>
            </div>
            <!-- We submit 'onchange' so this button is optional -->
            <!-- <input type="submit" value="Load Questions" class="btn btn-primary"> -->
        </form>
    </div>

    <%-- Only show the question manager if a quiz has been selected --%>
    <% if (selectedQuizId > 0) { %>
    
        <div class="container">
            
            <!-- 2. List of Existing Questions -->
            <div class="questions-list-container card">
                <div class="card-header">Existing Questions</div>
                
                <% if (questions.isEmpty()) { %>
                    <p>No questions found for this quiz. Add one using the form!</p>
                <% } else { %>
                    <% for (Question q : questions) { 
                        String correctAnswerText = "";
                        switch(q.getCorrectAnswer()) {
                            case 1: correctAnswerText = q.getOption1(); break;
                            case 2: correctAnswerText = q.getOption2(); break;
                            case 3: correctAnswerText = q.getOption3(); break;
                            case 4: correctAnswerText = q.getOption4(); break;
                        }
                    %>
                    <div class="question-item">
                        <div>
                            <div class="question-text-list"><%= q.getQuestionText() %></div>
                            <div class="correct-answer-list">Correct: <%= correctAnswerText %></div>
                        </div>
                        <a href="adminQuestion?action=delete&questionId=<%= q.getQuestionId() %>&quizId=<%= selectedQuizId %>" 
                           class="btn btn-danger"
                           onclick="return confirm('Are you sure you want to delete this question?');">
                           Delete
                        </a>
                    </div>
                    <% } %>
                <% } %>
            </div>
            
            <!-- 3. Add New Question Form -->
            <div class="add-question-container card">
                <div class="card-header">Add a New Question</div>
                
                <form action="adminQuestion" method="post">
                    <!-- Hidden fields to send to the servlet -->
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="quizId" value="<%= selectedQuizId %>">
                    
                    <div class="form-group">
                        <label for="questionText">Question Text:</label>
                        <textarea id="questionText" name="questionText" rows="3" required></textarea>
                    </div>
                    <div class="form-group">
                        <label for="option1">Option 1:</label>
                        <input type="text" id="option1" name="option1" required>
                    </div>
                    <div class="form-group">
                        <label for="option2">Option 2:</label>
                        <input type="text" id="option2" name="option2" required>
                    </div>
                    <div class="form-group">
                        <label for="option3">Option 3:</label>
                        <input type="text" id="option3" name="option3" required>
                    </div>
                    <div class="form-group">
                        <label for="option4">Option 4:</label>
                        <input type="text" id="option4" name="option4" required>
                    </div>
                    <div class="form-group">
                        <label for="correctAnswer">Correct Answer (1-4):</label>
                        <input type="number" id="correctAnswer" name="correctAnswer" min="1" max="4" required>
                    </div>
                    
                    <input type="submit" value="Add Question" class="btn btn-primary">
                </form>
            </div>
            
        </div>
    
    <% } // End of if(selectedQuizId > 0) %>

</body>
</html>

