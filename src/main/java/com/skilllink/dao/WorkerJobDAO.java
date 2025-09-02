// src/main/java/com/skilllink/dao/WorkerJobDAO.java
package com.skilllink.dao;

import com.skilllink.model.JobPost;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public interface WorkerJobDAO {

    /** Approved, category-matched jobs not yet assigned to anyone. */
    List<JobPost> listOffersForWorker(long workerId, int limit);

    /** Insert assignment (if free), close the job for others. Returns false if already taken. */
    boolean acceptJob(long jobId, long workerId);

    /** Accepted jobs for the worker (with assignment status + accepted time). */
    List<WorkerAcceptedJob> listAcceptedByWorker(long workerId);

    /** Set worker assignment to completed; also mark job_posts.status='completed'. */
    boolean markCompleted(long jobId, long workerId);

    /** Row DTO for the "Accepted jobs" table (JavaBean-compliant). */
    public static class WorkerAcceptedJob {
        private long jobId;
        private String title;
        private String clientName;
        private String categoryName;
        private String locationText;
        private BigDecimal budgetAmount;
        private LocalDateTime acceptedAt;
        private String assignmentStatus; // accepted | in_progress | completed | cancelled

        public long getJobId() { return jobId; }
        public void setJobId(long jobId) { this.jobId = jobId; }

        public String getTitle() { return title; }
        public void setTitle(String title) { this.title = title; }

        public String getClientName() { return clientName; }
        public void setClientName(String clientName) { this.clientName = clientName; }

        public String getCategoryName() { return categoryName; }
        public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

        public String getLocationText() { return locationText; }
        public void setLocationText(String locationText) { this.locationText = locationText; }

        public BigDecimal getBudgetAmount() { return budgetAmount; }
        public void setBudgetAmount(BigDecimal budgetAmount) { this.budgetAmount = budgetAmount; }

        public LocalDateTime getAcceptedAt() { return acceptedAt; }
        public void setAcceptedAt(LocalDateTime acceptedAt) { this.acceptedAt = acceptedAt; }

        public String getAssignmentStatus() { return assignmentStatus; }
        public void setAssignmentStatus(String assignmentStatus) { this.assignmentStatus = assignmentStatus; }
    }
}
