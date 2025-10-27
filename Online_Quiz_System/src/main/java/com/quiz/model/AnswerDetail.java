package com.quiz.model;

/**
 * A "View Model" to hold all the data for displaying
 * a single answered question in the admin review.
 */
public class AnswerDetail {

    private String questionText;
    private String option1;
    private String option2;
    private String option3;
    private String option4;
    private int correctAnswer; // The correct option number (1-4)
    private int userAnswer;    // The user's selected option number (1-4)

    // --- Getters and Setters ---
    
    public String getQuestionText() {
        return questionText;
    }
    public void setQuestionText(String questionText) {
        this.questionText = questionText;
    }
    public String getOption1() {
        return option1;
    }
    public void setOption1(String option1) {
        this.option1 = option1;
    }
    public String getOption2() {
        return option2;
    }
    public void setOption2(String option2) {
        this.option2 = option2;
    }
    public String getOption3() {
        return option3;
    }
    public void setOption3(String option3) {
        this.option3 = option3;
    }
    public String getOption4() {
        return option4;
    }
    public void setOption4(String option4) {
        this.option4 = option4;
    }
    public int getCorrectAnswer() {
        return correctAnswer;
    }
    public void setCorrectAnswer(int correctAnswer) {
        this.correctAnswer = correctAnswer;
    }
    public int getUserAnswer() {
        return userAnswer;
    }
    public void setUserAnswer(int userAnswer) {
        this.userAnswer = userAnswer;
    }
}
