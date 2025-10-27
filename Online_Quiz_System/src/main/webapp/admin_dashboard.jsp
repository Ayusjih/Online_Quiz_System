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
    // --- End of Security Check ---
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
        padding: 0; 
        margin: 0;
        background-color: #f0f2f5; 
        color: #1a2c3d; /* Darker text */
    }
    
    /* --- PROFESSIONAL HEADER BAR --- */
    .header-bar {
        background-color: #ffffff;
        padding: 12px 30px; /* Slightly less padding */
        box-shadow: 0 1px 3px rgba(0,0,0,0.05); /* Softer shadow */
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
        box-sizing: border-box; /* Include padding in width/height */
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
        max-width: 1100px; /* Wider container */
        margin: 40px auto;
        padding: 20px;
    }
    .welcome-text {
        font-size: 24px;
        font-weight: 600;
        margin-bottom: 25px;
        color: #1a2c3d;
    }
    
    /* Card Grid Layout */
    .card-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
        gap: 30px;
    }
    
    /* Card Styling */
    .card {
        background: #ffffff;
        border-radius: 12px; /* More rounded */
        box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        padding: 25px;
        display: flex;
        flex-direction: column;
        transition: all 0.2s ease-in-out;
        border: 1px solid #e2e8f0;
    }
    .card:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 16px rgba(0,0,0,0.08);
    }
    
    .card-header {
        display: flex;
        align-items: center;
        gap: 12px;
        margin-bottom: 15px;
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
        flex-grow: 1; 
        margin-bottom: 25px;
        line-height: 1.5;
    }
    .card-link {
        display: block;
        padding: 12px 15px;
        background-color: #007bff;
        color: white;
        text-decoration: none;
        border-radius: 8px;
        font-size: 16px;
        font-weight: 500;
        text-align: center;
        transition: background-color 0.2s ease;
    }
    .card-link:hover {
        background-color: #0056b3;
    }
</style>
</head>
<body>

    <!-- UPDATED HEADER BAR -->
    <div class="header-bar">
        <div class="header-title">Admin Panel</div>
        
        <div class="profile-area">
            <div class="profile-info">
                <!-- NEW PROFILE ICON -->
                <svg class="profile-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                  <path fill-rule="evenodd" d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z" clip-rule="evenodd" />
                </svg>
                <span class="profile-name">
                    Logged in as: <b><%= adminUser.getUsername() %></b>
                </span>
            </div>
            <a href="logout" class="logout-btn">Logout</a>
        </div>
    </div>
    
    <div class="container">
        <p class="welcome-text">Welcome, <%= adminUser.getUsername() %>. Choose an option to get started.</p>
    
        <div class="card-grid">
        
            <!-- Card 1: Manage Quizzes -->
            <div class="card">
                <div>
                    <div class="card-header">
                        <!-- NEW CARD ICON -->
                        <svg class="card-icon" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 10h16M4 14h16M4 18h16" />
                        </svg>
                        <h3 class="card-title">Manage Quizzes</h3>
                    </div>
                    <p class="card-description">Add new quizzes, delete existing quizzes, and view all quiz details.</p>
                </div>
                <a href="manage_quizzes.jsp" class="card-link">Manage Quizzes</a>
            </div>
            
            <!-- Card 2: View All Results -->
            <div class="card">
                <div>
                    <div class="card-header">
                        <!-- NEW CARD ICON -->
                        <svg class="card-icon" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                        </svg>
                        <h3 class="card-title">View All Results</h3>
                    </div>
                    <p class="card-description">See a complete history of all quizzes taken by all students.</p>
                </div>
                <a href="view_results.jsp" class="card-link">View All Results</a>
            </div>
            
            <!-- Card 3: Manage Questions -->
            <div class="card">
                <div>
                    <div class="card-header">
                        <!-- NEW CARD ICON -->
                        <svg class="card-icon" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                        </svg>
                        <h3 class="card-title">Manage Questions</h3>
                    </div>
                    <p class="card-description">Add, delete, or edit questions for any existing quiz.</p>
                </div>
                <a href="manage_questions.jsp" class="card-link">Manage Questions</a>
            </div>
            
        </div>
    </div>

</body>
</html>

