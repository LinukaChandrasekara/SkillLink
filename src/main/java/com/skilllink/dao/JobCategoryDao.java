package com.skilllink.dao;

import com.skilllink.model.JobCategory;
import java.util.List;

public interface JobCategoryDao {
    List<JobCategory> findAll() throws Exception;
}
