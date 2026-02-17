<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="lk.oceanviewresort.model.Guest" %>
<%
  request.setAttribute("pageTitle", "Guest Form - Receptionist");
  String ctx = request.getContextPath();
  Guest guest = (Guest) request.getAttribute("guest");
  String error = (String) request.getAttribute("error");
  boolean editing = (guest != null);
  String actionUrl = editing ? (ctx + "/app/reception/guest/edit") : (ctx + "/app/reception/guest/new");
%>
<jsp:include page="../partials/header.jsp"/>

<div class="card">
  <h2><%= editing ? "Edit Guest" : "Add New Guest" %></h2>

  <% if (error != null && !error.isEmpty()) { %>
  <div class="err"><%= error %></div>
  <% } %>

  <form method="post" action="<%= actionUrl %>">
    <% if (editing) { %>
    <input type="hidden" name="guestId" value="<%= guest.getGuestId() %>">
    <% } %>

    <div class="row">
      <div class="col">
        <label>Full Name</label>
        <input type="text" name="fullName" required value="<%= editing ? guest.getFullName() : "" %>">
      </div>
      <div class="col">
        <label>Mobile (Unique)</label>
        <input type="text" name="mobile" required value="<%= editing ? guest.getMobile() : "" %>">
      </div>
    </div>

    <div class="row">
      <div class="col">
        <label>NIC / Passport (Unique)</label>
        <input type="text" name="nicPassport" required value="<%= editing ? guest.getNicPassport() : "" %>">
      </div>
      <div class="col">
        <label>Email (Optional)</label>
        <input type="email" name="email" value="<%= (editing && guest.getEmail() != null) ? guest.getEmail() : "" %>">
      </div>
    </div>

    <div class="row">
      <div class="col">
        <label>Address</label>
        <textarea name="address" required><%= editing ? guest.getAddress() : "" %></textarea>
      </div>
    </div>

    <div style="margin-top:10px;">
      <button class="btn" type="submit"><%= editing ? "Update Guest" : "Save Guest" %></button>
      <a class="btn2" href="<%= ctx %>/app/reception/guests">Back</a>
    </div>
  </form>
</div>

<jsp:include page="../partials/footer.jsp"/>
