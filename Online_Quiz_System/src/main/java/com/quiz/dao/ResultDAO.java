package com.quiz.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import com.quiz.model.AnswerDetail;
import com.quiz.model.Result;
import com.quiz.model.ResultDetails;
import com.quiz.util.DBConnection;

public class ResultDAO {

    // (saveResult) - Ab Map<Integer, String> accept karega
    public void saveResult(Result result, Map<Integer, String> answers) {
        
        String sqlResult = "INSERT INTO results (user_id, quiz_id, score) VALUES (?, ?, ?)";
        // 'user_answer' ab String (VARCHAR) hai
        String sqlAnswer = "INSERT INTO result_answers (result_id, question_id, user_answer) VALUES (?, ?, ?)";
        
        Connection conn = null;
        PreparedStatement psResult = null;
        PreparedStatement psAnswer = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); 
            
            psResult = conn.prepareStatement(sqlResult, Statement.RETURN_GENERATED_KEYS);
            psResult.setInt(1, result.getUserId());
            psResult.setInt(2, result.getQuizId());
            psResult.setInt(3, result.getScore());
            psResult.executeUpdate();
            
            int newResultId = -1;
            try (ResultSet rs = psResult.getGeneratedKeys()) {
                if (rs.next()) {
                    newResultId = rs.getInt(1);
                } else {
                    throw new SQLException("Creating result failed, no ID obtained.");
                }
            }
            
            psAnswer = conn.prepareStatement(sqlAnswer);
            
            for (Map.Entry<Integer, String> entry : answers.entrySet()) {
                psAnswer.setInt(1, newResultId);
                psAnswer.setInt(2, entry.getKey());
                psAnswer.setString(3, entry.getValue()); // <-- INT se String ho gaya
                psAnswer.addBatch();
            }
            psAnswer.executeBatch(); 

            conn.commit(); 
            
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
        } finally {
            try {
                if (psResult != null) psResult.close();
                if (psAnswer != null) psAnswer.close();
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // (getResultAnswers) - Naye columns fetch karne ke liye updated
    public List<AnswerDetail> getResultAnswers(int resultId) {
        List<AnswerDetail> answerList = new ArrayList<>();
        String sql = "SELECT q.question_type, q.question_text, q.options, q.correct_answer, ra.user_answer " +
                     "FROM result_answers ra " +
                     "JOIN questions q ON ra.question_id = q.question_id " +
                     "WHERE ra.result_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, resultId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AnswerDetail detail = new AnswerDetail();
                    detail.setQuestionType(rs.getString("question_type"));
                    detail.setQuestionText(rs.getString("question_text"));
                    detail.setOptions(rs.getString("options"));
                    detail.setCorrectAnswer(rs.getString("correct_answer"));
                    detail.setUserAnswer(rs.getString("user_answer")); // <-- INT se String
                    
                    answerList.add(detail);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return answerList;
    }
    
    // (getAllResultDetails) - Ismein koi change nahi hai
    public List<ResultDetails> getAllResultDetails() {
        List<ResultDetails> resultsList = new ArrayList<>();
        String sql = "SELECT r.result_id, u.username, q.title, r.score, r.date_taken " +
                     "FROM results r " +
                     "JOIN users u ON r.user_id = u.user_id " +
                     "JOIN quizzes q ON r.quiz_id = q.quiz_id " +
                     "ORDER BY r.date_taken DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ResultDetails details = new ResultDetails();
                details.setResultId(rs.getInt("result_id"));
                details.setUsername(rs.getString("username"));
                details.setQuizTitle(rs.getString("title"));
                details.setScore(rs.getInt("score"));
                details.setDateTaken(rs.getTimestamp("date_taken"));
                resultsList.add(details);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return resultsList;
    }
}
