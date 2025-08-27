package com.skilllink.dao.jdbc;

import com.skilllink.dao.JobPostDAO;
import com.skilllink.dao.dto.PagedResult;
import com.skilllink.model.JobPost;
import com.skilllink.model.enums.JobStatus;

import java.sql.*;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class JdbcJobPostDAO implements JobPostDAO {

    @Override
    public long countByStatus(JobStatus status) {
        final String sql = "SELECT COUNT(*) FROM job_posts WHERE status=?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status.toDb());
            try (ResultSet rs = ps.executeQuery()) { return rs.next()? rs.getLong(1):0L; }
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    @Override
    public PagedResult<JobPost> list(String q, JobStatus status, int page, int pageSize) {
        page = Math.max(1, page);
        pageSize = Math.min(Math.max(5, pageSize), 100);
        int offset = (page-1) * pageSize;

        String base = " FROM job_posts j JOIN job_categories jc ON jc.job_category_id=j.job_category_id " +
                      " JOIN users u ON u.user_id=j.client_id WHERE 1=1 ";
        List<Object> params = new ArrayList<>();
        if (q != null && !q.isBlank()) {
            base += " AND (j.title LIKE ? OR j.description LIKE ?) ";
            String like = "%" + q.trim() + "%"; params.add(like); params.add(like);
        }
        if (status != null) { base += " AND j.status=? "; params.add(status.toDb()); }

        String countSql = "SELECT COUNT(*) " + base;
        String dataSql  = "SELECT j.*, jc.name AS job_category_name, u.full_name AS client_name " +
                          base + " ORDER BY j.created_at DESC LIMIT ? OFFSET ?";

        try (Connection c = DB.getConnection()) {
            long total;
            try (PreparedStatement cps = c.prepareStatement(countSql)) {
                bind(cps, params);
                try (ResultSet rs = cps.executeQuery()) { total = rs.next()? rs.getLong(1):0L; }
            }
            List<JobPost> items = new ArrayList<>();
            try (PreparedStatement dps = c.prepareStatement(dataSql)) {
                List<Object> p2 = new ArrayList<>(params); p2.add(pageSize); p2.add(offset);
                bind(dps, p2);
                try (ResultSet rs = dps.executeQuery()) {
                    while (rs.next()) items.add(map(rs));
                }
            }
            int totalPages = (int)Math.ceil(total / (double)pageSize);
            return new PagedResult<>(items, page, pageSize, totalPages, total);
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    @Override
    public Optional<JobPost> findById(long jobId) {
        final String sql = "SELECT j.*, jc.name AS job_category_name, u.full_name AS client_name " +
                "FROM job_posts j JOIN job_categories jc ON jc.job_category_id=j.job_category_id " +
                "JOIN users u ON u.user_id=j.client_id WHERE j.job_id=?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, jobId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(map(rs));
                return Optional.empty();
            }
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    @Override
    public boolean approve(long jobId, long adminId) {
        final String sql = "UPDATE job_posts SET status='approved', reviewer_admin_id=?, reviewed_at=NOW() WHERE job_id=?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, adminId); ps.setLong(2, jobId);
            return ps.executeUpdate()==1;
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    @Override
    public boolean deny(long jobId, long adminId, String notes) {
        // (notes) can be saved later in a notes table if needed; schema doesn't include it now
        final String sql = "UPDATE job_posts SET status='denied', reviewer_admin_id=?, reviewed_at=NOW() WHERE job_id=?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, adminId); ps.setLong(2, jobId);
            return ps.executeUpdate()==1;
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    private static void bind(PreparedStatement ps, List<Object> params) throws SQLException {
        for (int i=0;i<params.size();i++) ps.setObject(i+1, params.get(i));
    }
    private static JobPost map(ResultSet rs) throws SQLException {
        JobPost j = new JobPost();
        j.setJobId(rs.getLong("job_id"));
        j.setClientId(rs.getLong("client_id"));
        j.setJobCategoryId(rs.getLong("job_category_id"));
        j.setTitle(rs.getString("title"));
        j.setDescription(rs.getString("description"));
        j.setBudgetAmount(rs.getBigDecimal("budget_amount"));
        j.setLocationText(rs.getString("location_text"));
        j.setStatus(com.skilllink.model.enums.JobStatus.fromDb(rs.getString("status")));
        j.setReviewerAdminId((Long)rs.getObject("reviewer_admin_id"));
        Timestamp t = rs.getTimestamp("reviewed_at"); if (t!=null) j.setReviewedAt(t.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime());
        Timestamp c = rs.getTimestamp("created_at"); if (c!=null) j.setCreatedAt(c.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime());
        Timestamp u = rs.getTimestamp("updated_at"); if (u!=null) j.setUpdatedAt(u.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime());
        j.setJobCategoryName(rs.getString("job_category_name"));
        j.setClientName(rs.getString("client_name"));
        return j;
    }
}
