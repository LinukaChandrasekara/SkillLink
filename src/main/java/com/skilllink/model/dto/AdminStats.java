package com.skilllink.model.dto;

import java.io.Serializable;

public class AdminStats implements Serializable {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private long totalUsers;
    private long verifiedWorkers;
    private long verifiedClients;
    private long pendingJobs;
    private long disabledUsers;
    private long newUsers7d;

    public long getTotalUsers() { return totalUsers; }
    public void setTotalUsers(long totalUsers) { this.totalUsers = totalUsers; }
    public long getVerifiedWorkers() { return verifiedWorkers; }
    public void setVerifiedWorkers(long verifiedWorkers) { this.verifiedWorkers = verifiedWorkers; }
    public long getVerifiedClients() { return verifiedClients; }
    public void setVerifiedClients(long verifiedClients) { this.verifiedClients = verifiedClients; }
    public long getPendingJobs() { return pendingJobs; }
    public void setPendingJobs(long pendingJobs) { this.pendingJobs = pendingJobs; }
    public long getDisabledUsers() { return disabledUsers; }
    public void setDisabledUsers(long disabledUsers) { this.disabledUsers = disabledUsers; }
    public long getNewUsers7d() { return newUsers7d; }
    public void setNewUsers7d(long newUsers7d) { this.newUsers7d = newUsers7d; }
}
