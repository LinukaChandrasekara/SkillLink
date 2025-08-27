package com.skilllink.model.enums;

public enum JobStatus {
    PENDING, APPROVED, DENIED, CLOSED, COMPLETED;

    public static JobStatus fromDb(String s) {
        if (s == null) return null;
        switch (s.toLowerCase()) {
            case "pending":   return PENDING;
            case "approved":  return APPROVED;
            case "denied":    return DENIED;
            case "closed":    return CLOSED;
            case "completed": return COMPLETED;
            default: throw new IllegalArgumentException("Unknown job status: " + s);
        }
    }
    public String toDb() {
        switch (this) {
            case PENDING:   return "pending";
            case APPROVED:  return "approved";
            case DENIED:    return "denied";
            case CLOSED:    return "closed";
            case COMPLETED: return "completed";
            default: throw new IllegalStateException();
        }
    }
}
