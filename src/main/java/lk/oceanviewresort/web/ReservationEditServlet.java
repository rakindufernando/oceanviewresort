package lk.oceanviewresort.web;

import lk.oceanviewresort.dao.ReservationDAO;
import lk.oceanviewresort.dao.RoomInventoryDAO;
import lk.oceanviewresort.model.Reservation;
import lk.oceanviewresort.model.RoomInventory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/app/reception/reservation/edit")
public class ReservationEditServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final RoomInventoryDAO roomDAO = new RoomInventoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int id = Integer.parseInt(req.getParameter("id"));
        Reservation r = reservationDAO.findById(id);

        req.setAttribute("rooms", roomDAO.getActiveRooms());
        req.setAttribute("reservation", r);
        req.setAttribute("error", req.getParameter("error"));

        req.getRequestDispatcher("/WEB-INF/views/reception/reservation_form.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        try {
            int reservationId = Integer.parseInt(req.getParameter("reservationId"));
            int guestId = Integer.parseInt(req.getParameter("guestId"));
            String roomType = req.getParameter("roomType");
            LocalDate checkIn = LocalDate.parse(req.getParameter("checkIn"));
            LocalDate checkOut = LocalDate.parse(req.getParameter("checkOut"));
            int adults = Integer.parseInt(req.getParameter("adults"));
            int children = Integer.parseInt(req.getParameter("children"));

            if (!checkOut.isAfter(checkIn)) {
                resp.sendRedirect(req.getContextPath()+"/app/reception/reservation/edit?id="+reservationId+"&error=Invalid dates");
                return;
            }

            RoomInventory inv = roomDAO.findByType(roomType);
            if (inv == null) {
                resp.sendRedirect(req.getContextPath()+"/app/reception/reservation/edit?id="+reservationId+"&error=Invalid room type");
                return;
            }

            int booked = reservationDAO.countOverlapping(roomType, checkIn, checkOut, reservationId);
            if (booked >= inv.getTotalRooms()) {
                resp.sendRedirect(req.getContextPath()+"/app/reception/reservation/edit?id="+reservationId+"&error=FULLY BOOKED for selected dates");
                return;
            }

            Reservation r = new Reservation();
            r.setReservationId(reservationId);
            r.setGuestId(guestId);
            r.setRoomType(roomType);
            r.setCheckIn(checkIn);
            r.setCheckOut(checkOut);
            r.setAdults(adults);
            r.setChildren(children);

            reservationDAO.update(r);

            int userId = (int) req.getSession(false).getAttribute("userId");
            new lk.oceanviewresort.dao.AuditDAO().log(userId, "UPDATE_RESERVATION", "ReservationId=" + reservationId);

            resp.sendRedirect(req.getContextPath() + "/app/reception/reservations?msg=Reservation updated");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/app/reception/reservations?error=Update failed");
        }
    }
}
