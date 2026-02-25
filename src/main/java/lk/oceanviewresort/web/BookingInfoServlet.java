package lk.oceanviewresort.web;

import lk.oceanviewresort.dao.GuestDAO;
import lk.oceanviewresort.dao.PaymentDAO;
import lk.oceanviewresort.dao.ReservationDAO;
import lk.oceanviewresort.dao.RoomInventoryDAO;
import lk.oceanviewresort.model.Guest;
import lk.oceanviewresort.model.Payment;
import lk.oceanviewresort.model.Reservation;
import lk.oceanviewresort.model.RoomInventory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.time.temporal.ChronoUnit;
import java.util.List;

@WebServlet("/booking-info")
public class BookingInfoServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final GuestDAO guestDAO = new GuestDAO();
    private final RoomInventoryDAO roomDAO = new RoomInventoryDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();

    private static final String S_GUEST_ID = "guestVerifiedGuestId";
    private static final String S_GUEST_AT = "guestVerifiedAt";

    private void clearGuestSession(HttpSession session) {
        if (session == null) return;
        session.removeAttribute(S_GUEST_ID);
        session.removeAttribute(S_GUEST_AT);
    }

    private boolean isExpired(HttpSession session) {
        if (session == null) return true;

        Object t = session.getAttribute(S_GUEST_AT);
        if (t == null) return true;

        try {
            long verifiedAt;
            if (t instanceof Long) verifiedAt = (Long) t;
            else verifiedAt = Long.parseLong(String.valueOf(t));

            long now = System.currentTimeMillis();
            long diffMs = now - verifiedAt;
            long maxMs = 15L * 60L * 1000L;
            return diffMs > maxMs;
        } catch (Exception e) {
            return true;
        }
    }

    private void setVerified(HttpSession session, int guestId) {
        session.setAttribute(S_GUEST_ID, guestId);
        session.setAttribute(S_GUEST_AT, System.currentTimeMillis());
    }

    private void loadBill(HttpServletRequest req, Reservation r) {
        RoomInventory inv = roomDAO.findByType(r.getRoomType());

        double rate = 0.0;
        if (inv != null) rate = inv.getRatePerNight();

        long nights = ChronoUnit.DAYS.between(r.getCheckIn(), r.getCheckOut());
        if (nights < 0) nights = 0;

        double total = nights * rate;

        double paid = paymentDAO.sumPaid(r.getReservationId());
        double balance = total - paid;

        List<Payment> payments = paymentDAO.listByReservation(r.getReservationId());

        req.setAttribute("rate", rate);
        req.setAttribute("nights", nights);
        req.setAttribute("total", total);
        req.setAttribute("paid", paid);
        req.setAttribute("balance", balance);
        req.setAttribute("payments", payments);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(true);

        String action = req.getParameter("action");
        if ("clear".equalsIgnoreCase(action)) {
            clearGuestSession(session);
            resp.sendRedirect(req.getContextPath() + "/booking-info");
            return;
        }

        String keep = req.getParameter("keep");
        boolean keepSession = "1".equals(keep);

        if (!keepSession) {
            clearGuestSession(session);
        } else {
            if (session.getAttribute(S_GUEST_ID) != null && isExpired(session)) {
                clearGuestSession(session);
                req.setAttribute("error", "Session expired. Please verify again.");
            }
        }

        String msg = req.getParameter("msg");
        String err = req.getParameter("error");

        if (msg != null && !msg.trim().isEmpty()) req.setAttribute("msg", msg);
        if (err != null && !err.trim().isEmpty()) req.setAttribute("error", err);

        String resNo = req.getParameter("reservationNo");

        if (resNo != null && !resNo.trim().isEmpty()) {
            Object gidObj = session.getAttribute(S_GUEST_ID);
            if (gidObj == null) {
                req.setAttribute("error", "Please verify using your details first.");
            } else {
                int guestId = (int) gidObj;
                Reservation r = reservationDAO.findByReservationNoAndGuestId(resNo.trim(), guestId);
                if (r == null) {
                    req.setAttribute("error", "Reservation not found for your details.");
                } else {
                    req.setAttribute("reservation", r);
                    loadBill(req, r);
                    req.setAttribute("reservations", reservationDAO.listByGuestId(guestId));
                }
            }
        } else {
            Object gidObj = session.getAttribute(S_GUEST_ID);
            if (gidObj != null) {
                int guestId = (int) gidObj;
                req.setAttribute("reservations", reservationDAO.listByGuestId(guestId));
            }
        }

        req.getRequestDispatcher("/WEB-INF/views/public/booking_info.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(true);

        String reservationNo = req.getParameter("reservationNo");
        String mobile = req.getParameter("mobile");
        String nic = req.getParameter("nicPassport");

        if (reservationNo == null) reservationNo = "";
        if (mobile == null) mobile = "";
        if (nic == null) nic = "";

        reservationNo = reservationNo.trim();
        mobile = mobile.trim();
        nic = nic.trim();

        int filled = 0;
        if (!reservationNo.isEmpty()) filled++;
        if (!mobile.isEmpty()) filled++;
        if (!nic.isEmpty()) filled++;

        if (filled < 2) {
            req.setAttribute("error", "For security, please enter at least two fields.");
            req.getRequestDispatcher("/WEB-INF/views/public/booking_info.jsp").forward(req, resp);
            return;
        }

        if (!reservationNo.isEmpty()) {
            Reservation r = reservationDAO.findForGuestLookup(reservationNo, mobile, nic);
            if (r == null) {
                clearGuestSession(session);
                req.setAttribute("error", "No matching reservation found.");
                req.getRequestDispatcher("/WEB-INF/views/public/booking_info.jsp").forward(req, resp);
                return;
            }

            setVerified(session, r.getGuestId());
            req.setAttribute("msg", "Verified. You can print the bill.");

            req.setAttribute("reservation", r);
            loadBill(req, r);

            req.setAttribute("reservations", reservationDAO.listByGuestId(r.getGuestId()));
            req.getRequestDispatcher("/WEB-INF/views/public/booking_info.jsp").forward(req, resp);
            return;
        }

        if (mobile.isEmpty() || nic.isEmpty()) {
            clearGuestSession(session);
            req.setAttribute("error", "Mobile and NIC or Passport are required when reservation number is not provided.");
            req.getRequestDispatcher("/WEB-INF/views/public/booking_info.jsp").forward(req, resp);
            return;
        }

        Guest g = guestDAO.findByMobileAndNic(mobile, nic);
        if (g == null) {
            clearGuestSession(session);
            req.setAttribute("error", "No guest found for the provided details.");
            req.getRequestDispatcher("/WEB-INF/views/public/booking_info.jsp").forward(req, resp);
            return;
        }

        setVerified(session, g.getGuestId());
        req.setAttribute("msg", "Verified. Select your reservation to view the bill.");
        req.setAttribute("reservations", reservationDAO.listByGuestId(g.getGuestId()));
        req.getRequestDispatcher("/WEB-INF/views/public/booking_info.jsp").forward(req, resp);
    }
}