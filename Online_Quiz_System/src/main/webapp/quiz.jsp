<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.quiz.model.User, com.quiz.model.Quiz, com.quiz.model.Question, java.util.List" %>
<%
    // --- Security Check 1: Is user logged in? ---
    User user = (User) session.getAttribute("loggedInUser");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return; 
    }
    
    // --- Get all quiz data from the session ---
    Quiz quiz = (Quiz) session.getAttribute("currentQuiz");
    List<Question> questions = (List<Question>) session.getAttribute("quizQuestions");
    Long startTime = (Long) session.getAttribute("startTime");

    // --- Security Check 2: Is a quiz active? ---
    if (quiz == null || questions == null || startTime == null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
    
    // --- Timer Setup ---
    long durationInMillis = quiz.getDurationMinutes() * 60 * 1000;
    long endTime = startTime + durationInMillis;
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quiz: <%= quiz.getTitle() %></title>
<style>
    /* (Same CSS as before - no changes) */
    body { font-family: Arial, sans-serif; background-color: #f4f4f4; padding: 20px; }
    .quiz-container { max-width: 800px; margin: 0 auto; background: #fff; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
    .quiz-header { padding: 20px; border-bottom: 1px solid #eee; display: flex; justify-content: space-between; align-items: center; }
    .quiz-title { font-size: 24px; font-weight: bold; }
    #timer { font-size: 20px; font-weight: bold; color: #d9534f; background: #f9f9f9; padding: 10px; border-radius: 5px; }
    .question-block { padding: 20px; border-bottom: 1px solid #eee; }
    .question-text { font-size: 18px; font-weight: bold; margin-bottom: 15px; }
    .options-list { list-style: none; padding: 0; }
    .options-list li { margin-bottom: 10px; }
    .options-list label { display: block; padding: 10px; background: #f9f9f9; border-radius: 5px; cursor: pointer; }
    .options-list label:hover { background: #e9e9e9; }
    /* Naya style FIB input ke liye */
    .fib-input { padding: 10px; font-size: 16px; border: 1px solid #ccc; border-radius: 5px; width: 300px; }
    
    .submit-btn { display: block; width: 95%; margin: 20px auto; padding: 15px; background-color: #007bff; color: white; 
                  border: none; border-radius: 5px; font-size: 18px; cursor: pointer; }
    .submit-btn:hover { background-color: #0056b3; }
</style>
</head>
<body>

    <div class="quiz-container">
        <div class="quiz-header">
            <div class="quiz-title"><%= quiz.getTitle() %></div>
            <div id="timer">Loading...</div>
        </div>
        
        <form id="quizForm" action="submitQuiz" method="post">
        
            <%
                // Loop through all the questions
                for (int i = 0; i < questions.size(); i++) {
                    Question q = questions.get(i);
            %>
            
            <div class="question-block">
                <div class="question-text">Q<%= (i + 1) %>: <%= q.getQuestionText() %></div>
                
                <%-- YEH HAI NAYA LOGIC --%>
                <% if ("MCQ".equals(q.getQuestionType())) { %>
                    <%-- MCQ Hai Toh Radio Buttons Dikhao --%>
                    <ul class="options-list">
                        <% for (String option : q.getOptionsList()) { %>
                            <li>
                                <label>
                                    <input type="radio" name="answer_<%= i %>" value="<%= option %>" required> 
                                    <%= option %>
                                </label>
                            </li>
                        <% } %>
                    </ul>
                
                <% } else if ("FIB".equals(q.getQuestionType())) { %>
                    <%-- FIB Hai Toh Text Input Dikhao --%>
                    <div class="form-group">
                        <label for="answer_<%= i %>">Answer (in integer):</label>
                        <input type="text" id="answer_<%= i %>" name="answer_<%= i %>" class="fib-input" required>
                    </div>
                
                <% } else { %>
                    <p>Error: Unknown question type.</p>
                <% } %>
                <%-- NAYA LOGIC KHATAM --%>
                
            </div>
            
            <% } // End of for loop %>
            
            <input type="submit" value="Submit Quiz" class="submit-btn">
        
        </form>
    </div>

    <script>
        // (Same Timer JavaScript as before - no changes)
        const endTime = <%= endTime %>;
        const quizForm = document.getElementById('quizForm');
        const timerElement = document.getElementById('timer');
        const timerInterval = setInterval(updateTimer, 1000);

        function updateTimer() {
            const now = new Date().getTime();
            const distance = endTime - now;
            if (distance < 0) {
                clearInterval(timerInterval);
                timerElement.innerHTML = "TIME'S UP!";
                alert("Time's up! Your quiz will be submitted automatically.");
                quizForm.submit();
            } else {
                const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
                const seconds = Math.floor((distance % (1000 * 60)) / 1000);
                timerElement.innerHTML = minutes + "m " + (seconds < 10 ? "0" : "") + seconds + "s";
            }
        }
        updateTimer();
    </script>

</body>
</html>

