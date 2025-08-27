// src/main/java/com/skilllink/dao/dto/ConversationSummary.java
package com.skilllink.dao.dto;

public class ConversationSummary {
    private long conversationId;
    private long otherUserId;       // for 1:1 chats (0 for group)
    private String title;           // other user’s name or "Group #id"
    private String lastSnippet;     // last message body preview
    private long unreadCount;       // unread for the viewer

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
}
