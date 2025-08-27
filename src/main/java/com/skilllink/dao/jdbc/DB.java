package com.skilllink.dao.jdbc;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/** Minimal connection helper (swap to a pool later if you want). */
public final class DB {
    private static final String URL  = System.getProperty("db.url",  "jdbc:mysql://localhost:3306/skilllink?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC");
    private static final String USER = System.getProperty("db.user", "root");
    private static final String PASS = System.getProperty("db.pass", "root");

    static {
        try { Class.forName("com.mysql.cj.jdbc.Driver"); }
        catch (ClassNotFoundException e) { throw new IllegalStateException("MySQL driver missing", e); }
    }

    private DB() {}

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }
}
