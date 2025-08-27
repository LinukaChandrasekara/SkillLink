package com.skilllink.model.views;

import java.io.Serializable;

public class WorkerRatingSummaryView implements Serializable {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Long workerId;
    private String fullName;
    private Double avgRating;      // AVG(rating)
    private Long totalReviews;     // COUNT(review_id)

    public Long getWorkerId() { return workerId; }
    public void setWorkerId(Long workerId) { this.workerId = workerId; }
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public Double getAvgRating() { return avgRating; }
    public void setAvgRating(Double avgRating) { this.avgRating = avgRating; }
    public Long getTotalReviews() { return totalReviews; }
    public void setTotalReviews(Long totalReviews) { this.totalReviews = totalReviews; }
}
