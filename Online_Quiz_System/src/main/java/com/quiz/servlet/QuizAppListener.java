package com.quiz.servlet;

import com.quiz.thread.QuizMonitorThread;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

/**
 * This class is triggered when the web application starts and stops.
 * We use it to start our background monitoring thread.
 */
@WebListener // This annotation auto-registers the listener with Tomcat
public class QuizAppListener implements ServletContextListener {

    private Thread monitorThread = null;

    /**
     * This method is called when your web app starts up.
     */
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // Create an instance of our runnable thread
        Runnable runnable = new QuizMonitorThread();
        
        // Create the actual Thread object
        monitorThread = new Thread(runnable);
        
        // Set as "daemon" so it doesn't prevent Tomcat from stopping
        monitorThread.setDaemon(true);
        
        // Start the thread!
        monitorThread.start();
    }

    /**
     * This method is called when your web app shuts down.
     */
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Stop our thread gracefully
        if (monitorThread != null) {
            monitorThread.interrupt();
        }
    }
}