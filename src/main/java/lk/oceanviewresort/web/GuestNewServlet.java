package lk.oceanviewresort.web;

import lk.oceanviewresort.dao.GuestDAO;
import lk.oceanviewresort.model.Guest;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/app/reception/guest/new")
public class GuestNewServlet extends HttpServlet {

    private final GuestDAO guestDAO = new GuestDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/reception/guest_form.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String fullName = req.getParameter("fullName");
        String address = req.getParameter("address");
        String mobile = req.getParameter("mobile");
        String nicPassport = req.getParameter("nicPassport");
        String email = req.getParameter("email");

        if (mobile == null || !mobile.matches("\\d{9,15}")) {
            req.setAttribute("error", "Invalid mobile number (use digits only, 9-15 length).");
            req.getRequestDispatcher("/WEB-INF/views/reception/guest_form.jsp").forward(req, resp);
            return;
        }

        if (guestDAO.existsMobileOrNic(mobile, nicPassport, 0)) {
            req.setAttribute("error", "Mobile number or NIC/Passport already exists.");
            req.getRequestDispatcher("/WEB-INF/views/reception/guest_form.jsp").forward(req, resp);
            return;
        }

        Guest g = new Guest();
        g.setFullName(fullName);
        g.setAddress(address);
        g.setMobile(mobile);
        g.setNicPassport(nicPassport);
        g.setEmail(email);

        try {
            guestDAO.create(g);

            int userId = (int) req.getSession(false).getAttribute("userId");
            new lk.oceanviewresort.dao.AuditDAO().log(userId, "ADD_GUEST",
                    "Mobile=" + mobile + ", NIC=" + nicPassport);

            resp.sendRedirect(req.getContextPath() + "/app/reception/guests?msg=Guest added");

        } catch (SQLException e) {
            req.setAttribute("error", "Duplicate mobile or NIC/Passport. Try another.");
            req.getRequestDispatcher("/WEB-INF/views/reception/guest_form.jsp").forward(req, resp);
        }
    }
}
