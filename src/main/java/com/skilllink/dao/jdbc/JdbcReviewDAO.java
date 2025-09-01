// src/main/java/com/skilllink/dao/jdbc/JdbcReviewDAO.java
package com.skilllink.dao.jdbc;

import com.skilllink.dao.ReviewDAO;
import java.sql.*;

public class JdbcReviewDAO implements ReviewDAO {

    @Override
    public long countCompletedForWorker(long workerId) {
        final String sql = "SELECT COUNT(*) FROM reviews WHERE worker_id=?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, workerId);
            try (ResultSet rs = ps.executeQuery()) { return rs.next()? rs.getLong(1):0L; }
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    @Override
    public RatingSummary getRatingSummary(long workerId) {
        final String sql = "SELECT AVG(rating) AS avg_rating, COUNT(*) AS cnt FROM reviews WHERE worker_id=?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, workerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    double avg = rs.getDouble("avg_rating");
                    long cnt = rs.getLong("cnt");
                    if (rs.wasNull()) { avg = 0.0; cnt = 0L; }
                    return new RatingSummary(avg, cnt);
                }
                return new RatingSummary(0.0, 0L);
            }
        } catch (SQLException e) { throw new RuntimeException(e); }
    }
}
