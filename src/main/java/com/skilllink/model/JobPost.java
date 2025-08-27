package com.skilllink.model;

import com.skilllink.model.enums.JobStatus;
import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

public class JobPost implements Serializable {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Long jobId;
    private Long clientId;           // clients.user_id
    private Long jobCategoryId;
    private String title;
    private String description;
    private BigDecimal budgetAmount;
    private String locationText;
    private JobStatus status;
    private Long reviewerAdminId;
    private LocalDateTime reviewedAt;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Optional convenience
    private String jobCategoryName;
    private String clientName;

    public JobPost() {}

    public Long getJobId() { return jobId; }
    public void setJobId(Long jobId) { this.jobId = jobId; }
    public Long getClientId() { return clientId; }
    public void setClientId(Long clientId) { this.clientId = clientId; }
    public Long getJobCategoryId() { return jobCategoryId; }
    public void setJobCategoryId(Long jobCategoryId) { this.jobCategoryId = jobCategoryId; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public BigDecimal getBudgetAmount() { return budgetAmount; }
    public void setBudgetAmount(BigDecimal budgetAmount) { this.budgetAmount = budgetAmount; }
    public String getLocationText() { return locationText; }
    public void setLocationText(String locationText) { this.locationText = locationText; }
    public JobStatus getStatus() { return status; }
    public void setStatus(JobStatus status) { this.status = status; }
    public Long getReviewerAdminId() { return reviewerAdminId; }
    public void setReviewerAdminId(Long reviewerAdminId) { this.reviewerAdminId = reviewerAdminId; }
    public LocalDateTime getReviewedAt() { return reviewedAt; }
    public void setReviewedAt(LocalDateTime reviewedAt) { this.reviewedAt = reviewedAt; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    public String getJobCategoryName() { return jobCategoryName; }
    public void setJobCategoryName(String jobCategoryName) { this.jobCategoryName = jobCategoryName; }
    public String getClientName() { return clientName; }
    public void setClientName(String clientName) { this.clientName = clientName; }

    @Override public String toString() {
        return "JobPost{id=" + jobId + ", title='" + title + "', status=" + status + "}";
    }
}
