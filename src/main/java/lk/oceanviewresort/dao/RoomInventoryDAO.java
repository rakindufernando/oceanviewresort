package lk.oceanviewresort.dao;

import lk.oceanviewresort.model.RoomInventory;
import lk.oceanviewresort.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class RoomInventoryDAO {

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
                list.add(r);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public RoomInventory findByType(String roomType) {
        String sql = "SELECT room_type, total_rooms, rate_per_night FROM room_inventory WHERE room_type=?";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, roomType);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    RoomInventory r = new RoomInventory();
                    r.setRoomType(rs.getString("room_type"));
                    r.setTotalRooms(rs.getInt("total_rooms"));
                    r.setRatePerNight(rs.getDouble("rate_per_night"));
                    return r;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}
