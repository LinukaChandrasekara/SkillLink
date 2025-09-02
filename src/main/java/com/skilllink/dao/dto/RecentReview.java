package com.skilllink.dao.dto;

public class RecentReview {
    private long clientId;
    private String clientName;
    private int rating;           // 1..5
    private String comment;       // nullable
    private String jobTitle;      // for context
    private String createdAt;     // formatted string for UI

    public long getClientId() { return clientId; }
    public void setClientId(long clientId) { this.clientId = clientId; }
    public String getClientName() { return clientName; }
    public void setClientName(String clientName) { this.clientName = clientName; }
    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }
    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }
    public String getJobTitle() { return jobTitle; }
    public void setJobTitle(String jobTitle) { this.jobTitle = jobTitle; }
    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
}
