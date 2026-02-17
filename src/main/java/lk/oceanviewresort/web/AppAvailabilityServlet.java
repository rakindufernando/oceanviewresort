package lk.oceanviewresort.web;

import lk.oceanviewresort.dao.ReservationDAO;
import lk.oceanviewresort.dao.RoomInventoryDAO;
import lk.oceanviewresort.model.RoomInventory;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/app/availability")
public class AppAvailabilityServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final RoomInventoryDAO roomDAO = new RoomInventoryDAO();

    private String esc(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        String checkInS = req.getParameter("checkIn");
        String checkOutS = req.getParameter("checkOut");

        LocalDate checkIn = LocalDate.now();
        LocalDate checkOut = checkIn.plusDays(1);

        try {
            if (checkInS != null && !checkInS.trim().isEmpty()) checkIn = LocalDate.parse(checkInS.trim());
            if (checkOutS != null && !checkOutS.trim().isEmpty()) checkOut = LocalDate.parse(checkOutS.trim());
        } catch (Exception e) {
            resp.setContentType("application/json; charset=UTF-8");
            resp.getWriter().print("{\"ok\":false,\"message\":\"INVALID_DATE_FORMAT\"}");
            return;
        }

        if (!checkOut.isAfter(checkIn)) {
            resp.setContentType("application/json; charset=UTF-8");
            resp.getWriter().print("{\"ok\":false,\"message\":\"INVALID_DATES\"}");
            return;
        }

        // NOTE: use YOUR existing method name here
        // If your DAO method name differs, replace only this line.
        List<RoomInventory> rooms = roomDAO.getActiveRooms();

        StringBuilder json = new StringBuilder();
        json.append("{\"ok\":true,");
        json.append("\"checkIn\":\"").append(checkIn).append("\",");
        json.append("\"checkOut\":\"").append(checkOut).append("\",");
        json.append("\"rooms\":[");

        for (int i = 0; i < rooms.size(); i++) {
            RoomInventory inv = rooms.get(i);

            // NOTE: use YOUR existing overlap count method name here
            int booked = reservationDAO.countOverlapping(inv.getRoomType(), checkIn, checkOut, 0);
            int available = inv.getTotalRooms() - booked;

            if (i > 0) json.append(",");
            json.append("{")
                    .append("\"roomType\":\"").append(esc(inv.getRoomType())).append("\",")
                    .append("\"total\":").append(inv.getTotalRooms()).append(",")
                    .append("\"booked\":").append(booked).append(",")
                    .append("\"available\":").append(Math.max(0, available)).append(",")
                    .append("\"status\":\"").append(available <= 0 ? "FULLY_BOOKED" : "AVAILABLE").append("\"")
                    .append("}");
        }

        json.append("]}");
        resp.setContentType("application/json; charset=UTF-8");
        resp.getWriter().print(json.toString());
    }
}
