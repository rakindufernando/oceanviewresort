<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/includes/favicon.jspf" %>
<%@ page import="java.util.*" %>
<%@ page import="lk.oceanviewresort.model.*" %>
<%
  request.setAttribute("pageTitle", "Reservation Form - Receptionist");
  String ctx = request.getContextPath();

  Reservation reservation = (Reservation) request.getAttribute("reservation");
  boolean editing = (reservation != null);

  List<RoomInventory> rooms = (List<RoomInventory>) request.getAttribute("rooms");
  Guest foundGuest = (Guest) request.getAttribute("foundGuest");

  String error = (String) request.getAttribute("error");
  String actionUrl = editing ? (ctx + "/app/reception/reservation/edit") : (ctx + "/app/reception/reservation/new");

  String guestIdVal = "";
  if (editing) guestIdVal = String.valueOf(reservation.getGuestId());
  if (!editing && foundGuest != null) guestIdVal = String.valueOf(foundGuest.getGuestId());
%>
<jsp:include page="../partials/header.jsp"/>

<div class="card">
  <h2><%= editing ? "Edit Reservation" : "Add New Reservation" %></h2>

  <% if (error != null && !error.isEmpty()) { %><div class="err"><%= error %></div><% } %>

  <% if (!editing) { %>
  <h3>Step 1: Find Guest</h3>
  <form method="get" action="<%= ctx %>/app/reception/reservation/new">
    <div class="row">
      <div class="col">
        <label>Search Guest by Mobile or NIC/Passport</label>
        <input type="text" name="guestKey" value="<%= request.getParameter("guestKey") != null ? request.getParameter("guestKey") : "" %>" required>
      </div>
      <div style="min-width:160px; display:flex; align-items:flex-end;">
        <button class="btn" type="submit">Search</button>
      </div>
    </div>
  </form>

  <% if (foundGuest != null) { %>
  <div class="msg">
    Guest found: <b><%= foundGuest.getFullName() %></b> |
    ID: <%= foundGuest.getGuestId() %> |
    Mobile: <%= foundGuest.getMobile() %> |
    NIC: <%= foundGuest.getNicPassport() %>
  </div>
  <% } %>

  <p class="small">If guest not found, go to Guests page and add the guest first.</p>
  <hr>
  <% } %>

  <h3>Step 2: Reservation Details</h3>
  <form method="post" action="<%= actionUrl %>">
    <% if (editing) { %>
    <input type="hidden" name="reservationId" value="<%= reservation.getReservationId() %>">
    <% } %>

    <div class="row">
      <div class="col">
        <label>Guest ID</label>
        <input type="number" name="guestId" required value="<%= guestIdVal %>" <%= (!editing && foundGuest != null) ? "readonly" : "" %>>
      </div>

      <div class="col">
        <label>Room Type</label>
        <select name="roomType" id="roomType" required onchange="checkAvailability()">
          <option value="">-- Select --</option>
          <%
            if (rooms != null) {
              for (RoomInventory rm : rooms) {
                String current = editing ? reservation.getRoomType() : "";
                String sel = (current != null && current.equals(rm.getRoomType())) ? "selected" : "";
          %>
          <option value="<%= rm.getRoomType() %>" <%= sel %>><%= rm.getRoomType() %> (Rate: <%= rm.getRatePerNight() %>)</option>
          <%
              }
            }
          %>
        </select>
      </div>
    </div>

    <div class="row">
      <div class="col">
        <label>Check-In</label>
        <input type="date" name="checkIn" id="checkIn" required onchange="checkAvailability()"
               value="<%= editing ? reservation.getCheckIn() : "" %>">
      </div>
      <div class="col">
        <label>Check-Out</label>
        <input type="date" name="checkOut" id="checkOut" required onchange="checkAvailability()"
               value="<%= editing ? reservation.getCheckOut() : "" %>">
      </div>
    </div>

    <div class="row">
      <div class="col">
        <label>Adults</label>
        <input type="number" name="adults" min="1" value="<%= editing ? reservation.getAdults() : "1" %>">
      </div>
      <div class="col">
        <label>Children</label>
        <input type="number" name="children" min="0" value="<%= editing ? reservation.getChildren() : "0" %>">
      </div>
    </div>

    <div id="availabilityBox" class="msg" style="display:none;"></div>

    <div style="margin-top:10px;">
      <button class="btn" type="submit"><%= editing ? "Update Reservation" : "Save Reservation" %></button>
      <a class="btn2" href="<%= ctx %>/app/reception/reservations">Back</a>
    </div>
  </form>

  <script>
    function checkAvailability(){
      var roomType = document.getElementById("roomType").value;
      var ci = document.getElementById("checkIn").value;
      var co = document.getElementById("checkOut").value;

      var box = document.getElementById("availabilityBox");
      box.style.display = "none";

      if(!roomType || !ci || !co) return;

      fetch("<%= ctx %>/app/reception/availability?roomType=" + encodeURIComponent(roomType)
              + "&checkIn=" + encodeURIComponent(ci) + "&checkOut=" + encodeURIComponent(co))
              .then(r => r.text())
              .then(t => {
                box.style.display = "block";
                if(t === "FULLY_BOOKED"){
                  box.className = "err";
                  box.innerHTML = "FULLY BOOKED for selected dates.";
                } else if(t.startsWith("AVAILABLE:")){
                  box.className = "msg";
                  box.innerHTML = "Available rooms: " + t.split(":")[1];
                } else {
                  box.className = "msg";
                  box.innerHTML = "Status: " + t;
                }
              })
              .catch(() => {
                box.style.display = "block";
                box.className = "err";
                box.innerHTML = "Availability check failed.";
              });
    }
  </script>
</div>

<jsp:include page="../partials/footer.jsp"/>
