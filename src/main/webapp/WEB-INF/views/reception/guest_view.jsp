<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="lk.oceanviewresort.model.Guest" %>
<%
    request.setAttribute("pageTitle", "Guest Details");
    String ctx = request.getContextPath();
    Guest g = (Guest) request.getAttribute("guest");
%>
<jsp:include page="../partials/header.jsp"/>

<div class="card">
    <h2>Guest Details</h2>

    <% if (g == null) { %>
    <div class="err">Guest not found.</div>
    <a class="btn2" href="<%= ctx %>/app/reception/guests">Back</a>
    <% } else { %>
    <table>
        <tr><th>Guest ID</th><td><%= g.getGuestId() %></td></tr>
        <tr><th>Full Name</th><td><%= g.getFullName() %></td></tr>
        <tr><th>Mobile</th><td><%= g.getMobile() %></td></tr>
        <tr><th>NIC/Passport</th><td><%= g.getNicPassport() %></td></tr>
        <tr><th>Email</th><td><%= g.getEmail() != null ? g.getEmail() : "" %></td></tr>
        <tr><th>Address</th><td><%= g.getAddress() %></td></tr>
    </table>

    <div style="margin-top:10px;">
        <a class="btn2" href="<%= ctx %>/app/reception/guest/edit?id=<%= g.getGuestId() %>">Edit</a>
        <a class="btn2" href="<%= ctx %>/app/reception/guests">Back</a>
    </div>
    <% } %>
</div>

<jsp:include page="../partials/footer.jsp"/>
