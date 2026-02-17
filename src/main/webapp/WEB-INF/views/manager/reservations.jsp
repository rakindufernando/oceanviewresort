<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="lk.oceanviewresort.model.Reservation" %>
<%
  request.setAttribute("pageTitle", "Reservations - Manager");
  String ctx = request.getContextPath();
  List<Reservation> reservations = (List<Reservation>) request.getAttribute("reservations");
%>
<jsp:include page="../partials/header.jsp"/>

<div class="card">
  <h2>Reservations (View Only)</h2>

  <form method="get" action="<%= ctx %>/app/manager/reservations">
    <div class="row">
      <div class="col">
        <label>Search (Reservation No / Guest)</label>
        <input type="text" name="q" value="<%= request.getParameter("q") != null ? request.getParameter("q") : "" %>">
      </div>
      <div style="min-width:160px; display:flex; align-items:flex-end;">
        <button class="btn" type="submit">Search</button>
        <a class="btn2" href="<%= ctx %>/app/manager/reservations">Clear</a>
      </div>
    </div>
  </form>

  <table>
    <tr><th>ID</th><th>Reservation No</th><th>Guest</th><th>Room</th><th>Check-In</th><th>Check-Out</th><th>Status</th></tr>
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
    </tr>
    <%
        }
      }
    %>
  </table>
</div>

<jsp:include page="../partials/footer.jsp"/>
