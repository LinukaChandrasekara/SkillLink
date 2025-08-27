package com.skilllink.dao;

import com.skilllink.dao.dto.PagedResult;
import com.skilllink.model.JobPost;
import com.skilllink.model.enums.JobStatus;

import java.util.Optional;

public interface JobPostDAO {
    long countByStatus(JobStatus status);
    PagedResult<JobPost> list(String q, JobStatus status, int page, int pageSize);
    Optional<JobPost> findById(long jobId);
    boolean approve(long jobId, long adminId);
    boolean deny(long jobId, long adminId, String reasonNote); // store in reviewer_notes if you add later, or ignore
}
