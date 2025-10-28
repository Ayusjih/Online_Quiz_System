package com.quiz.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp; // Make sure this is imported

import com.quiz.model.User;
import com.quiz.util.DBConnection;

public class UserDAO {

    /**
     * Validates a user's login credentials.
     * @param username The username entered by the user.
     * @param password The password entered by the user.
     * @return A 'User' object if login is successful, otherwise 'null'.
     */
    public User validateUser(String username, String password) {
        
        User user = null; 
        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                
                if (rs.next()) {
                    user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password")); 
                    user.setAdmin(rs.getBoolean("is_admin"));
                    
                    // --- UPDATED ---
                    // Fetch the new details
                    user.setEmail(rs.getString("email"));
                    user.setCreatedAt(rs.getTimestamp("created_at"));
                }
            }

        } catch (SQLException e) {
            System.out.println("Error in UserDAO.validateUser: " + e.getMessage());
            e.printStackTrace();
        }
        
        return user;
    }

    // --- [ NEW METHOD ] ---
    // Add this new method to your UserDAO.java file
    /**
     * Updates a user's profile information (email and password).
     * @param user The User object containing the userId and new details.
     * @return true if update was successful, false otherwise.
     */
    public boolean updateUser(User user) {
        // We will only update email and password.
        // We can add more fields here later if needed.
        String sql = "UPDATE users SET email = ?, password = ? WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getEmail());
            ps.setString(2, user.getPassword());
            ps.setInt(3, user.getUserId());

            int rowsAffected = ps.executeUpdate();
            
            // executeUpdate() returns the number of rows changed.
            // If it's more than 0, the update was successful.
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.out.println("Error in UserDAO.updateUser: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}

