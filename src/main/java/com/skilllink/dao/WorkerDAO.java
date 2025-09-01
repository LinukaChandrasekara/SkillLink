package com.skilllink.dao;

public interface WorkerDAO {
    boolean create(long userId, long jobCategoryId, int experienceYears);
    boolean update(long userId, long jobCategoryId, int experienceYears);
    boolean exists(long userId);
    Integer getCategoryId(long workerUserId);
}
