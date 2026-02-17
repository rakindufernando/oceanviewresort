package lk.oceanviewresort.web;

import lk.oceanviewresort.dao.GuestDAO;
import lk.oceanviewresort.dao.ReservationDAO;
import lk.oceanviewresort.dao.RoomInventoryDAO;
import lk.oceanviewresort.model.Guest;
import lk.oceanviewresort.model.Reservation;
import lk.oceanviewresort.model.RoomInventory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/app/reception/reservation/new")
public class ReservationNewServlet extends HttpServlet {

    private final RoomInventoryDAO roomDAO = new RoomInventoryDAO();
    private final GuestDAO guestDAO = new GuestDAO();
    private final ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<RoomInventory> rooms = roomDAO.getActiveRooms();
        req.setAttribute("rooms", rooms);

        String guestKey = req.getParameter("guestKey");
        if (guestKey != null && !guestKey.trim().isEmpty()) {
            Guest g = guestDAO.findByMobileOrNic(guestKey.trim());
            req.setAttribute("foundGuest", g);
            if (g == null) req.setAttribute("error", "Guest not found. Please add guest first.");
        }

        req.setAttribute("error", req.getParameter("error"));
        req.getRequestDispatcher("/WEB-INF/views/reception/reservation_form.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        try {
            int guestId = Integer.parseInt(req.getParameter("guestId"));
            String roomType = req.getParameter("roomType");
            LocalDate checkIn = LocalDate.parse(req.getParameter("checkIn"));
            LocalDate checkOut = LocalDate.parse(req.getParameter("checkOut"));
            int adults = Integer.parseInt(req.getParameter("adults"));
            int children = Integer.parseInt(req.getParameter("children"));

            if (!checkOut.isAfter(checkIn)) {
                resp.sendRedirect(req.getContextPath() + "/app/reception/reservation/new?error=Check-out must be after check-in");
                return;
            }

            RoomInventory inv = roomDAO.findByType(roomType);
            if (inv == null) {
                resp.sendRedirect(req.getContextPath() + "/app/reception/reservation/new?error=Invalid room type");
                return;
            }

            int booked = reservationDAO.countOverlapping(roomType, checkIn, checkOut, 0);
            if (booked >= inv.getTotalRooms()) {
                resp.sendRedirect(req.getContextPath() + "/app/reception/reservation/new?error=FULLY BOOKED for selected dates");
                return;
            }

            Reservation r = new Reservation();
            r.setReservationNo(reservationDAO.generateReservationNo());
            r.setGuestId(guestId);
            r.setRoomType(roomType);
            r.setCheckIn(checkIn);
            r.setCheckOut(checkOut);
            r.setAdults(adults);
            r.setChildren(children);
            r.setStatus("BOOKED");

            int createdBy = (int) req.getSession(false).getAttribute("userId");
            reservationDAO.create(r, createdBy);

            new lk.oceanviewresort.dao.AuditDAO().log(createdBy, "ADD_RESERVATION",
                    "ResNo=" + r.getReservationNo() + ", GuestId=" + guestId + ", Room=" + roomType);

            resp.sendRedirect(req.getContextPath()
                    + "/app/reception/billing?reservationNo=" + r.getReservationNo()
                    + "&msg=Reservation added. You can print the bill.");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/app/reception/reservation/new?error=Failed to add reservation");
        }
    }
}
