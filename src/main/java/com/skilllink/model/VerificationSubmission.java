package com.skilllink.model;

import com.skilllink.model.enums.VerificationStatus;
import java.io.Serializable;
import java.time.LocalDateTime;

public class VerificationSubmission implements Serializable {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Long submissionId;
    private Long userId;
    private byte[] idPhoto;
    private VerificationStatus status;   // pending/approved/denied (maps to users via trigger)
    private Long reviewerAdminId;
    private String reviewerNotes;
    private LocalDateTime createdAt;
    private LocalDateTime decidedAt;

    // Optional convenience
    private String userFullName;
    private String username;

    public VerificationSubmission() {}

    public Long getSubmissionId() { return submissionId; }
    public void setSubmissionId(Long submissionId) { this.submissionId = submissionId; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public byte[] getIdPhoto() { return idPhoto; }
    public void setIdPhoto(byte[] idPhoto) { this.idPhoto = idPhoto; }

    public VerificationStatus getStatus() { return status; }
    public void setStatus(VerificationStatus status) { this.status = status; }

    public Long getReviewerAdminId() { return reviewerAdminId; }
    public void setReviewerAdminId(Long reviewerAdminId) { this.reviewerAdminId = reviewerAdminId; }

    public String getReviewerNotes() { return reviewerNotes; }
    public void setReviewerNotes(String reviewerNotes) { this.reviewerNotes = reviewerNotes; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getDecidedAt() { return decidedAt; }
    public void setDecidedAt(LocalDateTime decidedAt) { this.decidedAt = decidedAt; }

    public String getUserFullName() { return userFullName; }
    public void setUserFullName(String userFullName) { this.userFullName = userFullName; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    @Override public String toString() {
        return "VerificationSubmission{id=" + submissionId + ", userId=" + userId + ", status=" + status + "}";
    }
}
