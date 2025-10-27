Online Quiz Platform (Java Web Application)

A feature-rich web application built with Java, Servlets, and JDBC, providing a platform for students to take quizzes and for admins to manage all content.

<img width="1872" height="800" alt="image" src="https://github.com/user-attachments/assets/fad4e9cb-79f8-4a15-954a-c2a1d7762edb" />


🚀 Core Features

1. Student Module

Secure Login: Students can log in with their credentials.

Professional Dashboard: A modern, clean dashboard shows all available quizzes.

Timed Quizzes: Each quiz has a server-side and client-side timer.

Instant Results: Students see their score (percentage) immediately after submission.

2. Admin Panel

Role-Based Access: Separate, secure dashboard for admin users (checks is_admin flag).

Manage Quizzes: Full CRUD (Create, Read, Delete) functionality for quizzes.

Manage Questions: Admins can select a quiz, and then CRUD (Create, Read, Delete) questions for it.

View All Results: Admins can view a detailed history of all quizzes taken by all students.

Detailed Answer Review: Admins can click "Details" on any result to see a question-by-question review of the user's answers (showing correct vs. wrong).

3. Advanced Backend

Multithreading: A server-side QuizMonitorThread runs in the background, tracking all active quizzes. It uses a ServletContextListener to start on server boot and a ConcurrentHashMap for thread-safe session management.

Database Transactions: Used in deleteQuiz and saveResult to ensure data integrity (e.g., if saving an answer fails, the entire result is rolled back).

DAO Pattern: Fully abstracted database layer (UserDAO, QuizDAO, QuestionDAO, ResultDAO) to separate business logic from data access.

🛠️ Technology Stack

Language: Java (JDK 24)

Backend: Java Servlets

Database: MySQL

Database Driver: JDBC (MySQL Connector/J)

Server: Apache Tomcat 11

Frontend: JSP (Jakarta Server Pages), HTML5, CSS3

Concurrency: java.lang.Thread, java.util.concurrent.ConcurrentHashMap

IDE: Eclipse JEE

📸 Screenshots

USER DASHBOARD ---> <img width="1903" height="809" alt="image" src="https://github.com/user-attachments/assets/aab5a1a2-8f65-4b28-afd5-452e923ea47f" />

QUIZ ---> <img width="1754" height="908" alt="image" src="https://github.com/user-attachments/assets/4cd00675-c905-4108-bb4d-d1b7f2600b81" />

RESULT ---> <img width="1466" height="740" alt="image" src="https://github.com/user-attachments/assets/5330b158-716b-4c4b-9616-ab84a18ef4ce" />
ADMIN DASHBOARD ---> <img width="1913" height="530" alt="image" src="https://github.com/user-attachments/assets/c647673a-1ead-4098-978e-d67905c0cbe2" />
<img width="1911" height="562" alt="image" src="https://github.com/user-attachments/assets/0a7a0fde-938c-4ae6-9f8a-f4b31ca5b965" />
<img width="1919" height="879" alt="image" src="https://github.com/user-attachments/assets/1b5b5014-8606-414b-abb8-34f14fe13af2" />
<img width="1894" height="412" alt="image" src="https://github.com/user-attachments/assets/2284491d-0323-4334-9180-61177e1de2ac" />
<img width="1907" height="846" alt="image" src="https://github.com/user-attachments/assets/bd575dca-acaf-4dbf-bdab-c89448862329" />
