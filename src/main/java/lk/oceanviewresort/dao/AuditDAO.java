package lk.oceanviewresort.dao;

import lk.oceanviewresort.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class AuditDAO {

    public void log(int userId, String action, String details) {
        String sql = "INSERT INTO audit_logs(user_id, action, details) VALUES(?,?,?)";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setString(2, action);
            ps.setString(3, details);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
