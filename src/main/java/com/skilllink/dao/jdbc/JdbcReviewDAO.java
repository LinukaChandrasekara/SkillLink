// src/main/java/com/skilllink/dao/jdbc/JdbcReviewDAO.java
package com.skilllink.dao.jdbc;

import com.skilllink.dao.ReviewDAO;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class JdbcReviewDAO implements ReviewDAO {

    @Override
    public List<ReviewView> listRecentForWorker(long workerId, int limit) {
        final String sql =
            "SELECT r.rating, r.comment, r.created_at, u.user_id AS client_id, u.full_name AS client_name, j.title AS job_title " +
            "FROM reviews r " +
            "JOIN users u ON u.user_id = r.client_id " +
            "JOIN job_posts j ON j.job_id = r.job_id " +
            "WHERE r.worker_id=? " +
            "ORDER BY r.created_at DESC LIMIT ?";
        List<ReviewView> out = new ArrayList<>();
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, workerId);
            ps.setInt(2, Math.max(1, limit));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ReviewView v = new ReviewView();
                    v.clientId  = rs.getLong("client_id");
                    v.clientName= rs.getString("client_name");
                    v.jobTitle  = rs.getString("job_title");
                    v.rating    = rs.getInt("rating");
                    v.comment   = rs.getString("comment");
                    Timestamp t = rs.getTimestamp("created_at");
                    v.createdAt = (t==null) ? "-" : t.toString();
                    out.add(v);
                }
            }
        } catch (SQLException e) { throw new RuntimeException(e); }
        return out;
    }
    @Override
    public Integer findWorkerCategoryId(long workerId) {
        final String sql = "SELECT job_category_id FROM workers WHERE user_id=?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, workerId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : null;
            }
        } catch (SQLException e) { throw new RuntimeException(e); }
    }
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
