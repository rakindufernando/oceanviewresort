package lk.oceanviewresort.dao;

import lk.oceanviewresort.model.RoomInventory;
import lk.oceanviewresort.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class RoomInventoryDAO {

    // Manager CRUD page needs full list (active + inactive)
    public List<RoomInventory> getAllRooms() {
        List<RoomInventory> list = new ArrayList<>();
        String sql = "SELECT room_type, total_rooms, rate_per_night, is_active FROM room_inventory ORDER BY room_type";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                RoomInventory r = new RoomInventory();
                r.setRoomType(rs.getString("room_type"));
                r.setTotalRooms(rs.getInt("total_rooms"));
                r.setRatePerNight(rs.getDouble("rate_per_night"));
                r.setActive(rs.getInt("is_active") == 1);
                list.add(r);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean create(RoomInventory r) {
        String sql = "INSERT INTO room_inventory(room_type, total_rooms, rate_per_night, is_active) VALUES(?,?,?,1)";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, r.getRoomType());
            ps.setInt(2, r.getTotalRooms());
            ps.setDouble(3, r.getRatePerNight());
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean update(RoomInventory r) {
        String sql = "UPDATE room_inventory SET total_rooms=?, rate_per_night=? WHERE room_type=?";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, r.getTotalRooms());
            ps.setDouble(2, r.getRatePerNight());
            ps.setString(3, r.getRoomType());
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean setActive(String roomType, boolean active) {
        String sql = "UPDATE room_inventory SET is_active=? WHERE room_type=?";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, active ? 1 : 0);
            ps.setString(2, roomType);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<RoomInventory> getActiveRooms() {
        List<RoomInventory> list = new ArrayList<>();
        String sql = "SELECT room_type, total_rooms, rate_per_night FROM room_inventory WHERE is_active=1";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                RoomInventory r = new RoomInventory();
                r.setRoomType(rs.getString("room_type"));
                r.setTotalRooms(rs.getInt("total_rooms"));
                r.setRatePerNight(rs.getDouble("rate_per_night"));
                r.setActive(true);
                list.add(r);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public RoomInventory findByType(String roomType) {
        String sql = "SELECT room_type, total_rooms, rate_per_night, is_active FROM room_inventory WHERE room_type=?";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, roomType);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    RoomInventory r = new RoomInventory();
                    r.setRoomType(rs.getString("room_type"));
                    r.setTotalRooms(rs.getInt("total_rooms"));
                    r.setRatePerNight(rs.getDouble("rate_per_night"));
                    r.setActive(rs.getInt("is_active") == 1);
                    return r;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}
