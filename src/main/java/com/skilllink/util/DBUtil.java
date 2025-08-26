package com.skilllink.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {
    private static final String URL =
        "jdbc:mysql://localhost:3306/skilllink?useSSL=false&characterEncoding=UTF-8&useUnicode=yes&serverTimezone=UTC";
    private static final String USER = "root";         // <- change
    private static final String PASS = "root";         // <- change

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // MySQL 8 driver
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL Driver not found", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }
}
