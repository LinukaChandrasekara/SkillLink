package com.skilllink.dao.jdbc;

import com.skilllink.dao.ClientDAO;
import com.skilllink.model.enums.ClientType;

import java.sql.*;

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
}
