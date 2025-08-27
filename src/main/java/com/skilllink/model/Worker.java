package com.skilllink.model;

import java.io.Serializable;

public class Worker implements Serializable {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Long userId;
    private Long jobCategoryId;
    private Integer experienceYears;

    // Optional convenience (joined values)
    private String jobCategoryName;

    public Worker() {}
    public Worker(Long userId, Long categoryId, Integer experienceYears) {
        this.userId = userId; this.jobCategoryId = categoryId; this.experienceYears = experienceYears;
    }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public Long getJobCategoryId() { return jobCategoryId; }
    public void setJobCategoryId(Long jobCategoryId) { this.jobCategoryId = jobCategoryId; }
    public Integer getExperienceYears() { return experienceYears; }
    public void setExperienceYears(Integer experienceYears) { this.experienceYears = experienceYears; }

    public String getJobCategoryName() { return jobCategoryName; }
    public void setJobCategoryName(String jobCategoryName) { this.jobCategoryName = jobCategoryName; }

    @Override public String toString() {
        return "Worker{userId=" + userId + ", jobCategoryId=" + jobCategoryId +
               ", years=" + experienceYears + "}";
    }
}
