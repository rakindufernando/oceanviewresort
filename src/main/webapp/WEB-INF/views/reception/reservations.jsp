<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/includes/favicon.jspf" %>
<%@ page import="java.util.*" %>
<%@ page import="lk.oceanviewresort.model.Reservation" %>
<%
  request.setAttribute("pageTitle", "Reservations - Receptionist");
  String ctx = request.getContextPath();
  String msg = (String) request.getAttribute("msg");
  String error = (String) request.getAttribute("error");
  List<Reservation> reservations = (List<Reservation>) request.getAttribute("reservations");
%>
<jsp:include page="../partials/header.jsp"/>

<div class="card">
  <h2>Reservation Management</h2>

  <% if (msg != null && !msg.isEmpty()) { %><div class="msg"><%= msg %></div><% } %>
  <% if (error != null && !error.isEmpty()) { %><div class="err"><%= error %></div><% } %>

  <div class="row">
    <div class="col">
      <form method="get" action="<%= ctx %>/app/reception/reservations">
        <label>Search (Reservation No / Guest Name)</label>
        <div class="row">
          <div class="col"><input type="text" name="q" value="<%= request.getParameter("q") != null ? request.getParameter("q") : "" %>"></div>
          <div style="min-width:160px;">
            <button class="btn" type="submit">Search</button>
            <a class="btn2" href="<%= ctx %>/app/reception/reservations">Clear</a>
          </div>
        </div>
      </form>
    </div>
    <div style="min-width:220px; display:flex; align-items:flex-end; gap:8px;">
      <a class="btn" href="<%= ctx %>/app/reception/reservation/new">Add New Reservation</a>
      <a class="btn2" href="<%= ctx %>/app/reception/billing">Billing</a>
    </div>
  </div>

  <table>
    <tr>
      <th>ID</th><th>Reservation No</th><th>Guest</th><th>Room</th><th>Check-In</th><th>Check-Out</th><th>Status</th><th>Actions</th>
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
        <a class="btn2" href="<%= ctx %>/app/reception/reservation/edit?id=<%= r.getReservationId() %>">Edit</a>
        <a class="btn2" onclick="return confirm('Cancel this reservation?');"
           href="<%= ctx %>/app/reception/reservation/cancel?id=<%= r.getReservationId() %>">Cancel</a>
        <a class="btn2" href="<%= ctx %>/app/reception/billing?reservationNo=<%= r.getReservationNo() %>">Bill</a>
      </td>
    </tr>
    <%
        }
      }
    %>
  </table>

  <p class="small">Availability is checked by overlapping dates (limit e.g. 150 rooms per type).</p>
</div>

<jsp:include page="../partials/footer.jsp"/>
