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

@WebServlet("/app/today-income")
public class AppTodayIncomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        // simple protection (only logged users)
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.setContentType("application/json; charset=UTF-8");
            resp.setStatus(401);
            resp.getWriter().print("{\"ok\":false,\"message\":\"UNAUTHORIZED\"}");
            return;
        }

        LocalDate today = LocalDate.now();
        Timestamp start = Timestamp.valueOf(today.atStartOfDay());
        Timestamp end = Timestamp.valueOf(today.plusDays(1).atStartOfDay());

        double total = 0;

        String sql = "SELECT IFNULL(SUM(amount),0) AS total " +
                "FROM payments WHERE paid_at >= ? AND paid_at < ?";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setTimestamp(1, start);
            ps.setTimestamp(2, end);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) total = rs.getDouble("total");
            }

        } catch (Exception e) {
            resp.setContentType("application/json; charset=UTF-8");
            resp.getWriter().print("{\"ok\":false,\"message\":\"DB_ERROR\"}");
            return;
        }

        resp.setContentType("application/json; charset=UTF-8");
        resp.getWriter().print("{\"ok\":true,\"total\":" + total + "}");
    }
}
