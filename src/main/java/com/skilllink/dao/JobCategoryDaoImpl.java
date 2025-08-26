package com.skilllink.dao;

import com.skilllink.model.JobCategory;
import com.skilllink.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class JobCategoryDaoImpl implements JobCategoryDao {
    @Override
    public List<JobCategory> findAll() throws Exception {
        String sql = "SELECT job_category_id, name FROM job_categories ORDER BY name";
        List<JobCategory> list = new ArrayList<>();
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                JobCategory jc = new JobCategory();
                jc.setJobCategoryId(rs.getInt(1));
                jc.setName(rs.getString(2));
                list.add(jc);
            }
        }
        return list;
    }
}
