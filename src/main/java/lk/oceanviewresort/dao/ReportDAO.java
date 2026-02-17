package lk.oceanviewresort.dao;

import lk.oceanviewresort.util.DBUtil;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class ReportDAO {

    public List<String[]> occupancyReport(LocalDate from, LocalDate to) {
        List<String[]> list = new ArrayList<>();

        String sql =
                "SELECT ri.room_type, ri.total_rooms, ri.rate_per_night, " +
                "IFNULL(SUM(DATEDIFF(LEAST(r.check_out, ?), GREATEST(r.check_in, ?))),0) AS booked_nights " +
                "FROM room_inventory ri " +
                "LEFT JOIN reservations r ON ri.room_type = r.room_type " +
                "AND r.status <> 'CANCELLED' " +
                "AND r.check_in < ? AND r.check_out > ? " +
                "GROUP BY ri.room_type, ri.total_rooms, ri.rate_per_night " +
                "ORDER BY ri.room_type";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setDate(1, Date.valueOf(to));
            ps.setDate(2, Date.valueOf(from));
            ps.setDate(3, Date.valueOf(to));
            ps.setDate(4, Date.valueOf(from));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new String[] {
                            rs.getString("room_type"),
                            String.valueOf(rs.getInt("total_rooms")),
                            String.format("%.2f", rs.getDouble("rate_per_night")),
                            String.valueOf(rs.getInt("booked_nights"))
                    });
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public String[] revenueReport(LocalDate from, LocalDate to) {
        String sql = "SELECT IFNULL(SUM(amount),0) AS total_revenue, COUNT(*) AS payment_count " +
                "FROM payments WHERE DATE(paid_at) BETWEEN ? AND ?";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setDate(1, Date.valueOf(from));
            ps.setDate(2, Date.valueOf(to));

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new String[] { rs.getString("total_revenue"), rs.getString("payment_count") };
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return new String[] { "0", "0" };
    }

    public List<String[]> reservationStatusSummary() {
        List<String[]> list = new ArrayList<>();
        String sql = "SELECT status, COUNT(*) AS c FROM reservations GROUP BY status";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new String[] { rs.getString("status"), rs.getString("c") });
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<String[]> reservationList(LocalDate from, LocalDate to) {
        List<String[]> list = new ArrayList<>();
        String sql =
                "SELECT r.reservation_no, g.full_name, r.room_type, r.check_in, r.check_out, r.status " +
                "FROM reservations r JOIN guests g ON r.guest_id=g.guest_id " +
                "WHERE r.check_in < ? AND r.check_out > ? " +
                "ORDER BY r.check_in ASC";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setDate(1, Date.valueOf(to));
            ps.setDate(2, Date.valueOf(from));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new String[] {
                            rs.getString(1),
                            rs.getString(2),
                            rs.getString(3),
                            rs.getString(4),
                            rs.getString(5),
                            rs.getString(6)
                    });
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
