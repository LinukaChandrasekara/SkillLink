package com.skilllink.util;

public class AuthUtil {
    // Simple password comparison (no hashing)
    public static boolean verifyPassword(String inputPassword, String storedPassword) {
        return inputPassword.equals(storedPassword);
    }
}