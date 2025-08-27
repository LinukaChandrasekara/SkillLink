package com.skilllink.model;

import java.io.Serializable;
import java.time.LocalDateTime;

public class Review implements Serializable {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Long reviewId;
    private Long jobId;
    private Long clientId;
    private Long workerId;
    private Integer rating;          // 1..5
    private String comment;
    private LocalDateTime createdAt;

    public Review() {}

    public Long getReviewId() { return reviewId; }
    public void setReviewId(Long reviewId) { this.reviewId = reviewId; }
    public Long getJobId() { return jobId; }
    public void setJobId(Long jobId) { this.jobId = jobId; }
    public Long getClientId() { return clientId; }
    public void setClientId(Long clientId) { this.clientId = clientId; }
    public Long getWorkerId() { return workerId; }
    public void setWorkerId(Long workerId) { this.workerId = workerId; }
    public Integer getRating() { return rating; }
    public void setRating(Integer rating) { this.rating = rating; }
    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    @Override public String toString() {
        return "Review{id=" + reviewId + ", rating=" + rating + "}";
    }
}
