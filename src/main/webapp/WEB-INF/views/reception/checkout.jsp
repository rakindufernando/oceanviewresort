<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/includes/favicon.jspf" %>
<%@ page import="lk.oceanviewresort.model.Reservation" %>
<%
    request.setAttribute("pageTitle", "Checkout - Receptionist");
    String ctx = request.getContextPath();

    String msg = (String) request.getAttribute("msg");
    String error = (String) request.getAttribute("error");
    Reservation r = (Reservation) request.getAttribute("reservation");

    String resNoParam = request.getParameter("reservationNo");
    if(resNoParam == null) resNoParam = "";
%>

<jsp:include page="../partials/header.jsp"/>

<div class="card">
    <h2>Guest Checkout (Early Checkout)</h2>

    <% if (msg != null && !msg.isEmpty()) { %><div class="msg"><%= msg %></div><% } %>
    <% if (error != null && !error.isEmpty()) { %><div class="err"><%= error %></div><% } %>

    <form method="get" action="<%= ctx %>/app/reception/checkout">
        <label>Reservation No</label>
        <div class="row">
            <div class="col">
                <input type="text" name="reservationNo" value="<%= resNoParam %>" placeholder="OV-2026-00001">
            </div>
            <div style="min-width:180px;">
                <button class="btn" type="submit">Find Reservation</button>
                <a class="btn2" href="<%= ctx %>/app/reception/checkout">Clear</a>
            </div>
        </div>
    </form>

    <% if (r != null) { %>

    <hr style="border:0;border-top:1px solid #d6ecff;margin:14px 0;">

    <h3 style="margin:0 0 8px 0;">Reservation Details</h3>

    <table>
        <tr><th>Reservation No</th><td><%= r.getReservationNo() %></td></tr>
        <tr><th>Guest</th><td><%= r.getGuestName() %></td></tr>
        <tr><th>Room Type</th><td><%= r.getRoomType() %></td></tr>
        <tr><th>Check-In</th><td><%= r.getCheckIn() %></td></tr>
        <tr><th>Scheduled Check-Out</th><td><%= r.getCheckOut() %></td></tr>
        <tr><th>Status</th><td><%= r.getStatus() %></td></tr>
    </table>

    <form method="post" action="<%= ctx %>/app/reception/checkout" onsubmit="return confirm('Confirm checkout update?');" style="margin-top:12px;">
        <input type="hidden" name="reservationId" value="<%= r.getReservationId() %>">
        <input type="hidden" name="reservationNo" value="<%= r.getReservationNo() %>">

        <div class="row">
            <div class="col">
                <label>Actual Checkout Date</label>
                <input type="date" id="actualCheckOut" name="actualCheckOut">
                <div class="small">You can enter an earlier date than scheduled checkout.</div>
            </div>
            <div class="col">
                <label>Reason (optional)</label>
                <textarea name="reason" placeholder="Guest leaving early..."></textarea>
            </div>
        </div>

        <div style="margin-top:10px; display:flex; gap:8px; flex-wrap:wrap;">
            <button class="btn" type="submit">Confirm Checkout</button>
            <a class="btn2" href="<%= ctx %>/app/reception/billing?reservationNo=<%= r.getReservationNo() %>">Open Billing</a>
            <a class="btn2" href="<%= ctx %>/app/reception/reservations">Back</a>
        </div>
    </form>

    <script>
        (function(){
            var scheduled = "<%= r.getCheckOut() %>"; // yyyy-mm-dd
            var checkIn = "<%= r.getCheckIn() %>";
            var input = document.getElementById("actualCheckOut");
            if(!input) return;

            // Default = today (but not after scheduled)
            var d = new Date();
            var yyyy = d.getFullYear();
            var mm = String(d.getMonth()+1).padStart(2,'0');
            var dd = String(d.getDate()).padStart(2,'0');
            var today = yyyy + "-" + mm + "-" + dd;

            input.max = scheduled;
            input.min = checkIn;
            input.value = (today <= scheduled ? today : scheduled);
        })();
    </script>

    <% } %>

    <p class="small" style="margin-top:12px;">
        After checkout update, billing nights and room availability will use the new updated check-out date.
    </p>
</div>

<jsp:include page="../partials/footer.jsp"/>
