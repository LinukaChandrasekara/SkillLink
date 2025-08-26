package com.skilllink.dao;

import com.skilllink.model.User;

public interface UserDao {
    boolean existsByUsernameOrEmail(String username, String email) throws Exception;
    User findByUsernameOrEmail(String usernameOrEmail) throws Exception;
    long insertUser(User user) throws Exception;
    void insertWorker(long userId, int categoryId, int experience) throws Exception;
    void insertClient(long userId, String clientType) throws Exception;
    void insertVerificationSubmission(long userId, byte[] idPhoto) throws Exception;
}
