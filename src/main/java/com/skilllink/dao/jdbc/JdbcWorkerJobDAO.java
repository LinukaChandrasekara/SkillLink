// src/main/java/com/skilllink/dao/jdbc/JdbcWorkerJobDAO.java
package com.skilllink.dao.jdbc;

import com.skilllink.dao.WorkerJobDAO;
import com.skilllink.model.JobPost;
import com.skilllink.model.enums.JobStatus;

import java.sql.*;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;

public class JdbcWorkerJobDAO implements WorkerJobDAO {

    @Override
    public List<JobPost> listOffersForWorker(long workerId, int limit) {
        final String sql = """
            SELECT j.*, jc.name AS job_category_name, u.full_name AS client_name
            FROM job_posts j
            JOIN workers w  ON w.user_id=? AND w.job_category_id=j.job_category_id
            JOIN job_categories jc ON jc.job_category_id=j.job_category_id
            JOIN users u ON u.user_id=j.client_id
            LEFT JOIN job_assignments a ON a.job_id=j.job_id
            WHERE j.status='approved' AND a.job_id IS NULL
            ORDER BY j.created_at DESC
            LIMIT ?
        """;
        List<JobPost> out = new ArrayList<>();
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, workerId);
            ps.setInt(2, Math.max(1, limit));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) out.add(mapJob(rs));
            }
        } catch (SQLException e) { throw new RuntimeException(e); }
        return out;
    }

    @Override
    public boolean acceptJob(long jobId, long workerId) {
        final String ins = "INSERT INTO job_assignments(job_id, worker_id) VALUES (?,?)";
        try (Connection c = DB.getConnection()) {
            c.setAutoCommit(false);
            try (PreparedStatement ps = c.prepareStatement(ins)) {
                ps.setLong(1, jobId); ps.setLong(2, workerId);
                ps.executeUpdate();
            }
            try (PreparedStatement ps2 = c.prepareStatement(
                    "UPDATE job_posts SET status='closed' WHERE job_id=? AND status='approved'")) {
                ps2.setLong(1, jobId);
                ps2.executeUpdate();
            }
            c.commit();
            return true;
        } catch (SQLIntegrityConstraintViolationException dup) {
            return false; // already taken
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public List<WorkerAcceptedJob> listAcceptedByWorker(long workerId) {
        final String sql = """
            SELECT j.job_id, j.title, u.full_name AS client_name, jc.name AS category_name,
                   j.location_text, j.budget_amount, a.assigned_at, a.status
            FROM job_assignments a
            JOIN job_posts j       ON j.job_id = a.job_id
            JOIN users u           ON u.user_id = j.client_id
            JOIN job_categories jc ON jc.job_category_id=j.job_category_id
            WHERE a.worker_id=?
            ORDER BY a.assigned_at DESC
        """;
        List<WorkerAcceptedJob> out = new ArrayList<>();
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, workerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    WorkerAcceptedJob w = new WorkerAcceptedJob();
                    w.setJobId(rs.getLong("job_id"));
                    w.setTitle(rs.getString("title"));
                    w.setClientName(rs.getString("client_name"));
                    w.setCategoryName(rs.getString("category_name"));
                    w.setLocationText(rs.getString("location_text"));
                    w.setBudgetAmount(rs.getBigDecimal("budget_amount"));
                    Timestamp t = rs.getTimestamp("assigned_at");
                    if (t != null) w.setAcceptedAt(t.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime());
                    w.setAssignmentStatus(rs.getString("status"));
                    out.add(w);
                }
            }
        } catch (SQLException e) { throw new RuntimeException(e); }
        return out;
    }

    @Override
    public boolean markCompleted(long jobId, long workerId) {
        final String up1 = "UPDATE job_assignments SET status='completed' WHERE job_id=? AND worker_id=? AND status<>'completed'";
        final String up2 = "UPDATE job_posts SET status='completed' WHERE job_id=? AND status<>'completed'";
        try (Connection c = DB.getConnection()) {
            c.setAutoCommit(false);
            int a;
            try (PreparedStatement ps = c.prepareStatement(up1)) {
                ps.setLong(1, jobId); ps.setLong(2, workerId);
                a = ps.executeUpdate();
            }
            if (a == 0) { c.rollback(); return false; }
            try (PreparedStatement ps2 = c.prepareStatement(up2)) {
                ps2.setLong(1, jobId);
                ps2.executeUpdate();
            }
            c.commit();
            return true;
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    // --- helpers ---
    private static JobPost mapJob(ResultSet rs) throws SQLException {
        JobPost j = new JobPost();
        j.setJobId(rs.getLong("job_id"));
        j.setClientId(rs.getLong("client_id"));
        j.setJobCategoryId((int) rs.getLong("job_category_id"));
        j.setTitle(rs.getString("title"));
        j.setDescription(rs.getString("description"));
        j.setBudgetAmount(rs.getBigDecimal("budget_amount"));
        j.setLocationText(rs.getString("location_text"));
        j.setStatus(JobStatus.fromDb(rs.getString("status")));
        Timestamp cts = rs.getTimestamp("created_at");
        if (cts != null) j.setCreatedAt(cts.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime());
        j.setJobCategoryName(rs.getString("job_category_name"));
        j.setClientName(rs.getString("client_name"));
        return j;
    }
}
