package com.quiz.model;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

public class AnswerDetail {

    private String questionType;
    private String questionText;
    private String options; 
    private String correctAnswer;
    private String userAnswer; // Yahaan 'int' se 'String' kar diya hai

    public List<String> getOptionsList() {
        if (options == null || options.isEmpty()) {
            return Collections.emptyList();
        }
        return Arrays.asList(options.split("\\|"));
    }
    
    public boolean isCorrect() {
        if (userAnswer == null || correctAnswer == null) {
            return false;
        }
        // Case-insensitive check (e.g., "41" aur "41 " same hain)
        return userAnswer.trim().equalsIgnoreCase(correctAnswer.trim());
    }

    // --- Getters and Setters ---

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

    // --- YEH AAPKA FIX HAI ---
    // Pehle yahaan 'int' tha, ab 'String' hai
    public String getUserAnswer() {
        return userAnswer;
    }

    public void setUserAnswer(String userAnswer) {
        this.userAnswer = userAnswer;
    }
    // --- FIX ENDS HERE ---
}

