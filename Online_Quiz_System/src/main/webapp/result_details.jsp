<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%-- Import all classes --%>
<%@ page import="com.quiz.model.User" %>
<%@ page import="com.quiz.dao.ResultDAO" %>
<%@ page import="com.quiz.model.AnswerDetail" %>
<%@ page import="java.util.List" %>

<%
    // --- ADMIN SECURITY CHECK ---
    User adminUser = (User) session.getAttribute("loggedInUser");
    if (adminUser == null || !adminUser.isAdmin()) {
        response.sendRedirect("login.jsp");
        return; 
    }

    // --- Get Data ---
    int resultId = 0;
    List<AnswerDetail> answers = null;
    
    try {
        resultId = Integer.parseInt(request.getParameter("resultId"));
        ResultDAO resultDAO = new ResultDAO();
        answers = resultDAO.getResultAnswers(resultId);
    } catch (Exception e) {
        // Handle bad ID or other errors
        response.sendRedirect("view_results.jsp"); // Send back to safety
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Result Details</title>
<style>
    body { 
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif; 
        padding: 20px; 
        background-color: #f0f2f5; 
        color: #333;
    }
    .header { 
        font-size: 28px; 
        font-weight: 700;
        margin-bottom: 10px;
        color: #1a202c;
    }
    .back-link {
        display: inline-block;
        margin-bottom: 20px;
        color: #007bff;
        text-decoration: none;
        font-weight: 500;
    }
    .back-link:hover {
        text-decoration: underline;
    }
    
    .question-card {
        background: #ffffff;
        border-radius: 8px;
        box-shadow: 0 4px 8px rgba(0,0,0,0.05);
        margin-bottom: 20px;
        border-left: 5px solid #ccc; /* Default border */
    }
    .question-card-correct {
        border-left-color: #28a745; /* Green for correct */
    }
    .question-card-wrong {
        border-left-color: #dc3545; /* Red for wrong */
    }
    
    .question-text {
        padding: 20px;
        font-size: 18px;
        font-weight: 600;
        border-bottom: 1px solid #edf2f7;
    }
    .answer-body {
        padding: 20px;
        font-size: 16px;
    }
    .answer-option {
        display: block;
        padding: 10px;
        border-radius: 5px;
        margin-bottom: 5px;
        background-color: #f8f9fa;
        border: 1px solid #eee;
    }
    
    /* Styles for correct/wrong answers */
    .user-answer-wrong {
        background-color: #fff0f0;
        border-color: #dc3545;
        font-weight: bold;
        color: #dc3545;
    }
    .correct-answer {
        background-color: #e6f7ec;
        border-color: #28a745;
        font-weight: bold;
        color: #228b22;
    }

</style>
</head>
<body>

    <h1 class="header">Quiz Review</h1>
    <a href="view_results.jsp" class="back-link">&larr; Back to All Results</a>

    <% 
    int questionNumber = 1;
    for (AnswerDetail answer : answers) {
    
        // Logic to determine which option is which
        String[] options = {
            answer.getOption1(),
            answer.getOption2(),
            answer.getOption3(),
            answer.getOption4()
        };
        
        boolean isCorrect = (answer.getUserAnswer() == answer.getCorrectAnswer());
    %>
    
    <div class="question-card <%= isCorrect ? "question-card-correct" : "question-card-wrong" %>">
        
        <div class="question-text">
            Q<%= questionNumber++ %>: <%= answer.getQuestionText() %>
        </div>
        
        <div class="answer-body">
            <% for (int i = 1; i <= 4; i++) {
                String optionText = options[i-1];
                String cssClass = "";
                
                if (i == answer.getCorrectAnswer()) {
                    cssClass = "correct-answer"; // This is the right answer
                } else if (i == answer.getUserAnswer()) {
                    cssClass = "user-answer-wrong"; // This is the user's wrong choice
                }
            %>
            
            <span class="answer-option <%= cssClass %>">
                <%= optionText %>
                
                <% if (i == answer.getCorrectAnswer()) { %>
                    <b>(Correct Answer)</b>
                <% } else if (i == answer.getUserAnswer()) { %>
                    <b>(Your Answer)</b>
                <% } %>
            </span>
            
            <% } %>
        </div>
        
    </div>

    <% } // End of loop %>

</body>
</html>
