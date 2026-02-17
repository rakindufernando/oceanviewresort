package lk.oceanviewresort.dao;

import lk.oceanviewresort.model.User;
import lk.oceanviewresort.util.DBUtil;
import lk.oceanviewresort.util.PasswordUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {

    public User authenticate(String username, String password) {
        String sql =
                "SELECT u.user_id, u.username, u.full_name, r.role_name " +
                "FROM users u JOIN roles r ON u.role_id=r.role_id " +
                "WHERE u.username=? AND u.password_hash=? AND u.is_active=1";

        String hash = PasswordUtil.sha256(password);

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, hash);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setUserId(rs.getInt("user_id"));
                    u.setUsername(rs.getString("username"));
                    u.setFullName(rs.getString("full_name"));
                    u.setRoleName(rs.getString("role_name"));
                    return u;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}
