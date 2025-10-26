package com.quiz.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Result implements Serializable {
    
    private static final long serialVersionUID = 1L;

    private int resultId;
    private int userId;
    private int quizId;
    private int score;
    private Timestamp dateTaken;

    // Default constructor
    public Result() {
    }

    // --- Getters and Setters ---
    
    public int getResultId() {
        return resultId;
    }

    public void setResultId(int resultId) {
        this.resultId = resultId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getQuizId() {
        return quizId;
    }

    public void setQuizId(int quizId) {
        this.quizId = quizId;
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