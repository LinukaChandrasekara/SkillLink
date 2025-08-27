package com.skilllink.dao.jdbc;

import com.skilllink.dao.VerificationSubmissionDAO;
import com.skilllink.dao.dto.PagedResult;
import com.skilllink.model.VerificationSubmission;
import com.skilllink.model.enums.VerificationStatus;

import java.sql.*;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;

public class JdbcVerificationSubmissionDAO implements VerificationSubmissionDAO {

    @Override
    public PagedResult<VerificationSubmission> list(String q, VerificationStatus status, int page, int pageSize) {
        page = Math.max(1, page);
        pageSize = Math.min(Math.max(5, pageSize), 100);
        int offset = (page-1)*pageSize;

        String base = " FROM verification_submissions vs " +
                      " JOIN users u ON u.user_id=vs.user_id " +
                      " JOIN roles r ON r.role_id=u.role_id WHERE 1=1 ";
        List<Object> params = new ArrayList<>();
        if (q != null && !q.isBlank()) {
            base += " AND (u.full_name LIKE ? OR u.username LIKE ? OR u.email LIKE ?) ";
            String like = "%" + q.trim() + "%";
            params.add(like); params.add(like); params.add(like);
        }
        if (status != null) { base += " AND vs.status=? "; params.add(status.toDb()); }

        String countSql = "SELECT COUNT(*) " + base;
        String dataSql  = "SELECT vs.*, u.full_name, u.username, r.role_name " +
                          base + " ORDER BY vs.created_at DESC LIMIT ? OFFSET ?";

        try (Connection c = DB.getConnection()) {
            long total;
            try (PreparedStatement cps = c.prepareStatement(countSql)) {
                bind(cps, params);
                try (ResultSet rs = cps.executeQuery()) { total = rs.next()? rs.getLong(1):0L; }
            }
            List<VerificationSubmission> items = new ArrayList<>();
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
    public VerificationSubmission findById(long submissionId) {
        final String sql = "SELECT vs.*, u.full_name, u.username " +
                           "FROM verification_submissions vs JOIN users u ON u.user_id=vs.user_id WHERE vs.submission_id=?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, submissionId);
            try (ResultSet rs = ps.executeQuery()) { return rs.next()? map(rs): null; }
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    @Override
    public byte[] getPhoto(long submissionId) {
        final String sql = "SELECT id_photo FROM verification_submissions WHERE submission_id=?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, submissionId);
            try (ResultSet rs = ps.executeQuery()) { return rs.next()? rs.getBytes(1): null; }
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    @Override
    public boolean approve(long submissionId, long reviewerAdminId, String notes) {
        final String sql = "UPDATE verification_submissions " +
                           "SET status='approved', reviewer_admin_id=?, reviewer_notes=?, decided_at=NOW() " +
                           "WHERE submission_id=?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, reviewerAdminId);
            ps.setString(2, notes);
            ps.setLong(3, submissionId);
            return ps.executeUpdate()==1;
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    @Override
    public boolean deny(long submissionId, long reviewerAdminId, String notes) {
        final String sql = "UPDATE verification_submissions " +
                           "SET status='denied', reviewer_admin_id=?, reviewer_notes=?, decided_at=NOW() " +
                           "WHERE submission_id=?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, reviewerAdminId);
            ps.setString(2, notes);
            ps.setLong(3, submissionId);
            return ps.executeUpdate()==1;
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    @Override
    public long create(long userId, byte[] idPhoto) {
        final String sql = "INSERT INTO verification_submissions (user_id, id_photo) VALUES (?, ?)";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, userId); ps.setBytes(2, idPhoto);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) { return rs.next()? rs.getLong(1):0L; }
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    private static void bind(PreparedStatement ps, List<Object> params) throws SQLException {
        for (int i=0;i<params.size();i++) ps.setObject(i+1, params.get(i));
    }
    private static VerificationSubmission map(ResultSet rs) throws SQLException {
        VerificationSubmission v = new VerificationSubmission();
        v.setSubmissionId(rs.getLong("submission_id"));
        v.setUserId(rs.getLong("user_id"));
        v.setStatus(VerificationStatus.fromDb(rs.getString("status")));
        v.setReviewerAdminId((Long)rs.getObject("reviewer_admin_id"));
        v.setReviewerNotes(rs.getString("reviewer_notes"));
        Timestamp ct = rs.getTimestamp("created_at");
        if (ct!=null) v.setCreatedAt(ct.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime());
        Timestamp dt = rs.getTimestamp("decided_at");
        if (dt!=null) v.setDecidedAt(dt.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime());
        v.setUserFullName(rs.getString("full_name"));
        v.setUsername(rs.getString("username"));
        return v;
    }
}
