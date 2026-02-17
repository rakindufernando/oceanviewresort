package lk.oceanviewresort.dao;

import lk.oceanviewresort.model.Payment;
import lk.oceanviewresort.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO {

    public boolean addPayment(int reservationId, double amount, String method, String referenceNo, int receivedBy) throws SQLException {
        String sql = "INSERT INTO payments(reservation_id, amount, method, reference_no, received_by) VALUES(?,?,?,?,?)";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, reservationId);
            ps.setDouble(2, amount);
            ps.setString(3, method);
            ps.setString(4, referenceNo);
            ps.setInt(5, receivedBy);
            return ps.executeUpdate() == 1;

        } catch (SQLException ex) {
            throw ex;
        } catch (Exception e) {
            throw new SQLException(e.getMessage());
        }
    }

    public List<Payment> listByReservation(int reservationId) {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT payment_id, reservation_id, amount, method, reference_no, paid_at " +
                "FROM payments WHERE reservation_id=? ORDER BY paid_at DESC";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, reservationId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Payment p = new Payment();
                    p.setPaymentId(rs.getInt("payment_id"));
                    p.setReservationId(rs.getInt("reservation_id"));
                    p.setAmount(rs.getDouble("amount"));
                    p.setMethod(rs.getString("method"));
                    p.setReferenceNo(rs.getString("reference_no"));
                    p.setPaidAt(rs.getTimestamp("paid_at").toLocalDateTime());
                    list.add(p);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public double sumPaid(int reservationId) {
        String sql = "SELECT IFNULL(SUM(amount),0) FROM payments WHERE reservation_id=?";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, reservationId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getDouble(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    public List<String[]> listAllTransactions() {
        List<String[]> list = new ArrayList<>();
        String sql = "SELECT p.paid_at, r.reservation_no, p.amount, p.method, p.reference_no, u.username " +
                "FROM payments p JOIN reservations r ON p.reservation_id=r.reservation_id " +
                "JOIN users u ON p.received_by=u.user_id ORDER BY p.paid_at DESC";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

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

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
