package lk.oceanviewresort.web;

import lk.oceanviewresort.dao.AuditDAO;
import lk.oceanviewresort.dao.CheckoutDAO;
import lk.oceanviewresort.dao.ReservationDAO;
import lk.oceanviewresort.model.Reservation;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;

@WebServlet("/app/reception/checkout")
public class ReceptionCheckoutServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final CheckoutDAO checkoutDAO = new CheckoutDAO();
    private final AuditDAO auditDAO = new AuditDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setAttribute("msg", req.getParameter("msg"));
        req.setAttribute("error", req.getParameter("error"));

        String resNo = req.getParameter("reservationNo");
        if (resNo != null && !resNo.trim().isEmpty()) {
            Reservation r = reservationDAO.findByReservationNo(resNo.trim());
            if (r != null) {
                req.setAttribute("reservation", r);
            } else {
                req.setAttribute("error", "Reservation not found.");
            }
        }

        req.getRequestDispatcher("/WEB-INF/views/reception/checkout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        String ctx = req.getContextPath();

        try {
            int reservationId = Integer.parseInt(req.getParameter("reservationId"));
            String reservationNo = req.getParameter("reservationNo");
            String actualStr = req.getParameter("actualCheckOut");
            String reason = req.getParameter("reason");

            Reservation r = reservationDAO.findById(reservationId);
            if (r == null) {
                resp.sendRedirect(ctx + "/app/reception/checkout?error=Reservation not found");
                return;
            }

            if (!r.getReservationNo().equals(reservationNo)) {
                resp.sendRedirect(ctx + "/app/reception/checkout?error=Reservation mismatch");
                return;
            }

            if ("CANCELLED".equalsIgnoreCase(r.getStatus())) {
                resp.sendRedirect(ctx + "/app/reception/checkout?reservationNo=" +
                        URLEncoder.encode(reservationNo, StandardCharsets.UTF_8) +
                        "&error=Cancelled reservation cannot be checked out");
                return;
            }

            if ("CHECKED_OUT".equalsIgnoreCase(r.getStatus())) {
                resp.sendRedirect(ctx + "/app/reception/checkout?reservationNo=" +
                        URLEncoder.encode(reservationNo, StandardCharsets.UTF_8) +
                        "&error=This reservation is already checked out");
                return;
            }

            if (actualStr == null || actualStr.trim().isEmpty()) {
                resp.sendRedirect(ctx + "/app/reception/checkout?reservationNo=" +
                        URLEncoder.encode(reservationNo, StandardCharsets.UTF_8) +
                        "&error=Please select actual checkout date");
                return;
            }

            LocalDate actualCheckout = LocalDate.parse(actualStr);

            // Must be AFTER check-in (at least 1 night)
            if (!actualCheckout.isAfter(r.getCheckIn())) {
                resp.sendRedirect(ctx + "/app/reception/checkout?reservationNo=" +
                        URLEncoder.encode(reservationNo, StandardCharsets.UTF_8) +
                        "&error=Actual checkout must be after check-in date");
                return;
            }

            // Early checkout ONLY (or same as scheduled)
            if (actualCheckout.isAfter(r.getCheckOut())) {
                resp.sendRedirect(ctx + "/app/reception/checkout?reservationNo=" +
                        URLEncoder.encode(reservationNo, StandardCharsets.UTF_8) +
                        "&error=Actual checkout cannot be after scheduled checkout");
                return;
            }

            boolean ok = checkoutDAO.markCheckedOut(reservationId, actualCheckout);

            if (ok) {
                int userId = (int) req.getSession(false).getAttribute("userId");
                auditDAO.log(userId, "CHECKOUT",
                        "ResId=" + reservationId +
                                ", ResNo=" + reservationNo +
                                ", ActualCheckOut=" + actualCheckout +
                                (reason != null && !reason.trim().isEmpty() ? ", Reason=" + reason.trim() : "")
                );

                resp.sendRedirect(ctx + "/app/reception/checkout?reservationNo=" +
                        URLEncoder.encode(reservationNo, StandardCharsets.UTF_8) +
                        "&msg=Checkout updated successfully");
            } else {
                resp.sendRedirect(ctx + "/app/reception/checkout?reservationNo=" +
                        URLEncoder.encode(reservationNo, StandardCharsets.UTF_8) +
                        "&error=Checkout update failed");
            }

        } catch (Exception e) {
            resp.sendRedirect(ctx + "/app/reception/checkout?error=Invalid data");
        }
    }
}
