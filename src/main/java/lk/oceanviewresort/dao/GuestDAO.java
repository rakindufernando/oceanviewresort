package lk.oceanviewresort.dao;

import lk.oceanviewresort.model.Guest;
import lk.oceanviewresort.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class GuestDAO {

    public boolean existsMobileOrNic(String mobile, String nicPassport, int excludeGuestId) {
        String sql = "SELECT COUNT(*) FROM guests " +
                "WHERE is_deleted=0 AND (mobile=? OR nic_passport=?) AND guest_id <> ?";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, mobile);
            ps.setString(2, nicPassport);
            ps.setInt(3, excludeGuestId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean create(Guest g) throws SQLException {
        String sql = "INSERT INTO guests(full_name, address, mobile, nic_passport, email) VALUES(?,?,?,?,?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, g.getFullName());
            ps.setString(2, g.getAddress());
            ps.setString(3, g.getMobile());
            ps.setString(4, g.getNicPassport());
            ps.setString(5, g.getEmail());
            return ps.executeUpdate() == 1;
        } catch (SQLException ex) {
            throw ex;
        } catch (Exception e) {
            throw new SQLException(e.getMessage());
        }
    }

    public boolean update(Guest g) throws SQLException {
        String sql = "UPDATE guests SET full_name=?, address=?, mobile=?, nic_passport=?, email=?, " +
                "updated_at=CURRENT_TIMESTAMP WHERE guest_id=? AND is_deleted=0";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, g.getFullName());
            ps.setString(2, g.getAddress());
            ps.setString(3, g.getMobile());
            ps.setString(4, g.getNicPassport());
            ps.setString(5, g.getEmail());
            ps.setInt(6, g.getGuestId());

            return ps.executeUpdate() == 1;

        } catch (SQLException ex) {
            throw ex;
        } catch (Exception e) {
            throw new SQLException(e.getMessage());
        }
    }

    public boolean softDelete(int id) throws SQLException {
        String sql = "UPDATE guests SET is_deleted=1, updated_at=CURRENT_TIMESTAMP WHERE guest_id=?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() == 1;

        } catch (SQLException ex) {
            throw ex;
        } catch (Exception e) {
            throw new SQLException(e.getMessage());
        }
    }

    public Guest findById(int id) {
        String sql = "SELECT guest_id, full_name, address, mobile, nic_passport, email " +
                "FROM guests WHERE guest_id=? AND is_deleted=0";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Guest g = new Guest();
                    g.setGuestId(rs.getInt("guest_id"));
                    g.setFullName(rs.getString("full_name"));
                    g.setAddress(rs.getString("address"));
                    g.setMobile(rs.getString("mobile"));
                    g.setNicPassport(rs.getString("nic_passport"));
                    g.setEmail(rs.getString("email"));
                    return g;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public Guest findByMobileOrNic(String key) {
        String sql = "SELECT guest_id, full_name, address, mobile, nic_passport, email " +
                "FROM guests WHERE is_deleted=0 AND (mobile=? OR nic_passport=?) LIMIT 1";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, key);
            ps.setString(2, key);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Guest g = new Guest();
                    g.setGuestId(rs.getInt("guest_id"));
                    g.setFullName(rs.getString("full_name"));
                    g.setAddress(rs.getString("address"));
                    g.setMobile(rs.getString("mobile"));
                    g.setNicPassport(rs.getString("nic_passport"));
                    g.setEmail(rs.getString("email"));
                    return g;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public List<Guest> searchGuests(String keyword) {
        List<Guest> list = new ArrayList<>();

        String sql = "SELECT guest_id, full_name, address, mobile, nic_passport, email " +
                "FROM guests WHERE is_deleted=0 ";

        boolean hasKey = keyword != null && !keyword.trim().isEmpty();
        if (hasKey) {
            sql += "AND (full_name LIKE ? OR mobile LIKE ? OR nic_passport LIKE ?) ";
        }
        sql += "ORDER BY guest_id DESC";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            if (hasKey) {
                String k = "%" + keyword.trim() + "%";
                ps.setString(1, k);
                ps.setString(2, k);
                ps.setString(3, k);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Guest g = new Guest();
                    g.setGuestId(rs.getInt("guest_id"));
                    g.setFullName(rs.getString("full_name"));
                    g.setAddress(rs.getString("address"));
                    g.setMobile(rs.getString("mobile"));
                    g.setNicPassport(rs.getString("nic_passport"));
                    g.setEmail(rs.getString("email"));
                    list.add(g);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
