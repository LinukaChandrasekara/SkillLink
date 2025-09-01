// src/main/java/com/skilllink/dao/VerificationDAO.java
package com.skilllink.dao;
public interface VerificationDAO {
  long createPendingSubmission(long userId, byte[] idPhoto);
}