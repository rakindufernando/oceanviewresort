package lk.oceanviewresort.web;

import lk.oceanviewresort.dao.ReservationDAO;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/app/admin/reservation/delete")
public class AdminReservationDeleteServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            boolean ok = reservationDAO.deleteHard(id);

            int userId = (int) req.getSession(false).getAttribute("userId");
            new lk.oceanviewresort.dao.AuditDAO().log(userId, "DELETE_RESERVATION", "ReservationId=" + id);

            if (ok) resp.sendRedirect(req.getContextPath() + "/app/admin/reservations?msg=Reservation deleted");
            else resp.sendRedirect(req.getContextPath() + "/app/admin/reservations?error=Reservation not found");

        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/app/admin/reservations?error=Delete failed");
        }
    }
}
