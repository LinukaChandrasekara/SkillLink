package com.skilllink.dao.jdbc;

import com.skilllink.dao.ClientDAO;
import com.skilllink.dao.dto.ClientCompletedJob;
import com.skilllink.dao.dto.ClientStats;
import com.skilllink.model.enums.ClientType;

import java.sql.*;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;

public class JdbcClientDAO implements ClientDAO {
    @Override
    public boolean create(long userId, ClientType type) {
        final String sql = "INSERT INTO clients (user_id, client_type) VALUES (?, ?)";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, userId); ps.setString(2, type.toDb());
            return ps.executeUpdate() == 1;
        } catch (SQLException e) { throw new RuntimeException(e); }
    }
    @Override
    public boolean updateType(long userId, ClientType type) {
        final String sql = "UPDATE clients SET client_type=? WHERE user_id=?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, type.toDb()); ps.setLong(2, userId);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) { throw new RuntimeException(e); }
    }
    @Override
    public boolean exists(long userId) {
        final String sql = "SELECT 1 FROM clients WHERE user_id=?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        } catch (SQLException e) { throw new RuntimeException(e); }
    }
    @Override
    public String getClientType(long userId) {
        final String sql = "SELECT client_type FROM clients WHERE user_id=?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) { return rs.next() ? rs.getString(1) : null; }
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    @Override
    public boolean setClientType(long userId, String type) {
        if (!"individual".equalsIgnoreCase(type) && !"business".equalsIgnoreCase(type)) type = "individual";
        // upsert: insert if missing, else update
        final String upsert =
            "INSERT INTO clients(user_id, client_type) VALUES (?,?) " +
            "ON DUPLICATE KEY UPDATE client_type=VALUES(client_type)";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(upsert)) {
            ps.setLong(1, userId);
            ps.setString(2, type.toLowerCase());
            return ps.executeUpdate() >= 1;
        } catch (SQLException e) { throw new RuntimeException(e); }
    }
    @Override
    public ClientStats getStats(long clientId) {
        final String qPosted  = "SELECT COUNT(*) FROM job_posts WHERE client_id=?";
        final String qPending = "SELECT COUNT(*) FROM job_posts WHERE client_id=? AND status='pending'";
        final String qHired   =
            "SELECT COUNT(*) " +
            "FROM job_assignments ja " +
            "JOIN job_posts jp ON jp.job_id=ja.job_id " +
            "WHERE jp.client_id=? AND ja.status IN ('accepted','in_progress','completed')";

        try (Connection con = DB.getConnection()) {
            long posted, pending, hired;

            try (PreparedStatement ps = con.prepareStatement(qPosted)) {
                ps.setLong(1, clientId);
                try (ResultSet rs = ps.executeQuery()) { rs.next(); posted = rs.getLong(1); }
            }

            try (PreparedStatement ps = con.prepareStatement(qPending)) {
                ps.setLong(1, clientId);
                try (ResultSet rs = ps.executeQuery()) { rs.next(); pending = rs.getLong(1); }
            }

            try (PreparedStatement ps = con.prepareStatement(qHired)) {
                ps.setLong(1, clientId);
                try (ResultSet rs = ps.executeQuery()) { rs.next(); hired = rs.getLong(1); }
            }

            return new ClientStats(posted, hired, pending);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public List<ClientCompletedJob> listCompletedJobs(long clientId, int limit) {
        final String sql =
            "SELECT jp.job_id, jp.title, jp.budget_amount, " +
            "       ja.worker_id, u.full_name AS worker_name, " +
            "       jp.updated_at AS completed_at, " +
            "       r.review_id " +
            "FROM job_assignments ja " +
            "JOIN job_posts jp ON jp.job_id = ja.job_id " +
            "JOIN users u ON u.user_id = ja.worker_id " +         // worker name
            "LEFT JOIN reviews r ON r.job_id = jp.job_id AND r.client_id = jp.client_id " +
            "WHERE jp.client_id = ? AND ja.status = 'completed' " +
            "ORDER BY COALESCE(jp.updated_at, ja.assigned_at) DESC " +
            "LIMIT ?";

        List<ClientCompletedJob> out = new ArrayList<>();
        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, clientId);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ClientCompletedJob x = new ClientCompletedJob();
                    x.setJobId(rs.getLong("job_id"));
                    x.setTitle(rs.getString("title"));
                    x.setBudgetAmount(rs.getDouble("budget_amount"));
                    x.setWorkerId(rs.getLong("worker_id"));
                    x.setWorkerName(rs.getString("worker_name"));

                    Timestamp t = rs.getTimestamp("completed_at");
                    if (t != null) {
                        x.setCompletedAt(t.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime());
                    }
                    x.setReviewed(rs.getObject("review_id") != null);
                    out.add(x);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return out;
    }

    @Override
    public ClientCompletedJob findCompletedJob(long clientId, long jobId) {
        final String sql =
            "SELECT jp.job_id, jp.title, jp.budget_amount, " +
            "       ja.worker_id, u.full_name AS worker_name, " +
            "       jp.updated_at AS completed_at, " +
            "       r.review_id " +
            "FROM job_assignments ja " +
            "JOIN job_posts jp ON jp.job_id = ja.job_id " +
            "JOIN users u ON u.user_id = ja.worker_id " +
            "LEFT JOIN reviews r ON r.job_id = jp.job_id AND r.client_id = jp.client_id " +
            "WHERE jp.client_id = ? AND ja.status = 'completed' AND jp.job_id = ? " +
            "LIMIT 1";
        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, clientId);
            ps.setLong(2, jobId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                ClientCompletedJob x = new ClientCompletedJob();
                x.setJobId(rs.getLong("job_id"));
                x.setTitle(rs.getString("title"));
                x.setBudgetAmount(rs.getDouble("budget_amount"));
                x.setWorkerId(rs.getLong("worker_id"));
                x.setWorkerName(rs.getString("worker_name"));
                x.setReviewed(rs.getObject("review_id") != null);
                Timestamp t = rs.getTimestamp("completed_at");
                if (t != null) x.setCompletedAt(t.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime());
                return x;
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
