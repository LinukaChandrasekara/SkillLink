package com.skilllink.model;

import java.time.LocalDateTime;

public class ConversationSummary {
    private long conversationId;
    private long otherUserId;
    private String otherFullName;
    private String otherRole;
    private long unreadCount;
    private String lastSnippet;
    private LocalDateTime lastAt;

    public long getConversationId() { return conversationId; }
    public void setConversationId(long conversationId) { this.conversationId = conversationId; }
    public long getOtherUserId() { return otherUserId; }
    public void setOtherUserId(long otherUserId) { this.otherUserId = otherUserId; }
    public String getOtherFullName() { return otherFullName; }
    public void setOtherFullName(String otherFullName) { this.otherFullName = otherFullName; }
    public String getOtherRole() { return otherRole; }
    public void setOtherRole(String otherRole) { this.otherRole = otherRole; }
    public long getUnreadCount() { return unreadCount; }
    public void setUnreadCount(long unreadCount) { this.unreadCount = unreadCount; }
    public String getLastSnippet() { return lastSnippet; }
    public void setLastSnippet(String lastSnippet) { this.lastSnippet = lastSnippet; }
    public LocalDateTime getLastAt() { return lastAt; }
    public void setLastAt(LocalDateTime lastAt) { this.lastAt = lastAt; }
}
