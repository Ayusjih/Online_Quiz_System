package com.quiz.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.quiz.model.User;
import com.quiz.util.DBConnection;

public class UserDAO {

    /**
     * Validates a user's login credentials.
     * * @param username The username entered by the user.
     * @param password The password entered by the user.
     * @return A 'User' object if login is successful, otherwise 'null'.
     */
    public User validateUser(String username, String password) {
        
        User user = null; // We'll return this. It stays null if no user is found.
        
        // This is our SQL query. 
        // The '?' are placeholders we fill in securely.
        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";

        /*
         * This is a "try-with-resources" block. It's the modern,
         * safe way to handle database connections.
         * * Any "resource" (like a Connection or PreparedStatement)
         * declared inside the parentheses () will be AUTOMATICALLY
         * closed at the end, even if an error happens.
         * This prevents database leaks!
         */
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // 1. Securely set the parameters (the '?')
            ps.setString(1, username); // Sets the first '?' to the username
            ps.setString(2, password); // Sets the second '?' to the password

            // 2. Execute the query
            // We use executeQuery() because we expect a result (a 'SELECT' statement)
            try (ResultSet rs = ps.executeQuery()) {
                
                // 3. Check if we got any results
                // rs.next() moves to the first row of results.
                // If it returns 'true', it means we found a matching user.
                if (rs.next()) {
                    // We found the user!
                    // Create a new User object to hold their data.
                    user = new User();
                    
                    // Fill the User object with data from the database row
                    user.setUserId(rs.getInt("user_id"));
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password")); // (optional to set, but good)
                    user.setAdmin(rs.getBoolean("is_admin"));
                }
            }

        } catch (SQLException e) {
            // This will catch any database errors
            System.out.println("Error in UserDAO.validateUser: " + e.getMessage());
            e.printStackTrace();
        }

        // Return the User object.
        // If we found a user, this will be the populated object.
        // If no user was found (or an error happened), this will be 'null'.
        return user;
    }

    // --- We will add more methods here later, like createUser() ---

}