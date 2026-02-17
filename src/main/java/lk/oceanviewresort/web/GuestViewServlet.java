package lk.oceanviewresort.web;

import lk.oceanviewresort.dao.GuestDAO;
import lk.oceanviewresort.model.Guest;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/app/reception/guest/view")
public class GuestViewServlet extends HttpServlet {

    private final GuestDAO guestDAO = new GuestDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int id = Integer.parseInt(req.getParameter("id"));
        Guest g = guestDAO.findById(id);

        req.setAttribute("guest", g);
        req.getRequestDispatcher("/WEB-INF/views/reception/guest_view.jsp").forward(req, resp);
    }
}
