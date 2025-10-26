package com.quiz.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    // --- !! IMPORTANT !! ---
    // Update these variables to match your MySQL setup
    private static final String DB_URL = "jdbc:mysql://localhost:3306/quiz_db";
    private static final String DB_USER = "root"; // <-- Change this to your MySQL username
    private static final String DB_PASSWORD = "1234"; // <-- Change this to your MySQL password
    // -----------------------

    private static Connection connection = null;

    /**
     * Gets a connection to the database.
     * @return A Connection object or null if connection fails.
     */
    public static Connection getConnection() {
        try {
            // 1. Load the JDBC driver
            // This line tells the application to find the .jar file we added.
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // 2. Attempt to establish the connection
            connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            
            System.out.println("--- Database Connection Successful! ---");

        } catch (ClassNotFoundException e) {
            System.out.println("--- MySQL JDBC Driver not found! ---");
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("--- Database Connection Failed! ---");
            e.printStackTrace();
        }
        
        return connection;
    }
}