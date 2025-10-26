package com.quiz.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.quiz.model.Quiz;
import com.quiz.util.DBConnection;

public class QuizDAO {

    /**
     * Fetches all quizzes from the database.
     * @return A List of Quiz objects.
     */

    public List<Quiz> getAllQuizzes() {
        // We'll return this list.
        List<Quiz> quizList = new ArrayList<>();
        
        String sql = "SELECT * FROM quizzes";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            // rs.next() will be true for each row found
            while (rs.next()) {
                // Create a new Quiz object for each row
                Quiz quiz = new Quiz();
                
                // Fill the object with data from the row
                quiz.setQuizId(rs.getInt("quiz_id"));
                quiz.setTitle(rs.getString("title"));
                quiz.setDurationMinutes(rs.getInt("duration_minutes"));
                
                // Add the populated object to our list
                quizList.add(quiz);
            }

        } catch (SQLException e) {
            System.out.println("Error in QuizDAO.getAllQuizzes: " + e.getMessage());
            e.printStackTrace();
        }

        // Return the list (it might be empty if no quizzes are found)
        return quizList;
    }
    

	public Quiz getQuizById(int quizId) {
        Quiz quiz = null;
        String sql = "SELECT * FROM quizzes WHERE quiz_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, quizId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    quiz = new Quiz();
                    quiz.setQuizId(rs.getInt("quiz_id"));
                    quiz.setTitle(rs.getString("title"));
                    quiz.setDurationMinutes(rs.getInt("duration_minutes"));
                }
            }

        } catch (SQLException e) {
            System.out.println("Error in QuizDAO.getQuizById: " + e.getMessage());
            e.printStackTrace();
        }
        
        return quiz;
    }
	
    // --- We will add getQuizById() later ---
}