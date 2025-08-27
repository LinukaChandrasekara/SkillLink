package com.skilllink.model.enums;

public enum VerificationStatus {
    UNVERIFIED, PENDING, VERIFIED, DENIED;

    public static VerificationStatus fromDb(String s) {
        if (s == null) return null;
        switch (s.toLowerCase()) {
            case "unverified": return UNVERIFIED;
            case "pending":    return PENDING;
            case "verified":   return VERIFIED;
            case "denied":     return DENIED;
            default: throw new IllegalArgumentException("Unknown verification_status: " + s);
        }
    }
    public String toDb() {
        switch (this) {
            case UNVERIFIED: return "unverified";
            case PENDING:    return "pending";
            case VERIFIED:   return "verified";
            case DENIED:     return "denied";
            default: throw new IllegalStateException();
        }
    }
}
