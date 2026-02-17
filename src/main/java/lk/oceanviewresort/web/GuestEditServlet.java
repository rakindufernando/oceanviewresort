package lk.oceanviewresort.web;

import lk.oceanviewresort.dao.GuestDAO;
import lk.oceanviewresort.model.Guest;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/app/reception/guest/edit")
public class GuestEditServlet extends HttpServlet {

    private final GuestDAO guestDAO = new GuestDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int id = Integer.parseInt(req.getParameter("id"));
        Guest g = guestDAO.findById(id);

        req.setAttribute("guest", g);
        req.getRequestDispatcher("/WEB-INF/views/reception/guest_form.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int guestId = Integer.parseInt(req.getParameter("guestId"));
        String fullName = req.getParameter("fullName");
        String address = req.getParameter("address");
        String mobile = req.getParameter("mobile");
        String nicPassport = req.getParameter("nicPassport");
        String email = req.getParameter("email");

        if (mobile == null || !mobile.matches("\\d{9,15}")) {
            Guest old = guestDAO.findById(guestId);
            req.setAttribute("guest", old);
            req.setAttribute("error", "Invalid mobile number (use digits only, 9-15 length).");
            req.getRequestDispatcher("/WEB-INF/views/reception/guest_form.jsp").forward(req, resp);
            return;
        }

        if (guestDAO.existsMobileOrNic(mobile, nicPassport, guestId)) {
            Guest old = guestDAO.findById(guestId);
            req.setAttribute("guest", old);
            req.setAttribute("error", "Mobile number or NIC/Passport already exists.");
            req.getRequestDispatcher("/WEB-INF/views/reception/guest_form.jsp").forward(req, resp);
            return;
        }

        Guest g = new Guest();
        g.setGuestId(guestId);
        g.setFullName(fullName);
        g.setAddress(address);
        g.setMobile(mobile);
        g.setNicPassport(nicPassport);
        g.setEmail(email);

        try {
            guestDAO.update(g);

            int userId = (int) req.getSession(false).getAttribute("userId");
            new lk.oceanviewresort.dao.AuditDAO().log(userId, "UPDATE_GUEST",
                    "GuestId=" + guestId + ", Mobile=" + mobile);

            resp.sendRedirect(req.getContextPath() + "/app/reception/guests?msg=Guest updated");

        } catch (SQLException e) {
            Guest old = guestDAO.findById(guestId);
            req.setAttribute("guest", old);
            req.setAttribute("error", "Update failed. Try again.");
            req.getRequestDispatcher("/WEB-INF/views/reception/guest_form.jsp").forward(req, resp);
        }
    }
}
