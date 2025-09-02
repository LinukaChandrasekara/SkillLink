// src/main/java/com/skilllink/dao/ReviewDAO.java
package com.skilllink.dao;

import java.util.List;

import com.skilllink.dao.dto.RecentReview;

public interface ReviewDAO {
    long countCompletedForWorker(long workerId);       // equals number of reviews for that worker
    RatingSummary getRatingSummary(long workerId);     // avg + count
    record RatingSummary(double avg, long count) {}
    Integer findWorkerCategoryId(long workerId);
    List<RecentReview> listRecentForWorker(long workerId, int limit);
    boolean existsForJobAndClient(long jobId, long clientId);
    long create(long jobId, long clientId, long workerId, int rating, String comment);
    public static final class ReviewView {
        public long clientId;
        public String clientName;
        public String jobTitle;
        public int rating;
        public String comment;
        public String createdAt;
    }
}
