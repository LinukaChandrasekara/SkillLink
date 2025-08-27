package com.skilllink.dao.jdbc;

import com.skilllink.dao.JobCategoryDAO;
import com.skilllink.model.JobCategory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class JdbcJobCategoryDAO implements JobCategoryDAO {
    @Override
    public List<JobCategory> listAll() {
        final String sql = "SELECT job_category_id, name, description FROM job_categories ORDER BY name";
        List<JobCategory> out = new ArrayList<>();
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                JobCategory jc = new JobCategory(rs.getLong(1), rs.getString(2), rs.getString(3));
                out.add(jc);
            }
        } catch (SQLException e) { throw new RuntimeException(e); }
        return out;
    }
    @Override
    public JobCategory findById(long id) {
        final String sql = "SELECT job_category_id, name, description FROM job_categories WHERE job_category_id=?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return new JobCategory(rs.getLong(1), rs.getString(2), rs.getString(3));
            }
            return null;
        } catch (SQLException e) { throw new RuntimeException(e); }
    }
}
