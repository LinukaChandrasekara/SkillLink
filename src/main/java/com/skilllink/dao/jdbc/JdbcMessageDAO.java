// src/main/java/com/skilllink/dao/jdbc/JdbcMessageDAO.java
package com.skilllink.dao.jdbc;

import com.skilllink.dao.MessageDAO;
import com.skilllink.model.Message;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class JdbcMessageDAO implements MessageDAO {

    @Override
    public List<Message> listByConversation(long conversationId, int limit, int offset) {
        final String sql =
            "SELECT message_id, conversation_id, sender_id, body, created_at, is_read " +
            "FROM messages WHERE conversation_id=? " +
            "ORDER BY created_at ASC LIMIT ? OFFSET ?";
        List<Message> list = new ArrayList<>();
        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, conversationId);
            ps.setInt(2, Math.max(1, limit));
            ps.setInt(3, Math.max(0, offset));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Message m = new Message();
                    m.setMessageId(rs.getLong("message_id"));
                    m.setConversationId(rs.getLong("conversation_id"));
                    m.setSenderId(rs.getLong("sender_id"));
                    m.setBody(rs.getString("body"));

                    Timestamp ts = rs.getTimestamp("created_at");
                    m.setCreatedAt(ts != null ? ts.toLocalDateTime() : (LocalDateTime) null);

                    m.setRead(rs.getBoolean("is_read"));
                    list.add(m);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    @Override
    public long create(long conversationId, long senderId, String body, byte[] attachment) {
        final String sql =
            "INSERT INTO messages(conversation_id, sender_id, body, attachment_blob) VALUES (?,?,?,?)";
        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, conversationId);
            ps.setLong(2, senderId);
            ps.setString(3, body);
            if (attachment == null) ps.setNull(4, Types.LONGVARBINARY);
            else ps.setBytes(4, attachment);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                return rs.next() ? rs.getLong(1) : 0L;
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void markReadAllForViewer(long conversationId, long viewerId) {
        final String sql = "UPDATE messages SET is_read=1 WHERE conversation_id=? AND sender_id<>? AND is_read=0";
        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, conversationId);
            ps.setLong(2, viewerId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
