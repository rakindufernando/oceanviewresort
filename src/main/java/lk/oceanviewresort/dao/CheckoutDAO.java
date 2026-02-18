package lk.oceanviewresort.dao;

import lk.oceanviewresort.util.DBUtil;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.time.LocalDate;

public class CheckoutDAO {

    public boolean markCheckedOut(int reservationId, LocalDate actualCheckout) throws Exception {

        String sql = "UPDATE reservations " +
                "SET check_out=?, status='CHECKED_OUT', updated_at=CURRENT_TIMESTAMP " +
                "WHERE reservation_id=? AND status<>'CANCELLED' AND status<>'CHECKED_OUT'";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setDate(1, Date.valueOf(actualCheckout));
            ps.setInt(2, reservationId);

            return ps.executeUpdate() == 1;
        }
    }
}
