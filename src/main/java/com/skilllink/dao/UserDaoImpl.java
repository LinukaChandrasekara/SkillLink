package com.skilllink.dao;

import com.skilllink.model.User;
import com.skilllink.util.DBUtil;

import java.sql.*;

public class UserDaoImpl implements UserDao {

    @Override
    public boolean existsByUsernameOrEmail(String username, String email) throws Exception {
        String sql = "SELECT 1 FROM users WHERE username = ? OR email = ? LIMIT 1";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    @Override
    public User findByUsernameOrEmail(String usernameOrEmail) throws Exception {
        String sql = "SELECT * FROM users WHERE username = ? OR email = ? LIMIT 1";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, usernameOrEmail);
            ps.setString(2, usernameOrEmail);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setUserId(rs.getLong("user_id"));
                    u.setRoleId(rs.getInt("role_id"));
                    u.setFullName(rs.getString("full_name"));
                    u.setNid(rs.getString("nid"));
                    u.setPhone(rs.getString("phone"));
                    u.setEmail(rs.getString("email"));
                    u.setAge(rs.getShort("age"));
                    u.setAddressLine(rs.getString("address_line"));
                    u.setUsername(rs.getString("username"));
                    u.setPasswordHash(rs.getString("password_hash"));
                    u.setBio(rs.getString("bio"));
                    u.setProfilePicture(rs.getBytes("profile_picture"));
                    u.setVerificationStatus(rs.getString("verification_status"));
                    u.setActive(rs.getBoolean("is_active"));
                    u.setCreatedAt(rs.getTimestamp("created_at").toInstant());
                    return u;
                }
            }
        }
        return null;
    }

    @Override
    public long insertUser(User user) throws Exception {
        String sql = """
            INSERT INTO users (role_id, full_name, nid, phone, email, age, address_line,
                               username, password_hash, bio, profile_picture, verification_status)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'unverified')
            """;
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            int i=1;
            ps.setInt(i++, user.getRoleId());
            ps.setString(i++, user.getFullName());
            ps.setString(i++, user.getNid());
            ps.setString(i++, user.getPhone());
            ps.setString(i++, user.getEmail());
            ps.setShort(i++, user.getAge());
            ps.setString(i++, user.getAddressLine());
            ps.setString(i++, user.getUsername());
            ps.setString(i++, user.getPasswordHash());
            ps.setString(i++, user.getBio());
            if (user.getProfilePicture() != null) {
                ps.setBytes(i++, user.getProfilePicture());
            } else {
                ps.setNull(i++, Types.BLOB);
            }
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getLong(1);
            }
        }
        throw new SQLException("Failed to insert user");
    }

    @Override
    public void insertWorker(long userId, int categoryId, int experience) throws Exception {
        String sql = "INSERT INTO workers (user_id, job_category_id, experience_years) VALUES (?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ps.setInt(2, categoryId);
            ps.setInt(3, experience);
            ps.executeUpdate();
        }
    }

    @Override
    public void insertClient(long userId, String clientType) throws Exception {
        String sql = "INSERT INTO clients (user_id, client_type) VALUES (?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ps.setString(2, clientType);
            ps.executeUpdate();
        }
    }

    @Override
    public void insertVerificationSubmission(long userId, byte[] idPhoto) throws Exception {
        if (idPhoto == null) return; // optional at signup
        String sql = "INSERT INTO verification_submissions (user_id, id_photo, status) VALUES (?, ?, 'pending')";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ps.setBytes(2, idPhoto);
            ps.executeUpdate();
        }
    }
}
