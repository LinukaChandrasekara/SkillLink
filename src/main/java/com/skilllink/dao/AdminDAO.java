package com.skilllink.dao;

public interface AdminDAO {
    boolean linkAsAdmin(long userId); // INSERT INTO admins(user_id)
    boolean exists(long userId);
}
