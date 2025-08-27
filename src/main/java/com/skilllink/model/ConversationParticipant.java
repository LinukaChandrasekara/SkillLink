package com.skilllink.model;

import java.io.Serializable;
import java.time.LocalDateTime;

public class ConversationParticipant implements Serializable {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Long conversationId;
    private Long userId;
    private LocalDateTime joinedAt;

    public ConversationParticipant() {}

    public Long getConversationId() { return conversationId; }
    public void setConversationId(Long conversationId) { this.conversationId = conversationId; }
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public LocalDateTime getJoinedAt() { return joinedAt; }
    public void setJoinedAt(LocalDateTime joinedAt) { this.joinedAt = joinedAt; }

    @Override public String toString() {
        return "ConversationParticipant{convId=" + conversationId + ", userId=" + userId + "}";
    }
}
