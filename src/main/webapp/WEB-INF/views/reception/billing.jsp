<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="lk.oceanviewresort.model.*" %>
<%
  request.setAttribute("pageTitle", "Billing - Receptionist");
  String ctx = request.getContextPath();

  String msg = (String) request.getAttribute("msg");
  String error = (String) request.getAttribute("error");

  Reservation r = (Reservation) request.getAttribute("reservation");
  Double rate = (Double) request.getAttribute("rate");
  Long nights = (Long) request.getAttribute("nights");
  Double total = (Double) request.getAttribute("total");
  Double paid = (Double) request.getAttribute("paid");
  Double balance = (Double) request.getAttribute("balance");
  List<Payment> payments = (List<Payment>) request.getAttribute("payments");

  String resNoParam = request.getParameter("reservationNo") != null ? request.getParameter("reservationNo") : "";
%>
<jsp:include page="../partials/header.jsp"/>



<div class="card">
  <h2>Billing & Payments</h2>

  <% if (msg != null && !msg.isEmpty()) { %><div class="msg"><%= msg %></div><% } %>
  <% if (error != null && !error.isEmpty()) { %><div class="err"><%= error %></div><% } %>

  <div class="no-print">
    <form method="get" action="<%= ctx %>/app/reception/billing">
      <div class="row">
        <div class="col">
          <label>Search Reservation No</label>
          <input type="text" name="reservationNo" value="<%= resNoParam %>" required>
        </div>
        <div style="min-width:160px; display:flex; align-items:flex-end;">
          <button class="btn" type="submit">Search</button>
        </div>
      </div>
    </form>
  </div>

  <% if (r != null) { %>
  <hr>

  <div class="bill">
    <div class="bill-top">
      <div>
        <h3 style="margin:0;">Ocean View Resort</h3>
        <div class="small">Hotel Reservation Invoice</div>
        <div class="small">oceanviewresort.lk</div>
      </div>
      <div class="right">
        <div><b>Date:</b> <%= new java.util.Date() %></div>
        <div><b>Reservation No:</b> <%= r.getReservationNo() %></div>
      </div>
    </div>

    <hr>

    <table>
      <tr><th>Guest Name</th><td><%= r.getGuestName() %></td></tr>
      <tr><th>Room Type</th><td><%= r.getRoomType() %></td></tr>
      <tr><th>Check-In</th><td><%= r.getCheckIn() %></td></tr>
      <tr><th>Check-Out</th><td><%= r.getCheckOut() %></td></tr>
      <tr><th>Nights</th><td><%= nights != null ? nights : 0 %></td></tr>
      <tr><th>Rate per Night</th><td><%= rate != null ? String.format("%.2f", rate) : "0.00" %></td></tr>
      <tr><th>Total</th><td><b><%= total != null ? String.format("%.2f", total) : "0.00" %></b></td></tr>
      <tr><th>Paid</th><td><%= paid != null ? String.format("%.2f", paid) : "0.00" %></td></tr>
      <tr><th>Balance</th><td><b><%= balance != null ? String.format("%.2f", balance) : "0.00" %></b></td></tr>
    </table>

    <div class="sign">
      <div class="line">Guest Signature</div>
      <div class="line">Receptionist Signature</div>
    </div>

    <p class="small" style="margin-top:12px;">Thank you for choosing Ocean View Resort.</p>
  </div>

  <div class="no-print" style="margin-top:10px;">
    <button class="btn" type="button" onclick="window.print()">Print Bill</button>
  </div>

  <hr>

  <div class="no-print">
    <h3>Add Payment</h3>
    <form method="post" action="<%= ctx %>/app/reception/billing">
      <input type="hidden" name="reservationId" value="<%= r.getReservationId() %>">
      <input type="hidden" name="reservationNo" value="<%= r.getReservationNo() %>">

      <div class="row">
        <div class="col">
          <label>Amount</label>
          <input type="number" step="0.01" name="amount" required>
        </div>
        <div class="col">
          <label>Method</label>
          <select name="method" required>
            <option value="CASH">CASH</option>
            <option value="CARD">CARD</option>
            <option value="BANK">BANK</option>
          </select>
        </div>
        <div class="col">
          <label>Reference (Optional)</label>
          <input type="text" name="referenceNo">
        </div>
      </div>

      <div style="margin-top:10px;">
        <button class="btn" type="submit">Save Payment</button>
      </div>
    </form>

    <h3>Payment History</h3>
    <table>
      <tr><th>Date</th><th>Amount</th><th>Method</th><th>Reference</th></tr>
      <%
        if (payments != null) {
          for (Payment p : payments) {
      %>
      <tr>
        <td><%= p.getPaidAt() %></td>
        <td><%= String.format("%.2f", p.getAmount()) %></td>
        <td><%= p.getMethod() %></td>
        <td><%= p.getReferenceNo() != null ? p.getReferenceNo() : "" %></td>
      </tr>
      <%
          }
        }
      %>
    </table>
  </div>
  <% } %>
</div>

<jsp:include page="../partials/footer.jsp"/>
