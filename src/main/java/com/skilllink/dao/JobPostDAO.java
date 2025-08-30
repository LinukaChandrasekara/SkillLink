package com.skilllink.dao;

import com.skilllink.dao.dto.PagedResult;
import com.skilllink.model.JobPost;
import com.skilllink.model.enums.JobStatus;

import java.util.List;
import java.util.Optional;

public interface JobPostDAO {
    long countByStatus(JobStatus status);
    PagedResult<JobPost> list(String q, JobStatus status, int page, int pageSize);
    Optional<JobPost> findById(long jobId);
    boolean approve(long jobId, long adminId);
    boolean deny(long jobId, long adminId, String reasonNote); // store in reviewer_notes if you add later, or ignore
    List<JobPost> listByClient(long clientId);

    long create(JobPost job); // status defaults to 'pending'

    boolean updateByClientRepend(JobPost job);
    // UPDATE job_posts SET title=?, description=?, budget_amount=?, location_text=?, job_category_id=?, status='pending'
    // WHERE job_id=? AND client_id=? AND status IN ('pending','denied')

    boolean deleteByClientIfEditable(long jobId, long clientId);
    // DELETE FROM job_posts WHERE job_id=? AND client_id=? AND status IN ('pending','denied')

}
