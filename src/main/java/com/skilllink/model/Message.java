package com.skilllink.model;

import java.io.Serializable;
import java.time.LocalDateTime;

public class Message implements Serializable {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Long messageId;
    private Long conversationId;
    private Long senderId;
    private String body;
    private byte[] attachmentBlob;
    private String createdAt;
    private boolean read;

    public Message() {}

    public Long getMessageId() { return messageId; }
    public void setMessageId(Long messageId) { this.messageId = messageId; }
    public Long getConversationId() { return conversationId; }
    public void setConversationId(Long conversationId) { this.conversationId = conversationId; }
    public Long getSenderId() { return senderId; }
    public void setSenderId(Long senderId) { this.senderId = senderId; }
    public String getBody() { return body; }
    public void setBody(String body) { this.body = body; }
    public byte[] getAttachmentBlob() { return attachmentBlob; }
    public void setAttachmentBlob(byte[] attachmentBlob) { this.attachmentBlob = attachmentBlob; }
    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String string) { this.createdAt = string; }
    public boolean isRead() { return read; }
    public void setRead(boolean read) { this.read = read; }

    @Override public String toString() {
        return "Message{id=" + messageId + ", convId=" + conversationId + "}";
    }
}
