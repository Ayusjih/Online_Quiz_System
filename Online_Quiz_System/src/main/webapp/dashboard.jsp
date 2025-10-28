<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.quiz.model.User" %>
<%@ page import="com.quiz.dao.QuizDAO" %>
<%@ page import="com.quiz.model.Quiz" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    // --- Security Check ---
    User user = (User) session.getAttribute("loggedInUser");
    if (user == null || user.isAdmin()) { // Admins should not be here
        response.sendRedirect("login.jsp");
        return; 
    }
    
    // --- Get Data for Quizzes ---
    QuizDAO quizDAO = new QuizDAO();
    List<Quiz> quizzes = quizDAO.getAllQuizzes();
    
    // --- Format Joined Date ---
    String joinedDate = "N/A";
    if (user.getCreatedAt() != null) {
        // Format: "October 28, 2025"
        joinedDate = new SimpleDateFormat("MMMM d, yyyy").format(user.getCreatedAt());
    }
    
    // --- Get first letter for avatar ---
    String firstLetter = String.valueOf(user.getUsername().charAt(0)).toUpperCase();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard</title>
<style>
    /* --- Base & Dark Mode --- */
    :root {
        --bg-color: #f0f2f5;
        --card-bg: #ffffff;
        --text-color: #1a2c3d;
        --text-color-light: #4a5568;
        --border-color: #e2e8f0;
        --shadow: 0 4px 12px rgba(0,0,0,0.05);
        --shadow-hover: 0 8px 16px rgba(0,0,0,0.08);
        --accent-color: #007bff;
        --accent-color-hover: #0056b3;
        --green-color: #28a745;
        --green-color-hover: #218838;
        --red-color: #dc3545;
        --red-color-hover: #c82333;
    }
    
    .dark-mode {
        --bg-color: #1a202c;
        --card-bg: #2d3748;
        --text-color: #edf2f7;
        --text-color-light: #a0aec0;
        --border-color: #4a5568;
        --shadow: 0 4px 12px rgba(0,0,0,0.1);
        --shadow-hover: 0 8px 16px rgba(0,0,0,0.15);
    }
    
    body {
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif;
        padding: 0;
        margin: 0 0 0 0; /* Make space for header */
        background-color: var(--bg-color);
        color: var(--text-color);
        transition: background-color 0.3s, color 0.3s;
    }
    
    /* --- Header Bar --- */
    .header-bar {
        background-color: var(--card-bg);
        padding: 12px 30px;
        box-shadow: var(--shadow);
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-bottom: 1px solid var(--border-color);
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        z-index: 1000;
        transition: background-color 0.3s, border-color 0.3s;
    }
    .header-title {
        font-size: 22px;
        font-weight: 700;
        color: var(--text-color);
        margin: 0;
    }
    .profile-avatar {
        width: 36px;
        height: 36px;
        border-radius: 50%;
        background-color: var(--accent-color);
        color: white;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: 600;
        font-size: 18px;
        cursor: pointer;
        user-select: none;
    }
    
    /* --- Main Content --- */
    .container {
        max-width: 900px;
        margin: 100px auto 40px auto; /* Start below fixed header */
        padding: 20px;
    }
    .welcome-text {
        font-size: 24px;
        font-weight: 600;
        margin-bottom: 25px;
        color: var(--text-color);
    }
    
    /* Quiz Card Styling */
    .quiz-list {
        display: grid;
        gap: 20px;
    }
    .quiz-card {
        background: var(--card-bg);
        border-radius: 12px;
        box-shadow: var(--shadow);
        border: 1px solid var(--border-color);
        display: flex;
        flex-direction: column;
        overflow: hidden;
        transition: all 0.2s ease-in-out;
    }
    .quiz-card:hover {
        transform: translateY(-5px);
        box-shadow: var(--shadow-hover);
    }
    .quiz-card-content {
        padding: 25px;
        flex-grow: 1;
    }
    .quiz-card-header {
        display: flex;
        align-items: center;
        gap: 12px;
        margin-bottom: 10px;
    }
    .quiz-icon {
        width: 24px;
        height: 24px;
        color: var(--accent-color);
    }
    .quiz-title {
        font-size: 20px;
        font-weight: 600;
        color: var(--text-color);
        margin: 0;
    }
    .quiz-duration {
        font-size: 14px;
        color: var(--text-color-light);
    }
    .quiz-card-footer {
        padding: 20px 25px;
        background-color: var(--bg-color);
        border-top: 1px solid var(--border-color);
        transition: background-color 0.3s, border-color 0.3s;
    }
    .start-btn {
        display: block;
        width: 100%;
        padding: 12px 15px;
        background-color: var(--green-color);
        color: white;
        text-decoration: none;
        border-radius: 8px;
        font-size: 16px;
        font-weight: 600;
        text-align: center;
        transition: background-color 0.2s ease;
    }
    .start-btn:hover {
        background-color: var(--green-color-hover);
    }

    /* --- Sidebar --- */
    .sidebar {
        position: fixed;
        top: 0;
        right: -350px; /* Start off-screen */
        width: 320px;
        height: 100%;
        background-color: var(--card-bg);
        box-shadow: -5px 0 15px rgba(0,0,0,0.1);
        z-index: 1002;
        transition: right 0.4s ease;
        display: flex;
        flex-direction: column;
    }
    .sidebar.show {
        right: 0;
    }
    .sidebar-header {
        padding: 20px;
        border-bottom: 1px solid var(--border-color);
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .sidebar-title {
        font-size: 20px;
        font-weight: 600;
        color: var(--text-color);
    }
    .sidebar-close-btn {
        font-size: 28px;
        cursor: pointer;
        color: var(--text-color-light);
        background: none;
        border: none;
        padding: 0;
    }
    .sidebar-body {
        padding: 25px;
        flex-grow: 1;
    }
    .profile-info {
        display: flex;
        align-items: center;
        gap: 15px;
        margin-bottom: 25px;
    }
    .profile-avatar-large {
        width: 60px;
        height: 60px;
        border-radius: 50%;
        background-color: var(--accent-color);
        color: white;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: 700;
        font-size: 28px;
        flex-shrink: 0; /* Don't shrink */
    }
    .profile-name-email {
        overflow: hidden; /* Handle long text */
    }
    .profile-name {
        font-size: 18px;
        font-weight: 600;
        color: var(--text-color);
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }
    .profile-email {
        font-size: 14px;
        color: var(--text-color-light);
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }
    .profile-joined {
        font-size: 14px;
        color: var(--text-color-light);
        background-color: var(--bg-color);
        padding: 10px;
        border-radius: 8px;
        text-align: center;
        margin-bottom: 25px;
    }
    
    /* Dark Mode Toggle */
    .dark-mode-toggle {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 10px 0;
        font-size: 16px;
        font-weight: 500;
    }
    .toggle-switch {
        position: relative;
        display: inline-block;
        width: 50px;
        height: 28px;
    }
    .toggle-switch input { opacity: 0; width: 0; height: 0; }
    .slider {
        position: absolute;
        cursor: pointer;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background-color: #ccc;
        transition: 0.4s;
        border-radius: 34px;
    }
    .slider:before {
        position: absolute;
        content: "";
        height: 20px;
        width: 20px;
        left: 4px;
        bottom: 4px;
        background-color: white;
        transition: 0.4s;
        border-radius: 50%;
    }
    input:checked + .slider {
        background-color: var(--accent-color);
    }
    input:checked + .slider:before {
        transform: translateX(22px);
    }
    
    /* Sidebar Footer Buttons */
    .sidebar-footer {
        padding: 20px;
        border-top: 1px solid var(--border-color);
        display: grid;
        gap: 10px;
    }
    .sidebar-btn {
        display: block;
        padding: 12px;
        text-align: center;
        text-decoration: none;
        border-radius: 8px;
        font-size: 15px;
        font-weight: 600;
        transition: all 0.2s ease;
    }
    .btn-edit-profile {
        background-color: var(--accent-color);
        color: white;
    }
    .btn-edit-profile:hover {
        background-color: var(--accent-color-hover);
    }
    .btn-logout {
        background-color: var(--bg-color);
        color: var(--red-color);
        border: 1px solid var(--red-color);
    }
    .btn-logout:hover {
        background-color: var(--red-color);
        color: white;
    }
    
    /* --- Modal --- */
    .modal-backdrop {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0,0,0,0.5);
        z-index: 1003;
        display: none; /* Hidden by default */
        align-items: center;
        justify-content: center;
    }
    .modal-backdrop.show {
        display: flex;
    }
    .modal {
        background: var(--card-bg);
        border-radius: 12px;
        padding: 30px;
        width: 90%;
        max-width: 400px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        text-align: center;
    }
    .modal-title {
        font-size: 22px;
        font-weight: 600;
        color: var(--text-color);
        margin-bottom: 15px;
    }
    .modal-body {
        font-size: 16px;
        color: var(--text-color-light);
        margin-bottom: 30px;
    }
    .modal-actions {
        display: flex;
        gap: 15px;
    }
    .modal-btn {
        flex: 1;
        padding: 12px;
        border-radius: 8px;
        font-size: 16px;
        font-weight: 600;
        cursor: pointer;
        border: none;
        text-decoration: none;
    }
    .btn-cancel {
        background-color: var(--bg-color);
        color: var(--text-color-light);
        border: 1px solid var(--border-color);
    }
    .btn-confirm-logout {
        background-color: var(--red-color);
        color: white;
    }
    
    /* --- Overlay for Sidebar --- */
    .overlay {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0,0,0,0.4);
        z-index: 1001;
        display: none; /* Hidden by default */
    }
    .overlay.show {
        display: block;
    }

</style>
</head>
<body>

    <!-- --- Header --- -->
    <div class="header-bar">
        <div class="header-title">Student Dashboard</div>
        <div class="profile-avatar" id="profileIcon"><%= firstLetter %></div>
    </div>

    <!-- --- Main Content --- -->
    <div class="container">
        <p class="welcome-text">Welcome, <%= user.getUsername() %>. Choose a quiz to get started.</p>
    
        <div class="quiz-list">
        
            <% for (Quiz quiz : quizzes) { %>
                <div class="quiz-card">
                    <div class="quiz-card-content">
                        <div class="quiz-card-header">
                            <svg class="quiz-icon" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                              <path stroke-linecap="round" stroke-linejoin="round" d="M9.75 3.104v5.714a2.25 2.25 0 01-.659 1.591L5 14.5M9.75 3.104c-.251.023-.501.05-.75.082m.75-.082a24.301 24.301 0 014.5 0m0 0v5.714c0 .597.237 1.17.659 1.591L19.8 15.3M14.25 3.104c.251.023.501.05.75.082M19.8 15.3l-1.57.393A9.003 9.003 0 0112 21a9.003 9.003 0 01-6.23-.907L4.2 15.3m15.6 0l-1.57-.393m0 0l-1.57 3.932m-12.46 0l1.57-3.932" />
                            </svg>
                            <h3 class="quiz-title"><%= quiz.getTitle() %></h3>
                        </div>
                        <p class="quiz-duration">Duration: <%= quiz.getDurationMinutes() %> minutes</p>
                    </div>
                    <div class="quiz-card-footer">
                        <a href="startQuiz?quizId=<%= quiz.getQuizId() %>" class="start-btn">Start Quiz</a>
                    </div>
                </div>
            <% } %>
            
            <% if (quizzes.isEmpty()) { %>
                <p>No quizzes are available at this time.</p>
            <% } %>
            
        </div>
    </div>

    <!-- --- Sidebar (Profile, Dark Mode, Logout) --- -->
    <div class="sidebar" id="profileSidebar">
        <!-- Sidebar Header -->
        <div class="sidebar-header">
            <h3 class="sidebar-title">My Profile</h3>
            <button class="sidebar-close-btn" id="closeSidebarBtn">&times;</button>
        </div>
        
        <!-- Sidebar Body -->
        <div class="sidebar-body">
            <!-- Profile Info -->
            <div class="profile-info">
                <div class="profile-avatar-large"><%= firstLetter %></div>
                <div class="profile-name-email">
                    <div class="profile-name"><%= user.getUsername() %></div>
                    <div class="profile-email"><%= user.getEmail() != null ? user.getEmail() : "No email set" %></div>
                </div>
            </div>
            
            <div class="profile-joined">
                Joined: <%= joinedDate %>
            </div>

            <!-- Dark Mode Toggle -->
            <div class="dark-mode-toggle">
                <span>Dark Mode</span>
                <label class="toggle-switch">
                    <input type="checkbox" id="darkModeToggle">
                    <span class="slider"></span>
                </label>
            </div>
        </div>
        
        <!-- Sidebar Footer -->
        <div class="sidebar-footer">
            <a href="edit_profile.jsp" class="sidebar-btn btn-edit-profile">Edit Profile</a>
            <button class="sidebar-btn btn-logout" id="logoutBtn">Logout</button>
        </div>
    </div>
    
    <!-- --- Logout Confirmation Modal --- -->
    <div class="modal-backdrop" id="logoutModal">
        <div class="modal">
            <h3 class="modal-title">Confirm Logout</h3>
            <p class="modal-body">Are you sure you want to log out?</p>
            <div class="modal-actions">
                <button class="modal-btn btn-cancel" id="cancelLogoutBtn">Cancel</button>
                <a href="logout" class="modal-btn btn-confirm-logout">Yes, Logout</a>
            </div>
        </div>
    </div>
    
    <!-- --- Overlay (for closing sidebar) --- -->
    <div class="overlay" id="pageOverlay"></div>


    <script>
        // --- Sidebar Logic ---
        const profileIcon = document.getElementById('profileIcon');
        const profileSidebar = document.getElementById('profileSidebar');
        const closeSidebarBtn = document.getElementById('closeSidebarBtn');
        const pageOverlay = document.getElementById('pageOverlay');

        function openSidebar() {
            profileSidebar.classList.add('show');
            pageOverlay.classList.add('show');
        }

        function closeSidebar() {
            profileSidebar.classList.remove('show');
            pageOverlay.classList.remove('show');
        }

        profileIcon.addEventListener('click', openSidebar);
        closeSidebarBtn.addEventListener('click', closeSidebar);
        pageOverlay.addEventListener('click', closeSidebar);

        // --- Logout Modal Logic ---
        const logoutBtn = document.getElementById('logoutBtn');
        const logoutModal = document.getElementById('logoutModal');
        const cancelLogoutBtn = document.getElementById('cancelLogoutBtn');

        logoutBtn.addEventListener('click', () => {
            logoutModal.classList.add('show');
            closeSidebar(); // Close sidebar when modal opens
        });

        cancelLogoutBtn.addEventListener('click', () => {
            logoutModal.classList.remove('show');
        });

        // --- Dark Mode Logic ---
        const darkModeToggle = document.getElementById('darkModeToggle');
        const docBody = document.body;

        // Check for saved preference
        if (localStorage.getItem('theme') === 'dark') {
            docBody.classList.add('dark-mode');
            darkModeToggle.checked = true;
        }

        darkModeToggle.addEventListener('change', () => {
            if (darkModeToggle.checked) {
                docBody.classList.add('dark-mode');
                localStorage.setItem('theme', 'dark');
            } else {
                docBody.classList.remove('dark-mode');
                localStorage.setItem('theme', 'light');
            }
        });
    </script>
</body>
</html>

