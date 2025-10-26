package com.quiz.util;

import java.sql.Connection;

public class ConnectionTest {

    public static void main(String[] args) {
        
        Connection conn = DBConnection.getConnection();
        
        if (conn != null) {
            System.out.println("SUCCESS: We are connected to the database!");
        } else {
            System.out.println("FAILURE: We could not connect.");
        }
    }
}