package com.skilllink.dao;

import com.skilllink.dao.dto.PagedResult;
import com.skilllink.model.VerificationSubmission;
import com.skilllink.model.enums.VerificationStatus;

public interface VerificationSubmissionDAO {
    PagedResult<VerificationSubmission> list(String q, VerificationStatus status, int page, int pageSize);
    VerificationSubmission findById(long submissionId);
    byte[] getPhoto(long submissionId);

    boolean approve(long submissionId, long reviewerAdminId, String notes);
    boolean deny(long submissionId, long reviewerAdminId, String notes);

    long create(long userId, byte[] idPhoto); // when user uploads
}
