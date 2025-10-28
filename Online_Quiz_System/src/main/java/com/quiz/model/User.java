package com.quiz.model;

import java.io.Serializable;

// We implement Serializable, which is good practice for
// classes that might be stored in a web session (like a logged-in user)
public class User implements Serializable {
    
    private static final long serialVersionUID = 1L; // For Serializable

    // Fields (must match your 'users' table columns)
    private int userId;
    private String username;
    private String password;
    private boolean isAdmin;
    private String email;
    
    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    // Default constructor
    public User() {
    }

    // --- Getters and Setters ---
    // These allow other classes to safely access the private fields

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public boolean isAdmin() {
        return isAdmin;
    }

    public void setAdmin(boolean isAdmin) {
        this.isAdmin = isAdmin;
    }
}