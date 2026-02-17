<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="lk.oceanviewresort.model.Reservation" %>
<%
    request.setAttribute("pageTitle", "Delete Reservations - Admin");
    String ctx = request.getContextPath();

    String msg = (String) request.getAttribute("msg");
    String error = (String) request.getAttribute("error");

    List<Reservation> reservations = (List<Reservation>) request.getAttribute("reservations");
%>
<jsp:include page="../partials/header.jsp"/>

<div class="card">
    <h2>Delete Reservations (Admin)</h2>
    <p class="small">Admin can hard delete reservations. No need to reset IDs after delete.</p>

    <% if (msg != null && !msg.isEmpty()) { %><div class="msg"><%= msg %></div><% } %>
    <% if (error != null && !error.isEmpty()) { %><div class="err"><%= error %></div><% } %>

    <form method="get" action="<%= ctx %>/app/admin/reservations">
        <div class="row">
            <div class="col">
                <label>Search (Reservation No / Guest)</label>
                <input type="text" name="q" value="<%= request.getParameter("q") != null ? request.getParameter("q") : "" %>">
            </div>
            <div style="min-width:160px; display:flex; align-items:flex-end;">
                <button class="btn" type="submit">Search</button>
                <a class="btn2" href="<%= ctx %>/app/admin/reservations">Clear</a>
            </div>
        </div>
    </form>

    <table>
        <tr>
            <th>ID</th><th>Reservation No</th><th>Guest</th><th>Room</th><th>Check-In</th><th>Check-Out</th><th>Status</th><th>Action</th>
        </tr>
        <%
            if (reservations != null) {
                for (Reservation r : reservations) {
        %>
        <tr>
            <td><%= r.getReservationId() %></td>
            <td><%= r.getReservationNo() %></td>
            <td><%= r.getGuestName() %></td>
            <td><%= r.getRoomType() %></td>
            <td><%= r.getCheckIn() %></td>
            <td><%= r.getCheckOut() %></td>
            <td><%= r.getStatus() %></td>
            <td>
                <a class="btn danger" href="<%= ctx %>/app/admin/reservation/delete?id=<%= r.getReservationId() %>"
                   onclick="return confirm('Are you sure to delete this reservation?');">Delete</a>
            </td>
        </tr>
        <%
                }
            }
        %>
    </table>
</div>

<jsp:include page="../partials/footer.jsp"/>
