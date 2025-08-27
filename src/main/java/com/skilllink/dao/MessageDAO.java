package com.skilllink.dao;

import com.skilllink.model.Message;

import java.util.List;

public interface MessageDAO {
    List<Message> listByConversation(long conversationId, int limit, int offset);
    long send(long conversationId, long senderId, String body, byte[] attachment);
    boolean markRead(long conversationId, long userId); // mark messages as read for a given user (optional)
}
