// src/main/java/com/skilllink/dao/ReviewDAO.java
package com.skilllink.dao;

public interface ReviewDAO {
    long countCompletedForWorker(long workerId);       // equals number of reviews for that worker
    RatingSummary getRatingSummary(long workerId);     // avg + count
    record RatingSummary(double avg, long count) {}
}
