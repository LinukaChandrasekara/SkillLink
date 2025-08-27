package com.skilllink.dao.jdbc;

import com.skilllink.dao.MessageDAO;
import com.skilllink.model.Message;

import java.sql.*;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;

public class JdbcMessageDAO implements MessageDAO {

    @Override
    public List<Message> listByConversation(long conversationId, int limit, int offset) {
        final String sql = "SELECT * FROM messages WHERE conversation_id=? ORDER BY created_at ASC LIMIT ? OFFSET ?";
        List<Message> out = new ArrayList<>();
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, conversationId); ps.setInt(2, limit); ps.setInt(3, offset);
            try (ResultSet rs = ps.executeQuery()) { while (rs.next()) out.add(map(rs)); }
        } catch (SQLException e) { throw new RuntimeException(e); }
        return out;
    }

    @Override
    public long send(long conversationId, long senderId, String body, byte[] attachment) {
        final String sql = "INSERT INTO messages (conversation_id, sender_id, body, attachment_blob) VALUES (?, ?, ?, ?)";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, conversationId);
            ps.setLong(2, senderId);
            ps.setString(3, body);
            if (attachment != null) ps.setBytes(4, attachment); else ps.setNull(4, Types.BLOB);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) { return rs.next()? rs.getLong(1):0L; }
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    @Override
    public boolean markRead(long conversationId, long userId) {
        // Optional: set is_read=true for messages NOT sent by userId
        final String sql = "UPDATE messages SET is_read=TRUE WHERE conversation_id=? AND sender_id<>?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, conversationId); ps.setLong(2, userId);
            ps.executeUpdate();
            return true;
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    private static Message map(ResultSet rs) throws SQLException {
        Message m = new Message();
        m.setMessageId(rs.getLong("message_id"));
        m.setConversationId(rs.getLong("conversation_id"));
        m.setSenderId(rs.getLong("sender_id"));
        m.setBody(rs.getString("body"));
        m.setAttachmentBlob(rs.getBytes("attachment_blob"));
        Timestamp ct = rs.getTimestamp("created_at");
        if (ct!=null) m.setCreatedAt(ct.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime());
        m.setRead(rs.getBoolean("is_read"));
        return m;
    }
}
