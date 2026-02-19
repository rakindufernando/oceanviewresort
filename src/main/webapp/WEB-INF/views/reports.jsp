<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/includes/favicon.jspf" %>
<%@ page import="java.util.*" %>
<%
    request.setAttribute("pageTitle", "Reports - Ocean View Resort");
    String msg = (String) request.getAttribute("msg");
    String error = (String) request.getAttribute("error");
    Object occObj = request.getAttribute("occ");
    Object revObj = request.getAttribute("rev");
    Object statusObj = request.getAttribute("statusSummary");
    Object resListObj = request.getAttribute("resList");
%>
<jsp:include page="partials/header.jsp"/>
<div class="card">
    <h2>Reports</h2>

    <% if (msg != null) { %><div class="msg"><%= msg %></div><% } %>
    <% if (error != null) { %><div class="err"><%= error %></div><% } %>

    <form method="get">
        <div class="row">
            <div class="col">
                <label>From Date</label>
                <input type="date" name="from" value="<%= request.getParameter("from") != null ? request.getParameter("from") : "" %>" required>
            </div>
            <div class="col">
                <label>To Date</label>
                <input type="date" name="to" value="<%= request.getParameter("to") != null ? request.getParameter("to") : "" %>" required>
            </div>
            <div class="col" style="min-width:160px;display:flex;align-items:flex-end;">
                <button class="btn" type="submit">Generate</button>
            </div>
        </div>
    </form>

    <%
        if (occObj != null && revObj != null) {
            List<String[]> occ = (List<String[]>) occObj;
            String[] rev = (String[]) revObj;
            List<String[]> statusSummary = statusObj != null ? (List<String[]>) statusObj : new ArrayList<>();
            List<String[]> resList = resListObj != null ? (List<String[]>) resListObj : new ArrayList<>();
    %>
    <hr>

    <h3>Revenue Summary</h3>
    <p>Total Revenue: <b><%= rev[0] %></b> | Payments: <b><%= rev[1] %></b></p>

    <h3>Occupancy Summary (Room Types)</h3>
    <table>
        <tr>
            <th>Room Type</th>
            <th>Total Rooms</th>
            <th>Rate / Night</th>
            <th>Booked Nights (range)</th>
        </tr>
        <% for (String[] r : occ) { %>
        <tr>
            <td><%= r[0] %></td>
            <td><%= r[1] %></td>
            <td><%= r[2] %></td>
            <td><%= r[3] %></td>
        </tr>
        <% } %>
    </table>

    <h3>Status Summary</h3>
    <table>
        <tr><th>Status</th><th>Count</th></tr>
        <% for (String[] s : statusSummary) { %>
        <tr><td><%= s[0] %></td><td><%= s[1] %></td></tr>
        <% } %>
    </table>

    <h3>Reservations in Date Range</h3>
    <table>
        <tr>
            <th>Reservation No</th><th>Guest</th><th>Room</th><th>Check-In</th><th>Check-Out</th><th>Status</th>
        </tr>
        <% for (String[] rr : resList) { %>
        <tr>
            <td><%= rr[0] %></td><td><%= rr[1] %></td><td><%= rr[2] %></td>
            <td><%= rr[3] %></td><td><%= rr[4] %></td><td><%= rr[5] %></td>
        </tr>
        <% } %>
    </table>

    <% } %>
</div>
<jsp:include page="partials/footer.jsp"/>
