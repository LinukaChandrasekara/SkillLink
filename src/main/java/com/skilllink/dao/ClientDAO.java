package com.skilllink.dao;

import java.util.List;

import com.skilllink.dao.dto.ClientCompletedJob;
import com.skilllink.dao.dto.ClientStats;
import com.skilllink.model.enums.ClientType;

public interface ClientDAO {
    boolean create(long userId, ClientType type);
    boolean updateType(long userId, ClientType type);
    boolean exists(long userId);
    String getClientType(long userId);                // returns "individual" | "business" | null
    boolean setClientType(long userId, String type);  // validates and updates
    ClientStats getStats(long clientId);
    List<ClientCompletedJob> listCompletedJobs(long clientId, int limit);
    ClientCompletedJob findCompletedJob(long clientId, long jobId);
}
