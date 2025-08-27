package com.skilllink.dao;

import com.skilllink.model.JobCategory;
import java.util.List;

public interface JobCategoryDAO {
    List<JobCategory> listAll();
    JobCategory findById(long id);
}
