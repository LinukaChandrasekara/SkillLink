package com.skilllink.model;

public class JobCategory {
    public int getJobCategoryId() {
		return jobCategoryId;
	}
	public void setJobCategoryId(int jobCategoryId) {
		this.jobCategoryId = jobCategoryId;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	private int jobCategoryId;
    private String name;
    // getters/setters
}
