package com.skilllink.dao.jdbc;

import com.skilllink.dao.AdminDAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class JdbcAdminDAO implements AdminDAO {
    @Override
    public boolean linkAsAdmin(long userId) {
        final String sql = "INSERT INTO admins (user_id) VALUES (?)";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, userId);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    @Override
    public boolean exists(long userId) {
        final String sql = "SELECT 1 FROM admins WHERE user_id=?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        } catch (SQLException e) { throw new RuntimeException(e); }
    }
}
