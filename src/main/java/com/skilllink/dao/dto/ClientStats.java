package com.skilllink.dao.dto;

public class ClientStats {
    private long jobsPosted;
    private long hired;           // accepted/in_progress/completed
    private long pendingPosts;

    public ClientStats() {}
    public ClientStats(long jobsPosted, long hired, long pendingPosts) {
        this.jobsPosted = jobsPosted; this.hired = hired; this.pendingPosts = pendingPosts;
    }
    public long getJobsPosted() { return jobsPosted; }
    public void setJobsPosted(long jobsPosted) { this.jobsPosted = jobsPosted; }
    public long getHired() { return hired; }
    public void setHired(long hired) { this.hired = hired; }
    public long getPendingPosts() { return pendingPosts; }
    public void setPendingPosts(long pendingPosts) { this.pendingPosts = pendingPosts; }
}
