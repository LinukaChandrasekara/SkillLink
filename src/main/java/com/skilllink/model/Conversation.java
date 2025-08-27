package com.skilllink.model;

import java.io.Serializable;
import java.time.LocalDateTime;

public class Conversation implements Serializable {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Long conversationId;
    private Long createdBy;
    private Long jobId;           // nullable
    private boolean group;
    private LocalDateTime createdAt;

    public Conversation() {}

    public Long getConversationId() { return conversationId; }
    public void setConversationId(Long conversationId) { this.conversationId = conversationId; }
    public Long getCreatedBy() { return createdBy; }
    public void setCreatedBy(Long createdBy) { this.createdBy = createdBy; }
    public Long getJobId() { return jobId; }
    public void setJobId(Long jobId) { this.jobId = jobId; }
    public boolean isGroup() { return group; }
    public void setGroup(boolean group) { this.group = group; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    @Override public String toString() {
        return "Conversation{id=" + conversationId + ", jobId=" + jobId + "}";
    }
}
