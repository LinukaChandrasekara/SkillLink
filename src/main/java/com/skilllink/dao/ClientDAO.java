package com.skilllink.dao;

import com.skilllink.model.enums.ClientType;

public interface ClientDAO {
    boolean create(long userId, ClientType type);
    boolean updateType(long userId, ClientType type);
    boolean exists(long userId);
}
