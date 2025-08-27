package com.skilllink.dao.jdbc;

import com.skilllink.dao.UserDAO;
import com.skilllink.dao.dto.PagedResult;
import com.skilllink.model.User;
import com.skilllink.model.enums.RoleName;
import com.skilllink.model.enums.VerificationStatus;

import java.sql.*;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class JdbcUserDAO implements UserDAO {

    @Override
    public long countAll() {
        final String sql = "SELECT COUNT(*) FROM users";
        try (Connection c = DB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getLong(1) : 0L;
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    @Override
    public long countByRole(String roleName) {
        final String sql =
            "SELECT COUNT(*) FROM users u JOIN roles r ON r.role_id=u.role_id WHERE r.role_name=?";
        try (Connection c = DB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, roleName);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getLong(1) : 0L;
            }
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    @Override
    public long countByVerification(String status) {
        final String sql = "SELECT COUNT(*) FROM users WHERE verification_status=?";
        try (Connection c = DB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getLong(1) : 0L;
            }
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    @Override
    public long countDisabled() {
        final String sql = "SELECT COUNT(*) FROM users WHERE is_active=FALSE";
        try (Connection c = DB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getLong(1) : 0L;
        } catch (SQLException e) { throw new RuntimeException(e); }
    }
    @Override
    public Optional findById(long userId) {
        final String sql =
            "SELECT u.user_id, u.full_name, u.username, r.role_name " +
            "FROM users u JOIN roles r ON r.role_id=u.role_id WHERE u.user_id=?";
        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                User u = new User();
                u.setUserId(rs.getLong("user_id"));
                u.setFullName(rs.getString("full_name"));
                u.setUsername(rs.getString("username"));
                u.setRoleName(RoleName.fromDb(rs.getString("role_name")));
                return Optional.empty();
            }
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    @Override
    public long countByRoleAndVerification(String roleName, String status) {
        final String sql = "SELECT COUNT(*) FROM users u JOIN roles r ON r.role_id=u.role_id WHERE r.role_name=? AND u.verification_status=?";
        try (var c = DB.getConnection(); var ps = c.prepareStatement(sql)) {
            ps.setString(1, roleName); ps.setString(2, status);
            try (var rs = ps.executeQuery()) { return rs.next()? rs.getLong(1):0L; }
        } catch (java.sql.SQLException e) { throw new RuntimeException(e); }
    }

    @Override
    public Optional<User> findByUsernameOrEmail(String login) {
        final String sql =
            "SELECT u.*, r.role_name FROM users u JOIN roles r ON r.role_id=u.role_id " +
            "WHERE u.username=? OR u.email=? LIMIT 1";
        try (Connection c = DB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, login);
            ps.setString(2, login);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(map(rs));
                return Optional.empty();
            }
        } catch (SQLException e) { throw new RuntimeException(e); }
    }
    @Override
    public List<User> listRecentNonAdmin(int limit) {
        final String sql =
            "SELECT u.user_id, u.full_name, u.username, r.role_name " +
            "FROM users u JOIN roles r ON r.role_id=u.role_id " +
            "WHERE r.role_name IN ('worker','client') " +
            "ORDER BY u.updated_at DESC LIMIT ?";
        List<User> out = new ArrayList<>();
        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, Math.max(1, limit));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User u = new User();
                    u.setUserId(rs.getLong("user_id"));
                    u.setFullName(rs.getString("full_name"));
                    u.setUsername(rs.getString("username"));
                    u.setRoleName(RoleName.fromDb(rs.getString("role_name")));
                    out.add(u);
                }
            }
        } catch (SQLException e) { throw new RuntimeException(e); }
        return out;
    }

    @Override
    public PagedResult<User> list(String q, String roleName, String verification, int page, int pageSize) {
        page = Math.max(1, page);
        pageSize = Math.min(Math.max(5, pageSize), 100);
        int offset = (page - 1) * pageSize;

        String base =
            " FROM users u JOIN roles r ON r.role_id=u.role_id WHERE 1=1 ";
        List<Object> params = new ArrayList<>();

        if (q != null && !q.isBlank()) {
            base += " AND (u.full_name LIKE ? OR u.email LIKE ? OR u.username LIKE ?) ";
            String like = "%" + q.trim() + "%";
            params.add(like); params.add(like); params.add(like);
        }
        if (roleName != null && !roleName.isBlank()) {
            base += " AND r.role_name=? "; params.add(roleName);
        }
        if (verification != null && !verification.isBlank()) {
            base += " AND u.verification_status=? "; params.add(verification);
        }

        String countSql = "SELECT COUNT(*) " + base;
        String dataSql  = "SELECT u.*, r.role_name " + base + " ORDER BY u.created_at DESC LIMIT ? OFFSET ?";

        try (Connection c = DB.getConnection()) {
            long total;
            try (PreparedStatement cps = c.prepareStatement(countSql)) {
                bindParams(cps, params);
                try (ResultSet rs = cps.executeQuery()) { total = rs.next() ? rs.getLong(1) : 0L; }
            }

            List<User> items = new ArrayList<>();
            try (PreparedStatement dps = c.prepareStatement(dataSql)) {
                List<Object> p2 = new ArrayList<>(params);
                p2.add(pageSize); p2.add(offset);
                bindParams(dps, p2);
                try (ResultSet rs = dps.executeQuery()) {
                    while (rs.next()) items.add(map(rs));
                }
            }
            int totalPages = (int) Math.ceil(total / (double) pageSize);
            return new PagedResult<>(items, page, pageSize, totalPages, total);
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    @Override
    public long create(User u) {
        final String sql =
            "INSERT INTO users (role_id, full_name, nid, phone, email, age, address_line, " +
            "username, password_hash, bio, profile_picture, verification_status, is_active) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection c = DB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, u.getRoleId());
            ps.setString(2, u.getFullName());
            ps.setString(3, u.getNid());
            ps.setString(4, u.getPhone());
            ps.setString(5, u.getEmail());
            ps.setInt(6, u.getAge());
            ps.setString(7, u.getAddressLine());
            ps.setString(8, u.getUsername());
            ps.setString(9, u.getPasswordHash());
            ps.setString(10, u.getBio());
            if (u.getProfilePicture() != null) ps.setBytes(11, u.getProfilePicture()); else ps.setNull(11, Types.BLOB);
            ps.setString(12, u.getVerificationStatus() == null ? "unverified" : u.getVerificationStatus().toDb());
            ps.setBoolean(13, u.isActive());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                return rs.next() ? rs.getLong(1) : 0L;
            }
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    @Override
    public boolean update(User u) {
        final String sql =
            "UPDATE users SET role_id=?, full_name=?, nid=?, phone=?, email=?, age=?, address_line=?, " +
            "username=?, password_hash=?, bio=?, verification_status=?, is_active=? WHERE user_id=?";
        try (Connection c = DB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, u.getRoleId());
            ps.setString(2, u.getFullName());
            ps.setString(3, u.getNid());
            ps.setString(4, u.getPhone());
            ps.setString(5, u.getEmail());
            ps.setInt(6, u.getAge());
            ps.setString(7, u.getAddressLine());
            ps.setString(8, u.getUsername());
            ps.setString(9, u.getPasswordHash());
            ps.setString(10, u.getBio());
            ps.setString(11, u.getVerificationStatus()==null?"unverified":u.getVerificationStatus().toDb());
            ps.setBoolean(12, u.isActive());
            ps.setLong(13, u.getUserId());
            return ps.executeUpdate() == 1;
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    @Override
    public boolean setVerificationStatus(long userId, VerificationStatus status) {
        final String sql = "UPDATE users SET verification_status=? WHERE user_id=?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status.toDb()); ps.setLong(2, userId);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    @Override
    public boolean setActive(long userId, boolean active) {
        final String sql = "UPDATE users SET is_active=? WHERE user_id=?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setBoolean(1, active); ps.setLong(2, userId);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    @Override
    public boolean delete(long userId) {
        final String sql = "DELETE FROM users WHERE user_id=?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, userId);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    @Override
    public byte[] getProfilePicture(long userId) {
        final String sql = "SELECT profile_picture FROM users WHERE user_id=?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getBytes(1);
            }
            return null;
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    @Override
    public boolean updateProfilePicture(long userId, byte[] pic) {
        final String sql = "UPDATE users SET profile_picture=? WHERE user_id=?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            if (pic != null) ps.setBytes(1, pic); else ps.setNull(1, Types.BLOB);
            ps.setLong(2, userId);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    // --- helpers ---
    private static void bindParams(PreparedStatement ps, List<Object> params) throws SQLException {
        for (int i=0;i<params.size();i++) ps.setObject(i+1, params.get(i));
    }

    private static User map(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserId(rs.getLong("user_id"));
        u.setRoleId(rs.getInt("role_id"));
        u.setRoleName(RoleName.fromDb(rs.getString("role_name")));
        u.setFullName(rs.getString("full_name"));
        u.setNid(rs.getString("nid"));
        u.setPhone(rs.getString("phone"));
        u.setEmail(rs.getString("email"));
        u.setAge(rs.getInt("age"));
        u.setAddressLine(rs.getString("address_line"));
        u.setUsername(rs.getString("username"));
        u.setPasswordHash(rs.getString("password_hash"));
        u.setBio(rs.getString("bio"));
        // Do not load profile_picture here for performance; use getProfilePicture endpoint
        u.setVerificationStatus(VerificationStatus.fromDb(rs.getString("verification_status")));
        u.setActive(rs.getBoolean("is_active"));
        if (rs.getTimestamp("created_at") != null)
            u.setCreatedAt(rs.getTimestamp("created_at").toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime());
        if (rs.getTimestamp("updated_at") != null)
            u.setUpdatedAt(rs.getTimestamp("updated_at").toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime());
        return u;
    }
}
