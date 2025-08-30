package com.skilllink.dao;

import com.skilllink.model.User;
import com.skilllink.model.enums.VerificationStatus;
import com.skilllink.dao.dto.PagedResult;

import java.util.List;
import java.util.Optional;

public interface UserDAO {
    long countAll();
    long countByRole(String roleName);
    long countByVerification(String status);
    long countByRoleAndVerification(String roleName, String status);
    long countDisabled();
 // com.skilllink.dao.UserDAO
    String getVerificationStatus(long userId);


    Optional<User> findById(long userId);
    List<User> listRecentNonAdmin(int limit);

    Optional<User> findByUsernameOrEmail(String login);

    /** List users for Admin → Manage Users with filters + pagination. roleName: admin/worker/client; verification: verified/pending/unverified/denied */
    PagedResult<User> list(String q, String roleName, String verification, int page, int pageSize);

    long create(User u);
    boolean update(User u);
    boolean setVerificationStatus(long userId, VerificationStatus status);
    boolean setActive(long userId, boolean active);
    boolean delete(long userId);

    byte[] getProfilePicture(long userId);
    boolean updateProfilePicture(long userId, byte[] pic);
}
