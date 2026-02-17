package lk.oceanviewresort.web;

import lk.oceanviewresort.dao.GuestDAO;
import lk.oceanviewresort.model.Guest;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/app/reception/guests")
public class ReceptionGuestsServlet extends HttpServlet {

    private final GuestDAO guestDAO = new GuestDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String q = req.getParameter("q");
        List<Guest> guests = guestDAO.searchGuests(q);

        req.setAttribute("msg", req.getParameter("msg"));
        req.setAttribute("error", req.getParameter("error"));
        req.setAttribute("guests", guests);

        req.getRequestDispatcher("/WEB-INF/views/reception/guests.jsp").forward(req, resp);
    }
}
