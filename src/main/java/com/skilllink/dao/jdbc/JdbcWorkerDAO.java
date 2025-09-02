package com.skilllink.dao.jdbc;

import com.skilllink.dao.WorkerDAO;
import com.skilllink.model.Worker;

import java.sql.*;
import java.util.Optional;

public class JdbcWorkerDAO implements WorkerDAO {
	
    @Override
    public Optional<Worker> findById(long userId) {
        final String sql = "SELECT user_id, job_category_id, experience_years FROM workers WHERE user_id=?";
        try (Connection c = DB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Worker w = new Worker();
                    w.setUserId(rs.getLong("user_id"));
                    w.setJobCategoryId(rs.getLong("job_category_id"));
                    w.setExperienceYears(rs.getInt("experience_years"));
                    return Optional.of(w);
                }
                return Optional.empty();
            }
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    @Override
    public boolean upsert(long userId, long jobCategoryId, int experienceYears) {
        final String sql =
            "INSERT INTO workers (user_id, job_category_id, experience_years) VALUES (?,?,?) " +
            "ON DUPLICATE KEY UPDATE job_category_id=VALUES(job_category_id), experience_years=VALUES(experience_years)";
        try (Connection c = DB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ps.setLong(2, jobCategoryId);
            ps.setInt(3, experienceYears);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { throw new RuntimeException(e); }
    }
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
    @Override
    public Integer getCategoryId(long workerUserId) {
        final String sql = "SELECT job_category_id FROM workers WHERE user_id=?";
        try (Connection c = DB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, workerUserId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
                return null;
            }
        } catch (SQLException e) { throw new RuntimeException(e); }
    }
}
