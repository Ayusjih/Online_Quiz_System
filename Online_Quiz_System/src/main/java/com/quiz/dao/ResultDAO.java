package com.quiz.dao;
import java.sql.Statement;
import java.util.Map;
import java.sql.Connection;
import com.quiz.model.ResultDetails;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;
import java.sql.ResultSet;
import java.util.ArrayList;
import com.quiz.model.Result;
import com.quiz.util.DBConnection;
import com.quiz.model.AnswerDetail;

public class ResultDAO {

    /**
     * Saves a quiz result to the database.
     * @param result The Result object to save.
     */
public void saveResult(Result result, Map<Integer, Integer> answers) {
        
        String sqlResult = "INSERT INTO results (user_id, quiz_id, score) VALUES (?, ?, ?)";
        String sqlAnswer = "INSERT INTO result_answers (result_id, question_id, user_answer) VALUES (?, ?, ?)";
        
        Connection conn = null;
        PreparedStatement psResult = null;
        PreparedStatement psAnswer = null;

        try {
            conn = DBConnection.getConnection();
            // --- Start Transaction ---
            conn.setAutoCommit(false); 
            
            // 1. Save the main result and get the new result_id
            psResult = conn.prepareStatement(sqlResult, Statement.RETURN_GENERATED_KEYS);
            psResult.setInt(1, result.getUserId());
            psResult.setInt(2, result.getQuizId());
            psResult.setInt(3, result.getScore());
            psResult.executeUpdate();
            
            // Get the newly generated result_id
            int newResultId = -1;
            try (ResultSet rs = psResult.getGeneratedKeys()) {
                if (rs.next()) {
                    newResultId = rs.getInt(1);
                } else {
                    throw new SQLException("Creating result failed, no ID obtained.");
                }
            }
            
            // 2. Save all the individual answers
            psAnswer = conn.prepareStatement(sqlAnswer);
            
            // Loop through the map of answers
            for (Map.Entry<Integer, Integer> entry : answers.entrySet()) {
                psAnswer.setInt(1, newResultId);
                psAnswer.setInt(2, entry.getKey());   // questionId
                psAnswer.setInt(3, entry.getValue()); // userAnswer
                psAnswer.addBatch(); // Add to a batch for efficient saving
            }
            psAnswer.executeBatch(); // Execute all inserts at once

            // --- If everything is OK, commit the changes ---
            conn.commit(); 
            
        } catch (SQLException e) {
            System.out.println("Error in ResultDAO.saveResult transaction: " + e.getMessage());
            // --- If anything fails, roll back all changes ---
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
        } finally {
            // --- Clean up ---
            try {
                if (psResult != null) psResult.close();
                if (psAnswer != null) psAnswer.close();
                if (conn != null) {
                    conn.setAutoCommit(true); // Reset to default
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
}    
    
    public List<ResultDetails> getAllResultDetails() {
        List<ResultDetails> resultsList = new ArrayList<>();
        
        // This is our JOIN query.
        String sql = "SELECT r.result_id, u.username,u.username, q.title, r.score, r.date_taken " +
                     "FROM results r " +
                     "JOIN users u ON r.user_id = u.user_id " +
                     "JOIN quizzes q ON r.quiz_id = q.quiz_id";
                     // We can add "ORDER BY r.date_taken DESC" to show newest first

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ResultDetails details = new ResultDetails();
                details.setUsername(rs.getString("username"));
                details.setQuizTitle(rs.getString("title"));
                details.setScore(rs.getInt("score"));
                details.setDateTaken(rs.getTimestamp("date_taken"));
                details.setResultId(rs.getInt("result_id"));
                
                resultsList.add(details);
            }

        } catch (SQLException e) {
            System.out.println("Error in ResultDAO.getAllResultDetails: " + e.getMessage());
            e.printStackTrace();
        }
        
        return resultsList;
    }
    /**
     * Fetches a detailed list of answers for a single quiz result.
     * @param resultId The ID of the result we want to inspect.
     * @return A List of AnswerDetail objects.
     */
    public List<AnswerDetail> getResultAnswers(int resultId) {
        List<AnswerDetail> answerList = new ArrayList<>();
        
        // This query JOINS the answers table with the questions table
        String sql = "SELECT q.question_text, q.option1, q.option2, q.option3, q.option4, " +
                     "q.correct_answer, ra.user_answer " +
                     "FROM result_answers ra " +
                     "JOIN questions q ON ra.question_id = q.question_id " +
                     "WHERE ra.result_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, resultId); // Set the result_id we are looking for
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AnswerDetail detail = new AnswerDetail();
                    detail.setQuestionText(rs.getString("question_text"));
                    detail.setOption1(rs.getString("option1"));
                    detail.setOption2(rs.getString("option2"));
                    detail.setOption3(rs.getString("option3"));
                    detail.setOption4(rs.getString("option4"));
                    detail.setCorrectAnswer(rs.getInt("correct_answer"));
                    detail.setUserAnswer(rs.getInt("user_answer"));
                    
                    answerList.add(detail);
                }
            }

        } catch (SQLException e) {
            System.out.println("Error in ResultDAO.getResultAnswers: " + e.getMessage());
            e.printStackTrace();
        }
        
        return answerList;
    }
    
    
    
    
}