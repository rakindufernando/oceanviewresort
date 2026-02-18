package lk.oceanviewresort.web;

import lk.oceanviewresort.dao.AuditDAO;
import lk.oceanviewresort.dao.RoomInventoryDAO;
import lk.oceanviewresort.model.RoomInventory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/app/manager/roomtypes")
public class ManagerRoomTypesServlet extends HttpServlet {

    private final RoomInventoryDAO roomDAO = new RoomInventoryDAO();
    private final AuditDAO auditDAO = new AuditDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        String roomType = req.getParameter("roomType");

        if ("edit".equals(action) && roomType != null && !roomType.trim().isEmpty()) {
            RoomInventory editRoom = roomDAO.findByType(roomType.trim());
            req.setAttribute("editRoom", editRoom);
        }

        List<RoomInventory> list = roomDAO.getAllRooms();
        req.setAttribute("rooms", list);

        req.getRequestDispatcher("/WEB-INF/views/manager/roomtypes.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) action = "";

        if ("create".equals(action)) {
            handleCreate(req, resp);
            return;
        }
        if ("update".equals(action)) {
            handleUpdate(req, resp);
            return;
        }
        if ("toggle".equals(action)) {
            handleToggle(req, resp);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/app/manager/roomtypes?error=Unknown action");
    }

    private void handleCreate(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String roomType = safe(req.getParameter("roomType"));
        String totalRoomsStr = safe(req.getParameter("totalRooms"));
        String rateStr = safe(req.getParameter("ratePerNight"));

        if (roomType.isEmpty()) {
            req.setAttribute("error", "Room type is required.");
            doGet(req, resp);
            return;
        }

        int totalRooms;
        double rate;
        try {
            totalRooms = Integer.parseInt(totalRoomsStr);
            rate = Double.parseDouble(rateStr);
        } catch (Exception e) {
            req.setAttribute("error", "Please enter valid numbers for total rooms and rate.");
            doGet(req, resp);
            return;
        }

        if (totalRooms <= 0) {
            req.setAttribute("error", "Total rooms must be greater than 0.");
            doGet(req, resp);
            return;
        }
        if (rate <= 0) {
            req.setAttribute("error", "Rate per night must be greater than 0.");
            doGet(req, resp);
            return;
        }

        // prevent duplicates
        if (roomDAO.findByType(roomType) != null) {
            req.setAttribute("error", "Room type already exists. Try another name.");
            doGet(req, resp);
            return;
        }

        RoomInventory r = new RoomInventory();
        r.setRoomType(roomType);
        r.setTotalRooms(totalRooms);
        r.setRatePerNight(rate);

        boolean ok = roomDAO.create(r);
        if (ok) {
            int userId = (int) req.getSession(false).getAttribute("userId");
            auditDAO.log(userId, "ADD_ROOM_TYPE", "Type=" + roomType + ", Rooms=" + totalRooms + ", Rate=" + rate);
            resp.sendRedirect(req.getContextPath() + "/app/manager/roomtypes?msg=Room type added");
        } else {
            req.setAttribute("error", "Failed to add room type.");
            doGet(req, resp);
        }
    }

    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String roomType = safe(req.getParameter("roomType"));
        String totalRoomsStr = safe(req.getParameter("totalRooms"));
        String rateStr = safe(req.getParameter("ratePerNight"));

        if (roomType.isEmpty()) {
            req.setAttribute("error", "Room type is missing.");
            doGet(req, resp);
            return;
        }

        int totalRooms;
        double rate;
        try {
            totalRooms = Integer.parseInt(totalRoomsStr);
            rate = Double.parseDouble(rateStr);
        } catch (Exception e) {
            req.setAttribute("error", "Please enter valid numbers for total rooms and rate.");
            req.setAttribute("editRoom", roomDAO.findByType(roomType));
            doGet(req, resp);
            return;
        }

        if (totalRooms <= 0) {
            req.setAttribute("error", "Total rooms must be greater than 0.");
            req.setAttribute("editRoom", roomDAO.findByType(roomType));
            doGet(req, resp);
            return;
        }
        if (rate <= 0) {
            req.setAttribute("error", "Rate per night must be greater than 0.");
            req.setAttribute("editRoom", roomDAO.findByType(roomType));
            doGet(req, resp);
            return;
        }

        RoomInventory r = new RoomInventory();
        r.setRoomType(roomType);
        r.setTotalRooms(totalRooms);
        r.setRatePerNight(rate);

        boolean ok = roomDAO.update(r);
        if (ok) {
            int userId = (int) req.getSession(false).getAttribute("userId");
            auditDAO.log(userId, "UPDATE_ROOM_TYPE", "Type=" + roomType + ", Rooms=" + totalRooms + ", Rate=" + rate);
            resp.sendRedirect(req.getContextPath() + "/app/manager/roomtypes?msg=Room type updated");
        } else {
            req.setAttribute("error", "Failed to update room type.");
            req.setAttribute("editRoom", roomDAO.findByType(roomType));
            doGet(req, resp);
        }
    }

    private void handleToggle(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String roomType = safe(req.getParameter("roomType"));
        String makeActive = safe(req.getParameter("makeActive"));

        if (roomType.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/app/manager/roomtypes?error=Room type is missing");
            return;
        }

        boolean active = "1".equals(makeActive);
        boolean ok = roomDAO.setActive(roomType, active);

        if (ok) {
            int userId = (int) req.getSession(false).getAttribute("userId");
            auditDAO.log(userId, active ? "ACTIVATE_ROOM_TYPE" : "DEACTIVATE_ROOM_TYPE",
                    "Type=" + roomType);

            resp.sendRedirect(req.getContextPath() + "/app/manager/roomtypes?msg=Status updated");
        } else {
            resp.sendRedirect(req.getContextPath() + "/app/manager/roomtypes?error=Failed to update status");
        }
    }

    private String safe(String s) {
        if (s == null) return "";
        return s.trim();
    }
}
