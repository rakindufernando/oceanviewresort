<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    request.setAttribute("pageTitle", "Dashboard - Ocean View Resort");
    String ctx = request.getContextPath();
    String role = (String) session.getAttribute("role");
%>
<jsp:include page="partials/header.jsp"/>

<div class="card">
    <h2>Dashboard</h2>
    <p class="small">Welcome to Ocean View Resort internal reservation system.</p>

    <% if ("ADMIN".equals(role)) { %>
    <div class="row">
        <div class="col card">
            <h3>User Management</h3>
            <p class="small">Create users, update roles, reset passwords.</p>
            <a class="btn" href="<%= ctx %>/app/admin/users">Open</a>
        </div>
        <div class="col card">
            <h3>Reports</h3>
            <p class="small">Revenue + occupancy reports.</p>
            <a class="btn" href="<%= ctx %>/app/admin/reports">Open</a>
        </div>
        <div class="col card">
            <h3>Transactions</h3>
            <p class="small">View all payment records.</p>
            <a class="btn" href="<%= ctx %>/app/admin/transactions">Open</a>
        </div>
    </div>
    <div style="margin-top:10px;">
        <a class="btn2" href="<%= ctx %>/app/admin/reservations">Delete Reservations</a>
    </div>

    <% } else if ("RECEPTIONIST".equals(role)) { %>
    <div class="row">
        <div class="col card">
            <h3>Guest Management</h3>
            <p class="small">Add, update, delete guests (no duplicates for Mobile and NIC/Passport).</p>
            <a class="btn" href="<%= ctx %>/app/reception/guests">Open</a>
        </div>
        <div class="col card">
            <h3>Reservation Management</h3>
            <p class="small">Add/update reservations with availability limit (150 rooms per type).</p>
            <a class="btn" href="<%= ctx %>/app/reception/reservations">Open</a>
        </div>
        <div class="col card">
            <h3>Billing + Payments</h3>
            <p class="small">Calculate bill and print invoice.</p>
            <a class="btn" href="<%= ctx %>/app/reception/billing">Open</a>
        </div>
        <div class="col card">
            <h3>Early Checkout</h3>
            <p class="small">Update actual checkout date and mark reservation as checked out.</p>
            <a class="btn" href="<%= ctx %>/app/reception/checkout">Open</a>
        </div>
    </div>

    <% } else if ("MANAGER".equals(role)) { %>
    <div class="row">
        <div class="col card">
            <h3>View Reservations</h3>
            <p class="small">View reservations.</p>
            <a class="btn" href="<%= ctx %>/app/manager/reservations">Open</a>
        </div>
        <div class="col card">
            <h3>Reports</h3>
            <p class="small">Generate occupancy and revenue reports.</p>
            <a class="btn" href="<%= ctx %>/app/manager/reports">Open</a>
        </div>
    </div>
    <% } else { %>
    <div class="err">Role not found. Please login again.</div>
    <a class="btn2" href="<%= ctx %>/login">Go to Login</a>
    <% } %>
</div>

<script>

    document.addEventListener("DOMContentLoaded", function () {


        var links = document.querySelectorAll("a[href]");
        var currentPath = window.location.pathname;

        for (var i = 0; i < links.length; i++) {
            try {
                var u = new URL(links[i].href, window.location.href);
                if (u.pathname === currentPath) {
                    links[i].classList.add("active-link");
                }
            } catch (e) { }
        }
    });
</script>

<jsp:include page="partials/footer.jsp"/>