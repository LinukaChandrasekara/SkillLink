package com.skilllink.dao.dto;

import java.time.LocalDateTime;

/**
 * Lightweight row for the conversation list (left column).
 * NOTE: exposes alias getters so older JSPs that use
 * otherFullName / lastMessageText keep working.
 */
public class ConversationSummary {
    private long conversationId;
    private long otherUserId;     // 0 for group chats
    private String title;         // other user's name OR "Group #<id>"
    private String lastSnippet;   // preview of last message
    private long unreadCount;     // unread for the viewer
    private LocalDateTime lastMessageAt;

    // --- canonical getters/setters ---
    public long getConversationId() { return conversationId; }
    public void setConversationId(long conversationId) { this.conversationId = conversationId; }

    public long getOtherUserId() { return otherUserId; }
    public void setOtherUserId(long otherUserId) { this.otherUserId = otherUserId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getLastSnippet() { return lastSnippet; }
    public void setLastSnippet(String lastSnippet) { this.lastSnippet = lastSnippet; }

    public long getUnreadCount() { return unreadCount; }
    public void setUnreadCount(long unreadCount) { this.unreadCount = unreadCount; }

    public LocalDateTime getLastMessageAt() { return lastMessageAt; }
    public void setLastMessageAt(LocalDateTime lastMessageAt) { this.lastMessageAt = lastMessageAt; }

    // --- alias getters for JSP compatibility ---
    /** Older JSPs refer to ${cvo.otherFullName} – map it to title */
    public String getOtherFullName() { return title; }
    /** Some pages used ${cvo.lastMessageText} – map it to lastSnippet */
    public String getLastMessageText() { return lastSnippet; }
    /** If a template used ${cvo.otherName} */
    public String getOtherName() { return title; }
}
