package com.quiz.thread;

import java.util.Collection;

import com.quiz.model.Quiz;
import com.quiz.util.QuizSessionManager;

import jakarta.servlet.http.HttpSession;

/**
 * This is our background thread. It runs in an infinite loop
 * checking every active quiz to see if its time is up.
 */
public class QuizMonitorThread implements Runnable {

    // How often (in milliseconds) the thread should wake up and check.
    private static final int CHECK_INTERVAL = 5000; // 5 seconds

    @Override
    public void run() {
        System.out.println("--- Quiz Monitor Thread Started! ---");
        
        try {
            // This is the infinite loop for our thread
            while (true) {
                
                // Get all sessions that are currently taking a quiz
                Collection<HttpSession> sessions = QuizSessionManager.getActiveSessions();

                for (HttpSession session : sessions) {
                    try {
                        // Get the quiz data from the session
                        Quiz quiz = (Quiz) session.getAttribute("currentQuiz");
                        Long startTime = (Long) session.getAttribute("startTime");

                        // If data is missing (e.g., session expired), remove it
                        if (quiz == null || startTime == null) {
                            QuizSessionManager.remove(session);
                            continue; // Go to the next session
                        }

                        // --- The Main Timer Logic ---
                        long durationInMillis = quiz.getDurationMinutes() * 60 * 1000;
                        long endTime = startTime + durationInMillis;

                        // Check if the current time is past the end time
                        if (System.currentTimeMillis() > endTime) {
                            
                            // --- TIME IS UP! ---
                            System.out.println("--- SERVER TIME UP for session: " + session.getId());
                            
                            // Set the "TIME_UP" flag in the user's session.
                            session.setAttribute("TIME_UP", true);
                            
                            // Stop monitoring this session
                            QuizSessionManager.remove(session);
                        }
                        
                    } catch (Exception e) {
                        // Catch errors from a single session (e.g., session invalidated)
                        System.out.println("Error processing session " + session.getId() + ": " + e.getMessage());
                        QuizSessionManager.remove(session);
                    }
                }

                // Put the thread to sleep for 5 seconds before checking again
                Thread.sleep(CHECK_INTERVAL);
                
            }
        } catch (InterruptedException e) {
            // This happens if the thread is "woken up" to be shut down
            System.out.println("--- Quiz Monitor Thread Interrupted and Stopping. ---");
        }
    }
}