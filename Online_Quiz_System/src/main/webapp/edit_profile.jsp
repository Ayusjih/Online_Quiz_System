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
    
    // Check for error messages from the servlet
    String errorMessage = (String) request.getAttribute("errorMessage");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif;
            background-color: #f0f2f5;
            color: #1a2c3d;
            margin: 0;
            padding: 20px;
            display: grid;
            place-items: center;
            min-height: 90vh;
        }
        .container {
            width: 100%;
            max-width: 500px;
        }
        .form-card {
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            padding: 30px 40px;
            border: 1px solid #e2e8f0;
        }
        .form-title {
            font-size: 24px;
            font-weight: 700;
            color: #1a2c3d;
            text-align: center;
            margin-bottom: 25px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            font-weight: 600;
            font-size: 14px;
            color: #4a5568;
            margin-bottom: 8px;
        }
        .form-group input[type="text"],
        .form-group input[type="email"],
        .form-group input[type="password"] {
            width: 100%;
            padding: 12px 15px;
            font-size: 16px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            box-sizing: border-box; /* Important */
        }
        .form-group input[disabled] {
            background-color: #f8f9fa;
            color: #6c757d;
        }
        .error-message {
            color: #dc3545;
            background-color: #fbebee;
            border: 1px solid #f5c6cb;
            padding: 10px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: center;
            font-size: 14px;
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
        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #007bff;
            text-decoration: none;
            font-weight: 500;
        }
        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <div class="container">
        <div class="form-card">
            <h1 class="form-title">Edit Your Profile</h1>

            <%-- Show error if it exists --%>
            <% if (errorMessage != null) { %>
                <div class="error-message"><%= errorMessage %></div>
            <% } %>

            <form action="updateProfile" method="post">
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" value="<%= user.getUsername() %>" disabled>
                </div>

                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" value="<%= user.getEmail() != null ? user.getEmail() : "" %>" required>
                </div>

                <div class="form-group">
                    <label for="password">New Password</label>
                    <input type="password" id="password" name="password" required>
                </div>

                <div class="form-group">
                    <label for="confirmPassword">Confirm New Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" required>
                </div>

                <button type="submit" class="submit-btn">Save Changes</button>
            </form>
        </div>
        
        <%-- Back link logic --%>
        <% if (user.isAdmin()) { %>
            <a href="admin_dashboard.jsp" class="back-link">&larr; Back to Dashboard</a>
        <% } else { %>
            <a href="dashboard.jsp" class="back-link">&larr; Back to Dashboard</a>
        <% } %>
    </div>

</body>
</html>

