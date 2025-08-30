package com.skilllink.dao;


import com.skilllink.dao.dto.ConversationSummary;
import com.skilllink.model.Message;

import java.util.List;
import java.util.Optional;

public interface ConversationMessageDAO {

    /** List the user's 1:1 conversations (non-group), newest first. */
    List<com.skilllink.model.ConversationSummary> listUserConversations(long userId);

    /** Return an existing direct conversation (optionally scoped to a job), else create it. */
    long ensureDirectConversation(long userA, long userB, Long jobIdOrNull);

    /** If a conversation exists for these two participants (and job), return its id. */
    Optional<Long> findDirectConversationId(long userA, long userB, Long jobIdOrNull);

    /** Validate that a user is a participant in a conversation. */
    boolean isParticipant(long conversationId, long userId);

    /** For a direct conversation, return the other person's user_id (if any). */
    Optional<Long> findPeer(long conversationId, long myUserId);

    /** Load messages in ascending order (oldest first). */
    List<Message> listMessages(long conversationId, int limit);

    /** Insert a message. Returns generated message_id. */
    long send(long conversationId, long senderId, String body);

    /** Mark all incoming (from others) messages as read for this user. */
    int markRead(long conversationId, long readerUserId);
}
