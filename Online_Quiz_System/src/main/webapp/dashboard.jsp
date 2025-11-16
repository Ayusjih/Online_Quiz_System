<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%-- Import all the classes we need --%>
<%@ page import="com.quiz.model.User" %>
<%@ page import="com.quiz.dao.QuizDAO" %>
<%@ page import="com.quiz.model.Quiz" %>
<%@ page import="java.util.List" %>

<%
    // --- Security Check ---
    // Har page par yeh check zaroori hai
    User user = (User) session.getAttribute("loggedInUser");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return; 
    }
    
    // Agar admin galti se student dashboard par aa jaaye, toh usse admin page par bhej do
    if (user.isAdmin()) {
        response.sendRedirect("admin_dashboard.jsp");
        return;
    }
    
    // --- Get Data ---
    QuizDAO quizDAO = new QuizDAO();
    List<Quiz> quizzes = quizDAO.getAllQuizzes();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Dashboard</title>
<!-- 
    Saara common CSS (Header, Sidebar, Dark Mode) navbar.jsp se aa raha hai
-->
<style>
    /* --- Sirf is page ke specific styles --- */
    .dashboard-container {
        max-width: 900px;
        margin: 20px auto;
        padding: 0 20px;
    }
    
    .welcome-text {
        font-size: 24px;
        font-weight: 600;
        margin-bottom: 25px;
        color: var(--text-color);
    }
    
    .quiz-card {
        background: var(--card-bg-color);
        border: 1px solid var(--border-color);
        border-radius: 12px;
        box-shadow: var(--shadow);
        padding: 20px 25px;
        margin-bottom: 20px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        transition: all 0.2s ease-in-out;
    }
    .quiz-card:hover {
        transform: translateY(-4px);
        box-shadow: var(--shadow-hover);
    }
    
    .quiz-info {
        display: flex;
        align-items: center;
        gap: 20px;
    }
    
    .quiz-icon {
        width: 40px;
        height: 40px;
        color: #007bff;
    }
    
    .quiz-title {
        font-size: 20px;
        font-weight: 600;
        color: var(--text-color);
        margin: 0 0 5px 0;
    }
    
    .quiz-details {
        font-size: 14px;
        color: var(--text-color-light);
    }
    
    .start-button {
        background-color: #28a745;
        color: white;
        padding: 12px 20px;
        text-decoration: none;
        border-radius: 8px;
        font-weight: 600;
        font-size: 15px;
        transition: background-color 0.2s ease;
    }
    
    .start-button:hover {
        background-color: #218838;
    }

</style>
</head>

<!-- Body ko 'page-container' class di hai taaki padding sahi rahe -->
<body class="page-container">

    <!-- 
    =====================================================================
        Reusable Navbar ko yahaan include kiya ja raha hai
        (The Reusable Navbar is being included here)
    =====================================================================
    -->
    <jsp:include page="navbar.jsp" />
    
    
    <!-- 
    =====================================================================
        Sirf is Page ka Content
        (Only this Page's Content)
    =====================================================================
    -->
    <div class="dashboard-container">
    
        <p class="welcome-text">Welcome, <%= user.getUsername() %>. Choose a quiz to get started.</p>
        
        <div class="quiz-list">
        
            <% for (Quiz quiz : quizzes) { %>
                <div class="quiz-card">
                    <div class="quiz-info">
                        <!-- Icon -->
                        <svg class="quiz-icon" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13.5M8.571 8.007l6.857 3.9-6.857 3.9V8.007z" />
                        </svg>
                        
                        <!-- Details -->
                        <div>
                            <h3 class="quiz-title"><%= quiz.getTitle() %></h3>
                            <span class="quiz-details">Duration: <%= quiz.getDurationMinutes() %> minutes</span>
                        </div>
                    </div>
                    
                    <!-- Button -->
                    <a href="startQuiz?quizId=<%= quiz.getQuizId() %>" class="start-button">
                        Start Quiz
                    </a>
                </div>
            <% } // End of loop %>
            
            <% if (quizzes.isEmpty()) { %>
                <p>No quizzes are available right now. Please check back later.</p>
            <% } %>
            
        </div>
    </div>

</body>
</html>