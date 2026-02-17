package lk.oceanviewresort.web;

import lk.oceanviewresort.dao.PaymentDAO;
import lk.oceanviewresort.dao.ReservationDAO;
import lk.oceanviewresort.dao.RoomInventoryDAO;
import lk.oceanviewresort.model.Payment;
import lk.oceanviewresort.model.Reservation;
import lk.oceanviewresort.model.RoomInventory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.temporal.ChronoUnit;
import java.util.List;

@WebServlet("/app/reception/billing")
public class BillingServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final RoomInventoryDAO roomDAO = new RoomInventoryDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String resNo = req.getParameter("reservationNo");

        req.setAttribute("msg", req.getParameter("msg"));
        req.setAttribute("error", req.getParameter("error"));

        if (resNo != null && !resNo.trim().isEmpty()) {
            Reservation r = reservationDAO.findByReservationNo(resNo.trim());
            req.setAttribute("reservation", r);

            if (r != null) {
                RoomInventory inv = roomDAO.findByType(r.getRoomType());
                double rate = inv != null ? inv.getRatePerNight() : 0;

                long nights = ChronoUnit.DAYS.between(r.getCheckIn(), r.getCheckOut());
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
            } else {
                req.setAttribute("error", "Reservation not found.");
            }
        }

        req.getRequestDispatcher("/WEB-INF/views/reception/billing.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        try {
            int reservationId = Integer.parseInt(req.getParameter("reservationId"));
            String reservationNo = req.getParameter("reservationNo");
            double amount = Double.parseDouble(req.getParameter("amount"));
            String method = req.getParameter("method");
            String ref = req.getParameter("referenceNo");

            int receivedBy = (int) req.getSession(false).getAttribute("userId");

            paymentDAO.addPayment(reservationId, amount, method, ref, receivedBy);

            int userId = (int) req.getSession(false).getAttribute("userId");
            new lk.oceanviewresort.dao.AuditDAO().log(userId, "ADD_PAYMENT",
                    "ResId=" + reservationId + ", ResNo=" + reservationNo + ", Amount=" + amount + ", Method=" + method);

            resp.sendRedirect(req.getContextPath() + "/app/reception/billing?reservationNo=" + reservationNo + "&msg=Payment added");

        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/app/reception/billing?error=Payment failed");
        }
    }
}
