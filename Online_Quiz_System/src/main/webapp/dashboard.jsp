<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%-- Import all the classes we need --%>
<%@ page import="com.quiz.model.User" %>
<%@ page import="com.quiz.dao.QuizDAO" %>
<%@ page import="com.quiz.model.Quiz" %>
<%@ page import="java.util.List" %>

<%
    // --- Security Check ---
    User user = (User) session.getAttribute("loggedInUser");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return; 
    }
    
    // --- Get Data ---
    // 1. Create the DAO
    QuizDAO quizDAO = new QuizDAO();
    // 2. Call the method to get all quizzes
    List<Quiz> quizzes = quizDAO.getAllQuizzes();
    
    // 'quizzes' is now a List object, ready to be used below
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Dashboard</title>
<style>
    body { font-family: Arial, sans-serif; padding: 20px; background-color: #f9f9f9; }
    .welcome { font-size: 24px; margin-bottom: 20px; }
    .quiz-list { list-style: none; padding: 0; }
    .quiz-item { background: #fff; border: 1px solid #ddd; border-radius: 8px; 
                  padding: 15px; margin-bottom: 10px; display: flex; 
                  justify-content: space-between; align-items: center; }
    .quiz-title { font-size: 18px; font-weight: bold; }
    .quiz-details { font-size: 14px; color: #555; }
    .start-button { background-color: #28a745; color: white; padding: 10px 15px; 
                    text-decoration: none; border-radius: 5px; }
    .start-button:hover { background-color: #218838; }
</style>
</head>
<body>

    <div class="welcome">
        Welcome, <%= user.getUsername() %>!
    </div>
    
    <h2>Available Quizzes</h2>
    
    <ul class="quiz-list">
    
        <%-- Use a JSP loop to iterate over our quiz List --%>
        <% for (Quiz quiz : quizzes) { %>
        
            <li class="quiz-item">
                <div>
                    <div class="quiz-title"><%= quiz.getTitle() %></div>
                    <div class="quiz-details">Duration: <%= quiz.getDurationMinutes() %> minutes</div>
                </div>
                
                <%-- This link will go to our StartQuizServlet (we'll build it next) --%>
                <a href="startQuiz?quizId=<%= quiz.getQuizId() %>" class="start-button">
                    Start Quiz
                </a>
            </li>
    
        <% } // End of the loop %>
        
        <%-- Add a message if no quizzes are found --%>
        <% if (quizzes.isEmpty()) { %>
            <p>No quizzes are available at this time.</p>
        <% } %>
        
    </ul>

</body>
</html>