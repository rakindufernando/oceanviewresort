package lk.oceanviewresort.dao;

import lk.oceanviewresort.model.Reservation;
import lk.oceanviewresort.util.DBUtil;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAO {

    public String generateReservationNo() {
        String year = String.valueOf(LocalDate.now().getYear());
        int next = 1;

        String sql = "SELECT MAX(reservation_id) FROM reservations";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                int maxId = rs.getInt(1);
                next = maxId + 1;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return "OV-" + year + "-" + String.format("%05d", next);
    }


    public int countOverlapping(String roomType, LocalDate checkIn, LocalDate checkOut, int excludeReservationId) {
        String sql = "SELECT COUNT(*) FROM reservations " +
                "WHERE room_type=? AND status<>'CANCELLED' " +
                "AND check_in < ? AND check_out > ? " +
                "AND reservation_id <> ?";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, roomType);
            ps.setDate(2, Date.valueOf(checkOut));
            ps.setDate(3, Date.valueOf(checkIn));
            ps.setInt(4, excludeReservationId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    public boolean create(Reservation r, int createdBy) throws SQLException {
        String sql = "INSERT INTO reservations(reservation_no, guest_id, room_type, check_in, check_out, adults, children, status, created_by) " +
                "VALUES(?,?,?,?,?,?,?,?,?)";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, r.getReservationNo());
            ps.setInt(2, r.getGuestId());
            ps.setString(3, r.getRoomType());
            ps.setDate(4, Date.valueOf(r.getCheckIn()));
            ps.setDate(5, Date.valueOf(r.getCheckOut()));
            ps.setInt(6, r.getAdults());
            ps.setInt(7, r.getChildren());
            ps.setString(8, r.getStatus());
            ps.setInt(9, createdBy);

            return ps.executeUpdate() == 1;

        } catch (SQLException ex) {
            throw ex;
        } catch (Exception e) {
            throw new SQLException(e.getMessage());
        }
    }

    public boolean update(Reservation r) throws SQLException {
        String sql = "UPDATE reservations SET guest_id=?, room_type=?, check_in=?, check_out=?, adults=?, children=?, " +
                "updated_at=CURRENT_TIMESTAMP WHERE reservation_id=?";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, r.getGuestId());
            ps.setString(2, r.getRoomType());
            ps.setDate(3, Date.valueOf(r.getCheckIn()));
            ps.setDate(4, Date.valueOf(r.getCheckOut()));
            ps.setInt(5, r.getAdults());
            ps.setInt(6, r.getChildren());
            ps.setInt(7, r.getReservationId());

            return ps.executeUpdate() == 1;

        } catch (SQLException ex) {
            throw ex;
        } catch (Exception e) {
            throw new SQLException(e.getMessage());
        }
    }

    public boolean cancel(int reservationId) throws SQLException {
        String sql = "UPDATE reservations SET status='CANCELLED', updated_at=CURRENT_TIMESTAMP WHERE reservation_id=?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, reservationId);
            return ps.executeUpdate() == 1;

        } catch (SQLException ex) {
            throw ex;
        } catch (Exception e) {
            throw new SQLException(e.getMessage());
        }
    }

    public Reservation findById(int id) {
        String sql = "SELECT r.reservation_id, r.reservation_no, r.guest_id, g.full_name AS guest_name, " +
                "r.room_type, r.check_in, r.check_out, r.adults, r.children, r.status " +
                "FROM reservations r JOIN guests g ON r.guest_id=g.guest_id " +
                "WHERE r.reservation_id=?";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Reservation r = new Reservation();
                    r.setReservationId(rs.getInt("reservation_id"));
                    r.setReservationNo(rs.getString("reservation_no"));
                    r.setGuestId(rs.getInt("guest_id"));
                    r.setGuestName(rs.getString("guest_name"));
                    r.setRoomType(rs.getString("room_type"));
                    r.setCheckIn(rs.getDate("check_in").toLocalDate());
                    r.setCheckOut(rs.getDate("check_out").toLocalDate());
                    r.setAdults(rs.getInt("adults"));
                    r.setChildren(rs.getInt("children"));
                    r.setStatus(rs.getString("status"));
                    return r;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public Reservation findByReservationNo(String reservationNo) {
        String sql = "SELECT r.reservation_id, r.reservation_no, r.guest_id, g.full_name AS guest_name, " +
                "r.room_type, r.check_in, r.check_out, r.adults, r.children, r.status " +
                "FROM reservations r JOIN guests g ON r.guest_id=g.guest_id " +
                "WHERE r.reservation_no=?";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, reservationNo);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Reservation r = new Reservation();
                    r.setReservationId(rs.getInt("reservation_id"));
                    r.setReservationNo(rs.getString("reservation_no"));
                    r.setGuestId(rs.getInt("guest_id"));
                    r.setGuestName(rs.getString("guest_name"));
                    r.setRoomType(rs.getString("room_type"));
                    r.setCheckIn(rs.getDate("check_in").toLocalDate());
                    r.setCheckOut(rs.getDate("check_out").toLocalDate());
                    r.setAdults(rs.getInt("adults"));
                    r.setChildren(rs.getInt("children"));
                    r.setStatus(rs.getString("status"));
                    return r;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public List<Reservation> search(String keyword) {
        List<Reservation> list = new ArrayList<>();

        String sql = "SELECT r.reservation_id, r.reservation_no, g.full_name AS guest_name, " +
                "r.room_type, r.check_in, r.check_out, r.status " +
                "FROM reservations r JOIN guests g ON r.guest_id=g.guest_id ";

        boolean hasKey = keyword != null && !keyword.trim().isEmpty();
        if (hasKey) {
            sql += "WHERE (r.reservation_no LIKE ? OR g.full_name LIKE ?) ";
        }
        sql += "ORDER BY r.reservation_id DESC";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            if (hasKey) {
                String k = "%" + keyword.trim() + "%";
                ps.setString(1, k);
                ps.setString(2, k);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Reservation r = new Reservation();
                    r.setReservationId(rs.getInt("reservation_id"));
                    r.setReservationNo(rs.getString("reservation_no"));
                    r.setGuestName(rs.getString("guest_name"));
                    r.setRoomType(rs.getString("room_type"));
                    r.setCheckIn(rs.getDate("check_in").toLocalDate());
                    r.setCheckOut(rs.getDate("check_out").toLocalDate());
                    r.setStatus(rs.getString("status"));
                    list.add(r);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }


    public boolean deleteHard(int reservationId) throws SQLException {
        String deletePayments = "DELETE FROM payments WHERE reservation_id=?";
        String deleteReservation = "DELETE FROM reservations WHERE reservation_id=?";

        try (Connection con = DBUtil.getConnection()) {
            con.setAutoCommit(false);

            try (PreparedStatement ps1 = con.prepareStatement(deletePayments);
                 PreparedStatement ps2 = con.prepareStatement(deleteReservation)) {

                ps1.setInt(1, reservationId);
                ps1.executeUpdate();

                ps2.setInt(1, reservationId);
                int rows = ps2.executeUpdate();

                con.commit();
                return rows == 1;

            } catch (Exception e) {
                con.rollback();
                throw e;
            } finally {
                con.setAutoCommit(true);
            }

        } catch (SQLException ex) {
            throw ex;
        } catch (Exception e) {
            throw new SQLException(e.getMessage());
        }
    }
}
