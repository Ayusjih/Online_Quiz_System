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
    
    
    /**
     * Adds a new question to a specific quiz.
     * @param question The Question object to add.
     */
    public void addQuestion(Question question) {
        String sql = "INSERT INTO questions (quiz_id, question_text, option1, option2, option3, option4, correct_answer) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, question.getQuizId());
            ps.setString(2, question.getQuestionText());
            ps.setString(3, question.getOption1());
            ps.setString(4, question.getOption2());
            ps.setString(5, question.getOption3());
            ps.setString(6, question.getOption4());
            ps.setInt(7, question.getCorrectAnswer());
            
            ps.executeUpdate();

        } catch (SQLException e) {
            System.out.println("Error in QuestionDAO.addQuestion: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Deletes a single question by its ID.
     * @param questionId The ID of the question to delete.
     */
    public void deleteQuestion(int questionId) {
        // We also need to delete any answers referencing this question
        String deleteAnswersSql = "DELETE FROM result_answers WHERE question_id = ?";
        String deleteQuestionSql = "DELETE FROM questions WHERE question_id = ?";

        try (Connection conn = DBConnection.getConnection()) {
            
            conn.setAutoCommit(false); // Start transaction

            // 1. Delete associated answers
            try (PreparedStatement psAnswers = conn.prepareStatement(deleteAnswersSql)) {
                psAnswers.setInt(1, questionId);
                psAnswers.executeUpdate();
            }
            
            // 2. Delete the question itself
            try (PreparedStatement psQuestion = conn.prepareStatement(deleteQuestionSql)) {
                psQuestion.setInt(1, questionId);
                psQuestion.executeUpdate();
            }

            conn.commit(); // Commit both deletes

        } catch (SQLException e) {
            System.out.println("Error in QuestionDAO.deleteQuestion transaction: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
}