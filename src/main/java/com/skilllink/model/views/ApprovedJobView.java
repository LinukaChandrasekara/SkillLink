package com.skilllink.model.views;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

public class ApprovedJobView implements Serializable {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Long jobId;
    private String title;
    private String description;
    private BigDecimal budgetAmount;
    private String locationText;
    private Long jobCategoryId;
    private String jobCategoryName;
    private Long clientId;      // actually users.user_id (client)
    private String clientName;
    private String status;      // should be "approved"
    private LocalDateTime createdAt;

    // getters/setters
    public Long getJobId() { return jobId; }
    public void setJobId(Long jobId) { this.jobId = jobId; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public BigDecimal getBudgetAmount() { return budgetAmount; }
    public void setBudgetAmount(BigDecimal budgetAmount) { this.budgetAmount = budgetAmount; }
    public String getLocationText() { return locationText; }
    public void setLocationText(String locationText) { this.locationText = locationText; }
    public Long getJobCategoryId() { return jobCategoryId; }
    public void setJobCategoryId(Long jobCategoryId) { this.jobCategoryId = jobCategoryId; }
    public String getJobCategoryName() { return jobCategoryName; }
    public void setJobCategoryName(String jobCategoryName) { this.jobCategoryName = jobCategoryName; }
    public Long getClientId() { return clientId; }
    public void setClientId(Long clientId) { this.clientId = clientId; }
    public String getClientName() { return clientName; }
    public void setClientName(String clientName) { this.clientName = clientName; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
