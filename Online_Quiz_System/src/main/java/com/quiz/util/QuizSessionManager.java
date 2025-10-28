package com.quiz.util;

import java.util.Collection;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import jakarta.servlet.http.HttpSession;

/**
 * A thread-safe, global manager to track all active quiz sessions.
 * This class is a "Singleton" (it only has static methods).
 */
public class QuizSessionManager {

    // A ConcurrentHashMap is thread-safe. This is critical for multithreading.
    // We map the unique Session ID (String) to the Session object itself.
    private static Map<String, HttpSession> activeSessions = new ConcurrentHashMap<>();

    /**
     * Adds a new quiz session to be monitored.
     * @param session The user's session that just started a quiz.
     */
    public static void add(HttpSession session) {
        activeSessions.put(session.getId(), session);
        System.out.println("MONITOR: Added session " + session.getId() + ". Total: " + activeSessions.size());
    }

    /**
     * Removes a session from monitoring (because it was submitted or timed out).
     * @param session The user's session.
     */
    public static void remove(HttpSession session) {
        if (session != null) {
            activeSessions.remove(session.getId());
            System.out.println("MONITOR: Removed session " + session.getId() + ". Total: " + activeSessions.size());
        }
    }

    /**
     * Gets all currently active sessions for the monitor thread to check.
     * @return A Collection of all active HttpSessions.
     */
    public static Collection<HttpSession> getActiveSessions() {
        return activeSessions.values();
    }
}