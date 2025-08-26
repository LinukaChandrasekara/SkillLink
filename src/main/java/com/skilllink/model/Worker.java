package com.skilllink.model;

public class Worker {
	
	private long userId;
    private int jobCategoryId;
    private int experienceYears;
	
    public long getUserId() {
		return userId;
	}
	public void setUserId(long userId) {
		this.userId = userId;
	}
	public int getJobCategoryId() {
		return jobCategoryId;
	}
	public void setJobCategoryId(int jobCategoryId) {
		this.jobCategoryId = jobCategoryId;
	}
	public int getExperienceYears() {
		return experienceYears;
	}
	public void setExperienceYears(int experienceYears) {
		this.experienceYears = experienceYears;
	}

    // getters/setters
}
