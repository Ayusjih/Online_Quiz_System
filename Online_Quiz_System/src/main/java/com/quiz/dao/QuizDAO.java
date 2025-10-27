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
	/**
     * Adds a new quiz to the database.
     * @param quiz The Quiz object containing the title and duration.
     */
    public void addQuiz(Quiz quiz) {
        String sql = "INSERT INTO quizzes (title, duration_minutes) VALUES (?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, quiz.getTitle());
            ps.setInt(2, quiz.getDurationMinutes());

            ps.executeUpdate(); // Use executeUpdate() for INSERT

        } catch (SQLException e) {
            System.out.println("Error in QuizDAO.addQuiz: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Deletes a quiz (and all its questions) from the database.
     * @param quizId The ID of the quiz to delete.
     */
    public void deleteQuiz(int quizId) {
        // We must delete questions first due to the FOREIGN KEY constraint
        String deleteQuestionsSql = "DELETE FROM questions WHERE quiz_id = ?";
        String deleteQuizSql = "DELETE FROM quizzes WHERE quiz_id = ?";

        try (Connection conn = DBConnection.getConnection()) {
            
            // Turn off auto-commit to run this as a "transaction"
            conn.setAutoCommit(false); 

            // 1. Delete associated questions
            try (PreparedStatement psQuestions = conn.prepareStatement(deleteQuestionsSql)) {
                psQuestions.setInt(1, quizId);
                psQuestions.executeUpdate();
            }
            
            // 2. Delete the quiz itself
            try (PreparedStatement psQuiz = conn.prepareStatement(deleteQuizSql)) {
                psQuiz.setInt(1, quizId);
                int rowsAffected = psQuiz.executeUpdate();
                
                if (rowsAffected == 0) {
                	throw new SQLException("Deleting quiz failed, no rows affected.");
                }
            }

            // If both deletes succeed, commit the changes
            conn.commit(); 

        } catch (SQLException e) {
            System.out.println("Error in QuizDAO.deleteQuiz: " + e.getMessage());
            e.printStackTrace();
            // We don't have a conn.rollback() here because try-with-resources
            // will close the connection, and any uncommitted changes are
            // automatically rolled back.
        }
    }
}