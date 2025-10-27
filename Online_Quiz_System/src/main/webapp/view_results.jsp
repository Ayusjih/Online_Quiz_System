<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%-- Import all classes --%>
<%@ page import="com.quiz.model.User" %>
<%@ page import="com.quiz.dao.ResultDAO" %>
<%@ page import="com.quiz.model.ResultDetails" %> <%-- Make sure you've updated this model --%>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    // --- ADMIN SECURITY CHECK ---
    User adminUser = (User) session.getAttribute("loggedInUser");
    if (adminUser == null || !adminUser.isAdmin()) {
        response.sendRedirect("login.jsp");
        return; 
    }
    
    // --- Get Data ---
    ResultDAO resultDAO = new ResultDAO();
    List<ResultDetails> allResults = resultDAO.getAllResultDetails();
    
    SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy 'at' hh:mm a");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View All Results</title>
    <%-- (Your <style> tags go here... I'll remove them for brevity) --%>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif; padding: 20px; background-color: #f0f2f5; }
        .header { font-size: 28px; font-weight: 700; margin-bottom: 10px; }
        .back-link { display: inline-block; margin-bottom: 20px; color: #007bff; text-decoration: none; font-weight: 500; }
        .table-container { width: 100%; background: #ffffff; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.05); overflow: hidden; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 16px 20px; text-align: left; border-bottom: 1px solid #edf2f7; }
        th { background-color: #f8f9fa; font-size: 13px; text-transform: uppercase; color: #4a5568; }
        .score-badge { display: inline-block; padding: 4px 10px; border-radius: 12px; font-weight: 600; }
        .score-pass { background-color: #e6f7ec; color: #228b22; }
        .score-fail { background-color: #fff0f0; color: #dc3545; }
        .details-btn { background-color: #007bff; color: white; padding: 6px 14px; text-decoration: none; border-radius: 5px; font-size: 14px; }
        .details-btn:hover { background-color: #0056b3; }
        .empty-state { text-align: center; padding: 40px; color: #555; }
    </style>
</head>
<body>

    <h1 class="header">All Student Results</h1>
    <a href="admin_dashboard.jsp" class="back-link">&larr; Back to Admin Dashboard</a>

    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>Student</th>
                    <th>Quiz Title</th>
                    <th>Score</th>
                    <th>Date Taken</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <% for (ResultDetails result : allResults) { 
                    String scoreClass = result.getScore() >= 50 ? "score-pass" : "score-fail";
                %>
                    <tr>
                        <td><%= result.getUsername() %></td>
                        <td><%= result.getQuizTitle() %></td>
                        <td>
                            <span class="score-badge <%= scoreClass %>">
                                <%= result.getScore() %>%
                            </span>
                        </td>
                        <td><%= sdf.format(result.getDateTaken()) %></td>
                        <td>
                            <a href="result_details.jsp?resultId=<%= result.getResultId() %>" class="details-btn">
                                View Details
                            </a>
                        </td>
                    </tr>
                <% } %>
                
                <% if (allResults.isEmpty()) { %>
                    <tr>
                        <td colspan="5">
                            <div class="empty-state">No results found.</div>
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</body>
</html>

