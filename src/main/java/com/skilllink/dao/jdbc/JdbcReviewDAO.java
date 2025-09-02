// src/main/java/com/skilllink/dao/jdbc/JdbcReviewDAO.java
package com.skilllink.dao.jdbc;

import com.skilllink.dao.ReviewDAO;
import com.skilllink.dao.dto.RecentReview;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class JdbcReviewDAO implements ReviewDAO {
	
	
    @Override
    public boolean existsForJobAndClient(long jobId, long clientId) {
        final String q = "SELECT 1 FROM reviews WHERE job_id=? AND client_id=? LIMIT 1";
        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(q)) {
            ps.setLong(1, jobId);
            ps.setLong(2, clientId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    @Override
    public long create(long jobId, long clientId, long workerId, int rating, String comment) {
        final String sql = "INSERT INTO reviews(job_id, client_id, worker_id, rating, comment) VALUES (?,?,?,?,?)";
        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, jobId);
            ps.setLong(2, clientId);
            ps.setLong(3, workerId);
            ps.setInt(4, rating);
            ps.setString(5, comment);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                rs.next();
                return rs.getLong(1);
            }
        } catch (SQLException e) {
            // duplicate (already reviewed) falls here because of the UNIQUE (job_id, client_id)
            throw new RuntimeException(e);
        }
    }

    @Override
    public List<RecentReview> listRecentForWorker(long workerId, int limit) {
        final String sql =
            "SELECT r.client_id, u.full_name AS client_name, r.rating, r.comment, " +
            "       jp.title AS job_title, DATE_FORMAT(r.created_at, '%Y-%m-%d %H:%i') AS created_at " +
            "FROM reviews r " +
            "JOIN users u   ON u.user_id = r.client_id " +
            "JOIN job_posts jp ON jp.job_id = r.job_id " +
            "WHERE r.worker_id=? " +
            "ORDER BY r.created_at DESC " +
            "LIMIT ?";
        List<RecentReview> out = new java.util.ArrayList<>();
        try (var con = DB.getConnection();
             var ps = con.prepareStatement(sql)) {
            ps.setLong(1, workerId);
            ps.setInt(2, Math.max(1, limit));
            try (var rs = ps.executeQuery()) {
                while (rs.next()) {
                    var rr = new RecentReview();
                    rr.setClientId(rs.getLong("client_id"));
                    rr.setClientName(rs.getString("client_name"));
                    rr.setRating(rs.getInt("rating"));
                    rr.setComment(rs.getString("comment"));
                    rr.setJobTitle(rs.getString("job_title"));
                    rr.setCreatedAt(rs.getString("created_at"));
                    out.add(rr);
                }
            }
        } catch (java.sql.SQLException e) {
            throw new RuntimeException(e);
        }
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
