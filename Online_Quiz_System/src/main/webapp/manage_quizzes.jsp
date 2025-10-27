<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%-- Import all the classes we need --%>
<%@ page import="com.quiz.model.User" %>
<%@ page import="com.quiz.dao.QuizDAO" %>
<%@ page import="com.quiz.model.Quiz" %>
<%@ page import="java.util.List" %>

<%
    // --- ADMIN SECURITY CHECK ---
    // This MUST be on every admin page.
    User adminUser = (User) session.getAttribute("loggedInUser");
    if (adminUser == null || !adminUser.isAdmin()) {
        response.sendRedirect("login.jsp");
        return; 
    }
    
    // --- Get Data ---
    // Use the same DAO method as the student dashboard
    QuizDAO quizDAO = new QuizDAO();
    List<Quiz> quizzes = quizDAO.getAllQuizzes();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manage Quizzes</title>
<style>
    body { font-family: Arial, sans-serif; padding: 20px; background-color: #f0f2f5; }
    .header { font-size: 24px; font-weight: bold; margin-bottom: 20px; }
    .container { display: flex; gap: 30px; }
    .quiz-list-container { flex: 2; }
    .add-quiz-container { flex: 1; }
    
    /* Quiz List Styles */
    .quiz-list { list-style: none; padding: 0; }
    .quiz-item { background: #fff; border: 1px solid #ddd; border-radius: 8px; 
                  padding: 15px; margin-bottom: 10px; display: flex; 
                  justify-content: space-between; align-items: center; }
    .quiz-title { font-size: 18px; font-weight: bold; }
    .delete-btn { background-color: #dc3545; color: white; padding: 8px 12px; 
                   text-decoration: none; border-radius: 5px; font-size: 14px; }
    .delete-btn:hover { background-color: #c82333; }
    
    /* Add Form Styles */
    .add-form { background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
    .form-group { margin-bottom: 15px; }
    .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
    .form-group input[type="text"], .form-group input[type="number"] {
        width: 95%; padding: 8px; border: 1px solid #ccc; border-radius: 4px;
    }
    .submit-btn { width: 100%; padding: 10px; background-color: #007bff; color: white;
                  border: none; border-radius: 4px; font-size: 16px; cursor: pointer; }
    .submit-btn:hover { background-color: #0056b3; }
</style>
</head>
<body>

    <div class="header">Manage Quizzes</div>
    <p><a href="admin_dashboard.jsp">&larr; Back to Admin Dashboard</a></p>
    
    <div class="container">
        
        <!-- Left Side: List of Quizzes -->
        <div class="quiz-list-container">
            <h3>Existing Quizzes</h3>
            <ul class="quiz-list">
                <% for (Quiz quiz : quizzes) { %>
                    <li class="quiz-item">
                        <div>
                            <div class="quiz-title"><%= quiz.getTitle() %></div>
                            (ID: <%= quiz.getQuizId() %>, Duration: <%= quiz.getDurationMinutes() %> min)
                        </div>
                        
                        <!-- This link goes to our new AdminQuizServlet -->
                        <a href="adminQuiz?action=delete&quizId=<%= quiz.getQuizId() %>" 
                           class="delete-btn" 
                           onclick="return confirm('Are you sure you want to delete this quiz AND all its questions?');">
                           Delete
                        </a>
                    </li>
                <% } %>
                <% if (quizzes.isEmpty()) { %>
                    <p>No quizzes found.</p>
                <% } %>
            </ul>
        </div>
        
        <!-- Right Side: Add New Quiz Form -->
        <div class="add-quiz-container">
            <h3>Add a New Quiz</h3>
            <!-- This form also goes to our new AdminQuizServlet -->
            <form action="adminQuiz" method="post" class="add-form">
                <!-- We use a hidden input to tell the servlet what action to perform -->
                <input type="hidden" name="action" value="add">
                
                <div class="form-group">
                    <label for="title">Quiz Title:</label>
                    <input type="text" id="title" name="title" required>
                </div>
                <div class="form-group">
                    <label for="duration">Duration (in minutes):</label>
                    <input type="number" id="duration" name="duration" min="1" required>
                </div>
                <input type="submit" value="Add Quiz" class="submit-btn">
            </form>
        </div>
        
    </div>

</body>
</html>