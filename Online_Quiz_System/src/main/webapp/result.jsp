<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.quiz.model.User" %>

<%
    // --- Security Check ---
    User user = (User) session.getAttribute("loggedInUser");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return; 
    }

    // --- Get Score Data from Session ---
    // The SubmitQuizServlet put these here for us.
    Integer finalScore = (Integer) session.getAttribute("finalScore");
    Integer totalQuestions = (Integer) session.getAttribute("totalQuestions");
    Integer correctAnswers = (Integer) session.getAttribute("correctAnswers");
    
    // --- Security Check 2 ---
    // If the score is missing, they didn't just finish a quiz.
    if (finalScore == null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
    
    // --- Clean Up Session ---
    // Now that we've displayed the score, remove it from the session
    // so it doesn't show up again by accident.
    session.removeAttribute("finalScore");
    session.removeAttribute("totalQuestions");
    session.removeAttribute("correctAnswers");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quiz Results</title>
<style>
    body { font-family: Arial, sans-serif; display: grid; place-items: center; min-height: 80vh; background-color: #f4f4f4; }
    .result-card { background: #fff; border: 1px solid #ccc; padding: 30px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); text-align: center; }
    .result-title { font-size: 28px; font-weight: bold; margin-bottom: 20px; }
    .score { font-size: 60px; font-weight: bold; color: #007bff; margin: 20px 0; }
    .score-details { font-size: 18px; color: #555; margin-bottom: 30px; }
    .dashboard-btn { background-color: #28a745; color: white; padding: 12px 20px; 
                     text-decoration: none; border-radius: 5px; font-size: 16px; }
    .dashboard-btn:hover { background-color: #218838; }
</style>
</head>
<body>

    <div class="result-card">
        <div class="result-title">Quiz Complete!</div>
        
        <div class="score"><%= finalScore %>%</div>
        
        <div class="score-details">
            You answered <%= correctAnswers %> out of <%= totalQuestions %> questions correctly.
        </div>
        
        <a href="dashboard.jsp" class="dashboard-btn">Back to Dashboard</a>
    </div>

</body>
</html>