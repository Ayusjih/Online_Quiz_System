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

    // (getQuestionsForQuiz) - Naye columns ko fetch karne ke liye updated
    public List<Question> getQuestionsForQuiz(int quizId) {
        List<Question> questionList = new ArrayList<>();
        String sql = "SELECT * FROM questions WHERE quiz_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quizId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Question q = new Question();
                    q.setQuestionId(rs.getInt("question_id"));
                    q.setQuizId(rs.getInt("quiz_id"));
                    q.setQuestionType(rs.getString("question_type")); // NAYA
                    q.setQuestionText(rs.getString("question_text"));
                    q.setOptions(rs.getString("options")); // NAYA
                    q.setCorrectAnswer(rs.getString("correct_answer")); // UPDATED
                    
                    questionList.add(q);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return questionList;
    }

    // (addQuestion) - Naye columns ko insert karne ke liye updated
    public void addQuestion(Question question) {
        String sql = "INSERT INTO questions (quiz_id, question_type, question_text, options, correct_answer) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, question.getQuizId());
            ps.setString(2, question.getQuestionType());
            ps.setString(3, question.getQuestionText());
            ps.setString(4, question.getOptions()); // MCQ ke liye options, FIB ke liye NULL
            ps.setString(5, question.getCorrectAnswer()); // Dono ke liye String answer

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // (deleteQuestion) - Ismein koi change nahi hai
    public void deleteQuestion(int questionId) {
        String sql = "DELETE FROM questions WHERE question_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, questionId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}

