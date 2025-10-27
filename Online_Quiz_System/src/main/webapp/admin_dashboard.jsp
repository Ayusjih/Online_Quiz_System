<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.quiz.model.User" %>

<%
    // --- ADMIN SECURITY CHECK ---
    User adminUser = (User) session.getAttribute("loggedInUser");
    
    if (adminUser == null) {
        response.sendRedirect("login.jsp");
        return; 
    }
    
    if (!adminUser.isAdmin()) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin Dashboard</title>
<style>
    body { 
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif; 
        padding: 20px; 
        background-color: #f0f2f5; 
        color: #333;
    }
    .header { 
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 10px;
    }
    .header h1 {
        font-size: 28px; 
        font-weight: 700;
        color: #1a202c;
    }
    .user-info {
        font-size: 16px;
        color: #555;
    }
    .card-container {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
        gap: 20px;
        margin-top: 20px;
    }
    .card {
        background: #ffffff;
        border-radius: 8px;
        box-shadow: 0 4px 8px rgba(0,0,0,0.05);
        padding: 25px;
        transition: all 0.2s ease-in-out;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
    }
    .card:hover {
        transform: translateY(-5px);
        box-shadow: 0 6px 12px rgba(0,0,0,0.1);
    }
    .card h3 {
        font-size: 20px;
        font-weight: 600;
        color: #007bff;
        margin: 0 0 10px 0;
    }
    .card p {
        font-size: 15px;
        color: #4a5568;
        line-height: 1.5;
        flex-grow: 1;
    }
    .card-link {
        display: inline-block;
        margin-top: 20px;
        padding: 10px 18px;
        background-color: #007bff;
        color: white;
        text-decoration: none;
        border-radius: 5px;
        font-weight: 500;
        transition: background-color 0.2s;
        text-align: center;
    }
    .card-link:hover {
        background-color: #0056b3;
    }
    .card-link.disabled {
        background-color: #c0c0c0;
        cursor: not-allowed;
    }
</style>
</head>
<body>

    <div class="header">
        <h1>Admin Panel</h1>
        <div class="user-info">
            Logged in as: <strong><%= adminUser.getUsername() %></strong>
        </div>
    </div>
    <p>Welcome to the admin control panel. Choose an option to get started.</p>

    <div class="card-container">
    
        <!-- Card 1: Manage Quizzes -->
        <div class="card">
            <div>
                <h3>Manage Quizzes</h3>
                <p>Add new quizzes, delete existing quizzes, and view all quiz details.</p>
            </div>
            <a href="manage_quizzes.jsp" class="card-link">Go to Quizzes</a>
        </div>
        
        <!-- Card 2: View Results -->
        <div class="card">
            <div>
                <h3>View All Results</h3>
                <p>See a complete history of all quizzes taken by all students.</p>
            </div>
            <a href="view_results.jsp" class="card-link">View Results</a>
        </div>

        <!-- Card 3: Manage Questions (Coming Soon) -->
        <div class="card">
            <div>
                <h3>Manage Questions</h3>
                <p>Add, edit, or delete questions for each quiz. (Coming Soon)</p>
            </div>
            <a href="#" class="card-link disabled">Coming Soon</a>
        </div>

    </div>

</body>
</html>
