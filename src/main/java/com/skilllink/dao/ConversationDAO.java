package com.skilllink.dao;

import com.skilllink.model.Conversation;

import java.util.List;

public interface ConversationDAO {
    long create(Long createdBy, Long jobId, boolean group);
    Conversation findById(long conversationId);
    List<Conversation> listForUser(long userId, int limit, int offset);
    boolean addParticipant(long conversationId, long userId);
    List<Long> listParticipants(long conversationId);
}
