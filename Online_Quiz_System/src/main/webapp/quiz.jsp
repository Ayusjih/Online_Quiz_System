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
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Quiz: <%= quiz.getTitle() %></title>
<!-- 
    Saara common CSS (Header, Sidebar, Dark Mode) navbar.jsp se aa raha hai
-->
<style>
    /* =====================================================================
        Yahaan is page ke specific styles vaapas add kar diye hain
        (This page's specific styles have been added back here)
    =====================================================================
    */
    .quiz-container { 
        max-width: 800px; 
        margin: 20px auto; 
        background: var(--card-bg-color); 
        border-radius: 8px; 
        box-shadow: var(--shadow);
        border: 1px solid var(--border-color);
        overflow: hidden; /* Taaki header ke corners match karein */
    }
    .quiz-header { 
        padding: 20px; 
        border-bottom: 1px solid var(--border-color); 
        display: flex; 
        justify-content: space-between; 
        align-items: center; 
        background-color: var(--bg-color);
    }
    .quiz-title { 
        font-size: 24px; 
        font-weight: 600; 
        color: var(--text-color);
    }
    #timer { 
        font-size: 20px; 
        font-weight: 600; 
        color: #d9534f; 
        background: var(--card-bg-color); 
        padding: 10px; 
        border-radius: 5px; 
        border: 1px solid var(--border-color);
    }
    
    .question-block { 
        padding: 25px; 
        border-bottom: 1px solid var(--border-color); 
    }
    .question-block:last-child {
        border-bottom: none;
    }
    
    .question-text { 
        font-size: 18px; 
        font-weight: 600; 
        margin-bottom: 20px; 
        color: var(--text-color);
        line-height: 1.5;
    }
    
    /* Options list (MCQ) */
    .options-list { 
        list-style: none; 
        padding: 0; 
    }
    .options-list li { 
        margin-bottom: 12px; 
    }
    .options-list label { 
        display: block; 
        padding: 12px 15px; 
        background: var(--bg-color); 
        border-radius: 5px; 
        cursor: pointer;
        border: 1px solid var(--border-color);
        transition: background-color 0.2s, border-color 0.2s;
    }
    .options-list label:hover { 
        background-color: #e9e9e9; 
    }
    .options-list input[type="radio"] {
        margin-right: 10px;
    }
    
    /* Text Input (FIB) */
    .fib-input {
        width: 100%;
        padding: 12px;
        border: 1px solid var(--border-color);
        border-radius: 5px;
        font-size: 16px;
        background-color: var(--bg-color);
        color: var(--text-color);
        box-sizing: border-box; /* Important for width: 100% */
    }
    
    /* Submit Button */
    .submit-btn { 
        display: block; 
        width: calc(100% - 50px); /* 25px padding on each side */
        margin: 25px; 
        padding: 15px; 
        background-color: #007bff; 
        color: white; 
        border: none; 
        border-radius: 8px; 
        font-size: 18px; 
        font-weight: 600;
        cursor: pointer; 
    }
    .submit-btn:hover { 
        background-color: #0056b3; 
    }
</style>
</head>

<!-- Body ko 'page-container' class di hai taaki padding sahi rahe -->
<body class="page-container">

    <!-- 
    =====================================================================
        Reusable Navbar ko yahaan include kiya ja raha hai
        (Yahaan par aapki 'navbar.jsp' file ka sahi code hona zaroori hai)
    =====================================================================
    -->
    <jsp:include page="navbar.jsp" />
    
    
    <!-- 
    =====================================================================
        Sirf is Page ka Content
    =====================================================================
    -->
    <div class="quiz-container">
        <div class="quiz-header">
            <div class="quiz-title"><%= quiz.getTitle() %></div>
            <div id="timer">Loading...</div>
        </div>
        
        <!-- This form will submit all answers at once to our SubmitQuizServlet -->
        <form id="quizForm" action="submitQuiz" method="post">
        
            <%
                // Loop through all the questions
                for (int i = 0; i < questions.size(); i++) {
                    Question q = questions.get(i);
            %>
            
            <div class="question-block">
                <div class="question-text">
                    Q<%= (i + 1) %>: <%= q.getQuestionText() %>
                </div>
                
                <%-- YEH HAI NAYA HYBRID LOGIC --%>
                <% if ("MCQ".equals(q.getQuestionType())) { %>
                
                    <%-- MCQ (Multiple Choice) ---%>
                    <ul class="options-list">
                        <% 
                           // getOptionsList() humein ["Opt1", "Opt2", ...] dega
                           List<String> options = q.getOptionsList(); 
                           for (int j = 0; j < options.size(); j++) {
                               int optionValue = j + 1; // 1, 2, 3, or 4
                        %>
                        <li>
                            <label>
                                <!-- Value mein 1, 2, 3, ya 4 store hoga -->
                                <input type="radio" name="answer_<%= i %>" value="<%= optionValue %>" required> 
                                <%= options.get(j) %>
                            </label>
                        </li>
                        <% } %>
                    </ul>
                
                <% } else { %>
                
                    <%-- FIB (Fill in the Blank) ---%>
                    <div>
                        <!-- Name "answer_i" hi rahega -->
                        <input type="text" name="answer_<%= i %>" class="fib-input" 
                               placeholder="Type your answer here..." required>
                    </div>
                    
                <% } // End of if/else %>
                
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
                
                // Alert se pehle submit karein, taaki user alert band kare tab tak submit ho jaaye
                // (Submit before the alert, so it submits even if the user is slow to close the alert)
                if (quizForm) {
                    quizForm.submit();
                }
                alert("Time's up! Your quiz is being submitted automatically.");
                
            } else {
                // Calculate minutes and seconds
                const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
                const seconds = Math.floor((distance % (1000 * 60)) / 1000);
                
                // Display the time, adding a "0" if seconds < 10
                if(timerElement) {
                    timerElement.innerHTML = minutes + "m " + (seconds < 10 ? "0" : "") + seconds + "s";
                }
            }
        }
        
        // Run it once immediately so it doesn't say "Loading..."
        updateTimer();
    </script>

</body>
</html>