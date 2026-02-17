package lk.oceanviewresort.web;

import lk.oceanviewresort.dao.ReservationDAO;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/app/reception/reservation/cancel")
public class ReservationCancelServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            reservationDAO.cancel(id);

            int userId = (int) req.getSession(false).getAttribute("userId");
            new lk.oceanviewresort.dao.AuditDAO().log(userId, "CANCEL_RESERVATION", "ReservationId=" + id);

            resp.sendRedirect(req.getContextPath() + "/app/reception/reservations?msg=Reservation cancelled");
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/app/reception/reservations?error=Cancel failed");
        }
    }
}
