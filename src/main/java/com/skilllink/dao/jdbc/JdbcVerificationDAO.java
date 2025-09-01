// src/main/java/com/skilllink/dao/jdbc/JdbcVerificationDAO.java
package com.skilllink.dao.jdbc;

import com.skilllink.dao.VerificationDAO;
import java.sql.*;

public class JdbcVerificationDAO implements VerificationDAO {
  @Override
  public long createPendingSubmission(long userId, byte[] idPhoto) {
    final String ins = "INSERT INTO verification_submissions(user_id,id_photo,status) VALUES (?,?, 'pending')";
    try (Connection c = DB.getConnection()) {
      try (PreparedStatement ps = c.prepareStatement(ins, Statement.RETURN_GENERATED_KEYS)) {
        ps.setLong(1, userId);
        ps.setBytes(2, idPhoto);
        ps.executeUpdate();
        try (ResultSet rs = ps.getGeneratedKeys()) {
          rs.next();
          long sid = rs.getLong(1);
          try (PreparedStatement up = c.prepareStatement(
              "UPDATE users SET verification_status='pending' WHERE user_id=?")) {
            up.setLong(1, userId);
            up.executeUpdate();
          }
          return sid;
        }
      }
    } catch (SQLException e) {
      throw new RuntimeException(e);
    }
  }
}
