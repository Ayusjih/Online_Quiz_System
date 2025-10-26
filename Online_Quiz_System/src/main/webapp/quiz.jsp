<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%-- Import all the classes we need --%>
<%@ page import="com.quiz.model.User" %>
<%@ page import="com.quiz.model.Quiz" %>
<%@ page import="com.quiz.model.Question" %>
<%@ page import="java.util.List" %>

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
    // If these are null, the user hasn't started a quiz properly.
    if (quiz == null || questions == null || startTime == null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
    
    // --- Timer Setup ---
    // Calculate when the quiz should end
    long durationInMillis = quiz.getDurationMinutes() * 60 * 1000;
    long endTime = startTime + durationInMillis;
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quiz: <%= quiz.getTitle() %></title>
<style>
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
        
        <!-- This form will submit all answers at once to our new SubmitQuizServlet -->
        <form id="quizForm" action="submitQuiz" method="post">
        
            <%
                // Loop through all the questions
                for (int i = 0; i < questions.size(); i++) {
                    Question q = questions.get(i);
            %>
            
            <div class="question-block">
                <div class="question-text">Q<%= (i + 1) %>: <%= q.getQuestionText() %></div>
                <ul class="options-list">
                    <!-- 
                       The 'name' attribute is "answer_<%= i %>".
                       This will give us "answer_0", "answer_1", etc.
                       The 'value' is 1, 2, 3, or 4 for the option.
                    -->
                    <li><label><input type="radio" name="answer_<%= i %>" value="1" required> <%= q.getOption1() %></label></li>
                    <li><label><input type="radio" name="answer_<%= i %>" value="2" required> <%= q.getOption2() %></label></li>
                    <li><label><input type="radio" name="answer_<%= i %>" value="3" required> <%= q.getOption3() %></label></li>
                    <li><label><input type="radio" name="answer_<%= i %>" value="4" required> <%= q.getOption4() %></label></li>
                </ul>
            </div>
            
            <% } // End of for loop %>
            
            <input type="submit" value="Submit Quiz" class="submit-btn">
        
        </form>
    </div>

    <script>
        // --- Countdown Timer JavaScript ---
        
        // Get the server's end time (in milliseconds) from our JSP variable
        const endTime = <%= endTime %>;
        const quizForm = document.getElementById('quizForm');
        const timerElement = document.getElementById('timer');

        // Start a timer that runs every 1 second
        const timerInterval = setInterval(updateTimer, 1000);

        function updateTimer() {
            // Get the current time
            const now = new Date().getTime();
            
            // Calculate time remaining
            const distance = endTime - now;

            // If time is up
            if (distance < 0) {
                clearInterval(timerInterval); // Stop the timer
                timerElement.innerHTML = "TIME'S UP!";
                alert("Time's up! Your quiz will be submitted automatically.");
                quizForm.submit(); // Auto-submit the form
            } else {
                // Calculate minutes and seconds
                const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
                const seconds = Math.floor((distance % (1000 * 60)) / 1000);
                
                // Display the time, adding a "0" if seconds < 10
                timerElement.innerHTML = minutes + "m " + (seconds < 10 ? "0" : "") + seconds + "s";
            }
        }
        
        // Run it once immediately so it doesn't say "Loading..."
        updateTimer();
    </script>

</body>
</html>