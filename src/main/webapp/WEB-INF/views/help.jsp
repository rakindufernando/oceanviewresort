<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/includes/favicon.jspf" %>
<%
  request.setAttribute("pageTitle", "Help - Ocean View Resort");
%>
<jsp:include page="partials/header.jsp"/>
<div class="card">
  <h2>Help / Guidelines</h2>
  <p class="small">This page is for new staff members to understand how to use the system.</p>

  <h3>Login</h3>
  <ul>
    <li>Use your username and password given by the Admin.</li>
    <li>If login is not working, ask Admin to reset your password.</li>
  </ul>

  <h3>Guests (Receptionist)</h3>
  <ul>
    <li>Add new guests and maintain guest details.</li>
    <li>Mobile number and NIC/Passport are unique (no duplicates).</li>
  </ul>

  <h3>Reservations (Receptionist)</h3>
  <ul>
    <li>Search guest by Mobile or NIC/Passport and create reservation.</li>
    <li>Room availability is limited (example 150 rooms per room type).</li>
  </ul>

  <h3>Billing (Receptionist)</h3>
  <ul>
    <li>Search reservation number and generate invoice.</li>
    <li>Click Print Bill to print invoice.</li>
  </ul>

  <h3>Reports (Manager/Admin)</h3>
  <ul>
    <li>Select date range and generate reports.</li>
  </ul>

  <h3>User Management (Admin)</h3>
  <ul>
    <li>Admin can add/edit/disable users and assign roles.</li>
  </ul>
</div>
<jsp:include page="partials/footer.jsp"/>
