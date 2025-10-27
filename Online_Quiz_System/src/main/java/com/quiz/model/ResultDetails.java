package com.quiz.model;

import java.sql.Timestamp;

/**
 * This is a "View Model" or "DTO" (Data Transfer Object).
 * It's not a database table. It just holds the data from our
 * complex JOIN query to display on the admin page.
 */
public class ResultDetails {

    private String username;
    private int resultId;
    private String quizTitle;
    private int score;
    private Timestamp dateTaken;

    // Getters and Setters for all fields
    public int getResultId() {
        return resultId;
    }
    public void setResultId(int resultId) {
        this.resultId = resultId;
    }


    public String getUsername() {
        return username;
    }
    public void setUsername(String username) {
        this.username = username;
    }
    public String getQuizTitle() {
        return quizTitle;
    }
    public void setQuizTitle(String quizTitle) {
        this.quizTitle = quizTitle;
    }
    public int getScore() {
        return score;
    }
    public void setScore(int score) {
        this.score = score;
    }
    public Timestamp getDateTaken() {
        return dateTaken;
    }
    public void setDateTaken(Timestamp dateTaken) {
        this.dateTaken = dateTaken;
    }
}
