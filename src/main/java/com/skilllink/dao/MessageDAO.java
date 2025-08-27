// src/main/java/com/skilllink/dao/MessageDAO.java
package com.skilllink.dao;

import com.skilllink.model.Message;
import java.util.List;

public interface MessageDAO {
    List<Message> listByConversation(long conversationId, int limit, int offset);
    long create(long conversationId, long senderId, String body, byte[] attachment);
    void markReadAllForViewer(long conversationId, long viewerId);
}
