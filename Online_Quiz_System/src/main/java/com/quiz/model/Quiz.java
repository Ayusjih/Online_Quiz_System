package com.quiz.model;

import java.io.Serializable;

public class Quiz implements Serializable {

    private static final long serialVersionUID = 1L;

    // Fields from 'quizzes' table
    private int quizId;
    private String title;
    private int durationMinutes;

    // Default constructor
    public Quiz() {
    }

    // --- Getters and Setters ---

    public int getQuizId() {
        return quizId;
    }

    public void setQuizId(int quizId) {
        this.quizId = quizId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public int getDurationMinutes() {
        return durationMinutes;
    }

    public void setDurationMinutes(int durationMinutes) {
        this.durationMinutes = durationMinutes;
    }
}