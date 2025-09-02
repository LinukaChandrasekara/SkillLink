package com.skilllink.dao;

import java.util.Optional;

import com.skilllink.model.Worker;

public interface WorkerDAO {
    boolean create(long userId, long jobCategoryId, int experienceYears);
    boolean update(long userId, long jobCategoryId, int experienceYears);
    boolean exists(long userId);
    Integer getCategoryId(long workerUserId);
    Optional<Worker> findById(long userId);
    /** Insert or update the worker's trade info. */
    boolean upsert(long userId, long jobCategoryId, int experienceYears);
}
