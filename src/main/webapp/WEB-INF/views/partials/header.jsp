<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String ctx = request.getContextPath();
    String role = (String) session.getAttribute("role");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= (request.getAttribute("pageTitle") != null ? request.getAttribute("pageTitle") : "Ocean View Resort") %></title>
    <link rel="stylesheet" href="<%= ctx %>/assets/app.css">
</head>
<body>
<header>
    <div class="top">
        <div>
            <h1>Ocean View Resort</h1>
            <div class="sub">Hotel Reservation & Billing System (oceanviewresort.lk)</div>
        </div>
        <div class="small">
            <%
                if (session != null && session.getAttribute("userId") != null) {
            %>
            Logged in as <b><%= session.getAttribute("fullName") %></b> (<%= role %>) |
            <a href="<%= ctx %>/logout">Logout</a>
            <%
                }
            %>
        </div>
    </div>

    <%
        if (session != null && session.getAttribute("userId") != null) {
    %>
    <nav>
        <a href="<%= ctx %>/app/dashboard">Dashboard</a>
        <a href="<%= ctx %>/app/help">Help</a>

        <%
            if ("RECEPTIONIST".equals(role)) {
        %>
        <a href="<%= ctx %>/app/reception/guests">Guest Management</a>
        <a href="<%= ctx %>/app/reception/reservations">Reservation Management</a>
        <a href="<%= ctx %>/app/reception/billing">Billing + Payments</a>
        <a href="<%= ctx %>/app/reception/checkout">Early Checkout</a>
        <%
        } else if ("MANAGER".equals(role)) {
        %>
        <a href="<%= ctx %>/app/manager/reservations">Reservations</a>
        <a href="<%= ctx %>/app/manager/reports">Reports</a>
        <a href="<%= ctx %>/app/reception/checkout">Checkout</a>
        <%
        } else if ("ADMIN".equals(role)) {
        %>
        <a href="<%= ctx %>/app/admin/users">User Management</a>
        <a href="<%= ctx %>/app/admin/reservations">Delete Reservations</a>
        <a href="<%= ctx %>/app/admin/transactions">Transactions</a>
        <a href="<%= ctx %>/app/admin/reports">Reports</a>
        <%
            }
        %>
    </nav>
    <%
        }
    %>
</header>
<div class="container">
