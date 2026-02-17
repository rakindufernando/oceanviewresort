package lk.oceanviewresort.dao;

import lk.oceanviewresort.util.DBUtil;
import lk.oceanviewresort.util.PasswordUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AdminUserDAO {

    public List<String[]> listUsers() {
        List<String[]> list = new ArrayList<>();
        String sql =
                "SELECT u.user_id, u.username, u.full_name, r.role_name, u.is_active " +
                "FROM users u JOIN roles r ON u.role_id=r.role_id " +
                "ORDER BY u.user_id DESC";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new String[] {
                        rs.getString(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getString(4),
                        rs.getString(5)
                });
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean addUser(String username, String password, String fullName, int roleId) throws SQLException {
        String sql = "INSERT INTO users(username, password_hash, full_name, role_id, is_active) VALUES(?,?,?,?,1)";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, PasswordUtil.sha256(password));
            ps.setString(3, fullName);
            ps.setInt(4, roleId);

            return ps.executeUpdate() == 1;

        } catch (SQLException ex) {
            throw ex;
        } catch (Exception e) {
            throw new SQLException(e.getMessage());
        }
    }

    public boolean toggleActive(int userId, int active) throws SQLException {
        String sql = "UPDATE users SET is_active=? WHERE user_id=?";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, active);
            ps.setInt(2, userId);
            return ps.executeUpdate() == 1;

        } catch (SQLException ex) {
            throw ex;
        } catch (Exception e) {
            throw new SQLException(e.getMessage());
        }
    }

    public boolean resetPassword(int userId, String newPassword) throws SQLException {
        String sql = "UPDATE users SET password_hash=? WHERE user_id=?";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, PasswordUtil.sha256(newPassword));
            ps.setInt(2, userId);
            return ps.executeUpdate() == 1;

        } catch (SQLException ex) {
            throw ex;
        } catch (Exception e) {
            throw new SQLException(e.getMessage());
        }
    }

    public String[] findUserById(int userId) {
        String sql = "SELECT user_id, username, full_name, role_id, is_active FROM users WHERE user_id=?";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new String[] {
                            rs.getString("user_id"),
                            rs.getString("username"),
                            rs.getString("full_name"),
                            rs.getString("role_id"),
                            rs.getString("is_active")
                    };
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean updateUser(int userId, String username, String fullName, int roleId, int isActive) throws SQLException {
        String sql = "UPDATE users SET username=?, full_name=?, role_id=?, is_active=? WHERE user_id=?";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, fullName);
            ps.setInt(3, roleId);
            ps.setInt(4, isActive);
            ps.setInt(5, userId);

            return ps.executeUpdate() == 1;

        } catch (SQLException ex) {
            throw ex;
        } catch (Exception e) {
            throw new SQLException(e.getMessage());
        }
    }

    public boolean deleteUserHard(int userId) throws SQLException {
        String sql = "DELETE FROM users WHERE user_id=?";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            return ps.executeUpdate() == 1;

        } catch (SQLException ex) {
            throw ex;
        } catch (Exception e) {
            throw new SQLException(e.getMessage());
        }
    }
}
