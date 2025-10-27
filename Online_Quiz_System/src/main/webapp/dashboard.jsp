<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%-- Import all the classes we need --%>
<%@ page import="com.quiz.model.User" %>
<%@ page import="com.quiz.dao.QuizDAO" %>
<%@ page import="com.quiz.model.Quiz" %>
<%@ page import="java.util.List" %>

<%
    // --- Security Check 1: Is user logged in? ---
    User user = (User) session.getAttribute("loggedInUser");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return; 
    }
    
    // --- Security Check 2: Is user an admin? ---
    // If they are, send them to their own dashboard.
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
<style>
    body { 
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif; 
        padding: 0;
        margin: 0;
        background-color: #f0f2f5; 
        color: #1a2c3d;
    }
    
    /* --- PROFESSIONAL HEADER BAR --- */
    .header-bar {
        background-color: #ffffff;
        padding: 12px 30px;
        box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-bottom: 1px solid #e2e8f0;
    }
    .header-title { 
        font-size: 22px; 
        font-weight: 700;
        color: #1a2c3d;
        margin: 0;
    }
    
    /* Profile Area styling */
    .profile-area {
        display: flex;
        align-items: center;
        gap: 15px; /* Space between items */
    }
    .profile-info {
        display: flex;
        align-items: center;
        gap: 8px;
    }
    .profile-icon {
        width: 32px;
        height: 32px;
        border-radius: 50%;
        background-color: #e0e7ff;
        color: #4338ca;
        padding: 5px;
        box-sizing: border-box; 
    }
    .profile-name {
        font-size: 14px;
        font-weight: 500;
        color: #4a5568;
    }
    
    .logout-btn {
        background-color: #f8fafc;
        color: #dc3545;
        border: 1px solid #dc3545;
        padding: 8px 12px;
        text-decoration: none;
        border-radius: 5px;
        font-weight: 600;
        font-size: 14px;
        transition: all 0.2s ease;
    }
    .logout-btn:hover {
        background-color: #dc3545;
        color: #ffffff;
    }
    /* --- END OF HEADER --- */

    .container {
        max-width: 900px;
        margin: 40px auto;
        padding: 20px;
    }
    .welcome-text {
        font-size: 24px;
        font-weight: 600;
        margin-bottom: 25px;
        color: #1a2c3d;
    }

    /* --- NEW CARD STYLING --- */
    .card {
        background: #ffffff;
        border-radius: 12px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        padding: 20px 25px; /* Padding */
        display: flex; /* Changed */
        flex-direction: row; /* Changed */
        justify-content: space-between; /* Changed */
        align-items: center; /* Changed */
        transition: all 0.2s ease-in-out;
        border: 1px solid #e2e8f0;
        margin-bottom: 15px; /* Space between cards */
    }
    .card:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 16px rgba(0,0,0,0.08);
    }
    
    /* NEW: Wrapper for card content */
    .card-content {
        flex-grow: 1; /* Takes up available space */
    }
    
    .card-header {
        display: flex;
        align-items: center;
        gap: 12px;
        margin-bottom: 8px; /* Less margin */
    }
    .card-icon {
        width: 24px;
        height: 24px;
        color: #007bff;
    }
    .card-title {
        font-size: 20px;
        font-weight: 600;
        color: #1a2c3d;
        margin: 0;
    }
    
    .card-description {
        font-size: 15px;
        color: #4a5568;
        line-height: 1.5;
        padding-left: 36px; /* Align with title */
    }
    
    /* --- UPDATED START BUTTON --- */
    .start-btn {
        padding: 12px 20px; /* Bigger button */
        background-color: #28a745; 
        color: white;
        text-decoration: none;
        border-radius: 8px;
        font-size: 16px;
        font-weight: 500;
        text-align: center;
        transition: background-color 0.2s ease;
        white-space: nowrap; /* Prevent button text from wrapping */
        margin-left: 20px; /* Space from content */
    }
    .start-btn:hover {
        background-color: #218838;
    }
</style>
</head>
<body>

    <!-- UPDATED HEADER BAR -->
    <div class="header-bar">
        <div class="header-title">Student Dashboard</div>
        
        <div class="profile-area">
            <div class="profile-info">
                <!-- NEW PROFILE ICON -->
                <svg class="profile-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                  <path fill-rule="evenodd" d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z" clip-rule="evenodd" />
                </svg>
                <span class="profile-name">
                    Logged in as: <b><%= user.getUsername() %></b>
                </span>
            </div>
            <a href="logout" class="logout-btn">Logout</a>
        </div>
    </div>
    
    <div class="container">
        <p class="welcome-text">Welcome, <%= user.getUsername() %>. Choose a quiz to get started.</p>
    
        <%-- Quiz List --%>
        <div class="quiz-list">
            <% for (Quiz quiz : quizzes) { %>
            
                <!-- UPDATED CARD STRUCTURE -->
                <div class="card">
                    <div class="card-content">
                        <div class="card-header">
                            <!-- NEW CARD ICON -->
                            <svg class="card-icon" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01" />
                            </svg>
                            <h3 class="card-title"><%= quiz.getTitle() %></h3>
                        </div>
                        <p class="card-description">
                            Duration: <%= quiz.getDurationMinutes() %> minutes
                        </p>
                    </div>
                    <a href="startQuiz?quizId=<%= quiz.getQuizId() %>" class="start-btn">Start Quiz</a>
                </div>
                <!-- END OF CARD -->
        
            <% } // End of the loop %>
            
            <% if (quizzes.isEmpty()) { %>
                <div class="card">
                   <p class="card-description">No quizzes are available at this time. Please check back later.</p>
                </div>
            <% } %>
        </div>
    
    </div>

</body>
</html>

