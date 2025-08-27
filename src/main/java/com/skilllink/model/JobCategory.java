package com.skilllink.model;

import java.io.Serializable;

public class JobCategory implements Serializable {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Long jobCategoryId;
    private String name;
    private String description;

    public JobCategory() {}
    public JobCategory(Long id, String name, String description) {
        this.jobCategoryId = id; this.name = name; this.description = description;
    }
    public Long getJobCategoryId() { return jobCategoryId; }
    public void setJobCategoryId(Long jobCategoryId) { this.jobCategoryId = jobCategoryId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    @Override public String toString() {
        return "JobCategory{id=" + jobCategoryId + ", name='" + name + "'}";
    }
}
