package com.skilllink.model.enums;

public enum RoleName {
    ADMIN, WORKER, CLIENT;

    public static RoleName fromDb(String s) {
        if (s == null) return null;
        switch (s.toLowerCase()) {
            case "admin": return ADMIN;
            case "worker": return WORKER;
            case "client": return CLIENT;
            default: throw new IllegalArgumentException("Unknown role: " + s);
        }
    }
    public String toDb() {
        switch (this) {
            case ADMIN: return "admin";
            case WORKER: return "worker";
            case CLIENT: return "client";
            default: throw new IllegalStateException();
        }
    }
}
