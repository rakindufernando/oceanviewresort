package lk.oceanviewresort.web;

import lk.oceanviewresort.dao.GuestDAO;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/app/reception/guest/delete")
public class GuestDeleteServlet extends HttpServlet {

    private final GuestDAO guestDAO = new GuestDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int id = Integer.parseInt(req.getParameter("id"));

        try {
            guestDAO.softDelete(id);
            resp.sendRedirect(req.getContextPath() + "/app/reception/guests?msg=Guest deleted");
        } catch (SQLException e) {
            resp.sendRedirect(req.getContextPath() + "/app/reception/guests?error=Delete failed");
        }
    }
}
