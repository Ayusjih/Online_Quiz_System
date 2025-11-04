<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.quiz.model.User" %>
<%@ page import="com.quiz.dao.ResultDAO" %>
<%@ page import="com.quiz.model.AnswerDetail" %>
<%@ page import="com.quiz.model.Quiz" %>
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
    
    /* Styles for FIB */
    .fib-answer {
        font-family: 'Courier New', Courier, monospace;
        font-size: 1.1em;
    }

</style>
</head>
<body>

    <h1 class="header">Quiz Review</h1>
    <a href="view_results.jsp" class="back-link">&larr; Back to All Results</a>

    <% 
    int questionNumber = 1;
    for (AnswerDetail answer : answers) {
    
        // --- YEH HAI NAYA HYBRID LOGIC ---
        boolean isCorrect = false;
        String userAnswer = answer.getUserAnswer();
        String correctAnswer = answer.getCorrectAnswer();
        
        if (answer.getQuestionType().equals("MCQ")) {
            // MCQ ko value (e.g., "1") se check karein
            isCorrect = userAnswer.equals(correctAnswer);
        } else {
            // FIB ko text se check karein (case-insensitive)
            isCorrect = userAnswer.trim().equalsIgnoreCase(correctAnswer.trim());
        }
    %>
    
    <div class="question-card <%= isCorrect ? "question-card-correct" : "question-card-wrong" %>">
        
        <div class="question-text">
            Q<%= questionNumber++ %>: [<%= answer.getQuestionType() %>] <%= answer.getQuestionText() %>
        </div>
        
        <div class="answer-body">
            
            <%-- Check question type --%>
            <% if ("MCQ".equals(answer.getQuestionType())) { %>
            
                <%-- YEH NAYA "MCQ" LOGIC HAI --%>
                <% 
                   List<String> optionsList = answer.getOptionsList();
                   int userAnswerInt = 0;
                   int correctAnswerInt = 0;
                   
                   // Convert answers (e.g., "1") to integers for comparison
                   try {
                       // Handle "[Not Answered]" case
                       if (!userAnswer.startsWith("[")) {
                           userAnswerInt = Integer.parseInt(userAnswer);
                       }
                       correctAnswerInt = Integer.parseInt(correctAnswer);
                   } catch (NumberFormatException e) {
                       // Agar answer 1-4 nahi hai (koi error), toh default 0 rahega
                   }
                   
                   // Ab options (1, 2, 3, 4) loop karein
                   for (int i = 0; i < optionsList.size(); i++) {
                       String optionText = optionsList.get(i);
                       int currentOptionNum = i + 1; // Option number is 1, 2, 3, or 4
                       String cssClass = "";
                       
                       // Check if this option is the correct one
                       if (currentOptionNum == correctAnswerInt) {
                           cssClass = "correct-answer";
                       } 
                       // Check if this option is the one user chose (and it was wrong)
                       else if (currentOptionNum == userAnswerInt && !isCorrect) {
                           cssClass = "user-answer-wrong";
                       }
                %>
                
                <span class="answer-option <%= cssClass %>">
                    <%= optionText %>
                    
                    <% if (currentOptionNum == correctAnswerInt) { %>
                        <b>(Correct Answer)</b>
                    <% } else if (currentOptionNum == userAnswerInt) { %>
                        <b>(Your Answer)</b>
                    <% } %>
                </span>
                
                <% } // End of for loop %>
            
            <% } else { // "Fill in the Blank" (FIB) LOGIC %>
            
                <span class="answer-option correct-answer fib-answer">
                    Correct Answer: <%= correctAnswer %>
                </span>
                <span class="answer-option <%= isCorrect ? "" : "user-answer-wrong" %> fib-answer">
                    Your Answer: <%= (userAnswer == null || userAnswer.isEmpty() || userAnswer.equals("[Not Answered]")) ? "[Not Answered]" : userAnswer %>
                </span>
            
            <% } // End of if/else %>
            
        </div>
        
    </div>

    <% } // End of main loop %>
    
    <% if (answers.isEmpty()) { %>
        <p>No answer details found for this result.</p>
    <% } %>

</body>
</html>

