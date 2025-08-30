package com.skilllink.dao;

import com.skilllink.model.enums.ClientType;

public interface ClientDAO {
    boolean create(long userId, ClientType type);
    boolean updateType(long userId, ClientType type);
    boolean exists(long userId);
    String getClientType(long userId);                // returns "individual" | "business" | null
    boolean setClientType(long userId, String type);  // validates and updates
}
