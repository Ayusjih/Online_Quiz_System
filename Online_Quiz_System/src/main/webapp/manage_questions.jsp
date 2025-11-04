<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="com.quiz.model.User" %>
<%@ page import="com.quiz.dao.QuizDAO" %>
<%@ page import="com.quiz.dao.QuestionDAO" %>
<%@ page import="com.quiz.model.Quiz" %>
<%@ page import="com.quiz.model.Question" %>
<%@ page import="java.util.List" %>

<%
    // --- ADMIN SECURITY CHECK ---
    User adminUser = (User) session.getAttribute("loggedInUser");
    if (adminUser == null || !adminUser.isAdmin()) {
        response.sendRedirect("login.jsp");
        return; 
    }
    
    // --- Get Data ---
    QuizDAO quizDAO = new QuizDAO();
    List<Quiz> allQuizzes = quizDAO.getAllQuizzes();
    
    // Check if a quiz is selected
    String selectedQuizIdParam = request.getParameter("quizId");
    List<Question> questions = null;
    int selectedQuizId = 0;
    
    if (selectedQuizIdParam != null && !selectedQuizIdParam.isEmpty()) {
        try {
            selectedQuizId = Integer.parseInt(selectedQuizIdParam);
            QuestionDAO questionDAO = new QuestionDAO();
            questions = questionDAO.getQuestionsForQuiz(selectedQuizId);
        } catch (NumberFormatException e) {
            // Handle invalid ID
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
    body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif; padding: 20px; background-color: #f0f2f5; color: #333; }
    .header { font-size: 28px; font-weight: 700; margin-bottom: 10px; color: #1a202c; }
    .back-link { display: inline-block; margin-bottom: 20px; color: #007bff; text-decoration: none; font-weight: 500; }
    .back-link:hover { text-decoration: underline; }
    .container { display: flex; flex-wrap: wrap; gap: 30px; }
    .card { background: #ffffff; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.05); border: 1px solid #e2e8f0; }
    .card-header { padding: 15px 20px; border-bottom: 1px solid #edf2f7; font-size: 20px; font-weight: 600; }
    .card-body { padding: 20px; }
    .quiz-selector-card { flex: 1 1 100%; }
    .selector-form { display: flex; gap: 10px; align-items: center; }
    .selector-form label { font-weight: 500; }
    .selector-form select, .selector-form button {
        padding: 10px;
        border-radius: 5px;
        border: 1px solid #ccc;
        font-size: 16px;
    }
    .selector-form button { background-color: #007bff; color: white; cursor: pointer; border-color: #007bff; }
    .selector-form button:hover { background-color: #0056b3; }
    .questions-list-container { flex: 2; min-width: 400px; }
    .question-item { border: 1px solid #eee; border-radius: 5px; padding: 15px; margin-bottom: 15px; display: flex; justify-content: space-between; align-items: flex-start; }
    .question-text-list { font-weight: 500; margin-bottom: 10px; }
    .question-details-list { font-size: 14px; color: #555; }
    .question-details-list strong { color: #333; }
    .question-actions { display: flex; flex-direction: column; gap: 5px; }
    .delete-btn { background-color: #dc3545; color: white; padding: 5px 10px; text-decoration: none; border-radius: 5px; font-size: 14px; text-align: center; }
    .delete-btn:hover { background-color: #c82333; }
    .question-options-list { list-style: none; padding-left: 20px; margin: 10px 0; font-size: 14px; }
    .question-options-list li { padding: 2px 0; }
    .add-question-container { flex: 1; min-width: 300px; align-self: flex-start; }
    .form-group { margin-bottom: 15px; }
    .form-group label { display: block; margin-bottom: 5px; font-weight: 500; }
    .form-group input[type="text"], .form-group textarea, .form-group select {
        width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box;
    }
    .form-group textarea { resize: vertical; min-height: 80px; }
    .submit-btn { width: 100%; padding: 10px; background-color: #28a745; color: white; border: none; border-radius: 5px; font-size: 16px; cursor: pointer; }
    .submit-btn:hover { background-color: #218838; }
</style>
</head>
<body>

    <h1 class="header">Manage Questions</h1>
    <a href="admin_dashboard.jsp" class="back-link">&larr; Back to Admin Dashboard</a>

    <div class="container">
    
        <div class="quiz-selector-card card">
            <div class="card-header">Select a Quiz to Manage</div>
            <div class="card-body">
                <form action="manage_questions.jsp" method="get" class="selector-form">
                    <label for="quizId">Quiz:</label>
                    <select id="quizId" name="quizId">
                        <option value="">-- Select a Quiz --</option>
                        <% for (Quiz quiz : allQuizzes) { %>
                            <option value="<%= quiz.getQuizId() %>" <%= (selectedQuizId == quiz.getQuizId()) ? "selected" : "" %>>
                                <%= quiz.getTitle() %>
                            </option>
                        <% } %>
                    </select>
                    <button type="submit">Load Questions</button>
                </form>
            </div>
        </div>

        <% if (questions != null) { %>
            <div class="questions-list-container card">
                <div class="card-header">Existing Questions</div>
                <div class="card-body">
                <% if (questions.isEmpty()) { %>
                    <p>No questions found for this quiz. Add one using the form!</p>
                <% } else { %>
                    <% for (Question q : questions) { %>
                        <div class="question-item">
                            <div>
                                <div class="question-text-list">
                                    [<%= q.getQuestionType() %>] <%= q.getQuestionText() %>
                                </div>
                                
                                <% if ("MCQ".equals(q.getQuestionType())) { %>
                                    <ul class="question-options-list">
                                    <% 
                                        int optNum = 1;
                                        for(String option : q.getOptionsList()) {
                                    %>
                                        <li><%= optNum++ %>. <%= option %></li>
                                    <% } %>
                                    </ul>
                                <% } %>
                                
                                <div class="question-details-list">
                                    <strong>Correct Answer:</strong> <%= q.getCorrectAnswer() %>
                                </div>
                            </div>
                            <div class="question-actions">
                                <a href="adminQuestion?action=delete&questionId=<%= q.getQuestionId() %>&quizId=<%= selectedQuizId %>" 
                                   class="delete-btn" 
                                   onclick="return confirm('Are you sure you want to delete this question?');">
                                   Delete
                                </a>
                            </div>
                        </div>
                    <% } %>
                <% } %>
                </div>
            </div>

            <div class="add-question-container card">
                <div class="card-header">Add a New Question</div>
                <div class="card-body">
                    <form action="adminQuestion" method="post" onsubmit="return validateForm()">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="quizId" value="<%= selectedQuizId %>">
                        
                        <div class="form-group">
                            <label for="questionType">Question Type:</label>
                            <select id="questionType" name="questionType" onchange="toggleMCQFields()">
                                <option value="MCQ">Multiple Choice (MCQ)</option>
                                <option value="FIB">Fill in the Blank (FIB)</option>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="questionText">Question Text:</label>
                            <textarea id="questionText" name="questionText" required></textarea>
                        </div>
                        
                        <div id="mcqOptions">
                            <div class="form-group">
                                <label for="option1">Option 1:</label>
                                <input type="text" id="option1" name="option1">
                            </div>
                            <div class="form-group">
                                <label for="option2">Option 2:</label>
                                <input type="text" id="option2" name="option2">
                            </div>
                            <div class="form-group">
                                <label for="option3">Option 3:</label>
                                <input type="text" id="option3" name="option3">
                            </div>
                            <div class="form-group">
                                <label for="option4">Option 4:</label>
                                <input type="text" id="option4" name="option4">
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="correctAnswer">Correct Answer:</label>
                            <input type="text" id="correctAnswer" name="correctAnswer" required
                                   placeholder="For MCQ, enter option number (1-4). For FIB, enter exact answer.">
                        </div>
                        
                        <input type="submit" value="Add Question" class="submit-btn">
                    </form>
                </div>
            </div>
            
        <% } %>
    </div>

    <script>
        function toggleMCQFields() {
            var type = document.getElementById('questionType').value;
            var mcqDiv = document.getElementById('mcqOptions');
            var answerInput = document.getElementById('correctAnswer');
            
            if (type === 'MCQ') {
                mcqDiv.style.display = 'block';
                answerInput.placeholder = 'Enter option number (1-4)';
            } else {
                mcqDiv.style.display = 'none';
                answerInput.placeholder = 'Enter exact answer (e.g., "Ayush")';
            }
        }
        
        document.addEventListener('DOMContentLoaded', toggleMCQFields);
        
        function validateForm() {
            var type = document.getElementById('questionType').value;
            if (type === 'MCQ') {
                if (document.getElementById('option1').value === '' || 
                    document.getElementById('option2').value === '' || 
                    document.getElementById('option3').value === '' || 
                    document.getElementById('option4').value === '') {
                    
                    alert('Please fill in all 4 options for an MCQ question.');
                    return false;
                }
                
                var correct = document.getElementById('correctAnswer').value;
                if (!['1', '2', '3', '4'].includes(correct)) {
                    alert('For MCQ, Correct Answer must be a number: 1, 2, 3, or 4.');
                    return false;
                }
            }
            return true;
        }
    </script>
</body>
</html>

