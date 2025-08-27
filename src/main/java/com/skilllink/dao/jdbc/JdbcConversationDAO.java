package com.skilllink.dao.jdbc;

import com.skilllink.dao.ConversationDAO;
import com.skilllink.model.Conversation;

import java.sql.*;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;

public class JdbcConversationDAO implements ConversationDAO {
    @Override
    public long create(Long createdBy, Long jobId, boolean group) {
        final String sql = "INSERT INTO conversations (created_by, job_id, is_group) VALUES (?, ?, ?)";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, createdBy);
            if (jobId != null) ps.setLong(2, jobId); else ps.setNull(2, Types.BIGINT);
            ps.setBoolean(3, group);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) { return rs.next()? rs.getLong(1):0L; }
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    @Override
    public Conversation findById(long conversationId) {
        final String sql = "SELECT * FROM conversations WHERE conversation_id=?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, conversationId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
                return null;
            }
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    @Override
    public List<Conversation> listForUser(long userId, int limit, int offset) {
        final String sql =
            "SELECT c.* FROM conversations c " +
            "JOIN conversation_participants p ON p.conversation_id=c.conversation_id " +
            "WHERE p.user_id=? ORDER BY c.created_at DESC LIMIT ? OFFSET ?";
        List<Conversation> out = new ArrayList<>();
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, userId); ps.setInt(2, limit); ps.setInt(3, offset);
            try (ResultSet rs = ps.executeQuery()) { while (rs.next()) out.add(map(rs)); }
        } catch (SQLException e) { throw new RuntimeException(e); }
        return out;
    }

    @Override
    public boolean addParticipant(long conversationId, long userId) {
        final String sql = "INSERT INTO conversation_participants (conversation_id, user_id) VALUES (?, ?)";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, conversationId); ps.setLong(2, userId);
            return ps.executeUpdate()==1;
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    @Override
    public List<Long> listParticipants(long conversationId) {
        final String sql = "SELECT user_id FROM conversation_participants WHERE conversation_id=?";
        List<Long> ids = new ArrayList<>();
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, conversationId);
            try (ResultSet rs = ps.executeQuery()) { while (rs.next()) ids.add(rs.getLong(1)); }
        } catch (SQLException e) { throw new RuntimeException(e); }
        return ids;
    }

    private static Conversation map(ResultSet rs) throws SQLException {
        Conversation cv = new Conversation();
        cv.setConversationId(rs.getLong("conversation_id"));
        cv.setCreatedBy(rs.getLong("created_by"));
        cv.setJobId((Long)rs.getObject("job_id"));
        cv.setGroup(rs.getBoolean("is_group"));
        Timestamp ct = rs.getTimestamp("created_at");
        if (ct!=null) cv.setCreatedAt(ct.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime());
        return cv;
    }
}
