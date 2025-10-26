package com.quiz.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.quiz.model.Question;
import com.quiz.util.DBConnection;

public class QuestionDAO {

    /**
     * Fetches all questions for a specific quiz.
     * @param quizId The ID of the quiz.
     * @return A List of Question objects.
     */
    public List<Question> getQuestionsForQuiz(int quizId) {
        List<Question> questionList = new ArrayList<>();
        
        // The '?' is a placeholder for the quizId
        String sql = "SELECT * FROM questions WHERE quiz_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // Set the first '?' to the quizId we passed in
            ps.setInt(1, quizId); 
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Question q = new Question();
                    q.setQuestionId(rs.getInt("question_id"));
                    q.setQuizId(rs.getInt("quiz_id"));
                    q.setQuestionText(rs.getString("question_text"));
                    q.setOption1(rs.getString("option1"));
                    q.setOption2(rs.getString("option2"));
                    q.setOption3(rs.getString("option3"));
                    q.setOption4(rs.getString("option4"));
                    q.setCorrectAnswer(rs.getInt("correct_answer"));
                    
                    questionList.add(q);
                }
            }

        } catch (SQLException e) {
            System.out.println("Error in QuestionDAO.getQuestionsForQuiz: " + e.getMessage());
            e.printStackTrace();
        }
        
        return questionList;
    }
}