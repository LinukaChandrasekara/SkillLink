package com.skilllink.model.enums;

public enum ClientType {
    INDIVIDUAL, BUSINESS;

    public static ClientType fromDb(String s) {
        if (s == null) return null;
        switch (s.toLowerCase()) {
            case "individual": return INDIVIDUAL;
            case "business":   return BUSINESS;
            default: throw new IllegalArgumentException("Unknown client_type: " + s);
        }
    }
    public String toDb() {
        switch (this) {
            case INDIVIDUAL: return "individual";
            case BUSINESS:   return "business";
            default: throw new IllegalStateException();
        }
    }
}
