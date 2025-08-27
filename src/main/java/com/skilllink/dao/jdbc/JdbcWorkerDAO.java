package com.skilllink.dao.jdbc;

import com.skilllink.dao.WorkerDAO;

import java.sql.*;

public class JdbcWorkerDAO implements WorkerDAO {
    @Override
    public boolean create(long userId, long jobCategoryId, int experienceYears) {
        final String sql = "INSERT INTO workers (user_id, job_category_id, experience_years) VALUES (?, ?, ?)";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, userId); ps.setLong(2, jobCategoryId); ps.setInt(3, experienceYears);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) { throw new RuntimeException(e); }
    }
    @Override
    public boolean update(long userId, long jobCategoryId, int experienceYears) {
        final String sql = "UPDATE workers SET job_category_id=?, experience_years=? WHERE user_id=?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, jobCategoryId); ps.setInt(2, experienceYears); ps.setLong(3, userId);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) { throw new RuntimeException(e); }
    }
    @Override
    public boolean exists(long userId) {
        final String sql = "SELECT 1 FROM workers WHERE user_id=?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        } catch (SQLException e) { throw new RuntimeException(e); }
    }
}
