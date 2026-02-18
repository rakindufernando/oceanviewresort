package lk.oceanviewresort.web;

import lk.oceanviewresort.util.DBUtil;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.time.LocalDate;

@WebServlet("/app/income-stats")
public class AppIncomeStatsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        // Must be logged in
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.setContentType("application/json; charset=UTF-8");
            resp.setStatus(401);
            resp.getWriter().print("{\"ok\":false,\"message\":\"UNAUTHORIZED\"}");
            return;
        }

        // Today range: [today 00:00, tomorrow 00:00)
        LocalDate today = LocalDate.now();
        Timestamp todayStart = Timestamp.valueOf(today.atStartOfDay());
        Timestamp todayEnd = Timestamp.valueOf(today.plusDays(1).atStartOfDay());

        // Month range: [1st day 00:00, 1st of next month 00:00)
        LocalDate monthStartDate = today.withDayOfMonth(1);
        LocalDate nextMonthStartDate = monthStartDate.plusMonths(1);
        Timestamp monthStart = Timestamp.valueOf(monthStartDate.atStartOfDay());
        Timestamp monthEnd = Timestamp.valueOf(nextMonthStartDate.atStartOfDay());

        double todayTotal = 0;
        int todayCount = 0;

        double monthTotal = 0;
        int monthCount = 0;

        // NOTE: if your column/table names differ, change ONLY here:
        String sqlSumCount = "SELECT IFNULL(SUM(amount),0) AS total, COUNT(*) AS cnt " +
                "FROM payments WHERE paid_at >= ? AND paid_at < ?";

        try (Connection con = DBUtil.getConnection()) {

            // Today
            try (PreparedStatement ps = con.prepareStatement(sqlSumCount)) {
                ps.setTimestamp(1, todayStart);
                ps.setTimestamp(2, todayEnd);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        todayTotal = rs.getDouble("total");
                        todayCount = rs.getInt("cnt");
                    }
                }
            }

            // This month
            try (PreparedStatement ps = con.prepareStatement(sqlSumCount)) {
                ps.setTimestamp(1, monthStart);
                ps.setTimestamp(2, monthEnd);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        monthTotal = rs.getDouble("total");
                        monthCount = rs.getInt("cnt");
                    }
                }
            }

        } catch (Exception e) {
            resp.setContentType("application/json; charset=UTF-8");
            resp.getWriter().print("{\"ok\":false,\"message\":\"DB_ERROR\"}");
            return;
        }

        resp.setContentType("application/json; charset=UTF-8");
        resp.getWriter().print(
                "{\"ok\":true," +
                        "\"todayTotal\":" + todayTotal + "," +
                        "\"todayCount\":" + todayCount + "," +
                        "\"monthTotal\":" + monthTotal + "," +
                        "\"monthCount\":" + monthCount +
                        "}"
        );
    }
}
