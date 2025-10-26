package com.quiz.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.quiz.model.Result;
import com.quiz.util.DBConnection;

public class ResultDAO {

    /**
     * Saves a quiz result to the database.
     * @param result The Result object to save.
     */
    public void saveResult(Result result) {
        
        String sql = "INSERT INTO results (user_id, quiz_id, score) VALUES (?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // Set the parameters for the INSERT statement
            ps.setInt(1, result.getUserId());
            ps.setInt(2, result.getQuizId());
            ps.setInt(3, result.getScore());

            // We use executeUpdate() for INSERT, UPDATE, or DELETE
            ps.executeUpdate(); 

        } catch (SQLException e) {
            System.out.println("Error in ResultDAO.saveResult: " + e.getMessage());
            e.printStackTrace();
        }
    }
}