package lk.oceanviewresort.web;

import lk.oceanviewresort.dao.ReservationDAO;
import lk.oceanviewresort.dao.RoomInventoryDAO;
import lk.oceanviewresort.model.RoomInventory;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/app/reception/availability")
public class AvailabilityServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final RoomInventoryDAO roomDAO = new RoomInventoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        String roomType = req.getParameter("roomType");
        String checkInS = req.getParameter("checkIn");
        String checkOutS = req.getParameter("checkOut");

        resp.setContentType("text/plain; charset=UTF-8");

        if (roomType == null || checkInS == null || checkOutS == null ||
                roomType.isEmpty() || checkInS.isEmpty() || checkOutS.isEmpty()) {
            resp.getWriter().println("PLEASE_SELECT");
            return;
        }

        try {
            LocalDate checkIn = LocalDate.parse(checkInS);
            LocalDate checkOut = LocalDate.parse(checkOutS);

            if (!checkOut.isAfter(checkIn)) {
                resp.getWriter().println("INVALID_DATES");
                return;
            }

            RoomInventory inv = roomDAO.findByType(roomType);
            if (inv == null) {
                resp.getWriter().println("INVALID_ROOMTYPE");
                return;
            }

            int booked = reservationDAO.countOverlapping(roomType, checkIn, checkOut, 0);
            int remaining = inv.getTotalRooms() - booked;

            if (remaining <= 0) resp.getWriter().println("FULLY_BOOKED");
            else resp.getWriter().println("AVAILABLE:" + remaining);

        } catch (Exception e) {
            resp.getWriter().println("ERROR");
        }
    }
}
