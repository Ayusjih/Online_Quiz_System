<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="com.quiz.model.User" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    User loggedInUser = (User) session.getAttribute("loggedInUser");

    String firstLetter = " ";
    String username = "User";
    String email = "No email set";
    String joinedDate = "N/A";
    boolean isAdmin = false;

    if (loggedInUser != null) {
        if(loggedInUser.getUsername() != null && !loggedInUser.getUsername().isEmpty()) {
            firstLetter = loggedInUser.getUsername().substring(0, 1).toUpperCase();
            username = loggedInUser.getUsername();
        }
        if(loggedInUser.getEmail() != null) {
            email = loggedInUser.getEmail();
        }
        if(loggedInUser.getCreatedAt() != null) {
            joinedDate = new SimpleDateFormat("MMM d, yyyy").format(loggedInUser.getCreatedAt());
        }
        isAdmin = loggedInUser.isAdmin();
    }
%>

<!-- 
=====================================================================
    COMMON CSS (HEADER, SIDEBAR, MODAL, DARK MODE)
=====================================================================
-->
<style>
    :root {
        --bg-color: #f0f2f5;
        --card-bg-color: #ffffff;
        --text-color: #1a2c3d;
        --text-color-light: #4a5568;
        --border-color: #e2e8f0;
        --header-bg: #ffffff;
        --shadow: 0 4px 12px rgba(0,0,0,0.05);
        --shadow-hover: 0 8px 16px rgba(0,0,0,0.08);
    }
    
    .dark-mode {
        --bg-color: #1a202c;
        --card-bg-color: #2d3748;
        --text-color: #e2e8f0;
        --text-color-light: #a0aec0;
        --border-color: #4a5568;
        --header-bg: #2d3748;
        --shadow: 0 4px 12px rgba(0,0,0,0.1);
        --shadow-hover: 0 8px 16px rgba(0,0,0,0.15);
    }
    
    body {
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif; 
        padding: 0; 
        margin: 0 0 80px 0; 
        background-color: var(--bg-color); 
        color: var(--text-color);
        transition: background-color 0.3s, color 0.3s;
    }
    
    .page-container {
        padding-top: 80px; 
    }

    .header-bar {
        background-color: var(--header-bg);
        padding: 12px 30px;
        box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-bottom: 1px solid var(--border-color);
        position: fixed; 
        top: 0;
        left: 0;
        right: 0;
        height: 50px; 
        z-index: 1000;
        transition: background-color 0.3s;
    }
    .header-title-link {
        text-decoration: none; 
    }
    .header-title { 
        font-size: 22px; 
        font-weight: 700;
        color: var(--text-color);
        margin: 0;
    }
    .profile-area {
        display: flex;
        align-items: center;
        gap: 15px;
    }
    .profile-info-header { 
        display: flex;
        align-items: center;
        gap: 8px;
        cursor: pointer;
        padding: 5px;
        border-radius: 8px;
        transition: background-color 0.2s;
    }
    .profile-info-header:hover { 
        background-color: var(--bg-color);
    }
    .profile-icon {
        width: 36px;
        height: 36px;
        border-radius: 50%;
        background-color: #e0e7ff;
        color: #4338ca;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 18px;
        font-weight: 600;
    }
    .profile-name-header {
        font-size: 15px;
        font-weight: 600;
        color: var(--text-color);
    }
    .logout-btn-header {
        background-color: var(--bg-color);
        color: #dc3545;
        border: 1px solid #dc3545;
        padding: 8px 12px;
        text-decoration: none;
        border-radius: 5px;
        font-weight: 600;
        font-size: 14px;
        transition: all 0.2s ease;
        cursor: pointer;
    }
    .logout-btn-header:hover {
        background-color: #dc3545;
        color: #ffffff;
    }


    .sidebar-overlay {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5);
        z-index: 2000;
        opacity: 0;
        visibility: hidden;
        transition: opacity 0.3s, visibility 0.3s;
    }
    .sidebar {
        position: fixed;
        top: 0;
        right: -350px; 
        width: 320px;
        height: 100%;
        background-color: var(--card-bg-color);
        box-shadow: -5px 0 15px rgba(0, 0, 0, 0.1);
        z-index: 2001;
        transition: right 0.3s ease-in-out;
        display: flex;
        flex-direction: column;
    }
    .sidebar.open {
        right: 0;
    }
    .sidebar-overlay.open {
        opacity: 1;
        visibility: visible;
    }
    .sidebar-header {
        padding: 20px;
        border-bottom: 1px solid var(--border-color);
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .sidebar-header h3 {
        margin: 0;
        font-size: 20px;
        color: var(--text-color);
    }
    .close-btn {
        background: none;
        border: none;
        font-size: 24px;
        cursor: pointer;
        color: var(--text-color-light);
    }
    .sidebar-body {
        padding: 20px;
        flex-grow: 1;
        overflow-y: auto;
    }
    .profile-info-sidebar { 
        display: flex;
        flex-direction: column;
        align-items: center;
        margin-bottom: 20px;
    }
    .profile-avatar-large {
        width: 80px;
        height: 80px;
        border-radius: 50%;
        background-color: #e0e7ff;
        color: #4338ca;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 40px;
        font-weight: 700;
        margin-bottom: 15px;
    }
    .profile-name-email {
        text-align: center;
    }
    .profile-name {
        font-size: 18px;
        font-weight: 600;
        color: var(--text-color);
        margin: 0;
    }
    .profile-email {
        font-size: 14px;
        color: var(--text-color-light);
        margin: 5px 0 0 0;
    }
    .profile-joined {
        font-size: 13px;
        color: var(--text-color-light);
        margin-top: 10px;
    }

    .dark-mode-toggle {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 15px;
        background-color: var(--bg-color);
        border-radius: 8px;
        margin: 20px 0;
    }
    .dark-mode-toggle span {
        font-weight: 500;
        color: var(--text-color);
    }
    .toggle-switch {
        position: relative;
        display: inline-block;
        width: 50px;
        height: 28px;
    }
    .toggle-switch input {
        opacity: 0;
        width: 0;
        height: 0;
    }
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
        background-color: #007bff;
    }
    input:checked + .slider:before {
        transform: translateX(22px);
    }
    
    .sidebar-footer {
        padding: 20px;
        border-top: 1px solid var(--border-color);
    }
    .sidebar-btn {
        display: block;
        width: 100%;
        padding: 12px;
        margin-bottom: 10px;
        border-radius: 8px;
        text-decoration: none;
        text-align: center;
        font-size: 15px;
        font-weight: 500;
        border: none;
        cursor: pointer;
        box-sizing: border-box; 
    }
    .edit-profile-btn {
        background-color: #007bff;
        color: white;
        transition: background-color 0.2s;
    }
    .edit-profile-btn:hover {
        background-color: #0056b3;
    }
    
    .admin-link {
        background-color: #ffc107;
        color: #333;
    }
    .admin-link:hover {
        background-color: #e0a800;
    }

    .modal-overlay {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.6);
        z-index: 3000;
        display: flex;
        align-items: center;
        justify-content: center;
        opacity: 0;
        visibility: hidden;
        transition: opacity 0.3s, visibility 0.3s;
    }
    .modal-overlay.open {
        opacity: 1;
        visibility: visible;
    }
    .modal {
        background-color: var(--card-bg-color);
        padding: 30px;
        border-radius: 12px;
        box-shadow: 0 5px 20px rgba(0, 0, 0, 0.2);
        max-width: 400px;
        width: 90%;
        text-align: center;
        transform: scale(0.9);
        transition: transform 0.3s;
    }
    .modal-overlay.open .modal {
        transform: scale(1);
    }
    .modal h3 {
        margin-top: 0;
        font-size: 22px;
        color: var(--text-color);
    }
    .modal p {
        font-size: 16px;
        color: var(--text-color-light);
        margin-bottom: 25px;
    }
    .modal-buttons {
        display: flex;
        gap: 10px;
        justify-content: center;
    }
    .modal-btn {
        padding: 10px 20px;
        border: none;
        border-radius: 8px;
        font-size: 16px;
        font-weight: 500;
        cursor: pointer;
        transition: background-color 0.2s;
    }
    .modal-btn-no {
        background-color: var(--bg-color);
        color: var(--text-color);
        border: 1px solid var(--border-color);
    }
    .modal-btn-no:hover {
        background-color: #e2e8f0;
    }
    .modal-btn-yes {
        background-color: #dc3545;
        color: white;
    }
    .modal-btn-yes:hover {
        background-color: #c82333;
    }

</style>

<!-- 1. Header Bar -->
<div class="header-bar">
    <a href="<%= isAdmin ? "admin_dashboard.jsp" : "dashboard.jsp" %>" class="header-title-link">
        <div class="header-title">
            <%= isAdmin ? "Admin Panel" : "Student Dashboard" %>
        </div>
    </a>
    
    <div class="profile-area">
        <div class="profile-info-header" id="openSidebarBtn">
            <div class="profile-icon">
                <%= firstLetter %>
            </div>
            <span class="profile-name-header">
                <%= username %>
            </span>
        </div>
        
        <button class="logout-btn-header" id="logoutBtnHeader">Logout</button>
    </div>
</div>

<!-- 2. Sidebar (Hidden by default) -->
<div class="sidebar-overlay" id="sidebarOverlay"></div>
<div class="sidebar" id="sidebar">
    
    <div class="sidebar-header">
        <h3>Profile & Settings</h3>
        <button class="close-btn" id="closeSidebarBtn">&times;</button>
    </div>
    
    <div class="sidebar-body">
        
        <div class="profile-info-sidebar">
            <div class="profile-avatar-large"><%= firstLetter %></div>
            <div class="profile-name-email">
                <h4 class="profile-name"><%= username %></h4>
                <p class="profile-email"><%= email %></p>
            </div>
            <div class="profile-joined">
                Joined: <%= joinedDate %>
            </div>
        </div>
        
        <div class="dark-mode-toggle">
            <span>Dark Mode 🌙☀️</span>
            <label class="toggle-switch">
                <input type="checkbox" id="darkModeToggle">
                <span class="slider"></span>
            </label>
        </div>
        
    </div>
    
    <div class="sidebar-footer">
        
        <% if (isAdmin) { %>
            <a href="admin_dashboard.jsp" class="sidebar-btn admin-link">Admin Dashboard</a>
        <% } else { %>
            <a href="dashboard.jsp" class="sidebar-btn edit-profile-btn">Student Dashboard</a>
        <% } %>
        
        <a href="edit_profile.jsp" class="sidebar-btn edit-profile-btn">Edit Profile</a>
    </div>
</div>

<!-- 3. Logout Modal (Hidden by default) -->
<div class="modal-overlay" id="logoutModal">
    <div class="modal">
        <h3>Logout</h3>
        <p>Are you sure you want to log out?</p>
        <div class="modal-buttons">
            <button class="modal-btn modal-btn-no" id="closeModalBtn">No, stay</button>
            <a href="logout" class="modal-btn modal-btn-yes" style="text-decoration:none;">Yes, logout</a>
        </div>
    </div>
</div>

<!-- 
=====================================================================
    COMMON JAVASCRIPT (SIDEBAR, MODAL, DARK MODE)
=====================================================================
-->
<script>
    (function() {
        
        var sidebar = document.getElementById('sidebar');
        var overlay = document.getElementById('sidebarOverlay');
        var openBtn = document.getElementById('openSidebarBtn');
        var closeBtn = document.getElementById('closeSidebarBtn');
        
        function openSidebar() {
            if(sidebar) sidebar.classList.add('open');
            if(overlay) overlay.classList.add('open');
        }
        function closeSidebar() {
            if(sidebar) sidebar.classList.remove('open');
            if(overlay) overlay.classList.remove('open');
        }
        
        if(openBtn) openBtn.addEventListener('click', openSidebar);
        if(closeBtn) closeBtn.addEventListener('click', closeSidebar);
        if(overlay) overlay.addEventListener('click', closeSidebar);

        var modal = document.getElementById('logoutModal');
        var openModalBtn = document.getElementById('logoutBtnHeader'); 
        var closeModalBtn = document.getElementById('closeModalBtn');
        
        function openModal() {
            if(modal) modal.classList.add('open');
        }
        function closeModal() {
            if(modal) modal.classList.remove('open');
        }

        if(openModalBtn) openModalBtn.addEventListener('click', openModal);
        if(closeModalBtn) closeModalBtn.addEventListener('click', closeModal);

        var toggle = document.getElementById('darkModeToggle');
        var body = document.body;
        var currentTheme = localStorage.getItem('theme');

        if (currentTheme === 'dark') {
            body.classList.add('dark-mode');
            if(toggle) toggle.checked = true;
        }

        function toggleTheme() {
            if (body.classList.contains('dark-mode')) {
                body.classList.remove('dark-mode');
                localStorage.setItem('theme', 'light');
            } else {
                body.classList.add('dark-mode');
                localStorage.setItem('theme', 'dark');
            }
        }

        if(toggle) toggle.addEventListener('change', toggleTheme);

    })();
</script>