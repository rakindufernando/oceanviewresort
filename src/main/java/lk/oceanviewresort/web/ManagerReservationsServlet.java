package lk.oceanviewresort.web;

import lk.oceanviewresort.dao.ReservationDAO;
import lk.oceanviewresort.model.Reservation;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/app/manager/reservations")
public class ManagerReservationsServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String q = req.getParameter("q");
        List<Reservation> list = reservationDAO.search(q);

        req.setAttribute("reservations", list);
        req.getRequestDispatcher("/WEB-INF/views/manager/reservations.jsp").forward(req, resp);
    }
}
