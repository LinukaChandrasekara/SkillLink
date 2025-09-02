package com.skilllink.dao.jdbc;

import com.skilllink.dao.ConversationDAO;
import com.skilllink.dao.dto.ConversationSummary;

import java.sql.*;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;

public class JdbcConversationDAO implements ConversationDAO {

    @Override
    public List<ConversationSummary> listForUser(long userId) {
        // Pull conversations where the user participates + last message + "other user" (for 1:1)
        final String sql =
            "SELECT c.conversation_id, c.is_group, " +
            "       ou.user_id AS other_user_id, ou.full_name AS other_full_name, " +
            "       MAX(m.created_at) AS last_time, " +
            "       SUBSTRING_INDEX( " +
            "         MAX(CONCAT(LPAD(UNIX_TIMESTAMP(m.created_at),10,'0'),'||', COALESCE(m.body,''))), " +
            "         '||', -1 " +
            "       ) AS last_snippet " +
            "FROM conversations c " +
            "JOIN conversation_participants cp " +
            "  ON cp.conversation_id = c.conversation_id AND cp.user_id = ? " +
            "LEFT JOIN ( " +
            "   SELECT cp2.conversation_id, u.user_id, u.full_name " +
            "   FROM conversation_participants cp2 " +
            "   JOIN users u ON u.user_id = cp2.user_id " +
            "   WHERE cp2.user_id <> ? " +
            ") ou ON ou.conversation_id = c.conversation_id " +
            "LEFT JOIN messages m ON m.conversation_id = c.conversation_id " +
            "GROUP BY c.conversation_id, c.is_group, ou.user_id, ou.full_name " +
            "ORDER BY last_time DESC";

        List<ConversationSummary> out = new ArrayList<>();
        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ps.setLong(2, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ConversationSummary cs = new ConversationSummary();
                    long cid = rs.getLong("conversation_id");
                    boolean isGroup = rs.getBoolean("is_group");
                    long otherId = rs.getLong("other_user_id");
                    String otherName = rs.getString("other_full_name");

                    cs.setConversationId(cid);
                    cs.setOtherUserId(isGroup ? 0L : otherId);
                    cs.setTitle(isGroup
                        ? ("Group #" + cid)
                        : (otherName == null ? ("Conversation #" + cid) : otherName));

                    cs.setLastSnippet(rs.getString("last_snippet"));

                    Timestamp t = rs.getTimestamp("last_time");
                    if (t != null) {
                        cs.setLastMessageAt(t.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime());
                    }

                    cs.setUnreadCount(unreadCountForViewer(con, cid, userId));
                    out.add(cs);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return out;
    }

    private long unreadCountForViewer(Connection con, long conversationId, long viewerId) throws SQLException {
        final String q = "SELECT COUNT(*) FROM messages WHERE conversation_id=? AND sender_id<>? AND is_read=0";
        try (PreparedStatement ps = con.prepareStatement(q)) {
            ps.setLong(1, conversationId);
            ps.setLong(2, viewerId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getLong(1) : 0L;
            }
        }
    }

    @Override
    public Long findDirectConversation(long userId1, long userId2) {
        final String sql =
            "SELECT c.conversation_id " +
            "FROM conversations c " +
            "JOIN conversation_participants cp1 ON cp1.conversation_id=c.conversation_id AND cp1.user_id=? " +
            "JOIN conversation_participants cp2 ON cp2.conversation_id=c.conversation_id AND cp2.user_id=? " +
            "WHERE c.is_group=0 " +
            "GROUP BY c.conversation_id " +
            "HAVING COUNT(*)=2 " +
            "LIMIT 1";
        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, userId1);
            ps.setLong(2, userId2);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getLong(1) : null;
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public long create(long createdBy, Long jobId, boolean isGroup) {
        final String sql = "INSERT INTO conversations(created_by, job_id, is_group) VALUES (?,?,?)";
        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, createdBy);
            if (jobId == null) ps.setNull(2, Types.BIGINT); else ps.setLong(2, jobId);
            ps.setBoolean(3, isGroup);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                rs.next();
                return rs.getLong(1);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void addParticipant(long conversationId, long userId) {
        final String sql = "INSERT IGNORE INTO conversation_participants(conversation_id, user_id) VALUES (?,?)";
        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, conversationId);
            ps.setLong(2, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public long findOtherParticipant(long conversationId, long currentUserId) {
        final String sql = "SELECT user_id FROM conversation_participants WHERE conversation_id=? AND user_id<>? LIMIT 1";
        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, conversationId);
            ps.setLong(2, currentUserId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getLong(1) : currentUserId; // fallback to self
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
