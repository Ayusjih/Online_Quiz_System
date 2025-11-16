<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.quiz.model.User" %>

<%
    // --- LOGIN PAGE LOGIC (Opposite of dashboard) ---
    // Agar user pehle se logged in hai, toh usse dashboard par bhej do.
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    if (loggedInUser != null) {
        
        if (loggedInUser.isAdmin()) {
            response.sendRedirect("admin_dashboard.jsp"); // Admin ko admin dash par
        } else {
            response.sendRedirect("dashboard.jsp"); // Student ko student dash par
        }
        return; // Stop processing this page
    }
    
    // Check for login error message
    String errorMessage = (String) request.getAttribute("errorMessage");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Quiz App - Login</title>
<!-- 
    Login page ka apna CSS hai. Yeh navbar.jsp ko nahi use karta hai.
    (Login page has its own CSS. It does not use navbar.jsp)
-->
<style>
    /* Dark Mode Variables (Default light mode) */
    :root {
        --bg-color: #f0f2f5;
        --card-bg-color: #ffffff;
        --text-color: #1a2c3d;
        --text-color-light: #4a5568;
        --border-color: #e2e8f0;
        --shadow: 0 4px 12px rgba(0,0,0,0.05);
    }
    
    body {
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif;
        background-color: var(--bg-color);
        color: var(--text-color);
        margin: 0;
        padding: 0;
    }
    
    /* --- Login Page Styles --- */
    .login-container {
        display: flex;
        align-items: center;
        justify-content: center;
        min-height: 100vh; /* Full screen height */
        padding: 20px;
    }
    
    .login-card {
        background: var(--card-bg-color);
        border: 1px solid var(--border-color);
        border-radius: 12px;
        box-shadow: var(--shadow);
        padding: 30px 35px;
        width: 100%;
        max-width: 400px;
    }
    
    .login-title {
        font-size: 28px;
        font-weight: 700;
        color: var(--text-color);
        text-align: center;
        margin-bottom: 25px;
    }
    
    .form-group {
        margin-bottom: 20px;
    }
    
    .form-group label {
        display: block;
        margin-bottom: 8px;
        font-weight: 600;
        color: var(--text-color-light);
    }
    
    .form-input {
        width: 100%;
        padding: 12px 15px;
        border: 1px solid var(--border-color);
        border-radius: 8px;
        font-size: 16px;
        background-color: var(--bg-color);
        color: var(--text-color);
        box-sizing: border-box; /* Important */
    }
    
    .submit-btn {
        width: 100%;
        padding: 14px;
        background-color: #007bff;
        color: white;
        border: none;
        border-radius: 8px;
        font-size: 16px;
        font-weight: 600;
        cursor: pointer;
        transition: background-color 0.2s ease;
    }
    
    .submit-btn:hover {
        background-color: #0056b3;
    }
    
    .error-message {
        background-color: #fff0f0;
        color: #dc3545;
        border: 1px solid #dc3545;
        padding: 12px;
        border-radius: 8px;
        text-align: center;
        margin-bottom: 20px;
    }

</style>
</head>

<!-- Login page par 'page-container' class ki zaroorat nahi hai -->
<body>
    
    <!-- 
    =====================================================================
        Yahaan se navbar.jsp include HATA diya gaya hai
        (The navbar.jsp include has been REMOVED from here)
    =====================================================================
    -->
    
    
    <!-- 
    =====================================================================
        Sirf Login Page ka Content
    =====================================================================
    -->
    <div class="login-container">
        
        <div class="login-card">
            <h2 class="login-title">Login</h2>
            
            <%-- Agar error message hai, toh yahaan dikhao --%>
            <% if (errorMessage != null) { %>
                <div class="error-message">
                    <%= errorMessage %>
                </div>
            <% } %>
            
            <form action="login" method="post">
                <div class="form-group">
                    <label for="username">Username:</label>
                    <input type="text" id="username" name="username" class="form-input" required>
                </div>
                <div class="form-group">
                    <label for="password">Password:</label>
                    <input type="password" id="password" name="password" class="form-input" required>
                </div>
                <div>
                    <input type="submit" value="Login" class="submit-btn">
                </div>
            </form>
            
        </div>
        
    </div>

</body>
</html>