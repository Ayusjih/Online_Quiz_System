package com.quiz.model;

import java.io.Serializable;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

public class Question implements Serializable {
    
    private static final long serialVersionUID = 1L;

    private int questionId;
    private int quizId;
    private String questionType; // 'MCQ' ya 'FIB'
    private String questionText;
    private String options; // "Option1|Option2|Option3|Option4"
    private String correctAnswer; // Ab String hai

    public Question() {
    }

    // Helper method: MCQ options ko list mein badalne ke liye
    public List<String> getOptionsList() {
        if (options == null || options.isEmpty()) {
            return Collections.emptyList();
        }
        return Arrays.asList(options.split("\\|"));
    }

    // --- Getters and Setters ---

    public int getQuestionId() {
        return questionId;
    }

    public void setQuestionId(int questionId) {
        this.questionId = questionId;
    }

    public int getQuizId() {
        return quizId;
    }

    public void setQuizId(int quizId) {
        this.quizId = quizId;
    }

    public String getQuestionType() {
        return questionType;
    }

    public void setQuestionType(String questionType) {
        this.questionType = questionType;
    }

    public String getQuestionText() {
        return questionText;
    }

    public void setQuestionText(String questionText) {
        this.questionText = questionText;
    }

    public String getOptions() {
        return options;
    }

    public void setOptions(String options) {
        this.options = options;
    }

    public String getCorrectAnswer() {
        return correctAnswer;
    }

    public void setCorrectAnswer(String correctAnswer) {
        this.correctAnswer = correctAnswer;
    }
}

