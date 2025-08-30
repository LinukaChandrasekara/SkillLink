package com.skilllink.dao.jdbc;

import com.skilllink.dao.ConversationMessageDAO;
import com.skilllink.model.ConversationSummary;
import com.skilllink.model.Message;

import java.sql.*;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class JdbcConversationMessageDAO implements ConversationMessageDAO {

    @Override
    public List<ConversationSummary> listUserConversations(long userId) {
        final String sql =
            "SELECT c.conversation_id, u2.user_id AS other_id, u2.full_name, r.role_name, " +
            "       lm.last_body, lm.last_at, COALESCE(ur.unread_cnt,0) AS unread_cnt " +
            "FROM conversation_participants cp " +
            "JOIN conversations c ON c.conversation_id=cp.conversation_id " +
            "JOIN conversation_participants cp2 ON cp2.conversation_id=c.conversation_id AND cp2.user_id<>cp.user_id " +
            "JOIN users u2 ON u2.user_id=cp2.user_id " +
            "JOIN roles r ON r.role_id=u2.role_id " +
            "LEFT JOIN ( " +
            "   SELECT m.conversation_id, m.body AS last_body, m.created_at AS last_at " +
            "   FROM messages m " +
            "   JOIN (SELECT conversation_id, MAX(created_at) AS mx FROM messages GROUP BY conversation_id) x " +
            "     ON x.conversation_id=m.conversation_id AND x.mx=m.created_at " +
            ") lm ON lm.conversation_id=c.conversation_id " +
            "LEFT JOIN ( " +
            "   SELECT conversation_id, COUNT(*) AS unread_cnt " +
            "   FROM messages WHERE is_read=FALSE AND sender_id<>? GROUP BY conversation_id " +
            ") ur ON ur.conversation_id=c.conversation_id " +
            "WHERE cp.user_id=? AND c.is_group=FALSE " +
            "  AND (SELECT COUNT(*) FROM conversation_participants t WHERE t.conversation_id=c.conversation_id)=2 " +
            "ORDER BY COALESCE(lm.last_at, c.created_at) DESC";

        List<ConversationSummary> out = new ArrayList<>();
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ps.setLong(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ConversationSummary s = new ConversationSummary();
                    s.setConversationId(rs.getLong("conversation_id"));
                    s.setOtherUserId(rs.getLong("other_id"));
                    s.setOtherFullName(rs.getString("full_name"));
                    s.setOtherRole(rs.getString("role_name"));
                    s.setLastSnippet(rs.getString("last_body"));
                    Timestamp t = rs.getTimestamp("last_at");
                    if (t != null)
                        s.setLastAt(t.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime());
                    s.setUnreadCount(rs.getLong("unread_cnt"));
                    out.add(s);
                }
            }
        } catch (SQLException e) { throw new RuntimeException(e); }
        return out;
    }

    @Override
    public Optional<Long> findDirectConversationId(long a, long b, Long jobId) {
        final String sql =
            "SELECT c.conversation_id " +
            "FROM conversations c " +
            "JOIN conversation_participants p1 ON p1.conversation_id=c.conversation_id AND p1.user_id=? " +
            "JOIN conversation_participants p2 ON p2.conversation_id=c.conversation_id AND p2.user_id=? " +
            "WHERE c.is_group=FALSE " +
            "  AND ( (? IS NULL AND c.job_id IS NULL) OR c.job_id=? ) " +
            "  AND (SELECT COUNT(*) FROM conversation_participants x WHERE x.conversation_id=c.conversation_id)=2 " +
            "LIMIT 1";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, a); ps.setLong(2, b);
            if (jobId == null) { ps.setNull(3, Types.BIGINT); ps.setNull(4, Types.BIGINT); }
            else { ps.setLong(3, jobId); ps.setLong(4, jobId); }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(rs.getLong(1));
                return Optional.empty();
            }
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    @Override
    public long ensureDirectConversation(long a, long b, Long jobId) {
        Optional<Long> existing = findDirectConversationId(a, b, jobId);
        if (existing.isPresent()) return existing.get();

        final String insConv = "INSERT INTO conversations (created_by, job_id, is_group) VALUES (?,?,FALSE)";
        try (Connection c = DB.getConnection()) {
            c.setAutoCommit(false);
            long convId;
            try (PreparedStatement ps = c.prepareStatement(insConv, Statement.RETURN_GENERATED_KEYS)) {
                ps.setLong(1, a);
                if (jobId == null) ps.setNull(2, Types.BIGINT); else ps.setLong(2, jobId);
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    convId = rs.next() ? rs.getLong(1) : 0L;
                }
            }
            try (PreparedStatement ps = c.prepareStatement(
                    "INSERT INTO conversation_participants (conversation_id, user_id) VALUES (?,?),(?,?)")) {
                ps.setLong(1, convId); ps.setLong(2, a);
                ps.setLong(3, convId); ps.setLong(4, b);
                ps.executeUpdate();
            }
            c.commit();
            return convId;
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    @Override
    public boolean isParticipant(long conversationId, long userId) {
        final String sql = "SELECT 1 FROM conversation_participants WHERE conversation_id=? AND user_id=? LIMIT 1";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, conversationId); ps.setLong(2, userId);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    @Override
    public Optional<Long> findPeer(long conversationId, long myUserId) {
        final String sql =
            "SELECT user_id FROM conversation_participants WHERE conversation_id=? AND user_id<>? LIMIT 1";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, conversationId); ps.setLong(2, myUserId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(rs.getLong(1));
                return Optional.empty();
            }
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    @Override
    public List<Message> listMessages(long conversationId, int limit) {
        limit = Math.max(1, Math.min(limit, 500));
        final String sql =
            "SELECT message_id, conversation_id, sender_id, body, created_at, is_read " +
            "FROM messages WHERE conversation_id=? " +
            "ORDER BY created_at ASC, message_id ASC LIMIT ?";
        List<Message> list = new ArrayList<>();
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, conversationId); ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Message m = new Message();
                    m.setMessageId(rs.getLong("message_id"));
                    m.setConversationId(rs.getLong("conversation_id"));
                    m.setSenderId(rs.getLong("sender_id"));
                    m.setBody(rs.getString("body"));
                    Timestamp t = rs.getTimestamp("created_at");
                    if (t != null)
                        m.setCreatedAt(t.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime());
                    m.setRead(rs.getBoolean("is_read"));
                    list.add(m);
                }
            }
        } catch (SQLException e) { throw new RuntimeException(e); }
        return list;
    }

    @Override
    public long send(long conversationId, long senderId, String body) {
        final String sql = "INSERT INTO messages (conversation_id, sender_id, body, created_at, is_read) " +
                           "VALUES (?,?,?,NOW(),FALSE)";
        try (Connection c = DB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, conversationId);
            ps.setLong(2, senderId);
            ps.setString(3, body);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                return rs.next() ? rs.getLong(1) : 0L;
            }
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    @Override
    public int markRead(long conversationId, long readerUserId) {
        final String sql =
            "UPDATE messages SET is_read=TRUE " +
            "WHERE conversation_id=? AND sender_id<>? AND is_read=FALSE";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, conversationId); ps.setLong(2, readerUserId);
            return ps.executeUpdate();
        } catch (SQLException e) { throw new RuntimeException(e); }
    }
}
