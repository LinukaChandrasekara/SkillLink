// src/main/java/com/skilllink/dao/ConversationDAO.java
package com.skilllink.dao;

import com.skilllink.dao.dto.ConversationSummary;
import java.util.List;

public interface ConversationDAO {
    List<ConversationSummary> listForUser(long userId);

    Long findDirectConversation(long userId1, long userId2);

    long create(long createdBy, Long jobId, boolean isGroup);

    void addParticipant(long conversationId, long userId);

    long findOtherParticipant(long conversationId, long currentUserId);
}
	