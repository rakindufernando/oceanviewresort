<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ include file="/WEB-INF/jsp/includes/favicon.jspf" %>
<%@ page import="lk.oceanviewresort.model.RoomInventory" %>
<%
    request.setAttribute("pageTitle", "Room Types - Manager");
    String ctx = request.getContextPath();
    List<RoomInventory> rooms = (List<RoomInventory>) request.getAttribute("rooms");
    RoomInventory editRoom = (RoomInventory) request.getAttribute("editRoom");
%>
<jsp:include page="../partials/header.jsp"/>

<div class="card">
    <h2>Room Types & Prices (Manager CRUD)</h2>

    <% if (request.getParameter("msg") != null) { %>
    <div class="msg"><%= request.getParameter("msg") %></div>
    <% } %>

    <% if (request.getParameter("error") != null) { %>
    <div class="err"><%= request.getParameter("error") %></div>
    <% } %>

    <% if (request.getAttribute("error") != null) { %>
    <div class="err"><%= request.getAttribute("error") %></div>
    <% } %>

    <div class="row">
        <div class="col">

            <% if (editRoom != null) { %>
            <h3>Update Room Type</h3>
            <form method="post" action="<%= ctx %>/app/manager/roomtypes">
                <input type="hidden" name="action" value="update">

                <label>Room Type</label>
                <input type="text" name="roomType" value="<%= editRoom.getRoomType() %>" readonly>

                <div class="row" style="margin-top:8px;">
                    <div class="col">
                        <label>Total Rooms</label>
                        <input type="number" name="totalRooms" min="1" value="<%= editRoom.getTotalRooms() %>">
                    </div>
                    <div class="col">
                        <label>Rate per Night (LKR)</label>
                        <input type="number" name="ratePerNight" min="0" step="0.01" value="<%= editRoom.getRatePerNight() %>">
                    </div>
                </div>

                <div style="margin-top:10px; display:flex; gap:8px;">
                    <button class="btn" type="submit">Update</button>
                    <a class="btn2" href="<%= ctx %>/app/manager/roomtypes">Cancel</a>
                </div>
            </form>
            <% } else { %>

            <h3>Add New Room Type</h3>
            <form method="post" action="<%= ctx %>/app/manager/roomtypes">
                <input type="hidden" name="action" value="create">

                <label>Room Type (Ex: Deluxe, Suite)</label>
                <input type="text" name="roomType" placeholder="Enter room type name">

                <div class="row" style="margin-top:8px;">
                    <div class="col">
                        <label>Total Rooms</label>
                        <input type="number" name="totalRooms" min="1" placeholder="Ex: 50">
                    </div>
                    <div class="col">
                        <label>Rate per Night (LKR)</label>
                        <input type="number" name="ratePerNight" min="0" step="0.01" placeholder="Ex: 15000.00">
                    </div>
                </div>

                <div style="margin-top:10px;">
                    <button class="btn" type="submit">Add Room Type</button>
                </div>
            </form>
            <% } %>

            <div class="small" style="margin-top:10px;">
                Note: Delete action here is a <b>soft delete</b> (it deactivates the room type). Existing reservations will not break.
            </div>

        </div>
    </div>

    <h3 style="margin-top:16px;">All Room Types</h3>

    <table>
        <tr>
            <th>Room Type</th>
            <th>Total Rooms</th>
            <th>Rate per Night (LKR)</th>
            <th>Status</th>
            <th style="width:240px;">Actions</th>
        </tr>
        <%
            if (rooms != null) {
                for (RoomInventory r : rooms) {
        %>
        <tr>
            <td><%= r.getRoomType() %></td>
            <td><%= r.getTotalRooms() %></td>
            <td><%= String.format("%.2f", r.getRatePerNight()) %></td>
            <td>
                <%= r.isActive() ? "ACTIVE" : "INACTIVE" %>
            </td>
            <td>
                <a class="btn2" href="<%= ctx %>/app/manager/roomtypes?action=edit&roomType=<%= java.net.URLEncoder.encode(r.getRoomType(), "UTF-8") %>">Edit</a>

                <form method="post" action="<%= ctx %>/app/manager/roomtypes" style="display:inline-block; margin-left:6px;">
                    <input type="hidden" name="action" value="toggle">
                    <input type="hidden" name="roomType" value="<%= r.getRoomType() %>">

                    <% if (r.isActive()) { %>
                    <input type="hidden" name="makeActive" value="0">
                    <button class="btn danger" type="submit" onclick="return confirm('Deactivate this room type?');">Deactivate</button>
                    <% } else { %>
                    <input type="hidden" name="makeActive" value="1">
                    <button class="btn" type="submit">Activate</button>
                    <% } %>
                </form>
            </td>
        </tr>
        <%
                }
            }
        %>
    </table>

</div>

<jsp:include page="../partials/footer.jsp"/>
